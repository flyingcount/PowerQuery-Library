////////////////////////////////////////////////////////////////////////////////
// fxTableEnhancedProfile
// Category : Info
// Author      : Paul Chan / Gemini
// Date        : 2026-03-08
// Source path : Function Library/InfoFunctions/fxTableEnhancedProfile
////////////////////////////////////////////////////////////////////////////////

/*
    Column Profiling Function (Complete Version)
    -------------------------
    Author: Paul Chan / Gemini
    Date: 2026-03-08
*/
let
    fxTableEnhancedProfile = (table as table) as table =>
let
    // Identify numeric columns
    numericCols = List.Select(
        Table.ColumnNames(table),
        each List.AllTrue(List.Transform(Table.Column(table, _), each _ = null or Value.Is(_, type number)))
    ),

    // Helper: Clean numeric list
    CleanNumericList = (list as list) as list =>
        List.Select(list, each Value.Is(_, type number)),

    // Helper: Mode (Using Table.Group)
    GetMode = (list as list) =>
        let
            toTable = Table.FromList(list, Splitter.SplitByNothing(), {"Val"}),
            Groups = Table.Group(toTable, {"Val"}, {{"Count", each Table.RowCount(_), type number}}),
            Sorted = Table.Sort(Groups, {{"Count", Order.Descending}}),
            Result = if List.IsEmpty(list) then null else Table.First(Sorted)[Val]
        in Result,

    // Helper: Skewness
    Skewness = (list as list) =>
        let
            n = List.Count(list),
            mean = List.Average(list),
            stdev = List.StandardDeviation(list),
            thirdMoment = List.Sum(List.Transform(list, each Number.Power(_ - mean, 3))) / n,
            skew = if stdev = 0 or n = 0 then null else thirdMoment / Number.Power(stdev, 3)
        in skew,

    // Helper: Kurtosis
    Kurtosis = (list as list) =>
        let
            n = List.Count(list),
            mean = List.Average(list),
            stdev = List.StandardDeviation(list),
            fourthMoment = List.Sum(List.Transform(list, each Number.Power(_ - mean, 4))) / n,
            kurt = if stdev = 0 or n = 0 then null else (fourthMoment / Number.Power(stdev, 4)) - 3
        in kurt,

    // Helper: Z-Score Extremes
    ZScoreExtremes = (list as list) =>
        let
            mean = List.Average(list),
            stdev = List.StandardDeviation(list),
            zScores = List.Transform(list, each if stdev = 0 or stdev = null then null else (_ - mean) / stdev),
            minZ = if List.IsEmpty(List.RemoveNulls(zScores)) then null else List.Min(zScores),
            maxZ = if List.IsEmpty(List.RemoveNulls(zScores)) then null else List.Max(zScores)
        in {minZ, maxZ},

    // Helper: Percentiles
    Percentiles = (list as list) =>
        let
            sorted = List.Sort(list),
            count = List.Count(sorted),
            getP = (p) => if count = 0 then null else sorted{Number.RoundDown(p * (count - 1))},
            p5 = getP(0.05), p25 = getP(0.25), p50 = getP(0.5), p75 = getP(0.75), p95 = getP(0.95)
        in {p5, p25, p50, p75, p95},

    // Helper: Type Label
    TypeLabel = (value as any) as text =>
        let
            t = Value.Type(value),
            label = if value = null then "null"
                    else if Type.Is(t, type number) then "number"
                    else if Type.Is(t, type text) then "text"
                    else if Type.Is(t, type logical) then "logical"
                    else if Type.Is(t, type date) then "date"
                    else if Type.Is(t, type datetime) then "datetime"
                    else "unknown"
        in label,

    // Helper Flags
    GetSkewFlag = (s) => if s = null then "n/a" else if Number.Abs(s) > 1 then "Highly Skewed" else if Number.Abs(s) > 0.5 then "Moderately Skewed" else "Symmetric",
    GetKurtFlag = (k) => if k = null then "n/a" else if k > 1 then "Leptokurtic" else if k < -1 then "Platykurtic" else "Mesokurtic",

    // Build profile rows
    profileRows = List.Transform(Table.ColumnNames(table), each
        let
            colName = _,
            colValues = Table.Column(table, colName),
            nonNulls = List.Select(colValues, each _ <> null),
            sampleValue = try nonNulls{0} otherwise null,
            dataType = TypeLabel(sampleValue),
            count = List.Count(colValues),
            nullCount = List.Count(List.Select(colValues, each _ = null)),
            distinctCount = List.Count(List.Distinct(nonNulls)),
            
            isNumeric = List.Contains(numericCols, colName),
            cleanNums = if isNumeric then CleanNumericList(nonNulls) else {},

            // Percentiles and stats
            p = try if isNumeric then Percentiles(cleanNums) else {null,null,null,null,null} otherwise {null,null,null,null,null},
            z = try if isNumeric then ZScoreExtremes(cleanNums) else {null,null} otherwise {null,null},
            
            minVal = try if isNumeric then List.Min(cleanNums) else null otherwise null,
            maxVal = try if isNumeric then List.Max(cleanNums) else null otherwise null,
            medianVal = p{2},
            modeVal = try if isNumeric then GetMode(cleanNums) else null otherwise null,
            meanVal = try if isNumeric then List.Average(cleanNums) else null otherwise null,
            stdevVal = try if isNumeric then List.StandardDeviation(cleanNums) else null otherwise null,
            
            skewVal = try if isNumeric then Skewness(cleanNums) else null otherwise null,
            kurtVal = try if isNumeric then Kurtosis(cleanNums) else null otherwise null,
            
            status = if dataType = "unknown" then "Unsupported" else if nullCount = count then "All null" else "Ok"
        in
            {
                colName, dataType, count, nullCount, distinctCount,
                minVal, maxVal, medianVal, modeVal, meanVal, stdevVal,
                skewVal, GetSkewFlag(skewVal), kurtVal, GetKurtFlag(kurtVal),
                z{0}, z{1}, // MinZScore, MaxZScore
                p{0}, p{1}, p{2}, p{3}, p{4}, // P5 - P95
                try (if isNumeric then p{3} - p{1} else null) otherwise null, // IQR
                try (if isNumeric then maxVal - minVal else null) otherwise null, // Range
                status
            }
    ),

    output = Table.FromRows(
        profileRows,
        {
            "Column", "DataType", "Count", "NullCount", "DistinctCount",
            "Min", "Max", "Median", "Mode", "Mean", "StdDev",
            "Skewness", "SkewFlag", "Kurtosis", "KurtosisFlag",
            "MinZScore", "MaxZScore", "P5", "P25", "P50", "P75", "P95",
            "IQR", "Range", "ProfileStatus"
        }
    )
in
    output
in
    fxTableEnhancedProfile
