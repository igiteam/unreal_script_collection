class UIAction_CycleLeaderBoardType extends UIAction
    native;

enum ELeaderboardFilterType
{
    LFT_GameType,                   // 0
    LFT_Players,                    // 1
    LFT_Timeframe,                  // 2
    LFT_MAX                         // 3
};

/** Which filter type we are going to cycle. */
var() UIAction_CycleLeaderBoardType.ELeaderboardFilterType FilterType;
/** Whether we are incrementing or decrementing the leaderboard type. */
var() bool bCycleBackward;
