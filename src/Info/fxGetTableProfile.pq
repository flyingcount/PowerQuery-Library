////////////////////////////////////////////////////////////////////////////////
// fxGetTableProfile
// Category : Info
// Description : Generates a statistical summary (Profile) of a given table.
// Author      : Paul Chan
// Date        : 2026-03-06
// Source path : Function Library/InfoFunctions/fxGetTableProfile
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxGetTableProfile
    Description: Generates a statistical summary (Profile) of a given table.
    Author: Paul Chan
    Date: 2026-03-06
*/
let
    Source = (InputTable as table) as table =>
let
    // Generate the profile of the provided table
    ProfileResult = Table.Profile(InputTable),
    
    // Optional: Sort by null count descending to see problematic columns first
    SortedProfile = Table.Sort(ProfileResult,{{"NullCount", Order.Descending}})
in
    SortedProfile
in
    Source
