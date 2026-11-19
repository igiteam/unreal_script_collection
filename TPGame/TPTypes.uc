/**
* This will hold all of our enums and types and such that we need to 
* use in multiple files where the enum can'y be mapped to a specific file.
*/
class TPTypes extends Object
	native;

// Don't reorder these as that will confuse Live
enum EDifficultyLevel
{
	DL_Normal,
	DL_Hard,
	DL_Insane,
};

/** The set of achievements that can be unlocked */
enum ETPAchievements
{
	TPA_InvalidAchievement,
};

enum ETPChapterType
{
	eCHAPTER_Skyscraper,
	eCHAPTER_Barricades,
	eCHAPTER_EscapeFromNewYork,
	eCHAPTER_WashingtonRaid,
	eCHAPTER_TowerOfLondon,
	eCHAPTER_ZepplinRide,
	eCHAPTER_No_ChapterStartPoint,
};

