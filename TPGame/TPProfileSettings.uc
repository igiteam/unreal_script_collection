/**
 * Copyright ? 2006 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Holds the list of settings the TPGame is interested and their default values
 *
 * NOTE: This class will normally be code generated, but the tool doesn't exist yet
 */
class TPProfileSettings extends OnlineProfileSettings
	native;

// PSI_MAX is where to start. Can't inherit enums so hard code
const EnemiesKilled = 40;
const BulletsFired = 41;
const MPEnemiesKilled = 42;
const BulletsHit = 43;
const BulletAccuracy = 44;
const IntelPickupData = 45;
const IntelGathered = 46;

const InsaneUnlocked = 49;
const TotalSprintTime = 50;
const GrappleKills = 51;

// Save game-related settings
const SelectedDeviceID		= 308;
const ChapterUnlocked		= 309; // Number of the highest chapter we've unlocked

// MP Settings
const MPMapPlayed			= 310;
const RankedTeamGamesWon	= 311;
const RankedDMGamesWon		= 312;
const AllyMesh				= 400;
const AxisMesh				= 401;
const AllyWeap				= 402;
const AxisWeap				= 403;
const DMMesh				= 404;
const DMWeap				= 405;

// Local and Online Accounts
const LocalAccountName		= 500;
const OnlineAccountName		= 501;
const OnlineAccountPassword = 502;

// Config options
const VideoResolution = 97;
const VideoPerformance = 98;
const VideoFullscreen = 99;
const VideoGamma = 100;
const VideoMidTones = 101;
const VideoHighlights = 102;
const ControllerConfigType = 103;
const AudioMasterVol = 104;
const AudioMusicVol = 105;
const AudioSFXVol = 106;
const AudioDialogVol = 107;
const GameSubtitles = 108;
const GameHUD = 109;
const GameCrosshairs = 110;
const AudioMusicSetting = 111;

enum eZeroBasedBonus
{
	BONUS_ALWAYS_HAVE_GRENADES,
	BONUS_ALWAYS_HAVE_AMMO,
	BONUS_DOUBLE_HEALTH_REGEN_RATE,
	BONUS_UNLOCK_CHAR_WEAP_ART,
	BONUS_UNLOCK_ENV_ART,
	BONUS_UNLOCK_ALL_LEVELS,
	BONUS_NUM
};

//
// The first bonus, BONUS_ALWAYS_HAVE_GRENADES_OFFSET, must be equal to FirstBonus.
// If unreal script were a little more flexible, I could just set these values in default properties
// by going BONUS_ALWAYS_HAVE_GRENADES + FirstBonus, but this does not compile.
//
const	FirstBonus								= 200;
const	BONUS_ALWAYS_HAVE_GRENADES_OFFSET		= 200;
const	BONUS_ALWAYS_HAVE_AMMO_OFFSET			= 201;
const	BONUS_DOUBLE_HEALTH_REGEN_RATE_OFFSET	= 202;
const	BONUS_UNLOCK_CHAR_WEAP_ART_OFFSET		= 203;
const	BONUS_UNLOCK_ENV_ART_OFFSET				= 204;
const	BONUS_UNLOCK_ALL_LEVELS_OFFSET			= 205;

struct native DefaultOverrides
{
	var int Id;
	var int Index;
	var int Value;
};

enum eControllerConfigType
{
	TPCO_Default,
	TPCO_Alternate,
	TPCO_DefaultSouthPaw,
	TPCO_AlternateSouthPaw
};

var array<DefaultOverrides> Defaults360;

/** Increments the EnemiesKilled count and returns true if the achievement should be awarded */
function int IncrementEnemiesKilled()
{
	local int Value;

	GetProfileSettingValueInt(EnemiesKilled,Value);
	Value++;
	SetProfileSettingValueInt(EnemiesKilled,Value);
	//`log("EnemiesKilled value is"@Value);
	if (Value == 50) // Combat Experience
		return 1;
	else if (Value == 250) // Combat Veteran
		return 2;
	else if (Value == 400) // One Man Army
		return 3;
	else
		return 0;
}

/** Increments the GrappleKills count and returns true if the achievement should be awarded */
function bool IncrementGrappleKills()
{
	local int Value;

	GetProfileSettingValueInt(GrappleKills,Value);
	Value++;
	SetProfileSettingValueInt(GrappleKills,Value);
	//`log("GrappleKills value is"@Value);
	if (Value == 40)
		return true;
	else
		return false;
}

/** Increments the BulletsFired count and returns true if the achievement should be awarded */
function bool IncrementBulletsFired(int NumFired)
{
	local int Value;
	local int BulletsHitValue;

	GetProfileSettingValueInt(BulletsFired,Value);
	Value += NumFired;
	SetProfileSettingValueInt(BulletsFired,Value);
	//`log("BulletsFired value is"@Value);

	GetProfileSettingValueInt(BulletsHit,BulletsHitValue);
	SetAccuracy(BulletsHitValue, Value);
	return Value >= 500 && Value < 510;
}

/** Increments the MPEnemiesKilled count and returns true if the achievement should be awarded */
function int IncrementMPEnemiesKilled(int NumKilled)
{
	local int Value;

	GetProfileSettingValueInt(MPEnemiesKilled,Value);
	Value += NumKilled;
	SetProfileSettingValueInt(MPEnemiesKilled,Value);
	//`log("MPEnemiesKilled value is"@Value);
	if (Value >= 2500) // Maybe I Should Go Outside...
		return 3;
	else if (Value >= 500) // Killer Instinct
		return 2;
	else if (Value >= 100) // Killer
		return 1;
	else
		return 0;
}

/** Increments the BulletsHit count, returns true if an achievement should be given*/
function bool IncrementBulletsHit(int NumHit)
{
	local int Value;
	local int BulletsFiredValue;

	GetProfileSettingValueInt(BulletsHit,Value);
	Value += NumHit;
	SetProfileSettingValueInt(BulletsHit,Value);
	//`log("BulletsHit value is"@Value);

	GetProfileSettingValueInt(BulletsFired,BulletsFiredValue);
	
	SetAccuracy(Value, BulletsFiredValue);
	// no achievement for now
	return false;
}

function SetAccuracy(int NumHit, int NumFired)
{
	local int RoundedAccuracy;
	local float Accuracy;

	if (NumFired != 0)
		Accuracy = (NumHit * 1.0f)/NumFired * 100.0f;
	else
		Accuracy = 0;

	if (Accuracy > 99.9)
		RoundedAccuracy = 100;
	else
		RoundedAccuracy = Accuracy;

	SetProfileSettingValueInt(BulletAccuracy,RoundedAccuracy);
	//`log("Accuracy:"@Accuracy);
}

function ResetSinglePlayerStats()
{
	SetProfileSettingValueInt(BulletsFired,0);
	SetProfileSettingValueInt(BulletsHit,0);
	SetProfileSettingValueInt(BulletAccuracy,0);
}

// Resets all intel to be flagged as not picked up
function ResetIntelData()
{
	SetProfileSettingValueInt(IntelPickupData,0);
	SetProfileSettingValueInt(IntelGathered,0);
}

/** Marks an intel as gathered, and returns true if an achievement should be given*/
function int GiveIntel(int IntelNum)
{
	local int CurrIntelPickupData;
	local int IntelMask;
	local int CurrIntelGathered;

	if (IntelNum > 31)
	{
		;
		return 0;
	}

	if (HaveIntel(IntelNum))
	{
		;
		return 0;
	}

	IntelMask = 1 << IntelNum;
	
	GetProfileSettingValueInt(IntelPickupData, CurrIntelPickupData);
	GetProfileSettingValueInt(IntelGathered, CurrIntelGathered);

	CurrIntelPickupData = CurrIntelPickupData | IntelMask;
	CurrIntelGathered++;

	//`log("IntelPickupData is now"@CurrIntelPickupData);
	//`log("IntelGathered is now"@CurrIntelGathered);

	SetProfileSettingValueInt(IntelPickupData, CurrIntelPickupData);
	SetProfileSettingValueInt(IntelGathered, CurrIntelGathered);

	if (CurrIntelGathered == 5) // Snoop
		return 1;
	else if (CurrIntelGathered == 15) // Intellectual
		return 2;
	else if (CurrIntelGathered == class'TPGameInfo'.const.NumTotalIntelPickups) // Master Spy
		return 3;
	else
		return 0;
}

// Returns true if intel number has already been gathered, otherwise false
function bool HaveIntel(int IntelNum)
{
	local int CurrIntelPickupData;
	local int IntelMask;

	if (IntelNum > 31)
	{
		;
		return false;
	}

	IntelMask = 1 << IntelNum;
	//`log("IntelNum is"@IntelNum@"Mask is"@IntelMask);
	// First make sure this one isn't somehow already marked as given in the data
	GetProfileSettingValueInt(IntelPickupData, CurrIntelPickupData);
	//`log("Current IntelPickupData is"@CurrIntelPickupData);

	if ((CurrIntelPickupData & IntelMask) != 0)
	{
		return true;
	}
	else
	{
		return false;
	}
}

function bool HaveAnyIntel()
{
	local int CurrIntelGathered;
	
	GetProfileSettingValueInt(IntelGathered, CurrIntelGathered);

	return CurrIntelgathered > 0;
}

function bool UnlockChapter(int ChapterNum)
{
	local int CurrChapterUnlocked;
	GetProfileSettingValueInt(ChapterUnlocked, CurrChapterUnlocked);
	
	if (CurrChapterUnlocked < ChapterNum)
	{
		SetProfileSettingValueInt(ChapterUnlocked, ChapterNum);
		return true;
	}
	else
		return false;
}

function bool SetMaxChapter(int ChapterNum)
{
	SetProfileSettingValueInt(ChapterUnlocked, ChapterNum);
	return true;
}

function bool IsChapterUnlocked(int ChapterNum)
{
	local int CurrChapterUnlocked;
	GetProfileSettingValueInt(ChapterUnlocked, CurrChapterUnlocked);
	
	return (ChapterNum <= CurrChapterUnlocked);
}

function int HighestChapterUnlocked()
{
	local int CurrChapterUnlocked;
	GetProfileSettingValueInt(ChapterUnlocked, CurrChapterUnlocked);
	return CurrChapterUnlocked;
}

// Multiplayer Functions
function int IncrementRankedGamesWon(bool bTeamGame)
{
	local int CurrRankedGamesWon;
	if (bTeamGame)
	{
		GetProfileSettingValueInt(RankedTeamGamesWon, CurrRankedGamesWon);
		SetProfileSettingValueInt(RankedTeamGamesWon, CurrRankedGamesWon+1);
	}
	else
	{
		GetProfileSettingValueInt(RankedDMGamesWon, CurrRankedGamesWon);
		SetProfileSettingValueInt(RankedDMGamesWon, CurrRankedGamesWon+1);
	}
	return CurrRankedGamesWon+1;
}

// Multiplayer Maps Played
function bool SetMPMapPlayed(int MapID, int GameMode)
{
	/*local int CurrMapPlayed;
	local int MapMask;*/

	local int gameModeOffset;
	local int mapOffset;
	local int AchievementVal;

	if ( gameMode == 0 )
		gameModeOffset = 1;
	else
		gameModeOffset = 16;

	// This isn't efficent, last second hack
	switch ( MapID )
	{
	case 0:
		mapOffset = 1;
		break;

	case 1:
		mapOffset = 2;
		break;

	case 2:
		mapOffset = 4;
		break;

	case 3:
		mapOffset = 8;
		break;
	}

	GetProfileSettingValueInt(MPMapPlayed, AchievementVal);

	AchievementVal = AchievementVal | (mapOffset * gameModeOffset);

	SetProfileSettingValueInt(MPMapPlayed, AchievementVal);

	return true;

	/*
	if (MapID > 3 || GameMode > 1)
	{
		return false;
	}

	if (GameMode == 0)
	{

	}
	else
	{

	}
	MapMask = 1 << (((MapID+1)*(GameMode+1))-1);

	GetProfileSettingValueInt(MPMapPlayed, CurrMapPlayed);
	
	CurrMapPlayed = CurrMapPlayed | MapMask;

	`log("MapMask: "@MapMask@", CurrMapPlayed: "@CurrMapPlayed);

	SetProfileSettingValueInt(MPMapPlayed, CurrMapPlayed);
	
	return true;*/
}

function bool PlayedAllMPMaps()
{
	local int CurrMapPlayed;
//	local int i;
//	local int MapMask;

	GetProfileSettingValueInt(MPMapPlayed, CurrMapPlayed);

	/*for (i = 0; i < 7; i++)
	{
		MapMask = 1 << i;

		if ((CurrMapPlayed & MapMask) == 0)
		{
			return false;
		}
	}*/

	if ( CurrMapPlayed >= 255 )
		return true;

	return false;

	//return true;
}

// Modifiers MP CharacterInfo
function SetAlliedMesh(int MeshID)
{
	SetProfileSettingValueInt(AllyMesh, MeshID);
}
function SetAxisMesh(int MeshID)
{
	SetProfileSettingValueInt(AxisMesh, MeshID);
}
function SetDMMesh(int MeshID)
{
	local int val;

	SetProfileSettingValueInt(DMMesh, MeshID);
	GetProfileSettingValueInt(DMMesh, val);
	;
}
function SetAlliedWeapon(int WeapID)
{
	SetProfileSettingValueInt(AllyWeap, WeapID);
}
function SetAxisWeapon(int WeapID)
{
	SetProfileSettingValueInt(AxisWeap, WeapID);
}
function SetDMWeapon(int WeapID)
{
	SetProfileSettingValueInt(DMWeap, WeapID);
}
// Accessors MP CharacterInfo
function int GetAlliedMesh()
{
	local int val;
	GetProfileSettingValueInt(AllyMesh, val);

	return val;
}
function int GetAxisMesh()
{
	local int val;
	GetProfileSettingValueInt(AxisMesh, val);

	return val;
}
function int GetAlliedWeapon()
{
	local int val;
	GetProfileSettingValueInt(AllyWeap, val);

	return val;
}
function int GetAxisWeapon()
{
	local int val;
	GetProfileSettingValueInt(AxisWeap, val);

	return val;
}
function int GetDMMesh()
{
	local int val;
	GetProfileSettingValueInt(DMMesh, val);

	return val;
}
function int GetDMWeapon()
{
	local int val;
	GetProfileSettingValueInt(DMWeap, val);

	return val;
}

/** 
 * Sets the selected device id for this profile.
 *
 * @param DeviceID	New Device ID
 */
function SetCurrentDeviceID(int DeviceID)
{
	SetProfileSettingValueInt(SelectedDeviceID, DeviceID);
}

function int GetCurrentDeviceID()
{
	local int val;
	GetProfileSettingValueInt(SelectedDeviceID, val);
	return val;
}

//
// Codemasters Bonus Codes
//
function UnlockBonus( int zeroBasedBonus )
{
	local	int		bonusNum;

	bonusNum = zeroBasedBonus +	FirstBonus;

	;

	SetProfileSettingValueID( bonusNum, 1 );
}

function UnlockAllBonuses( )
{
	;

	SetProfileSettingValueID( BONUS_ALWAYS_HAVE_GRENADES_OFFSET, 1 );
	SetProfileSettingValueID( BONUS_ALWAYS_HAVE_AMMO_OFFSET, 1 );
	SetProfileSettingValueID( BONUS_DOUBLE_HEALTH_REGEN_RATE_OFFSET, 1 );
	SetProfileSettingValueID( BONUS_UNLOCK_CHAR_WEAP_ART_OFFSET, 1 );
	SetProfileSettingValueID( BONUS_UNLOCK_ENV_ART_OFFSET, 1 );
	SetProfileSettingValueID( BONUS_UNLOCK_ALL_LEVELS_OFFSET, 1 );
}

function bool IsBonusUnlocked( int zeroBasedBonus )
{
	local	int		bonusNum;
	local	int		currValue;

	bonusNum = zeroBasedBonus +	FirstBonus;
	GetProfileSettingValueId( bonusNum, currValue );

	if ( currValue == 1 )
		return ( true );

	return ( false );
}

function name GetBonusName( int zeroBasedBonus )
{
	local	int		bonusNum;
	local	name	bonusName;

	bonusNum = zeroBasedBonus +	FirstBonus;
	bonusName = GetProfileSettingName(bonusNum);

	return ( bonusName );
}

/** Will return the value the user has set for YInversion */
function bool GetInvertMouseOption()
{
	local bool Retval;
	local int Value;

	GetProfileSettingValueId( PSI_YInversion, Value );

	switch( Value )
	{
	case PYIO_On:
		Retval = TRUE;
		break;
	case PYIO_Off:
		Retval = FALSE;
		break;
	default:
		Retval = FALSE;
		break;
	}

	return Retval;
}

function SetInvertMouseOption(bool bSetting)
{
	local int Value;

	if (bSetting)
		Value = PYIO_On;
	else
		Value = PYIO_Off;

	SetProfileSettingValueId( PSI_YInversion, Value );
}


/** Will return the value the user has set for ControllerVibratio */
function bool GetControllerVibrationOption()
{
	local bool Retval;
	local int Value;

	GetProfileSettingValueId( PSI_ControllerVibration, Value );

	switch( Value )
	{
	case PCVTO_On:
		Retval = TRUE;
		break;
	case PCVTO_Off:
		Retval = FALSE;
		break;
	default:
		Retval = TRUE;
		break;
	}

	return Retval;
}

function bool GetAutoAimOption()
{
	local bool Retval;
	local int Value;

	GetProfileSettingValueId( PSI_AutoAim, Value );

	switch( Value )
	{
	case PAAO_On:
		Retval = TRUE;
		break;
	case PAAO_Off:
		Retval = FALSE;
		break;
	default:
		Retval = FALSE;
		break;
	}

	return Retval;
}

function float GetVideoGamma()
{
	local int Value;

	GetProfileSettingValueInt( VideoGamma, Value );

	return Value / 10.0f;
}

function float GetMidTones()
{
	local int Value;

	GetProfileSettingValueInt( VideoMidTones, Value );

	return Value / 10.0f;
}

function float GetHighlights()
{
	local int Value;

	GetProfileSettingValueInt( VideoHighlights, Value );

	return Value / 10.0f;
}


/**
 * Sets all of the profile settings to their default values
 */
native function SetToDefaults();

// Sets a single profile setting index to its default value
// (Takes into account 360 Defaults as well)
native function SetIndexToDefault(int Index);

function float GetMasterVol()
{
	local int Value;

	GetProfileSettingValueInt( AudioMasterVol, Value );

	return Value / 10.0f;
}

function float GetMusicVol()
{
	local int Value;

	GetProfileSettingValueInt( AudioMusicVol, Value );

	return Value / 10.0f;
}

function float GetSFXVol()
{
	local int Value;

	GetProfileSettingValueInt( AudioSFXVol, Value );

	return Value / 10.0f;
}

function float GetDialogVol()
{
	local int Value;

	GetProfileSettingValueInt( AudioDialogVol, Value );

	return Value / 10.0f;
}

function bool GetSubtitlesOption()
{
	local int Value;

	GetProfileSettingValueId( GameSubtitles, Value );

	if (Value == 0)
		return false;
	else
		return true;
}

function bool GetHUDOption()
{
	local int Value;

	GetProfileSettingValueId( GameHUD, Value );

	if (Value == 0)
		return false;
	else
		return true;
}

function bool GetCrosshairOption()
{
	local int Value;

	GetProfileSettingValueId( GameCrosshairs, Value );

	if (Value == 0)
		return false;
	else
		return true;
}

function int GetDifficultyOption()
{
	local int Value;
	GetProfileSettingValueId(PSI_GameDifficulty, Value);
	
	return Value;
	
}

function bool IsInsaneUnlocked()
{
// 	local int Value;
// 	
// 	GetProfileSettingValueInt( InsaneUnlocked, Value );
// 
// 	if (Value == 0)
// 		return false;
// 	else
// 		return true;
	return true;
}

function UnlockInsane()
{
	SetProfileSettingValueInt( InsaneUnlocked, 1 );
}

function bool AddToSprintTime(float Time)
{
	local float Value;
	local string StrValue;
	
	GetProfileSettingValueFloat( TotalSprintTime, Value );

	Value += Time;

	StrValue = "" $ Value;

	SetProfileSettingValue( TotalSprintTime, StrValue );

	//`log("Total Sprint Time is"@Value);
	if (Value > 1800.0f)
		return true;
	else
		return false;
}

function bool GetSouthpawForced()
{
	local int Value;
	
	GetProfileSettingValueId( PSI_MovementControl, Value );
	//`log("Value is"@Value);
	if (Value == PMCO_L_Thumbstick)
		return false;
	else
		return true;
}

function int GetAccuracy()
{
	local int Value;
	GetProfileSettingValueInt(BulletAccuracy, Value);
	return Value;
}

function bool IsMusicEnabled()
{
	local int Value;
	
	GetProfileSettingValueId( AudioMusicSetting, Value );

	if (Value == 1)
		return true;
	else
		return false;
}

function bool IsFullscreenEnabled()
{
	local int Value;
	
	GetProfileSettingValueId( VideoFullscreen, Value );

	if (Value == 1)
		return true;
	else
		return false;
}

function int GetVideoResolution()
{
	local int Value;
	
	GetProfileSettingValueInt( VideoResolution, Value );

	return Value;
}

native function int GetVideoPerformanceFromAppCompat();

function int GetVideoPerformance()
{
	local int Value;
	
	GetProfileSettingValueInt( VideoPerformance, Value );
	
	if( Value == -1 )
	{
		Value = GetVideoPerformanceFromAppCompat();
		SetProfileSettingValueInt( VideoPerformance, Value ); 
	}

	return Value;
}

function SetLocalAccountName(string AccountName)
{
	SetProfileSettingValue(LocalAccountName, AccountName);
}

function SetOnlineAccountName(string AccountName)
{
	SetProfileSettingValue(OnlineAccountName, AccountName);
}

function SetOnlineAccountPassword(string AccountPassword)
{
	SetProfileSettingValue(OnlineAccountPassword, AccountPassword);
}

function string GetLocalAccountName()
{
	local string AccountName;

	GetProfileSettingValue(LocalAccountName, AccountName);

	return AccountName;
}

function string GetOnlineAccountName()
{
	local string AccountName;

	GetProfileSettingValue(OnlineAccountName, AccountName);

	return AccountName;
}

function string GetOnlineAccountPassword()
{
	local string AccountPassword;
	
	GetProfileSettingValue(OnlineAccountPassword, AccountPassword);

	return AccountPassword;
}


