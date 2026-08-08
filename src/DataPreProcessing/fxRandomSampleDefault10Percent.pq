////////////////////////////////////////////////////////////////////////////////
// fxRandomSampleDefault10Percent
// Category : DataPreProcessing
// Description : Performs a statistically random sample of an input table.
// Author      : Paul Chan
// Date        : 2026-03-07
// Source path : Function Library/DataPreProcessing/fxRandomSampleDefault10Percent
////////////////////////////////////////////////////////////////////////////////

/* Function: fxRandomSampleDefault10Percent
    Description: Performs a statistically random sample of an input table. 
                Defaults to 10% of the row count if no count is provided. 
                Uses Fisher-Yates-style indexing to ensure true shuffling.

    Parameters:
    - tbl: The source table to be sampled.
    - TopN (optional): The specific number of rows to return. 
                        Defaults to 10% of input size if left null.
    Author: Paul Chan
    Date: 2026-03-07
*/
let
    Source = (tbl as table, optional TopN as nullable number) as table =>
let

    // Step 1: Buffer the table to stabilize row count
    buffered = Table.Buffer(tbl),
    rowCount = Table.RowCount(buffered),

    // Step 2: Determine how many rows to keep
    keepCount = 
        if TopN <> null then 
            if TopN > rowCount then rowCount else TopN 
        else 
            Number.RoundUp(rowCount * 0.1),

    // Step 3: Generate a list of unique integers from 1 to rowCount
    indexList = List.Numbers(1, rowCount),

    // Step 4: Shuffle the list using a random comparator
    shuffledList = List.Sort(indexList, (a, b) => Number.Sign(Number.Random() - 0.5)),

    // Step 5: Add an index to the original table
    indexedOriginal = Table.AddIndexColumn(buffered, "JoinIndex", 0, 1),

    // Step 6: Convert shuffled list to table and add index
    shuffledTable = Table.AddIndexColumn(
        Table.FromList(shuffledList, Splitter.SplitByNothing(), {"RandomIndex"}),
        "JoinIndex", 0, 1
    ),

    // Step 7: Merge the shuffled RandomIndex into the original table
    merged = Table.Join(indexedOriginal, "JoinIndex", shuffledTable, "JoinIndex", JoinKind.Inner),

    // Step 8: Remove helper index column
    cleaned = Table.RemoveColumns(merged, {"JoinIndex"}),

    // Step 9: Sort by RandomIndex ascending
    sorted = Table.Sort(cleaned, {{"RandomIndex", Order.Ascending}}),

    // Step 10: Keep top N rows
    topNRows = Table.FirstN(sorted, keepCount)
in
    topNRows
in
    Source
