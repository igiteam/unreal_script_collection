class TPGameLeaderboard_Settings extends Settings
							native;

const GAME_MODE_DM						 = 0;
const GAME_MODE_TDM			             = 1;

enum ELeaderboardFilters
{
	LF_GameMode,
	LF_TimePeriod,
	LS_MatchType,
	LS_PlayerFilterType
};

enum ETimeFilterSettings
{
	TFS_Weekly,
	TFS_Monthly,
	TFS_AllTime
};

enum EMatchTypeSettings
{
	MTS_Ranked,
	MTS_Player
};

enum EPlayerFilterSettings
{
	PFS_Player,
	PFS_CenteredOnPlayer,
	PFS_Friends,
	PFS_TopRankings
};

