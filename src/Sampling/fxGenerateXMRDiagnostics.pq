////////////////////////////////////////////////////////////////////////////////
// fxGenerateXMRDiagnostics
// Category : Sampling
// Description : This function constructs a full diagnostic overlay for X-mR control chart analysis,
// Source path : Function Library/Sampling/fxGenerateXMRDiagnostics
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxGenerateXMRDiagnostics
    Signature: (table as table, DateColumn as text, ValueColumn as text) as table

    Description:
    This function constructs a full diagnostic overlay for X-mR control chart analysis,
    applying Western Electric rules, zone classification, and signal tiering for dashboard export.
    It supports audit traceability, pattern detection, and stewardship handoff.

    Parameters:
    - table: Input data table containing at least a date and numeric value column.
    - DateColumn: Name of the column containing date or sequential index values.
    - ValueColumn: Name of the column containing numeric measurements.

    Steps:
    1. Select and rename input columns to standardized names ("Date", "Value").
    2. Sort by Date and add an index for sequential logic.
    3. Compute PreviousValue and moving range (mR).
    4. Calculate control chart statistics: X̄, mR̄, StdDev, control limits, and SD bands.
    5. Flag breaches of control limits (Rule 1) and mR chart outliers.
    6. Classify each point into zone bands (Zone C, B, A, Beyond A).
    7. Apply Western Electric Rules 2–6 using buffered logic:
       - Rule 2: 8+ points on same side of centerline
       - Rule 3: 4 of 5 in Zone B or beyond (same side)
       - Rule 4: 6+ increasing or decreasing
       - Rule 5: 2 of 3 in Zone A (same side)
       - Rule 6: 14-point alternation
    8. Add rule flags to the table and summarize breaches.
    9. Generate a narratable dashboard comment for each row.
    10. Assign a SignalTier (1–6) based on breach severity for triage and export.
    11. Output final table with curated column order for dashboard integration.

    Output Columns:
    - Date, Value, X̄, X_UCL, X_LCL, SD bands
    - ZoneLabel, Rule flags (1–6), RuleBreachSummary
    - DashboardComment, SignalTier
    - mR, mR_UCL, mR̄, mR_OutOfControl

    Notes:
    - All calculations are wrapped in null-safe logic.
    - Designed for modular reuse and audit-ready export.
    - SignalTier enables conditional formatting and prioritization in dashboards.
*/
let
    Source = (table as table, DateColumn as text, ValueColumn as text) as table =>
let
    // Step 1: Select and rename columns
    SelectedCols = Table.SelectColumns(table, {DateColumn, ValueColumn}),
    Renamed = Table.RenameColumns(SelectedCols, {
        {DateColumn, "Date"},
        {ValueColumn, "Value"}
    }),
    Sorted = Table.Sort(Renamed, {{"Date", Order.Ascending}}),
    Indexed = Table.AddIndexColumn(Sorted, "Index", 0, 1, Int64.Type),

    // Step 2: Add PreviousValue and mR
    WithPrevious = Table.AddColumn(Indexed, "PreviousValue", each try Sorted{[Index]-1}[Value] otherwise null),
    WithMR = Table.AddColumn(WithPrevious, "mR", each if [PreviousValue] <> null then Number.Abs([Value] - [PreviousValue]) else null),

    // Step 3: Calculate X̄, mR̄, StdDev
    XBar = List.Average(List.RemoveNulls(WithMR[Value])),
    MRBar = List.Average(List.RemoveNulls(WithMR[mR])),
    StdDev = List.StandardDeviation(List.RemoveNulls(WithMR[Value])),

    // Step 4: Add control limits and SD bands
    WithLimits = Table.AddColumn(WithMR, "X_UCL", each XBar + 2.66 * MRBar),
    WithLimits2 = Table.AddColumn(WithLimits, "X_LCL", each XBar - 2.66 * MRBar),
    WithLimits3 = Table.AddColumn(WithLimits2, "mR_UCL", each 3.268 * MRBar),
    WithLimits4 = Table.AddColumn(WithLimits3, "X̄", each XBar),
    WithLimits5 = Table.AddColumn(WithLimits4, "mR̄", each MRBar),
    WithSD1 = Table.AddColumn(WithLimits5, "X_+1SD", each XBar + StdDev),
    WithSD2 = Table.AddColumn(WithSD1, "X_-1SD", each XBar - StdDev),
    WithSD3 = Table.AddColumn(WithSD2, "X_+2SD", each XBar + 2 * StdDev),
    WithSD4 = Table.AddColumn(WithSD3, "X_-2SD", each XBar - 2 * StdDev),

    // Step 5: Control limit flags (Rule 1)
    WithXFlag = Table.AddColumn(WithSD4, "Rule1_Beyond3Sigma", each 
        if [Value] > [X_UCL] then "Above UCL" 
        else if [Value] < [X_LCL] then "Below LCL" 
        else null),
    WithMRFlag = Table.AddColumn(WithXFlag, "mR_OutOfControl", each 
        if [mR] <> null and [mR] > [mR_UCL] then "Above UCL" 
        else null),

    // Step 6: Zone classification
    WithZone = Table.AddColumn(WithMRFlag, "ZoneLabel", each 
        let
            delta = Number.Abs([Value] - XBar),
            zone = 
                if delta <= StdDev then "Zone C"
                else if delta <= 2 * StdDev then "Zone B"
                else if delta <= 3 * StdDev then "Zone A"
                else "Beyond Zone A"
        in zone, type text),

    // Step 7: Western Electric Rules 2–6
    BufferedValues = List.Buffer(WithZone[Value]),
    BufferedZones = List.Buffer(WithZone[ZoneLabel]),
    Count = List.Count(BufferedValues),

    // Rule 2: 8+ points on same side of centerline
    Rule2Flags = List.Buffer(List.RemoveNulls(
        List.Transform({0..Count-8}, each 
            let slice = List.Range(BufferedValues, _, 8),
                allAbove = List.AllTrue(List.Transform(slice, each _ > XBar)),
                allBelow = List.AllTrue(List.Transform(slice, each _ < XBar))
            in if allAbove or allBelow then _ + 7 else null
        )
    )),

    // Rule 3: 4 of 5 in Zone B or beyond (same side)
    Rule3Flags = List.Buffer(List.RemoveNulls(
        List.Transform({0..Count-5}, each 
            let zoneSlice = List.Range(BufferedZones, _, 5),
                valueSlice = List.Range(BufferedValues, _, 5),
                highZones = {"Zone B", "Zone A", "Beyond Zone A"},
                highCount = List.Count(List.Select({0..4}, each List.Contains(highZones, zoneSlice{_}) and valueSlice{_} > XBar)),
                lowCount = List.Count(List.Select({0..4}, each List.Contains(highZones, zoneSlice{_}) and valueSlice{_} < XBar))
            in if highCount >= 4 or lowCount >= 4 then _ + 4 else null
        )
    )),

    // Rule 4: 6+ increasing or decreasing
    Rule4Flags = List.Buffer(List.RemoveNulls(
        List.Transform({0..Count-6}, each 
            let slice = List.Range(BufferedValues, _, 6),
                increasing = List.AllTrue(List.Transform({0..4}, each slice{_} < slice{_+1})),
                decreasing = List.AllTrue(List.Transform({0..4}, each slice{_} > slice{_+1}))
            in if increasing or decreasing then _ + 5 else null
        )
    )),

    // Rule 5: 2 of 3 in Zone A (same side)
    Rule5Flags = List.Buffer(List.RemoveNulls(
        List.Transform({0..Count-3}, each 
            let zoneSlice = List.Range(BufferedZones, _, 3),
                valueSlice = List.Range(BufferedValues, _, 3),
                highCount = List.Count(List.Select({0..2}, each zoneSlice{_} = "Zone A" and valueSlice{_} > XBar)),
                lowCount = List.Count(List.Select({0..2}, each zoneSlice{_} = "Zone A" and valueSlice{_} < XBar))
            in if highCount >= 2 or lowCount >= 2 then _ + 2 else null
        )
    )),

    // Rule 6: 14-point alternation
    DirectionList = List.Transform({1..Count-1}, each 
        let delta = BufferedValues{_} - BufferedValues{_-1}
        in if delta > 0 then "up" else if delta < 0 then "down" else "flat"
    ),
    IsAlternating = (slice as list) =>
        List.AllTrue(List.Transform({0..12}, each slice{_} <> slice{_+1} and slice{_} <> "flat" and slice{_+1} <> "flat")),
    Rule6Flags = List.Buffer(List.RemoveNulls(
        List.Transform({0..List.Count(DirectionList)-14}, each 
            let slice = List.Range(DirectionList, _, 14)
            in if IsAlternating(slice) then _ + 14 else null
        )
    )),

    // Step 8: Add rule flags to table
    AddRule2 = Table.AddColumn(WithZone, "Rule2_SameSide8", each if List.Contains(Rule2Flags, [Index]) then "Rule 2 breach" else null),
    AddRule3 = Table.AddColumn(AddRule2, "Rule3_ZoneB4of5", each if List.Contains(Rule3Flags, [Index]) then "Rule 3 breach" else null),
    AddRule4 = Table.AddColumn(AddRule3, "Rule4_Trend6", each if List.Contains(Rule4Flags, [Index]) then "Rule 4 breach" else null),
    AddRule5 = Table.AddColumn(AddRule4, "Rule5_ZoneA2of3", each if List.Contains(Rule5Flags, [Index]) then "Rule 5 breach" else null),
    AddRule6 = Table.AddColumn(AddRule5, "Rule6_Alternation14", each if List.Contains(Rule6Flags, [Index]) then "Rule 6 breach" else null),

    // Step 9: Breach summary
    WithSummary = Table.AddColumn(AddRule6, "RuleBreachSummary", each 
        Text.Combine(
            List.RemoveNulls({
                [Rule1_Beyond3Sigma],
                [Rule2_SameSide8],
                [Rule3_ZoneB4of5],
                [Rule4_Trend6],
                [Rule5_ZoneA2of3],
                [Rule6_Alternation14]
            }), "; "
        ), type text),

    // Step 10: Dashboard comment
    WithComment = Table.AddColumn(WithSummary, "DashboardComment", each 
        if [Rule1_Beyond3Sigma] <> null then "Rule 1 breach: " & [Rule1_Beyond3Sigma]
        else if [mR_OutOfControl] <> null then "mR chart breach: " & [mR_OutOfControl]
        else if [RuleBreachSummary] <> "" then "Pattern breach: " & [RuleBreachSummary]
        else if [ZoneLabel] = "Beyond Zone A" then "Outlier: Beyond Zone A"
        else if [ZoneLabel] = "Zone A" then "Significant deviation: Zone A"
        else if [ZoneLabel] = "Zone B" then "Moderate deviation: Zone B"
        else if [ZoneLabel] = "Zone C" then "Normal variation: Zone C"
        else null, type text),

    WithSignalTier = Table.AddColumn(WithComment, "SignalTier", each 
        if [Rule1_Beyond3Sigma] <> null then 1
        else if [Rule2_SameSide8] <> null or [Rule3_ZoneB4of5] <> null or [Rule4_Trend6] <> null or [Rule5_ZoneA2of3] <> null or [Rule6_Alternation14] <> null then 2
        else if [mR_OutOfControl] <> null then 3
        else if [ZoneLabel] = "Beyond Zone A" or [ZoneLabel] = "Zone A" then 4
        else if [ZoneLabel] = "Zone B" then 5
        else if [ZoneLabel] = "Zone C" then 6
        else null, Int64.Type),

    Final = Table.SelectColumns(WithSignalTier, {
        "Date",                // 1
        "Value",               // 2
        "X̄",                  // 3
        "X_UCL",               // 4
        "X_LCL",               // 5
        "X_+1SD",              // 6
        "X_-1SD",              // 7
        "X_+2SD",              // 8
        "X_-2SD",              // 9
        "ZoneLabel",           // 10
        "Rule1_Beyond3Sigma",  // 11
        "Rule2_SameSide8",     // 12
        "Rule3_ZoneB4of5",     // 13
        "Rule4_Trend6",        // 14
        "Rule5_ZoneA2of3",     // 15
        "Rule6_Alternation14", // 16
        "RuleBreachSummary",   // 17
        "DashboardComment",    // 18
        "SignalTier",          // 19
        "mR",                  // 20
        "mR_UCL",              // 21
        "mR̄",                  // 22
        "mR_OutOfControl"     // 23
    })
in
Final
in
    Source
