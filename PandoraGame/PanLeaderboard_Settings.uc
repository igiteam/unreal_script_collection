class PanLeaderboard_Settings extends Settings
    native;

const FS_GAME_MODE_TDM = 0;

enum ELeaderboardFilters
{
    LF_GameMode,                    // 0
    LF_TimePeriod,                  // 1
    LS_MatchType,                   // 2
    LS_PlayerFilterType,            // 3
    ELeaderboardFilters_MAX         // 4
};

enum ETimeFilterSettings
{
    TFS_Weekly,                     // 0
    TFS_Monthly,                    // 1
    TFS_AllTime,                    // 2
    TFS_MAX                         // 3
};

enum EMatchTypeSettings
{
    MTS_Ranked,                     // 0
    MTS_Player,                     // 1
    MTS_MAX                         // 2
};

enum EPlayerFilterSettings
{
    PFS_Player,                     // 0
    PFS_CenteredOnPlayer,           // 1
    PFS_Friends,                    // 2
    PFS_TopRankings,                // 3
    PFS_MAX                         // 4
};

defaultproperties
{
    LocalizedSettings=/* Array type was not detected. */
    LocalizedSettingsMappings=/* Array type was not detected. */
}