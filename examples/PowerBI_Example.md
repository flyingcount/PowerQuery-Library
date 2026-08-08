# Power BI example

## Load reusable functions

1. Open the `.pbix` → **Transform data**.
2. For each needed function: **New Source → Blank Query** → paste from `src/…/*.pq`.
3. Rename the query to the function name (`fx…`).
4. Optional: group queries into a folder (e.g. `Function Library`).

Functions are model-local — copy them into each PBIX that needs them, or maintain a template PBIX.

## Profile then model

```powerquery
let
    Source = Sql.Database("server", "db"){[Schema="dbo", Item="FactSales"]}[Data],
    Profile = fxTableEnhancedProfile(Source)
in
    Profile
```

Use the profile output (nulls, skew, key candidates via `fxGetFullColumnStats`) before building relationships.

## Sample for exploration

```powerquery
let
    Source = /* large fact table */,
    Sample = fxRandomSampleDefault10Percent(Source, null)
in
    Sample
```

## X̄–mR diagnostics

```powerquery
let
    Source = /* table with Date and Measure columns */,
    Diagnostics = fxGenerateXMRDiagnostics(Source, "Date", "Measure")
in
    Diagnostics
```

Load `Diagnostics` to the model and use `SignalTier` / `DashboardComment` in visuals.
