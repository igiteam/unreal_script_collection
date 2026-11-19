/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * List of profile settings for Gears
 *
 * NOTE: This class will normally be code generated, but the tool doesn't exist yet
 */
class GearProfileSettings extends OnlineProfileSettings
	native
	config(Game);

/** Control scheme choices */
enum EGearControlScheme
{
	GCS_Default,
	GCS_Alternate
};

/** Enums for various stick config options */
enum EGearStickConfigOpts
{
	WSCO_Default,
	WSCO_Legacy,
	WSCO_SouthPaw,
	WSCO_LegacySouthpaw
};

/** Enums for various stick config options */
enum EGearTriggerConfigOpts
{
	WTCO_Default,
	WTCO_SouthPaw
};

/** Common yes/no options */
enum EGearOptsYesNo
{
	WOYN_Yes,
	WOYN_No
};

/** Common on/off options */
enum EGearOptsOnOff
{
	WOOO_On,
	WOOO_Off
};

/** COG character choices */
enum ECogMPCharacter
{
	CMPC_Marcus,
	CMPC_Cole,
	CMPC_Baird,
	CMPC_Dom,
	CMPC_Carmine,
	CMPC_Dizzy,
	CMPC_Sam,
	CMPC_Prescott,
	CMPC_Anya,
	CMPC_Jace,
	CMPC_ColeThrashball,
	CMPC_OnyxGuard,
	CMPC_Griffin,
	CMPC_Bernie,
	CMPC_DomCommando,
	CMPC_ColeCiv,
	CMPC_MarcusNoArmor,
};

/** Locust character preference */
enum ELocustMPCharacter
{
	LMPC_Drone,
	LMPC_DroneSniper,
	LMPC_Hunter,
	LMPC_HunterNoArmor,
	LMPC_TheronHelmet,
	LMPC_BeastLord,
	LMPC_Flamer,
	LMPC_Kantus,
	LMPC_Myrrah,
	LMPC_SavageHunter,
	LMPC_SavageDrone,
	LMPC_SavageTheron,
};

/** TV Type of the user. */
enum ETVType
{
	TVT_Default,
	TVT_Soft,
	TVT_Lucent,
	TVT_Vibrant
};

/** Types of weapons that can be replaced */
enum EWeaponReplaceTypes
{
	WEAPRT_Default,
	WEAPRT_Remove
};

/** Types of public join types there can be */
enum EGearVersusPartyType
{
	// Party leader must invite players to join the party
	eGVPT_InviteRequired,
	// Friends of the party leader may join the party without being invited
	eGVPT_FriendsOnly,
	// Any player may join the party
	eGVPT_Public,
	// Kind of a fake party in that it is more of a LAN game than a party
	eGVPT_SystemLink,
	// Another fake party in that it is local and can only consist of one additional splitscreen player
	eGVPT_Local,
};

/** Types of coop join types there can be */
enum EGearCoopInviteType
{
	/** host must invite players to join */
	eGCIT_InviteRequired,

	/** friends of the host may join without being invited */
	eGCIT_FriendsOnly,

	/** any player may join */
	eGCIT_Public,
};

/** Types of campaign modes */
enum EGearCampMode
{
	eGCM_LivePublic,
	eGCM_LivePrivate,
	eGCM_SystemLink,
};

/** Types of voting for private matches */
enum EGearMapSelectType
{
	eGEARMAPSELECT_VOTE,
	eGEARMAPSELECT_HOSTSELECT,
};

/** Enum for checkpoint options */
enum EGearCheckpointUsage
{
	eGEARCHECKPOINT_UseLast,
	eGEARCHECKPOINT_Restart,
};

/** Enum of the memory slots used in the campaign */
enum EGearCampaignMemorySlot
{
	eGEARCAMPMEMORYSLOT_0,
	eGEARCAMPMEMORYSLOT_1,
	eGEARCAMPMEMORYSLOT_2,
};

/** Enum of all the UI navigation paths that might want to show a (NEW!) icon */
enum EGearLookAtNavPathType
{
	eNAVPATH_MainMenu_Training,
	eNAVPATH_MainMenu_WarJournal,
	eNAVPATH_WarJournal_Discover,
	eNAVPATH_WarJournal_Unlocks,
	eNAVPATH_WarJournal_Achieve,
	eNAVPATH_WarJournal_Titles,
};

/************************************************************************/
/* ACHIEVEMENT CONSTANTS                                                */
/************************************************************************/
/** Number of consecutive waves needed in Horde to get eGA_WELCOMETOARCADEMODE */
const NumArcadeChaptersCompleted = 5;
/** Number of consecutive waves needed in Horde to get eGA_WELCOMETOHORDEMODE */
const NumHordeWavesCompleted = 10;
/** Number of consecutive waves needed in Siege to get eGA_WELCOMETOBEASTMODE */
const NumSiegeWavesCompleted = 12;
/** Number of discoverables needed for eGA_COLLECTOR */
const DISCOVERABLE_COLLECTOR = 5;
/** Number of discoverables needed for eGA_PACKRAT */
const DISCOVERABLE_PACKRAT = 20;
/** Number of discoverables needed for eGA_HOARDER */
const DISCOVERABLE_HOARDER = 38;
/** Number of cog tags needed for eGA_REMEMBEREDTHEFALLEN */
const DISCOVERABLE_COGTAGS = 15;
/** Number of highest EOR scores in Arcade for eGA_FIRSTAMONGEQUALS */
const HighestScoreArcadeRequirement = 5;
/** Number of mini challenges to complete in Horde for eGA_CALLINGYOURSHOTS */
const HordeMiniChallengeRequirement = 10;
/** Number of TDM kills to get for eGA_WELCOMETOVERSUS */
const TDMKillsRequirement = 10;


/** Whether or not the profile has changed enough that it should be saved */
var bool bShouldBeSaved;

/** The last chapter in the core campaign. Used to differentiate campaign from DLC */
var config int LastCampaignChapter;

/** The last unlockable in the core campaign. */
var config int LastCampaignUnlockable;

/**
 * Ini option for specifying gametypes which should be hidden (used for demo builds, etc.)
 */
var		config	array<EGearMPTypes>		ExcludedGameTypeIds;


/**
 *	Settings that are not saved to live except when a non-lazy save setting is being saved
 */
var array<int>	LazySaveSettings;

/** This is the number of consecutive matches played by this player. DO NOT STORE! */
var transient int ConsecutiveMatchesPlayed;

/** Note this will only be set by per user EMS download */
var config bool bIsBanned;

/** Note this will only be set by per user EMS download */
var config bool bIsUnbanned;

/** Whether this person is an Epic employee or not */
var config bool bIsEpicDev;

/** Whether we are currently in System Link mode (overrides the Party Type in the profile settings) */
var transient bool bPartyTypeIsSystemLink;

/** Whether we are currently in local mode (overrides the Party Type in the profile settings) */
var transient bool bPartyTypeIsLocal;

/** The amount of XP to penalize a quitter with */
var config int XPQuitPenalty;

/** If true, the achievements will be enumerated all of the time ignoring the marked as enumed flag */
var config bool bForceAchievementRead;

/** If true, the profile will be uploaded all of the time ignoring the marked as uploaded flag */
var config bool bForceProfileUpload;

cpptext
{
private:
	/**
	 * Sets all of the profile settings to their default values and then does
	 * a check for your language setting and swaps the subtitle setting based
	 * off of that.
	 */
    virtual void SetToDefaults();

public:
}

/**
 * Finds the human readable name for a profile setting's value. Searches the
 * profile settings mappings for the specific profile setting and then returns a array of value mappings.
 *
 * @param ProfileSettingId the id to look up in the mappings table
 * @param Value the out param that gets the value copied to it
 *
 * @return true if found, false otherwise
 */
native function bool GetProfileSettingMappings(int ProfileSettingId,out array<IdToStringMapping> Values);

/**
 * Finds the human readable name for a profile setting's value. Searches the
 * profile settings mappings for the specifc profile setting and then returns the index of the currently selected value.
 *
 * @param ProfileSettingId the id to look up in the mappings table
 * @param Value the out param that gets the index copied ino it.
 *
 * @return true if found, false otherwise
 */
native function bool GetProfileSettingValueMappingIndex(int ProfileSettingId,out int ValueIndex);

/**
 * Hooks to allow child classes to dynamically adjust available profile settings or mappings based on e.g. ini values.
 */
event ModifyAvailableProfileSettings()
{
	Super.ModifyAvailableProfileSettings();

	RemoveExcludedGametypes();
}

/**
 * Removes any gametypes which were configured in the .ini to be disabled from the ProfileMappings array of the VERSUS_GAMETYPE setting.
 */
native final function RemoveExcludedGameTypes();


/** Will return the value the user has set for Gore */
function bool GetGoreConfigOption()
{
	local bool Retval;
	local int Value;

	GetProfileSettingValueId( `Gore, Value );

	switch( Value )
	{
	case WOOO_On:
		Retval = TRUE;
		break;
	case WOOO_Off:
		Retval = FALSE;
		break;
	default:
		Retval = FALSE;
		break;
	}

	return Retval;
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

/** Will return the value the user has set for XInversion */
function bool GetInvertTurnOption()
{
	local bool Retval;
	local int Value;

	GetProfileSettingValueId( `TurnInversion, Value );

	switch( Value )
	{
	case PXIO_On:
		Retval = TRUE;
		break;
	case PXIO_Off:
		Retval = FALSE;
		break;
	default:
		Retval = FALSE;
		break;
	}

	return Retval;
}

/** Will return the value the user has set for omnidirectional evade */
function bool GetOmniDirEvadeOption()
{
	local bool Retval;
	local int Value;

	GetProfileSettingValueId( `OmniDirEvade, Value );

	switch( Value )
	{
	case PODI_On:
		Retval = TRUE;
		break;
	case PODI_Off:
		Retval = FALSE;
		break;
	default:
		Retval = FALSE;
		break;
	}

	return Retval;
}

/** Will return the value the user has set for ControllerVibratio */
function bool GetControllerVibrationOption()
{
	local bool Retval;
	local int Value;

	GetProfileSettingValueId( PSI_ControllerVibration, Value );

	//`log( "GetControllerVibrationOption: " $ Value );

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




function bool GetHudOnOffConfigOption()
{
	local bool Retval;
	local int Value;

	GetProfileSettingValueId( `HudOnOff, Value );

	switch( Value )
	{
		case WOOO_On:
			Retval = TRUE;
			break;
		case WOOO_Off:
			Retval = FALSE;
			break;
		default:
			Retval = FALSE;
			break;
	}

	return Retval;
}

function bool GetTutorialConfigOption()
{
	local bool Retval;
	local int Value;

	GetProfileSettingValueId( `WeapTutorialsOn, Value );

	switch( Value )
	{
	case WOOO_On:
		Retval = TRUE;
		break;
	case WOOO_Off:
		Retval = FALSE;
		break;
	default:
		Retval = FALSE;
		break;
	}

	return Retval;
}

function bool GetPictogramTooltipsConfigOption()
{
	local bool Retval;
	local int Value;

	GetProfileSettingValueId( `PictogramTooltips, Value );

	switch( Value )
	{
	case WOOO_On:
		Retval = TRUE;
		break;
	case WOOO_Off:
		Retval = FALSE;
		break;
	default:
		Retval = FALSE;
		break;
	}

	return Retval;
}


/** Will return the value the user has set for MatureLanguage */
function bool GetMatureLanguageConfigOption()
{
	local bool Retval;
	local int Value;

	GetProfileSettingValueId( `MatureLang, Value );

	switch( Value )
	{
	case WOOO_On:
		Retval = TRUE;
		break;
	case WOOO_Off:
		Retval = FALSE;
		break;
	default:
		Retval = FALSE;
		break;
	}

	return Retval;
}


/** Will return the value the user has set for Subtitles */
function bool GetSubtitleConfigOption()
{
	local bool Retval;
	local int Value;

	GetProfileSettingValueId( `Subtitles, Value );

	switch( Value )
	{
	case WOOO_On:
		Retval = TRUE;
		break;
	case WOOO_Off:
		Retval = FALSE;
		break;
	default:
		Retval = FALSE;
		break;
	}

	return Retval;
}


function EGearTriggerConfigOpts GetTrigConfigOption()
{
	local EGearTriggerConfigOpts RetVal;
	local int Value;

	GetProfileSettingValueId( `GearTriggerConfig, Value );
	switch( Value )
	{
		case WTCO_SouthPaw:
			RetVal = WTCO_SouthPaw;
			break;
		case WTCO_Default:
		default:
			RetVal = WTCO_Default;
			break;
	}

	return RetVal;
}

function EGearStickConfigOpts GetStickConfigOption()
{
	local EGearStickConfigOpts RetVal;
	local int Value;

	GetProfileSettingValueId( `GearStickConfig, Value );
	switch( Value )
	{
		case WSCO_Legacy:
			RetVal = WSCO_Legacy;
			break;
		case WSCO_SouthPaw:
			RetVal = WSCO_SouthPaw;
			break;
		case WSCO_LegacySouthpaw:
			RetVal = WSCO_LegacySouthpaw;
			break;
		case WSCO_Default:
		default:
			RetVal = WSCO_Default;
			break;
	}

	return RetVal;
}

function EProfileControllerSensitivityOptions GetControllerSensitivityValue()
{
	local EProfileControllerSensitivityOptions RetVal;
	local int Value;

	GetProfileSettingValueId(PSI_ControllerSensitivity, Value );
	switch ( Value )
	{
		case PCSO_Medium:
			RetVal = PCSO_Medium;
			break;
		case PCSO_Low:
			RetVal = PCSO_Low;
			break;
		case PCSO_High:
			RetVal = PCSO_High;
			break;
		default:
			RetVal = PCSO_Medium;
			break;
	}

	return RetVal;
}

function EProfileControllerSensitivityOptions GetTargetSensitivityValue()
{
	local EProfileControllerSensitivityOptions RetVal;
	local int Value;

	GetProfileSettingValueId(`TargetSensitivity, Value );
	switch ( Value )
	{
	case PCSO_Medium:
		RetVal = PCSO_Medium;
		break;
	case PCSO_Low:
		RetVal = PCSO_Low;
		break;
	case PCSO_High:
		RetVal = PCSO_High;
		break;
	default:
		RetVal = PCSO_Medium;
		break;
	}

	return RetVal;
}

function EProfileControllerSensitivityOptions GetZoomSensitivityValue()
{
	local EProfileControllerSensitivityOptions RetVal;
	local int Value;

	GetProfileSettingValueId(`ZoomSensitivity, Value );
	switch ( Value )
	{
	case PCSO_Medium:
		RetVal = PCSO_Medium;
		break;
	case PCSO_Low:
		RetVal = PCSO_Low;
		break;
	case PCSO_High:
		RetVal = PCSO_High;
		break;
	default:
		RetVal = PCSO_Medium;
		break;
	}

	return RetVal;
}

/** Will return the Percentage to set the Dialog Volume to **/
function float GetDialogVolume()
{
	local float Value;

	GetProfileSettingValueFloat(`DialogueVolume, Value );

	return Value;
}


/** Will return the Percentage to set the Fx Volume to **/
function float GetFxVolume()
{
	local float Value;

	GetProfileSettingValueFloat(`FxVolume, Value );

	return Value;
}


/** Will return the Percentage to set the Music Volume to **/
function float GetMusicVolume()
{
	local float Value;

	GetProfileSettingValueFloat(`MusicVolume, Value );

	return Value;
}

/**
 * Gets the users gamma setting from the profile
 */
function float GetGammaSetting()
{
	local float Value;

	GetProfileSettingValueFloat(`GammaSetting,Value);

	return Value;
}

/**
 * @return Returns the user's TV type.
 */
function ETVType GetTVType()
{
	local int Value;
	GetProfileSettingValueId(`TelevisionType,Value);

	return ETVType(Value);
}

/** Get the saved tutorial variables */
function GetTutorialValues( out TutorialParams TutParams )
{
	GetProfileSettingValueInt(`SPTutorials1, TutParams.SPTut1);
	GetProfileSettingValueInt(`SPTutorials2, TutParams.SPTut2);
	GetProfileSettingValueInt(`SPTutorials3, TutParams.SPTut3);
	GetProfileSettingValueInt(`SPTutorials4, TutParams.SPTut4);
	GetProfileSettingValueInt(`MPTutorials1, TutParams.MPTut1);
	GetProfileSettingValueInt(`MPTutorials2, TutParams.MPTut2);
	GetProfileSettingValueInt(`MPTutorials3, TutParams.MPTut3);
	GetProfileSettingValueInt(`MPTutorials4, TutParams.MPTut4);
	GetProfileSettingValueInt(`TrainTutorials1, TutParams.TrainTut1);
	GetProfileSettingValueInt(`TrainTutorials2, TutParams.TrainTut2);
	GetProfileSettingValueInt(`TrainTutorials3, TutParams.TrainTut3);
	GetProfileSettingValueInt(`TrainTutorials4, TutParams.TrainTut4);
	GetProfileSettingValueInt(`SiegeTutorials1, TutParams.SiegeTut1);
	GetProfileSettingValueInt(`SiegeTutorials2, TutParams.SiegeTut2);
	GetProfileSettingValueInt(`SiegeTutorials3, TutParams.SiegeTut3);
	GetProfileSettingValueInt(`SiegeTutorials4, TutParams.SiegeTut4);
}

/** Set the tutorial values and save the profile */
function SetTutorialValues( out TutorialParams TutParams )
{
	SetProfileSettingValueInt(`SPTutorials1, TutParams.SPTut1);
	SetProfileSettingValueInt(`SPTutorials2, TutParams.SPTut2);
	SetProfileSettingValueInt(`SPTutorials3, TutParams.SPTut3);
	SetProfileSettingValueInt(`SPTutorials4, TutParams.SPTut4);
	SetProfileSettingValueInt(`MPTutorials1, TutParams.MPTut1);
	SetProfileSettingValueInt(`MPTutorials2, TutParams.MPTut2);
	SetProfileSettingValueInt(`MPTutorials3, TutParams.MPTut3);
	SetProfileSettingValueInt(`MPTutorials4, TutParams.MPTut4);
	SetProfileSettingValueInt(`TrainTutorials1, TutParams.TrainTut1);
	SetProfileSettingValueInt(`TrainTutorials2, TutParams.TrainTut2);
	SetProfileSettingValueInt(`TrainTutorials3, TutParams.TrainTut3);
	SetProfileSettingValueInt(`TrainTutorials4, TutParams.TrainTut4);
	SetProfileSettingValueInt(`SiegeTutorials1, TutParams.SiegeTut1);
	SetProfileSettingValueInt(`SiegeTutorials2, TutParams.SiegeTut2);
	SetProfileSettingValueInt(`SiegeTutorials3, TutParams.SiegeTut3);
	SetProfileSettingValueInt(`SiegeTutorials4, TutParams.SiegeTut4);
}

/** Whether a bit is set or not in a 32 bit integer */
final function bool BitIsSet( int IntegerValue, int BitIndex )
{
	return (IntegerValue & (1<<BitIndex)) != 0;
}

/** Whether a discoverable has been found yet */
function bool HasDiscoverableBeenFound( EGearDiscoverableType DiscType )
{
	local int FoundResultValue, ShiftValue;

	// Calculate the shift value
	ShiftValue = DiscType % `NUM_BITS_PER_INT;

	// Get the correct variable
	if ( DiscType < `NUM_BITS_PER_INT )
	{
		GetProfileSettingValueInt(`DiscoverFound1, FoundResultValue );
	}
	else
	{
		GetProfileSettingValueInt(`DiscoverFound2, FoundResultValue );
	}

	return BitIsSet( FoundResultValue, ShiftValue );
}

/** Returns how many discoverables have been found */
function GetNumDiscoverablesFound(out int DiscoverableCount, out int CogTagCount)
{
	local EGearDiscoverableType DiscType;
	local int Idx;

	DiscoverableCount = 0;
	CogTagCount = 0;
	for ( Idx = 0; Idx < EGearDiscoverableType_MAX; Idx++ )
	{
		DiscType = EGearDiscoverableType(Idx);
		if ( HasDiscoverableBeenFound(DiscType) )
		{
			if (InStr(string(DiscType),"_CogTag") == INDEX_NONE)
			{
				DiscoverableCount++;
			}
			else
			{
				CogTagCount++;
			}
		}
	}
}

/**
 * Function that returns whether or not any discoverables are unviewed
 * @return whether or not any disovereables are unviewed
 */
function bool AreAnyDiscoverablesUnviewed()
{
	local int NeedsViewedResultValue1, NeedsViewedResultValue2;

	GetProfileSettingValueInt(`DiscoverNeedsViewed1, NeedsViewedResultValue1 );
	GetProfileSettingValueInt(`DiscoverNeedsViewed2, NeedsViewedResultValue2 );
	return (NeedsViewedResultValue1 > 0 || NeedsViewedResultValue2 > 0);
}

/**
 * @return	the number of discoverables that have been found but not viewed
 */
function int GetNumUnviewedDiscoverables()
{
	local int Idx, Result;

	for ( Idx = 0; Idx < EGearDiscoverableType_MAX; Idx++ )
	{
		if ( IsDiscoverableMarkedForAttract(EGearDiscoverableType(Idx)) )
		{
			Result++;
		}
	}

	return Result;
}

/** Whether a newly discovered discoverable has been viewed in the front end yet */
function bool IsDiscoverableMarkedForAttract( EGearDiscoverableType DiscType )
{
	local int NeedsViewedResultValue, ShiftValue;
	local bool bResult;

	if ( HasDiscoverableBeenFound(DiscType) )
	{
		// Calculate the shift value
		ShiftValue = DiscType % `NUM_BITS_PER_INT;

		// Get the correct variable
		if ( DiscType < `NUM_BITS_PER_INT )
		{
			GetProfileSettingValueInt(`DiscoverNeedsViewed1, NeedsViewedResultValue );
		}
		else
		{
			GetProfileSettingValueInt(`DiscoverNeedsViewed2, NeedsViewedResultValue );
		}

		bResult = BitIsSet( NeedsViewedResultValue, ShiftValue );
	}

	return bResult;
}

/** Checks to see if the UI should send a progress message or unlock an achievement for discoverables */
function UpdateDiscoverableProgression(EGearDiscoverableType DiscType, GearPC GPC, optional bool bShouldSuppressAlert)
{
	local int NumCogTagsFound, NumDiscoverablesFound;
	local GearAlertManager GAM;

	GAM = GPC.GetAlertManager();

	GetNumDiscoverablesFound(NumDiscoverablesFound, NumCogTagsFound);

	if (InStr(string(DiscType),"_CogTag") == INDEX_NONE)
	{
		// Check for unlocking eGA_COLLECTOR
		if (NumDiscoverablesFound <= DISCOVERABLE_COLLECTOR)
		{
			if (NumDiscoverablesFound == DISCOVERABLE_COLLECTOR)
			{
				// @ACHIEVEMENT - Collector
				GPC.ClientUnlockAchievement(eGA_COLLECTOR);
			}
			else if (GAM != None && !bShouldSuppressAlert)
			{
				GAM.MadeProgress(ePROG_Achievement, eGA_COLLECTOR);
			}
		}
		// Check for unlocking eGA_PACKRAT
		else if (NumDiscoverablesFound <= DISCOVERABLE_PACKRAT)
		{
			if (NumDiscoverablesFound == DISCOVERABLE_PACKRAT)
			{
				// @ACHIEVEMENT - PackRat
				GPC.ClientUnlockAchievement(eGA_PACKRAT);
			}
			else if (GAM != None && !bShouldSuppressAlert)
			{
				GAM.MadeProgress(ePROG_Achievement, eGA_PACKRAT);
			}
		}
		// Check for unlocking eGA_HOARDER
		else if (NumDiscoverablesFound <= DISCOVERABLE_HOARDER)
		{
			if (NumDiscoverablesFound == DISCOVERABLE_HOARDER)
			{
				// @ACHIEVEMENT - Hoarder
				GPC.ClientUnlockAchievement(eGA_HOARDER);
			}
			else if (GAM != None && !bShouldSuppressAlert)
			{
				GAM.MadeProgress(ePROG_Achievement, eGA_HOARDER);
			}
		}
	}
	else
	{
		// Check for unlocking eGA_REMEMBEREDTHEFALLEN
		if (NumCogTagsFound == DISCOVERABLE_COGTAGS)
		{
			// @ACHIEVEMENT - Remembered the Fallen
			GPC.ClientUnlockAchievement(eGA_REMEMBEREDTHEFALLEN);
		}
		else if (GAM != None && !bShouldSuppressAlert)
		{
			GAM.MadeProgress(ePROG_Achievement, eGA_REMEMBEREDTHEFALLEN);
		}
	}
}

/** Mark a discoverable as found but yet not viewed */
function MarkDiscoverableAsFoundButNotViewed( EGearDiscoverableType DiscType, GearPC GPC, optional bool bSaveProfile=true )
{
	local int FoundResultValue, NeedsViewedResultValue, ShiftValue;

	// Make sure to only mark the discoverable if it hasn't already been marked since the "viewed"
	// field could get screwed up on accidental coop completes
	if ( !HasDiscoverableBeenFound(DiscType) )
	{
		// Add it to the most recently found list
		SetMostRecentlyFoundDiscoverable(DiscType);

		// First grab the correct variables from the profile and determine how much bit shifting to do
		if ( DiscType < `NUM_BITS_PER_INT )
		{
			GetProfileSettingValueInt(`DiscoverFound1, FoundResultValue );
			GetProfileSettingValueInt(`DiscoverNeedsViewed1, NeedsViewedResultValue );
			ShiftValue = DiscType;
		}
		else
		{
			GetProfileSettingValueInt(`DiscoverFound2, FoundResultValue );
			GetProfileSettingValueInt(`DiscoverNeedsViewed2, NeedsViewedResultValue );
			ShiftValue = DiscType - `NUM_BITS_PER_INT;
		}

		// Calculate the new values to be set in the profile
		FoundResultValue = FoundResultValue | (1 << ShiftValue);
		NeedsViewedResultValue = NeedsViewedResultValue | (1 << ShiftValue);

		// Set the profile
		if ( DiscType < `NUM_BITS_PER_INT )
		{
			SetProfileSettingValueInt(`DiscoverFound1, FoundResultValue );
			SetProfileSettingValueInt(`DiscoverNeedsViewed1, NeedsViewedResultValue );
		}
		else
		{
			SetProfileSettingValueInt(`DiscoverFound2, FoundResultValue );
			SetProfileSettingValueInt(`DiscoverNeedsViewed2, NeedsViewedResultValue );
		}

		// Check for discoverable progression
		UpdateDiscoverableProgression( DiscType, GPC );

		// Save the profile
		if ( bSaveProfile )
		{
			GPC.SaveProfile();
		}
	}
}

/** Mark a discoverable as viewed */
function bool MarkDiscoverableAsViewed( EGearDiscoverableType DiscType )
{
	local int Discover1_AttractMask, Discover2_AttractMask, ShiftValue, NegateMaskValue, AttractMask;
	local bool bResult;

	if ( HasDiscoverableBeenFound(DiscType) )
	{
		GetProfileSettingValueInt(`DiscoverNeedsViewed1, Discover1_AttractMask );
		GetProfileSettingValueInt(`DiscoverNeedsViewed2, Discover2_AttractMask );

		// First grab the correct variables from the profile and determine how much bit shifting to do
		if ( DiscType < `NUM_BITS_PER_INT )
		{
			AttractMask = Discover1_AttractMask;
			ShiftValue = DiscType;
		}
		else
		{
			AttractMask = Discover2_AttractMask;
			ShiftValue = DiscType - `NUM_BITS_PER_INT;
		}

		// Calculate the new values to be set in the profile
		NegateMaskValue = ~(1 << ShiftValue);
		AttractMask = AttractMask & NegateMaskValue;

		// Set the profile
		if ( DiscType < `NUM_BITS_PER_INT )
		{
			Discover1_AttractMask = AttractMask;
			SetProfileSettingValueInt(`DiscoverNeedsViewed1, AttractMask );
		}
		else
		{
			Discover2_AttractMask = AttractMask;
			SetProfileSettingValueInt(`DiscoverNeedsViewed2, AttractMask );
		}

		bResult = true;
	}

	return bResult;
}

/**
 * Returns the collectible type of the most nth recent collectable found
 *
 * @param RecentIdx - most recent = 0, oldest = 4
 */
function EGearDiscoverableType GetRecentlyFoundDiscoverable(int RecentIdx)
{
	local int Value;

	GetProfileSettingValueInt(`RecentDiscover1 + RecentIdx, Value);
	return EGearDiscoverableType(Value);
}

/** Sets a discoverable as the most recently found one */
function SetMostRecentlyFoundDiscoverable(EGearDiscoverableType DiscType)
{
	local int Value;
	local int ProfileId;

	// First move all the other recently found discoverables down the list
	for (ProfileId = `RecentDiscover4; ProfileId >= `RecentDiscover1; ProfileId--)
	{
		GetProfileSettingValueInt(ProfileId, Value);
		SetProfileSettingValueInt(ProfileId + 1, Value);
	}

	// Then set the newest one
	SetProfileSettingValueInt(`RecentDiscover1, DiscType);
}

/**
 * Returns the persistent data ID of the most nth recent challenge earned
 *
 * @param RecentIdx - most recent = 0, oldest = 4
 */
function int GetRecentlyEarnedChallenge(int RecentIdx)
{
	local int Value;

	GetProfileSettingValueInt(`RecentChallenge1 + RecentIdx, Value);
	return Value;
}

/** Sets a challenge as the most recently found one */
function SetMostRecentlyEarnedChallenge(int PersistentDataId)
{
	local int Value;
	local int ProfileId;

	// First move all the other recently found discoverables down the list
	for (ProfileId = `RecentChallenge4; ProfileId >= `RecentChallenge1; ProfileId--)
	{
		GetProfileSettingValueInt(ProfileId, Value);
		SetProfileSettingValueInt(ProfileId + 1, Value);
	}

	// Then set the newest one
	SetProfileSettingValueInt(`RecentChallenge1, PersistentDataId);
}

/**
 * Marks an achievement as completed and sets the bit for displaying the attract icon in war journal.
 */
function bool MarkAchievementAsCompleted( EGearAchievement AchievementId, GearPC GPC, optional bool bSaveProfile=true )
{
	local int ProfileId, CurrentCompletedAchievementMask, CurrentUnviewedAchievementMask, NewUnviewedAchievementMask;
	local bool bResult;

	if ( !HasCompletedAchievement(AchievementId) )
	{
		// mark it as completed
		ProfileId = AchievementId < `NUM_BITS_PER_INT ? `COMPLETED_ACHIEVEMENT_MASK_A : `COMPLETED_ACHIEVEMENT_MASK_B;
		GetProfileSettingValueInt(ProfileId, CurrentCompletedAchievementMask);
		SetProfileSettingValueInt(ProfileId, CurrentCompletedAchievementMask | (1 << (AchievementId % `NUM_BITS_PER_INT)));

		// now set the bit to show the attract icon for achievements in war journal
		ProfileId = AchievementId < `NUM_BITS_PER_INT ? `UNVIEWED_ACHIEVEMENT_MASK_A : `UNVIEWED_ACHIEVEMENT_MASK_B;
		GetProfileSettingValueInt(ProfileId, CurrentUnviewedAchievementMask);

		NewUnviewedAchievementMask = CurrentUnviewedAchievementMask | (1 << (AchievementId % `NUM_BITS_PER_INT));
		if ( NewUnviewedAchievementMask != CurrentUnviewedAchievementMask )
		{
			SetProfileSettingValueInt(ProfileId, NewUnviewedAchievementMask);

			if ( bSaveProfile )
			{
				GPC.SaveProfile();
			}
		}

		bResult = true;
	}

	return bResult;
}

/**
 * Marks the achievement as having been viewed by the user.
 */
function bool MarkAchievementAsViewed( EGearAchievement AchievementId )
{
	local int ProfileId, AchievementMaskValueA, AchievementMaskValueB, NegateMaskValue, AttractMask;
	local bool bResult;

	if ( HasCompletedAchievement(AchievementId) && IsAchievementMarkedForAttract(AchievementId) )
	{
		GetProfileSettingValueInt(`UNVIEWED_ACHIEVEMENT_MASK_A, AchievementMaskValueA );
		GetProfileSettingValueInt(`UNVIEWED_ACHIEVEMENT_MASK_B, AchievementMaskValueB );

		NegateMaskValue = ~(1 << (AchievementId % `NUM_BITS_PER_INT));
		if ( AchievementId < `NUM_BITS_PER_INT )
		{
			ProfileId = `UNVIEWED_ACHIEVEMENT_MASK_A;
			AttractMask = AchievementMaskValueA & NegateMaskValue;
			bResult = AchievementMaskValueA != AttractMask;

			AchievementMaskValueA = AttractMask;
		}
		else
		{
			ProfileId = `UNVIEWED_ACHIEVEMENT_MASK_B;
			AttractMask = AchievementMaskValueB & NegateMaskValue;
			bResult = AchievementMaskValueB != AttractMask;

			AchievementMaskValueB = AttractMask;
		}

		SetProfileSettingValueInt(ProfileId, AttractMask);
	}

	return bResult;
}

/**
 * @return	the number of discoverables that have been found but not viewed
 */
function int GetNumUnviewedAchievements()
{
	local int Idx, AchievementMaskValueA, AchievementMaskValueB, Result;

	GetProfileSettingValueInt(`UNVIEWED_ACHIEVEMENT_MASK_A, AchievementMaskValueA );
	GetProfileSettingValueInt(`UNVIEWED_ACHIEVEMENT_MASK_B, AchievementMaskValueB );

	for ( Idx = 0; Idx < `NUM_BITS_PER_INT; Idx++ )
	{
		if ( (AchievementMaskValueA & (1 << Idx)) != 0 )
		{
			Result++;
		}
	}
	for ( Idx = 0; Idx < eGA_DLC1 - `NUM_BITS_PER_INT; Idx++ )
	{
		if ( (AchievementMaskValueB & (1 << Idx)) != 0 )
		{
			Result++;
		}
	}

	return Result;
}

/** @return	TRUE if the user completed the specified achievement */
function bool HasCompletedAchievement( EGearAchievement AchievementId )
{
	local int ProfileId, CompletionMaskValue;
	local bool bResult;

	ProfileId = AchievementId < `NUM_BITS_PER_INT ? `COMPLETED_ACHIEVEMENT_MASK_A : `COMPLETED_ACHIEVEMENT_MASK_B;
	if ( GetProfileSettingValueInt(ProfileId, CompletionMaskValue) )
	{
		bResult = (CompletionMaskValue & (1 << (AchievementId % `NUM_BITS_PER_INT))) != 0;
	}

	return bResult;
}

/** @return	TRUE if the user has viewed the achievement in the war journal */
function bool IsAchievementMarkedForAttract( EGearAchievement AchievementId )
{
	local int ProfileId, UnviewedAchievementMask;
	local bool bResult;

	ProfileId = AchievementId < `NUM_BITS_PER_INT ? `UNVIEWED_ACHIEVEMENT_MASK_A : `UNVIEWED_ACHIEVEMENT_MASK_B;
	if ( GetProfileSettingValueInt(ProfileId, UnviewedAchievementMask) )
	{
		bResult = (UnviewedAchievementMask & (1 << (AchievementId%32))) != 0;
	}

	return bResult;
}

/**
* @return Returns the user's TV type.
*/
function EGearControlScheme GetControlScheme()
{
	local int Value;
	GetProfileSettingValueId(`GearControlScheme,Value);

	return EGearControlScheme(Value);
}

function int GetPreferredClassIndex(int Team)
{
	local int Value;

	GetProfileSettingValueInt((Team == 1 ? `LocustMPCharacter : `CogMPCharacter) , Value );
	return Value;
}

/** Returns the selected medal index */
function int GetPreferredMedalIndex()
{
	local int Value;

	if (!GetProfileSettingValueInt(`SelectedMedal, Value))
	{
		Value = -1;
	}
	return Value;
}

/** Sets the selected medal index */
function SetPreferredMedalIndex(int Value)
{
	SetProfileSettingValueInt(`SelectedMedal, Value);
}

/** Whether the players has ever configured their MP preferences or not */
function bool HasConfiguredMPPreferences()
{
	local int Value;

	if (GetProfileSettingValueInt(`AccessedMPPrefs, Value))
	{
		return (Value ==1);
	}
	// Default to true for local testing
	return true;
}

/** Mark this player as having configuring their MP prefs */
function MarkAsConfiguredMPPreferences()
{
	SetProfileSettingValueInt(`AccessedMPPrefs, 1);
}

/** Whether the palyers have ever configured their video calibration or not */
function bool HasConfiguredVideoSettings()
{
	local int Value;

	if (GetProfileSettingValueInt(`ConfiguredVideoSettings, Value))
	{
		return (Value == 1);
	}
	// Default to true for local testing
	return TRUE;
}

/** Mark this player as having configured their video calibration */
function MarkAsConfiguredVideoSettings()
{
	SetProfileSettingValueInt(`ConfiguredVideoSettings, 1);
}

/** Whether or not the player has ever configured their  */

/** Get the provider index for the skin provider for a configurable weapon */
function int GetProviderIndexForWeaponSkin(EWeaponClass WeapType)
{
	local int ProfileId;
	local int Value;

	ProfileId = INDEX_NONE;

	// Get the profile id based on the weapon type
	switch (WeapType)
	{
		case WC_Lancer:
			ProfileId = `WeaponSkin_Lancer;
			break;
		case WC_Hammerburst:
			ProfileId = `WeaponSkin_Hammerburst;
			break;
		case WC_RetroLancer:
			ProfileId = `WeaponSkin_Retro;
			break;
		case WC_Gnasher:
			ProfileId = `WeaponSkin_Gnasher;
			break;
		case WC_SawedOffShotgun:
			ProfileId = `WeaponSkin_SawedOff;
			break;
	}

	if (ProfileId != INDEX_NONE)
	{
		// return the value in the profile
		if (GetProfileSettingValueInt(ProfileId, Value))
		{
			return Value;
		}
	}

	return INDEX_NONE;
}

/** Set the provider index for the skin provider for a configurable weapon */
function SetUniqueIdForWeaponSkin(EWeaponClass WeapType, int UniqueId)
{
	local int ProfileId;

	ProfileId = INDEX_NONE;

	// Get the profile id based on the weapon type
	switch (WeapType)
	{
	case WC_Lancer:
		ProfileId = `WeaponSkin_Lancer;
		break;
	case WC_Hammerburst:
		ProfileId = `WeaponSkin_Hammerburst;
		break;
	case WC_RetroLancer:
		ProfileId = `WeaponSkin_Retro;
		break;
	case WC_Gnasher:
		ProfileId = `WeaponSkin_Gnasher;
		break;
	case WC_SawedOffShotgun:
		ProfileId = `WeaponSkin_SawedOff;
		break;
	}

	if (ProfileId != INDEX_NONE)
	{
		SetProfileSettingValueInt(ProfileId, UniqueId);
	}
}

/**
 * Set the default character to use for multiplayer
 *
 * @param Team - 0 for COG, 1 for Locust
 *
 * @param CharacterId - the ID of the player in the data provider
 */
function SetPreferredClassIndex(int Team, int CharacterId)
{
	SetProfileSettingValueInt((Team == 1 ? `LocustMPCharacter : `CogMPCharacter), CharacterId);
}

function int GetPreferredPrimaryWeaponId()
{
	local int Value;

	if ( !GetProfileSettingValueInt(`DefaultMPWeapon, Value) )
	{
		Value = WC_Lancer;
	}

	return Value;
}

/**
 * Set the default weapon for multiplayer
 *
 * @param WeaponId - the ID of the weapon in the data provider
 */
function SetPreferredPrimaryWeaponId(int WeaponId)
{
	SetProfileSettingValueInt(`DefaultMPWeapon, WeaponId);
}


function int GetPreferredSecondaryWeaponId()
{
	local int Value;

	if ( !GetProfileSettingValueInt(`DefaultSecondaryMPWeapon, Value) )
	{
		Value = WC_Gnasher;
	}

	return Value;
}

/**
 * Set the default weapon for multiplayer
 *
 * @param WeaponId - the ID of the weapon in the data provider
 */
function SetPreferredSecondaryWeaponId(int WeaponId)
{
	SetProfileSettingValueInt(`DefaultSecondaryMPWeapon, WeaponId);
}

function bool IsMapVoteEnabled()
{
	local int Value;

	if ( !GetProfileSettingValueId(`MAP_SELECTION_MODE, Value) )
	{
		Value = eGEARMAPSELECT_HOSTSELECT;
	}

	return Value != eGEARMAPSELECT_HOSTSELECT;
}

/** Returns the correct profile ID of the chapter completion based on chapter and difficulty */
function int GetChapterCompletedProfileID( int Chapter, bool bWasArcade, EDifficultyLevel Difficulty )
{
	local bool bUseFirstInt;

	// Determine if we're using the first packed integer or the second
	bUseFirstInt = (Chapter < 32);

	if (bWasArcade)
	{
		switch ( Difficulty )
		{
		case DL_Casual:
			return bUseFirstInt ? `CompletedChaptersArcadeCasual1 : `CompletedChaptersArcadeCasual2;
		case DL_Normal:
			return bUseFirstInt ? `CompletedChaptersArcadeNormal1 : `CompletedChaptersArcadeNormal2;
		case DL_Hardcore:
			return bUseFirstInt ? `CompletedChaptersArcadeHard1 : `CompletedChaptersArcadeHard2;
		case DL_Insane:
			return bUseFirstInt ? `CompletedChaptersArcadeInsane1 : `CompletedChaptersArcadeInsane2;
		}
	}
	else
	{
		switch ( Difficulty )
		{
		case DL_Casual:
			return bUseFirstInt ? `CompletedChaptersCasual1 : `CompletedChaptersCasual2;
		case DL_Normal:
			return bUseFirstInt ? `CompletedChaptersNormal1 : `CompletedChaptersNormal2;
		case DL_Hardcore:
			return bUseFirstInt ? `CompletedChaptersHard1 : `CompletedChaptersHard2;
		case DL_Insane:
			return bUseFirstInt ? `CompletedChaptersInsane1 : `CompletedChaptersInsane2;
		}
	}

	return -1;
}

/** Whether the player has ever unlocked any chapters (excluding the first since that is free) */
function bool HasUnlockedAnyChapters()
{
	local int Value;

	GetProfileSettingValueInt(`UnlockedChapterAccess1, Value);
	if (Value != 0 && Value != 1)
	{
		return true;
	}

	GetProfileSettingValueInt(`UnlockedChapterAccess2, Value);
	if (Value > 0)
	{
		return true;
	}

	return false;
}

/** Whether a chapter has been completed yet in a particular difficulty (EITHER ARCADE OR CINE) */
function bool HasChapterBeenCompleted( int Chapter, EDifficultyLevel Difficulty, optional bool bArcadeOnly=false )
{
	local int CineResultValue, ArcadeResultValue, ShiftValue;
	local int CineProfileID, ArcadeProfileID;
	local bool bUseFirstInt;

	// Determine if we're using the first packed integer or the second
	bUseFirstInt = (Chapter < 32);

	// Calculate the shift value
	ShiftValue = bUseFirstInt ? Chapter : Chapter - 32;

	// Chapter completion is either arcade OR cinematic, unless specified
	ArcadeProfileID = GetChapterCompletedProfileID( Chapter, true, Difficulty );
	GetProfileSettingValueInt(ArcadeProfileID, ArcadeResultValue );

	if (bArcadeOnly)
	{
		return BitIsSet( ArcadeResultValue, ShiftValue );
	}

	CineProfileID = GetChapterCompletedProfileID( Chapter, false, Difficulty );
	GetProfileSettingValueInt(CineProfileID, CineResultValue );

	return BitIsSet( CineResultValue, ShiftValue ) || BitIsSet( ArcadeResultValue, ShiftValue );
}

/** Whether a chapter has been unlocked for access */
function bool HasChapterBeenUnlockedForAccess( int Chapter )
{
	local int ResultValue, ShiftValue, ProfileID;
	local bool bUseFirstInt;
	local GearCampaignChapterData ChapterData;

	ChapterData = class'GearUIDataStore_GameResource'.static.GetChapterDataProvider(Chapter);
	if (ChapterData == none)
	{
		return false;
	}
	//If it is always unlocked...
	if (ChapterData.IsAlwaysUnlocked)
	{
		//unlock it in the profile
		MarkChapterForAccess(Chapter);
		return true;
	}

	// Determine if we're using the first packed integer or the second
	bUseFirstInt = (Chapter < 32);

	// Calculate the shift value
	ShiftValue = bUseFirstInt ? Chapter : Chapter - 32;

	// Get the correct variable from the helper function
	ProfileID = bUseFirstInt ? `UnlockedChapterAccess1 : `UnlockedChapterAccess2;

	GetProfileSettingValueInt(ProfileID, ResultValue );

	return BitIsSet( ResultValue, ShiftValue );
}

/** Whether a chapter has been completed yet using any variety of difficulties */
function bool HasChapterBeenCompletedAcossDifficulties(int Chapter, bool bArcadeOnly=false)
{
	local int DiffIndex;

	// Loop through all difficulties
	for (DiffIndex = 0; DiffIndex < DL_MAX; DiffIndex++)
	{
		if (HasChapterBeenCompleted(Chapter, EDifficultyLevel(DiffIndex), bArcadeOnly))
		{
			return true;
		}
	}

	return false;
}

/** Whether an act has been completed yet using any variety of difficulties */
function bool HasActBeenCompletedAcrossDifficulties(int Act)
{
	local array<int> ChapterList;
	local int ChapterIndex;

	class'GearUIDataStore_GameResource'.static.GetChapterPointsFromAct(Act, ChapterList);
	// Loop through all chapters in this act
	for (ChapterIndex = 0; ChapterIndex < ChapterList.Length; ChapterIndex++)
	{
		// If was not completed bail
		if (!HasChapterBeenCompletedAcossDifficulties(ChapterList[ChapterIndex]))
		{
		   return false;
		}
	}
	return true;
}

/** Whether an act has been completed yet in a particular difficulty */
function bool HasActBeenCompleted( int Act, EDifficultyLevel Difficulty )
{
	local array<int> ChapterList;
	local int Idx;

	class'GearUIDataStore_GameResource'.static.GetChapterPointsFromAct(Act, ChapterList);
	for ( Idx = 0; Idx < ChapterList.length; Idx++ )
	{
		if ( !HasChapterBeenCompleted(ChapterList[Idx], Difficulty) )
		{
			return false;
		}
	}

	return true;
}

/** Whether an act has been unlocked for access */
function bool HasActBeenUnlockedForAccess( int Act )
{
	local array<int> ChapterList;
	local int Idx;

	class'GearUIDataStore_GameResource'.static.GetChapterPointsFromAct(Act, ChapterList);
	for ( Idx = 0; Idx < ChapterList.length; Idx++ )
	{
		if ( HasChapterBeenUnlockedForAccess(ChapterList[Idx]) )
		{
			return true;
		}
	}

	return false;
}

/** Marks the chapter for access in the menus */
function MarkChapterForAccess( int Chapter )
{
	local int ResultValue, ShiftValue, ProfileID;
	local bool bUseFirstInt;

	// Determine if we're using the first packed integer or the second
	bUseFirstInt = (Chapter < 32);

	// Calculate the shift value
	ShiftValue = bUseFirstInt ? Chapter : Chapter - 32;

	// Get the correct variable
	ProfileID = bUseFirstInt ? `UnlockedChapterAccess1 : `UnlockedChapterAccess2;

	// Get the current value in the profile
	GetProfileSettingValueInt(ProfileID, ResultValue );

	// Calculate the new values to be set in the profile
	ResultValue = ResultValue | (1 << ShiftValue);

	// Set the profile
	SetProfileSettingValueInt(ProfileID, ResultValue );
}

/**
 * Whether a chapter has been completed when playing in a coop game
 * @param Chapter - chapter to check
 * @param bFullCoop - whether a chapter has been completed when playing in a 4 player coop game
 */
function bool HasChapterBeenCompletedInCoop( int Chapter, optional bool bFullCoop=false )
{
	local int ResultValue, ShiftValue, ProfileID;
	local bool bUseFirstInt;

	// Determine if we're using the first packed integer or the second
	bUseFirstInt = (Chapter < 32);

	// Calculate the shift value
	ShiftValue = bUseFirstInt ? Chapter : Chapter - 32;

	// Get the correct variable
	if (!bFullCoop)
	{
		ProfileID = bUseFirstInt ? `CoopCompletedChapters1 : `CoopCompletedChapters2;
	}
	else
	{
		ProfileID = bUseFirstInt ? `FullCoopCompletedChapters1 : `FullCoopCompletedChapters2;
	}

	GetProfileSettingValueInt(ProfileID, ResultValue );

	return BitIsSet( ResultValue, ShiftValue );
}

/** Return the number of campaign chapters completed in coop */
function GetNumCampaignChaptersCompletedInCoop(out int CoopComplete, out int FullCoopComplete)
{
	local int Idx;
	local int NumChaptersInGame;

	CoopComplete = 0;
	FullCoopComplete = 0;

	NumChaptersInGame = class'GearUIDataStore_GameResource'.static.GetNumChaptersInGame();
	for ( Idx = 0; Idx <= NumChaptersInGame; Idx++ )
	{
		if ( HasChapterBeenCompletedInCoop(Idx, false) )
		{
			CoopComplete++;
		}

		if ( HasChapterBeenCompletedInCoop(Idx, true) )
		{
			FullCoopComplete++;
		}
	}
}

/** Checks to see if an achievement for coop chapter completion is ready */
function UpdateCoopChapterCompleteProgression( GearPC GPC, bool bChapterAlreadyComplete, bool bFullCoopAlreadyComplete )
{
	local GearAlertManager GAM;
	local int NumChaptersInGame;
	local int NumCoopChaptersComplete, NumFullCoopChaptersComplete;

	NumChaptersInGame = class'GearUIDataStore_GameResource'.static.GetNumChaptersInGame();
	GetNumCampaignChaptersCompletedInCoop(NumCoopChaptersComplete, NumFullCoopChaptersComplete);

	GAM = GPC.GetAlertManager();

	if (!bChapterAlreadyComplete)
	{
		if (NumCoopChaptersComplete <= NumChaptersInGame)
		{
			// Check for unlocking eGA_MYFELLOWGEARS
			if (NumCoopChaptersComplete == NumChaptersInGame)
			{
				// @ACHIEVEMENT - My Fellow Gears
				GPC.ClientUnlockAchievement(eGA_MYFELLOWGEARS);
			}
			else if (GAM != None)
			{
				GAM.MadeProgress(ePROG_Achievement, eGA_MYFELLOWGEARS);
			}
		}
	}

	if (!bFullCoopAlreadyComplete)
	{
		if (NumFullCoopChaptersComplete <= NumChaptersInGame)
		{
			// Check for unlocking eGA_ADIFFERENTKINDOFFOURSOME
			if (NumFullCoopChaptersComplete == NumChaptersInGame)
			{
				// @ACHIEVEMENT - A Different Kind of Foursome
				GPC.ClientUnlockAchievement(eGA_ADIFFERENTKINDOFFOURSOME);
			}
			else if (GAM != None)
			{
				GAM.MadeProgress(ePROG_Achievement, eGA_ADIFFERENTKINDOFFOURSOME);
			}
		}
	}
}

/** Marks the CoopCompletedChapters(s) variables to reflect completing the chapter passed in - profile will be save by the caller */
function MarkCoopChapterComplete( int Chapter, GearPC GPC, int NumCoopPlayers )
{
	local int CurrentValue, ResultValue, ShiftValue, ProfileID;
	local bool bUseFirstInt;
	local bool bCoopChapterAlreadyComplete, bFullCoopAlreadyComplete;

	bCoopChapterAlreadyComplete = HasChapterBeenCompletedInCoop(Chapter);

	// Determine if we're using the first packed integer or the second
	bUseFirstInt = (Chapter < 32);

	// Calculate the shift value
	ShiftValue = bUseFirstInt ? Chapter : Chapter - 32;

	if (!bCoopChapterAlreadyComplete)
	{
		// Get the correct variable
		ProfileID = bUseFirstInt ? `CoopCompletedChapters1 : `CoopCompletedChapters2;

		// Get the current value in the profile
		GetProfileSettingValueInt(ProfileID, CurrentValue);

		// Calculate the new values to be set in the profile
		ResultValue = CurrentValue | (1 << ShiftValue);

		// Set the profile
		SetProfileSettingValueInt(ProfileID, ResultValue);
	}

	bFullCoopAlreadyComplete = HasChapterBeenCompletedInCoop(Chapter, true);
	if (!bFullCoopAlreadyComplete && NumCoopPlayers == 4)
	{
		// Get the correct variable
		ProfileID = bUseFirstInt ? `FullCoopCompletedChapters1 : `FullCoopCompletedChapters2;

		// Get the current value in the profile
		GetProfileSettingValueInt(ProfileID, CurrentValue);

		// Calculate the new values to be set in the profile
		ResultValue = CurrentValue | (1 << ShiftValue);

		// Set the profile
		SetProfileSettingValueInt(ProfileID, ResultValue);
	}

	// Check for achievement progress
	UpdateCoopChapterCompleteProgression( GPC, bCoopChapterAlreadyComplete, bFullCoopAlreadyComplete );
}

/**
 * Completes a chapter for a given difficulty
 *
 * @param ChapterNum - the chapter to complete
 * @param Difficulty - the difficulty of the current game
 * @param GPC - GearPC of the player unlocking the chapter
 * @param bWasArcade - arcade mode enabled
 * @param NumCoopPlayers - number of players involved
 * @param bSkipSave - prevents the profile from being saved (useful for recursively calling this function for unlocking lesser difficulties)
 */
function CompleteChapterByDifficulty( int Chapter, EDifficultyLevel Difficulty, GearPC GPC, optional bool bWasArcade, optional int NumCoopPlayers, optional bool bSkipSave )
{
	local int CurrentValue, ResultValue, ShiftValue, ProfileID;
	local bool bUseFirstInt;
	local bool bShouldSave;

	// Determine if we're using the first packed integer or the second
	bUseFirstInt = (Chapter < 32);

	// Calculate the shift value
	ShiftValue = bUseFirstInt ? Chapter : Chapter - 32;

	// Get the correct variable from the helper function
	ProfileID = GetChapterCompletedProfileID( Chapter, bWasArcade, Difficulty );

	// Get the current value in the profile
	GetProfileSettingValueInt(ProfileID, CurrentValue);

	// Calculate the new values to be set in the profile
	ResultValue = CurrentValue | (1 << ShiftValue);

	// Set the profile
	SetProfileSettingValueInt(ProfileID, ResultValue );

	if (bWasArcade && CurrentValue != ResultValue && !bSkipSave)
	{
		UpdateArcadeProgression(GPC);
	}

	// See if the player just finished the game so we can unlock
	// the Insane difficulty and some game completion achievements
	if ( HasCompletedGame(Difficulty) )
	{
		// Unlock insane difficulty for completing the game
		MarkUnlockableAsUnlockedButNotViewed( `UnlockableInsaneMode, GPC );

		// Unlock game completion achievements
		// NOTE: There are no breaks in this switch on purpose so that a player who beats
		//	the game on a higher difficulty gets credit for all difficulties!
		switch ( Difficulty )
		{
		case DL_Insane:
			// @ACHIEVEMENT - Once More Unto the Breach
			GPC.ClientUnlockAchievement( eGA_ONCEMOREUNTOTHEBREACH );
		case DL_Hardcore:
			// @ACHIEVEMENT - Ain't My First Rodeo
			GPC.ClientUnlockAchievement( eGA_AINTMYFIRSTRODEO );
		case DL_Normal:
		case DL_Casual:
			// @ACHIEVEMENT - Ready For More
			GPC.ClientUnlockAchievement( eGA_READYFORMORE );
		}
	}

	// Unlock this chapter at lesser difficulties
	if ( Difficulty > DL_Casual )
	{
		// Will recursively complete chapters at lesser difficulties but will not save the profile
		// until the recursion unwinds back to the root.
		CompleteChapterByDifficulty( Chapter, EDifficultyLevel(Difficulty-1), GPC, bWasArcade, NumCoopPlayers, true );
	}

	// Mark the next chapter as accessible now
	if ( !HasChapterBeenUnlockedForAccess(Chapter+1) )
	{
		MarkChapterForAccess(Chapter+1);
	}

	// Mark the chapter they just completed too since they could have jumped here via JIP
	if (Chapter > 0 &&
		!HasChapterBeenUnlockedForAccess(Chapter) )
	{
		MarkChapterForAccess(Chapter);
	}

	bShouldSave = true;

	// See if we should check for coop chapter completion
	// Hack: make sure they've been playing the game for at least 5 minutes so they can't ninja
	// the achievement
	if (GPC.IsActuallyPlayingCoop() &&
		(GPC.WorldInfo.TimeSeconds - GPC.CreationTime) > 90)
	{
		MarkCoopChapterComplete( Chapter, GPC, NumCoopPlayers );
		bShouldSave = true;
	}

	// See if we need to unlock an unlockable and save the profile if needed
	if (UpdateUnlockingUnlockable(Chapter, GPC))
	{
		bShouldSave = true;
	}

	// Save the profile
	if (bShouldSave && !bSkipSave)
	{
		GPC.SaveProfile();
	}
}

/** Checks the profile settings and determines if all of the chapters in the entire game have been completed within the same difficulty */
function bool HasCompletedGame( EDifficultyLevel Difficulty )
{
	local array<int> ActList;
	local int Idx;

	class'GearUIDataStore_GameResource'.static.GetGameCompletionActList(ActList);
	for ( Idx = 0; Idx < ActList.length; Idx++ )
	{
		if ( !HasActBeenCompleted(ActList[Idx], Difficulty) )
		{
			return false;
		}
	}

	return true;
}

/** Returns the number of chapters that have been completed on a particular difficulty */
function int GetNumChaptersCompleted( EDifficultyLevel Difficulty, optional bool bArcadeOnly=false )
{
	local int Idx, Count;
	local GearUIDataStore_GameResource GameResourceDS;
	local array<UIResourceDataProvider> ChapterProviders;

	Count = 0;

	GameResourceDS = class'GearUIManager'.static.GetGameResourceDataStore();
	if ( GameResourceDS.GetResourceProviders('Chapters', ChapterProviders) )
	{
		for ( Idx = 0; Idx < ChapterProviders.Length; Idx++ )
		{
			if ( HasChapterBeenCompleted( Idx, Difficulty, bArcadeOnly ) )
			{
				Count++;
			}
		}
	}

	return Count;
}

/** Have the Gears1 characters been unlocked or not? */
function bool Gears1CharactersAreUnlocked()
{
	if ( HasUnlockableBeenUnlocked(6) &&
		 HasUnlockableBeenUnlocked(7) &&
		 HasUnlockableBeenUnlocked(8) )
	{
		return true;
	}

	return false;
}

/** Whether an unlockable has been unlocked or not */
function bool HasUnlockableBeenUnlocked( int Unlockable )
{
	local int ResultValue;

	GetProfileSettingValueInt(`UnlockedUnlockables, ResultValue );

	return BitIsSet( ResultValue, Unlockable );
}

/** Whether a newly unlocked unlockable has been viewed in the front-end yet */
function bool IsUnlockableMarkedForAttract( int Unlockable )
{
	local int MarkedForAttractValue;

	GetProfileSettingValueInt(`UnlockableNeedsViewed, MarkedForAttractValue );
	return BitIsSet(MarkedForAttractValue, Unlockable);
}

/**
 * Checks to see if this is the chapter that complete an act and attempts to unlock an unlockable because of it
 *
 * @return - whether something was actually unlocked or not
 */
function bool UpdateUnlockingUnlockable(int ChapterCompleted, GearPC GPC)
{
	local GearCampaignActData ActData;
	local int Unlockable;

	ActData = class'GearUIDataStore_GameResource'.static.GetActDataProviderUsingChapter(ChapterCompleted);
	if (ActData != none)
	{
		if (HasActBeenCompletedAcrossDifficulties(ActData.ActNum))
		{
			switch (ActData.ActNum)
			{
				case 0:
					Unlockable = `UnlockableAct1;
					break;
				case 1:
					Unlockable = `UnlockableAct2;
					break;
				case 2:
					Unlockable = `UnlockableAct3;
					break;
				case 3:
					Unlockable = `UnlockableAct4;
					break;
				case 4:
					Unlockable = `UnlockableAct5;
					break;
			}
			return MarkUnlockableAsUnlockedButNotViewed(Unlockable, GPC);
		}
	}
	return false;
}

/** Mark an unlockable as unlocked but not yet viewed in the front-end */
function bool MarkUnlockableAsUnlockedButNotViewed(int Unlockable, GearPC GPC)
{
	local int ResultValue, NeedsViewedResultValue;
	local GearAlertManager GAM;

	GAM = GPC.GetAlertManager();

	// Make sure to only mark the unlockable if it hasn't already been marked since the "viewed"
	// field could get screwed up on accidental coop completes
	if ( !HasUnlockableBeenUnlocked(Unlockable) )
	{
		if (GAM != None)
		{
			GAM.MadeProgress(ePROG_Unlockable, Unlockable);
		}

		GetProfileSettingValueInt(`UnlockedUnlockables, ResultValue );
		GetProfileSettingValueInt(`UnlockableNeedsViewed, NeedsViewedResultValue );

		// Calculate the new values to be set in the profile
		ResultValue = ResultValue | (1 << Unlockable);
		NeedsViewedResultValue = NeedsViewedResultValue | (1 << Unlockable);

		// Set the profile
		SetProfileSettingValueInt(`UnlockedUnlockables, ResultValue );
		SetProfileSettingValueInt(`UnlockableNeedsViewed, NeedsViewedResultValue );

		return true;
	}
	return false;
}

/** Mark an unlockable as viewed in the front-end */
function bool MarkUnlockableAsViewed( int Unlockable )
{
	local int NegateMaskValue, AttractMask;

	if ( HasUnlockableBeenUnlocked(Unlockable) )
	{
		GetProfileSettingValueInt(`UnlockableNeedsViewed, AttractMask );

		// Calculate the new values to be set in the profile
		NegateMaskValue = ~(1 << Unlockable);
		AttractMask = AttractMask & NegateMaskValue;

		// Set the profile
		SetProfileSettingValueInt(`UnlockableNeedsViewed, AttractMask );

		return true;
	}

	return false;
}

/** Resets all of the unlockables */
function RelockAllUnlockables()
{
	SetProfileSettingValueInt(`UnlockedUnlockables, 0 );
	SetProfileSettingValueInt(`UnlockableNeedsViewed, 0 );
}

/** Mark an unlockable as locked and reset values */
function RelockUnlockable(int Unlockable)
{
	local int ResultValue, NeedsViewedResultValue;

	GetProfileSettingValueInt(`UnlockedUnlockables, ResultValue );
	GetProfileSettingValueInt(`UnlockableNeedsViewed, NeedsViewedResultValue );

	// Calculate the new values to be set in the profile
	ResultValue = ResultValue & ~(1 << Unlockable);
	NeedsViewedResultValue = NeedsViewedResultValue & ~(1 << Unlockable);

	// Set the profile
	SetProfileSettingValueInt(`UnlockedUnlockables, ResultValue );
	SetProfileSettingValueInt(`UnlockableNeedsViewed, NeedsViewedResultValue );
}

/** Whether a match has been won on a particular map */
function bool HasWonMPOnMap( EGearMapsShipped MapType )
{
	local int ResultValue;

	GetProfileSettingValueInt(`MPMapsCompleted, ResultValue );

	return BitIsSet( ResultValue, MapType );
}

/** Get the number of completed MP maps */
function int GetNumCompletedMPMaps()
{
	local int Idx, Count;

	Count = 0;
	for ( Idx = 0; Idx < eGEARMAP_MAX; Idx++ )
	{
		if ( HasWonMPOnMap(EGearMapsShipped(Idx)) )
		{
			Count++;
		}
	}

	return Count;
}

/** Get the number of MP maps we're shipping with */
function int GetNumShippedMPMaps()
{
	// Subtract 1 because the first index in the enum is None
	return (eGEARMAP_MAX - 1);
}

/** Mark the MP map as having been won on (completed) */
function MarkMPMapCompleted( EGearMapsShipped MapType )
{
	local int ResultValue;

	// Get the current value in the profile
	GetProfileSettingValueInt(`MPMapsCompleted, ResultValue );

	// Calculate the new values to be set in the profile
	ResultValue = ResultValue | (1 << MapType);

	// Set the profile
	SetProfileSettingValueInt(`MPMapsCompleted, ResultValue );
}

/** Checks for achievements dealing with winning MP gametypes (eGA_AroundTheWorld) */
function UpdateMPMatchProgression( EGearMPTypes MPType, EGearMapsShipped MapType, GearPC GPC )
{
}

/** Checks for achievements dealing with killing enemies */
function UpdateKillingProgression(class<GearDamageType> DmgType, GearPC GPC, bool bWasTDMMP=false)
{
	local int NumTotalKills;

	// Check for generic killing enemies achievement
	if (GetProfileSettingValueInt(`NumEnemiesKilled, NumTotalKills))
	{
		NumTotalKills++;
		SetProfileSettingValueInt(`NumEnemiesKilled, NumTotalKills);
	}

	// Check for TDM killing enemies achievement
	if (bWasTDMMP)
	{
		// Only social/ranked
		if (GearGRI_MP(GPC.WorldInfo.GRI).PlaylistId > 0)
		{
			UpdateAchievementProgression(eGA_WELCOMETOVERSUS, GPC);
		}
	}
}

/** Checks for completion of progressive achievements */
function UpdateAchievementProgression(EGearAchievement Achievement, GearPC GPC, int Count=1)
{
	local int NumTotal;
	local int Requirement;
	local int ProfileId;
	local GearAlertManager GAM;

	GAM = GPC.GetAlertManager();

	switch (Achievement)
	{
	case eGA_WELCOMETOVERSUS:
		// @ACHIEVEMENT - Welcome To Versus
		Requirement = TDMKillsRequirement;
		ProfileId = `TDMKills;
		break;
	case eGA_FIRSTAMONGEQUALS:
		// @ACHIEVEMENT - First Among Equals
		Requirement = HighestScoreArcadeRequirement;
		ProfileId = `HighestScoreArcade;
		break;
	case eGA_CALLINGYOURSHOTS:
		// @ACHIEVEMENT - Calling Your Shots
		Requirement = HordeMiniChallengeRequirement;
		ProfileId = `HordeMiniChallenges;
		break;
	default:
		Requirement = -1;
		ProfileId = -1;
		return;
	}

	if (GetProfileSettingValueInt(ProfileId, NumTotal))
	{
		NumTotal += Count;
		SetProfileSettingValueInt(ProfileId, NumTotal);
		if (NumTotal >= Requirement)
		{
			// @ACHIEVEMENT - several
			GPC.ClientUnlockAchievement(Achievement);
		}
		else
		{
			if (GAM != None)
			{
				GAM.MadeProgress(ePROG_Achievement, Achievement);
			}
		}
	}
}

/** Returns the current progression value for a progressive achievement */
final function int GetCurrentProgressValueForAchievement(EGearAchievement Achievement)
{
	local int NumTotal;
	local int ProfileId;

	switch (Achievement)
	{
	case eGA_WELCOMETOVERSUS:
		ProfileId = `TDMKills;
		break;
	case eGA_FIRSTAMONGEQUALS:
		ProfileID = `HighestScoreArcade;
		break;
	case eGA_CALLINGYOURSHOTS:
		ProfileID = `HordeMiniChallenges;
		break;
	default:
		`log("ERROR!!! Unsupported achievement"@Achievement@"is looking for a current progression value!!!");
		return 0;
	}

	GetProfileSettingValueInt(ProfileId, NumTotal);
	return NumTotal;
}

/** Sets the current progression value for a progressive achievement (only should be used in a cheat for testing!!!!) */
final function SetCurrentProgressValueForAchievement(EGearAchievement Achievement, int Value)
{
	local int ProfileId;

	switch (Achievement)
	{
	case eGA_WELCOMETOVERSUS:
		ProfileId = `TDMKills;
		break;
	case eGA_FIRSTAMONGEQUALS:
		ProfileID = `HighestScoreArcade;
		break;
	case eGA_CALLINGYOURSHOTS:
		ProfileID = `HordeMiniChallenges;
		break;
	default:
		`log("ERROR!!! Unsupported achievement"@Achievement@"is looking for a current progression value!!!");
		return;
	}

	SetProfileSettingValueInt(ProfileId, Value);
}

/**
 * Get the completion amount for a game achievement.
 *
 * @param	AchievementId	the id for the achievement to get the completion percetage for
 * @param	CurrentValue	the current number of times the event required to unlock the achievement has occurred.
 * @param	MaxValue		the value that represents 100% completion.
 *
 * @return	TRUE if the AchievementId specified represents an progressive achievement.  FALSE if the achievement is a one-time event
 *			or if the AchievementId specified is invalid.
 */
function bool GetAchievementProgression(GearPC GPC, EGearAchievement AchievementId, out float CurrentValue, out float MaxValue )
{
	local bool bResult;
	local int DiscoverableCount, CogTagCount;
	local int NumCoopChaptersComplete, NumFullCoopChaptersComplete;

	CurrentValue = 0;
	MaxValue = 0;
	switch ( AchievementId )
	{
		case eGA_MYFELLOWGEARS:
			MaxValue = class'GearUIDataStore_GameResource'.static.GetNumChaptersInGame();
			GetNumCampaignChaptersCompletedInCoop(NumCoopChaptersComplete, NumFullCoopChaptersComplete);
			CurrentValue = NumCoopChaptersComplete;
			bResult = true;
			break;

		case eGA_ADIFFERENTKINDOFFOURSOME:
			MaxValue = class'GearUIDataStore_GameResource'.static.GetNumChaptersInGame();
			GetNumCampaignChaptersCompletedInCoop(NumCoopChaptersComplete, NumFullCoopChaptersComplete);
			CurrentValue = NumFullCoopChaptersComplete;
			bResult = true;
			break;

		case eGA_COLLECTOR:
			MaxValue = DISCOVERABLE_COLLECTOR;
			GetNumDiscoverablesFound(DiscoverableCount, CogTagCount);
			CurrentValue = DiscoverableCount;
			bResult = true;
			break;

		case eGA_PACKRAT:
			MaxValue = DISCOVERABLE_PACKRAT;
			GetNumDiscoverablesFound(DiscoverableCount, CogTagCount);
			CurrentValue = DiscoverableCount;
			bResult = true;
			break;

		case eGA_HOARDER:
			MaxValue = DISCOVERABLE_HOARDER;
			GetNumDiscoverablesFound(DiscoverableCount, CogTagCount);
			CurrentValue = DiscoverableCount;
			bResult = true;
			break;

		case eGA_REMEMBEREDTHEFALLEN:
			MaxValue = DISCOVERABLE_COGTAGS;
			GetNumDiscoverablesFound(DiscoverableCount, CogTagCount);
			CurrentValue = CogTagCount;
			bResult = true;
			break;

		case eGA_LEVEL5:
			CurrentValue = GPC.StatManager.GetStatValueByName('Level');
			MaxValue = 5;
			bResult = true;
			break;

		case eGA_LEVEL10:
			CurrentValue = GPC.StatManager.GetStatValueByName('Level');
			MaxValue = 10;
			bResult = true;
			break;

		case eGA_LEVEL15:
			CurrentValue = GPC.StatManager.GetStatValueByName('Level');
			MaxValue = 15;
			bResult = true;
			break;

		case eGA_LEVEL25:
			CurrentValue = GPC.StatManager.GetStatValueByName('Level');
			MaxValue = 25;
			bResult = true;
			break;

		case eGA_WELCOMETOARCADEMODE:
			CurrentValue = GetNumArcadeChaptersCompleted();
			MaxValue = NumArcadeChaptersCompleted;
			bResult = true;
			break;

		case eGA_WELCOMETOHORDEMODE:
			CurrentValue = GetNumConsecutiveHordeWavesCompleted(NumHordeWavesCompleted);
			MaxValue = NumHordeWavesCompleted;
			bResult = true;
			break;

		case eGA_WELCOMETOBEASTMODE:
			CurrentValue = GetNumConsecutiveSiegeWavesCompleted(NumSiegeWavesCompleted);
			MaxValue = NumSiegeWavesCompleted;
			bResult = true;
			break;

		case eGA_WELCOMETOVERSUS:
			CurrentValue = GetCurrentProgressValueForAchievement(eGA_WELCOMETOVERSUS);
			MaxValue = TDMKillsRequirement;
			bResult = true;
			break;

		case eGA_FIRSTAMONGEQUALS:
			CurrentValue = GetCurrentProgressValueForAchievement(eGA_FIRSTAMONGEQUALS);
			MaxValue = HighestScoreArcadeRequirement;
			bResult = true;
			break;

		case eGA_CALLINGYOURSHOTS:
			CurrentValue = GetCurrentProgressValueForAchievement(eGA_CALLINGYOURSHOTS);
			MaxValue = HordeMiniChallengeRequirement;
			bResult = true;
			break;
		default:
			// not a progression achievement
			bResult = false;
		break;
	}

	return bResult;
}

/** Whether a horde wave has been completed */
function bool HasCompletedHordeWave( int HordeWaveIdx )
{
	local int FoundResultValue, ShiftValue;

	// Calculate the shift value
	ShiftValue = (HordeWaveIdx < 32) ? HordeWaveIdx : HordeWaveIdx - 32;

	// Get the correct variable
	if ( HordeWaveIdx < 32 )
	{
		GetProfileSettingValueInt(`HordeWavesBeat1, FoundResultValue );
	}
	else
	{
		GetProfileSettingValueInt(`HordeWavesBeat2, FoundResultValue );
	}

	return BitIsSet( FoundResultValue, ShiftValue );
}

/** Whether a siege wave has been completed */
function bool HasCompletedSiegeWave( int SiegeWaveIdx )
{
	local int FoundResultValue;

	// Get the correct variable
	if ( SiegeWaveIdx < 32 )
	{
		GetProfileSettingValueInt(`SiegeWavesBeat, FoundResultValue );
		return BitIsSet( FoundResultValue, SiegeWaveIdx );
	}

	return false;
}

/** Returns how many Horde waves have been completed */
function int GetNumHordeWavesCompleted()
{
	local int Idx, Count;

	Count = 0;
	for ( Idx = 0; Idx < class'GearGameHorde_Base'.default.MaxWaves; Idx++ )
	{
		if ( HasCompletedHordeWave(Idx) )
		{
			Count++;
		}
	}

	return Count;
}

/** Returns how many Siege waves have been completed */
function int GetNumSiegeWavesCompleted()
{
	local int Idx, Count;

	Count = 0;
	for ( Idx = 0; Idx < 12; Idx++ )
	{
		if ( HasCompletedSiegeWave(Idx) )
		{
			Count++;
		}
	}

	return Count;
}

/** Returns how many of the first consecutive Horde waves have been completed */
function int GetNumConsecutiveHordeWavesCompleted(int NumWaves)
{
	local int Idx, Count;

	Count = 0;
	for ( Idx = 0; Idx < NumWaves; Idx++ )
	{
		if ( HasCompletedHordeWave(Idx) )
		{
			Count++;
		}
		else
		{
			break;
		}
	}

	return Count;
}

/** Returns how many of the first consecutive Siege waves have been completed */
function int GetNumConsecutiveSiegeWavesCompleted(int NumWaves)
{
	local int Idx, Count;

	Count = 0;
	for ( Idx = 0; Idx < NumWaves; Idx++ )
	{
		if ( HasCompletedSiegeWave(Idx) )
		{
			Count++;
		}
		else
		{
			break;
		}
	}

	return Count;
}

/** Checks to see if the UI should send a progress message or unlock an achievement for completing a Horde wave */
function UpdateHordeWaveProgression( bool bDoConsecutiveCheck, GearPC GPC, bool bWaveAlreadyCompleted )
{
	local GearAlertManager GAM;
	local int NumConsecutiveWavesCompleted;

	// Check for unlocking eGA_WELCOMETOHORDEMODE
	if ( bDoConsecutiveCheck )
	{
		NumConsecutiveWavesCompleted = GetNumConsecutiveHordeWavesCompleted(NumHordeWavesCompleted);
		if ( NumConsecutiveWavesCompleted == NumHordeWavesCompleted )
		{
			// @ACHIEVEMENT - Welcome to Horde Mode
			GPC.ClientUnlockAchievement( eGA_WELCOMETOHORDEMODE );
		}
		else if (!bWaveAlreadyCompleted)
		{
			GAM = GPC.GetAlertManager();
			if (GAM != None)
			{
				GAM.MadeProgress(ePROG_Achievement, eGA_WELCOMETOHORDEMODE);
			}
		}
	}
}

/** Checks to see if the UI should send a progress message or unlock an achievement for completing a Siege wave */
function UpdateSiegeWaveProgression( bool bDoConsecutiveCheck, GearPC GPC, bool bWaveAlreadyCompleted )
{
	local GearAlertManager GAM;
	local int NumConsecutiveWavesCompleted;

	// Check for unlocking eGA_WELCOMETOBEASTMODE
	if ( bDoConsecutiveCheck )
	{
		NumConsecutiveWavesCompleted = GetNumConsecutiveSiegeWavesCompleted(NumSiegeWavesCompleted);
		if ( NumConsecutiveWavesCompleted == NumSiegeWavesCompleted )
		{
			// @ACHIEVEMENT - Welcome to Siege Mode
			GPC.ClientUnlockAchievement( eGA_WELCOMETOBEASTMODE );
		}
		else if (!bWaveAlreadyCompleted)
		{
			GAM = GPC.GetAlertManager();
			if (GAM != None)
			{
				GAM.MadeProgress(ePROG_Achievement, eGA_WELCOMETOBEASTMODE);
			}
		}
	}
}

/** Mark a Horde wave as completed */
function MarkHordeWaveAsCompleted( int HordeWaveIdx, GearPC GPC )
{
	local int FoundResultValue, ShiftValue;
	local bool bCheckForConsecutiveAchievement;
	local bool bWaveAlreadyCompleted;

	bWaveAlreadyCompleted = HasCompletedHordeWave(HordeWaveIdx);
	if (!bWaveAlreadyCompleted)
	{
		// See if the Progression/Achievement update should check for the eGA_WELCOMETOHORDEMODE achievement/progression
		bCheckForConsecutiveAchievement = (HordeWaveIdx < NumHordeWavesCompleted);

		// First grab the correct variables from the profile and determine how much bit shifting to do
		if ( HordeWaveIdx < 32 )
		{
			GetProfileSettingValueInt(`HordeWavesBeat1, FoundResultValue );
			ShiftValue = HordeWaveIdx;
		}
		else
		{
			GetProfileSettingValueInt(`HordeWavesBeat2, FoundResultValue );
			ShiftValue = HordeWaveIdx - 32;
		}

		// Calculate the new values to be set in the profile
		FoundResultValue = FoundResultValue | (1 << ShiftValue);

		// Set the profile
		if ( HordeWaveIdx < 32 )
		{
			SetProfileSettingValueInt(`HordeWavesBeat1, FoundResultValue );
		}
		else
		{
			SetProfileSettingValueInt(`HordeWavesBeat2, FoundResultValue );
		}

		// Check for progression and achievement unlock
		UpdateHordeWaveProgression(bCheckForConsecutiveAchievement, GPC, bWaveAlreadyCompleted);

		GPC.SaveProfile();
	}
}

/** Mark a Siege wave as completed */
function MarkSiegeWaveAsCompleted( int SiegeWaveIdx, GearPC GPC )
{
	local int FoundResultValue;
	local bool bCheckForConsecutiveAchievement;
	local bool bWaveAlreadyCompleted;

	bWaveAlreadyCompleted = HasCompletedSiegeWave(SiegeWaveIdx);
	if (!bWaveAlreadyCompleted && SiegeWaveIdx < 32 )
	{
		// See if the Progression/Achievement update should check for the eGA_WELCOMETOSIEGEMODE achievement/progression
		bCheckForConsecutiveAchievement = (SiegeWaveIdx < NumSiegeWavesCompleted);

		// First grab the correct variables from the profile and determine how much bit shifting to do
		GetProfileSettingValueInt(`SiegeWavesBeat, FoundResultValue );

		// Calculate the new values to be set in the profile
		FoundResultValue = FoundResultValue | (1 << SiegeWaveIdx);

		// Set the profile
		SetProfileSettingValueInt(`SiegeWavesBeat, FoundResultValue );

		// Check for progression and achievement unlock
		UpdateSiegeWaveProgression(bCheckForConsecutiveAchievement, GPC, bWaveAlreadyCompleted);

		GPC.SaveProfile();
	}
}

/** Returns how many chapters of arcade have been completed */
function int GetNumArcadeChaptersCompleted()
{
	local array<int> ActList;
	local array<int> ChapterList;
	local int ActIdx,ChpIdx,Count;

	class'GearUIDataStore_GameResource'.static.GetGameCompletionActList(ActList);
	for ( ActIdx = 0; ActIdx < ActList.length; ActIdx++ )
	{
		class'GearUIDataStore_GameResource'.static.GetChapterPointsFromAct(ActIdx, ChapterList);
		for ( ChpIdx = 0; ChpIdx < ChapterList.length; ChpIdx++ )
		{
			if ( HasChapterBeenCompletedAcossDifficulties(ChapterList[ChpIdx], true) )
			{
				Count++;
			}
		}
	}

	return Count;
}

/** Checks to see if the UI should send a progress message or unlock an achievement for completing a Horde wave */
function UpdateArcadeProgression( GearPC GPC )
{
	local GearAlertManager GAM;
	local int NumChaptersCompleted;

	// Check for unlocking eGA_WELCOMETOARCADEMODE
	NumChaptersCompleted = GetNumArcadeChaptersCompleted();
	if ( NumChaptersCompleted == NumArcadeChaptersCompleted )
	{
		// @ACHIEVEMENT - Welcome to Aracde Mode
		GPC.ClientUnlockAchievement( eGA_WELCOMETOARCADEMODE );
	}
	else if ( NumChaptersCompleted < NumArcadeChaptersCompleted )
	{
		GAM = GPC.GetAlertManager();
		if (GAM != None)
		{
			GAM.MadeProgress(ePROG_Achievement, eGA_WELCOMETOARCADEMODE);
		}
	}
}

/** Returns the last playlist id that the player used */
function int GetPlaylistID(bool bIsRanked)
{
	local int PlaylistIdResult;
	local name ProviderTag;
	local OnlinePlaylistProvider PlaylistProvider;

	if ( !GetProfileSettingValueInt(bIsRanked ? `PlaylistIdRanked : `PlaylistId, PlaylistIdResult) )
	{
		PlaylistIdResult = 1;
	}

	//Verify this playlist ID exists, otherwise set to something sensible
	ProviderTag = bIsRanked ? name(class'UIDataStore_OnlinePlaylists'.const.RANKEDPROVIDERTAG) : name(class'UIDataStore_OnlinePlaylists'.const.UNRANKEDPROVIDERTAG);
    PlaylistProvider = class'UIDataStore_OnlinePlaylists'.static.GetOnlinePlaylistProvider( ProviderTag, PlaylistIdResult );
	if ( PlaylistProvider == None )
	{
		PlaylistIdResult = 1;
	}

	return PlaylistIdResult;
}

/** @return Whether the player data have been uploaded today or not */
function bool HasPlayerDataBeenUploaded()
{
	local int Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec;
	local int UploadDay;

	GetSystemTime(Year,Month,DayOfWeek,Day,Hour,Min,Sec,MSec);

	if (GetProfileSettingValueInt(`ProfileDataUploaded,UploadDay))
	{
		return !bForceProfileUpload && UploadDay == Day;
	}
	return false;
}


/** Puts the timestamp of when the data was uploaded */
function MarkPlayerDataAsUploaded()
{
	local int Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec;
	GetSystemTime(Year,Month,DayOfWeek,Day,Hour,Min,Sec,MSec);

	SetProfileSettingValueInt(`ProfileDataUploaded,Day);
}

/**
 * @return number of days in a given month
 */
final function int GetDaysInMonth(int Year,int Month)
{
	local int DaysInMonth;
	local bool bIsLeapYear, bIsDiv4, bIsDiv100, bIsDiv400;

	// divisible by 4
	bIsDiv4 = Year % 4 == 0;
	// divisible by 100
	bIsDiv100 = Year % 100 == 0;
	// divisible by 400
	bIsDiv400 = Year % 400 == 0;
	// leap year is divisible by 4 but not 100 unless by 400
	bIsLeapYear = (bIsDiv4 && !bIsDiv100) || bIsDiv400;

	DaysInMonth = 31;
	if (Month == 2)
	{
		if (bIsLeapYear)
		{
			DaysInMonth = 29;
		}
		else
		{
			DaysInMonth = 28;
		}
	}
	else if (Month == 4 || Month == 6 || Month == 9 || Month == 11)
	{
		DaysInMonth = 30;
	}
	return DaysInMonth;
}

/**
 * @return elapsed minutes since the start of the given year
 */
final function int GetElapsedMinutes(int Year, int Month, int Day, int Hour, int Min)
{
	local int MonthIdx, TotalDays;

	TotalDays = Clamp(Day,0,GetDaysInMonth(Year,Month));
	for (MonthIdx=1; MonthIdx < Month; MonthIdx++)
	{
		TotalDays += GetDaysInMonth(Year,MonthIdx);
	}
	return (TotalDays * 24 + Hour) * 60 + Min;
}

/**
 * Read the bandwidth history and timestamp from the profile.
 *
 * @param BandwidthHistory [out] array of bandwidth entries to read from the profile
 * @param MinutesSinceLastTest [out] elapsed time in minutes since the last bandwidth test
 */
final function ReadBandwidthHistory(out array<ConnectionBandwidthStats> BandwidthHistory, out int MinutesSinceLastTest)
{
	local int Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec, MinutesSinceYear, MinutesSinceYearLast, UpstreamRate, CurBandwidthHistorySize;
	GetSystemTime(Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec);

	// Calculate minutes since the beginning of the year to timestamp the bandwidth history
	MinutesSinceYear = GetElapsedMinutes(Year,Month,Day,Hour,Min);
	// Get last timestamp in minutes
	GetProfileSettingValueInt(`BandwidthTestTimestamp,MinutesSinceYearLast);
	// Check for wrap around
	if (MinutesSinceYearLast > MinutesSinceYear)
	{
		// wrap by adding max minutes in the last year
		MinutesSinceYear += GetElapsedMinutes(Year-1,12,31,23,59);
	}
	// Minutes elapsed since the last bandwidth test occurred
	MinutesSinceLastTest = MinutesSinceYear - MinutesSinceYearLast;

	// Num entries currently stores in bandwidth history
	GetProfileSettingValueInt(`BandwidthHistorySize,CurBandwidthHistorySize);

	// Update array with history from profile settings
	BandwidthHistory.Length = 0;
	if (CurBandwidthHistorySize > 0 &&
		GetProfileSettingValueInt(`UpstreamBandwidth1,UpstreamRate))
	{
		BandwidthHistory.Length = BandwidthHistory.Length+1;
		BandwidthHistory[BandwidthHistory.Length-1].UpstreamRate = UpstreamRate;
	}
	if (CurBandwidthHistorySize > 1 &&
		GetProfileSettingValueInt(`UpstreamBandwidth2,UpstreamRate))
	{
		BandwidthHistory.Length = BandwidthHistory.Length+1;
		BandwidthHistory[BandwidthHistory.Length-1].UpstreamRate = UpstreamRate;
	}
	if (CurBandwidthHistorySize > 2 &&
		GetProfileSettingValueInt(`UpstreamBandwidth3,UpstreamRate))
	{
		BandwidthHistory.Length = BandwidthHistory.Length+1;
		BandwidthHistory[BandwidthHistory.Length-1].UpstreamRate = UpstreamRate;
	}
	if (CurBandwidthHistorySize > 3 &&
		GetProfileSettingValueInt(`UpstreamBandwidth4,UpstreamRate))
	{
		BandwidthHistory.Length = BandwidthHistory.Length+1;
		BandwidthHistory[BandwidthHistory.Length-1].UpstreamRate = UpstreamRate;
	}
	if (CurBandwidthHistorySize > 4 &&
		GetProfileSettingValueInt(`UpstreamBandwidth5,UpstreamRate))
	{
		BandwidthHistory.Length = BandwidthHistory.Length+1;
		BandwidthHistory[BandwidthHistory.Length-1].UpstreamRate = UpstreamRate;
	}
}

/**
 * Write the bandwidth history and timestamp from the profile.
 *
 * @param BandwidthHistory array of bandwidth entries to write to the profile
 * @param MinutesSinceLastTest [out] elapsed time in minutes since the last bandwidth test
 */
final function SaveBandwidthHistory(const out array<ConnectionBandwidthStats> BandwidthHistory)
{
	local int Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec, MinutesSinceYear;
	GetSystemTime(Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec);

	// Calculate minutes since the beginning of the year to timestamp the bandwidth history
	MinutesSinceYear = GetElapsedMinutes(Year,Month,Day,Hour,Min);
	SetProfileSettingValueInt(`BandwidthTestTimestamp,MinutesSinceYear);

	// Save num entries currently stores in bandwidth history
	SetProfileSettingValueInt(`BandwidthHistorySize,BandwidthHistory.Length);

	// Clear out entries
	SetProfileSettingValueInt(`UpstreamBandwidth1,0);
	SetProfileSettingValueInt(`UpstreamBandwidth2,0);
	SetProfileSettingValueInt(`UpstreamBandwidth3,0);
	SetProfileSettingValueInt(`UpstreamBandwidth4,0);
	SetProfileSettingValueInt(`UpstreamBandwidth5,0);
	// Update profile with new bandwidth history values
	if (BandwidthHistory.Length > 0)
	{
		SetProfileSettingValueInt(`UpstreamBandwidth1,BandwidthHistory[0].UpstreamRate);
	}
	if (BandwidthHistory.Length > 1)
	{
		SetProfileSettingValueInt(`UpstreamBandwidth2,BandwidthHistory[1].UpstreamRate);
	}
	if (BandwidthHistory.Length > 2)
	{
		SetProfileSettingValueInt(`UpstreamBandwidth3,BandwidthHistory[2].UpstreamRate);
	}
	if (BandwidthHistory.Length > 3)
	{
		SetProfileSettingValueInt(`UpstreamBandwidth4,BandwidthHistory[3].UpstreamRate);
	}
	if (BandwidthHistory.Length > 4)
	{
		SetProfileSettingValueInt(`UpstreamBandwidth5,BandwidthHistory[4].UpstreamRate);
	}
}

/** Function that should be called whenever a profile setting has been changed
 *	Will flip the bShouldBeSaved bit and will contain the logic to determine which settings do not flip this bit
 *	@param ProfileSettingId - The id of the profile setting that was changed
 */
native function ProfileSettingHasChanged(int ProfileSettingId);

/** Profile setting set function overridden to call ProfileSettingHasChanged if the profile setting was changed
 *	@param ProfileSettingId - The ID of the profile setting to change
 *	@param NewValue - The value to set the setting to
 */
native function bool SetProfileSettingValue(int ProfileSettingId,const out string NewValue);

/** Profile setting set function overridden to call ProfileSettingHasChanged if the profile setting was changed
 *	@param ProfileSettingId - The ID of the profile setting to change
 *	@param Value - The value to set the setting to
 */
native function bool SetProfileSettingValueId(int ProfileSettingId,int Value);

/** Profile setting set function overridden to call ProfileSettingHasChanged if the profile setting was changed
 *	@param ProfileId - The ID of the profile setting to change
 *	@param NewValue - The value to set the setting to
 */
native function bool SetRangedProfileSettingValue(int ProfileId,float NewValue);

/** Profile setting set function overridden to call ProfileSettingHasChanged if the profile setting was changed
 *	@param ProfileSettingId - The ID of the profile setting to change
 *	@param Value - The value to set the setting to
 */
native function bool SetProfileSettingValueFloat(int ProfileSettingId,float Value);

/** Profile setting set function overridden to call ProfileSettingHasChanged if the profile setting was changed
 *	@param ProfileSettingId - The ID of the profile setting to change
 *	@param Value - The value to set the setting to
 */
native function bool SetProfileSettingValueInt(int ProfileSettingId,int Value);

/**
 * Adds (or subtracts) from the user's disconnect total
 *
 * @param DisconnectDelta the change in the number of disconnects
 */
function AdjustDisconnectCount(int DisconnectDelta)
{
	local int NumDisconnects;

	// Read, update, and save their new quit count
	GetProfileSettingValueInt(`DisconnectCount,NumDisconnects);
	NumDisconnects += DisconnectDelta;
	NumDisconnects = Max(NumDisconnects,0);
	SetProfileSettingValueInt(`DisconnectCount,NumDisconnects);
}

/**
 * @return the user's disconnect total
 */
function int GetDisconnectCount()
{
	local int NumDisconnects;

	GetProfileSettingValueInt(`DisconnectCount,NumDisconnects);
	return NumDisconnects;
}

/**
 * Adds (or subtracts) from the user's quit total
 *
 * @param QuitDelta the change in the number of quits
 */
function AdjustQuitCount(int QuitDelta)
{
	local int QuitCount;

	// Read, update, and save their new quit count
	GetProfileSettingValueInt(`QuitDemerits,QuitCount);
	QuitCount += QuitDelta;
	QuitCount = Max(QuitCount,0);
	SetProfileSettingValueInt(`QuitDemerits,QuitCount);
}

/**
 * @return the user's quit total
 */
function int GetQuitCount()
{
	local int QuitCount;

	GetProfileSettingValueInt(`QuitDemerits,QuitCount);
	return QuitCount;
}

/** Used to clear the count after applying the punishment */
function ClearQuitCount()
{
	SetProfileSettingValueInt(`QuitDemerits,0);
}

/** @return the current penalty accrued */
function int GetQuitPenalty()
{
	return GetQuitCount() * XPQuitPenalty;
}

/**
 * @return the user's standby demerits total
 */
function int GetStandByDemerits()
{
	local int Count;

	GetProfileSettingValueInt(`StandByDemerits,Count);
	return Count;
}

/**
 * Adds (or subtracts) from the user's quit total
 *
 * @param Delta the change in the number of standby demerits
 */
function AdjustStandByDemeritsCount(int Delta)
{
	local int Count;

	// Read, update, and save their new quit count
	GetProfileSettingValueInt(`StandByDemerits,Count);
	Count += Delta;
	Count = Max(Count,0);
	SetProfileSettingValueInt(`StandByDemerits,Count);
}

/**
 * @return the user's good host ratio
 */
function float GetGoodHostRatio()
{
	//@todo sz - port from Gears2
	return 1.0f;
}

/** Looks at player's demerits and quits and decides whether to let them host or not */
function bool IsOkayToHost()
{
`if(`notdefined(FINAL_RELEASE))
	local int QuitCount;
	local int StandbyCount;

	QuitCount = GetQuitCount();
	StandbyCount = GetStandByDemerits();

	`LogOnline("");
	`LogOnline("Quit count = "$QuitCount);
	`LogOnline("Standby count = "$StandbyCount);
	`LogOnline("");
`endif

	return GetQuitCount() + GetStandByDemerits() == 0;
}

/** @return true if the player is banned, false otherwise */
function bool IsProfileBanned()
{
	local int IsProfBanned;

	GetProfileSettingValueInt(`IsBanned,IsProfBanned);
	// See if this player was banned by per object config or not
	// Also, check for the ban being saved into their profile (in case of MCP error)
	if (bIsBanned && IsProfBanned == 0)
	{
		SetProfileSettingValueInt(`IsBanned,1);
	}
	else if (!bIsBanned && IsProfBanned > 0)
	{
		bIsBanned = true;
	}
	// If we've forgiven them, then let them play MP again
	if (bIsUnbanned)
	{
		bIsBanned = false;
		SetProfileSettingValueInt(`IsBanned,0);
	}

	return bIsBanned || IsProfBanned > 0;
}

/** @return true if the player is an Epic dev, false otherwise */
function bool IsEpicDev()
{
	local int IsEpic;

	GetProfileSettingValueInt(`IsEpicDev,IsEpic);
	// Handle not being able to reach MCP by saving to the profile
	if (bIsEpicDev && IsEpic == 0)
	{
		SetProfileSettingValueInt(`IsEpicDev,1);
	}
	else if (!bIsEpicDev && IsEpic > 0)
	{
		bIsEpicDev = true;
	}

	return bIsEpicDev || IsEpic > 0;
}

/**
 * Accessor function to get the currently selected party type (this value should never be accessed directly because of the
 * relationship between what we actually save and what we use as settings during play
 */
final function EGearVersusPartyType GetPartyType()
{
	local int Value;

	// If the system link flag is set we just return the system link party type
	if (bPartyTypeIsSystemLink)
	{
		return eGVPT_SystemLink;
	}
	// Else if the local flag is set we just return the local party type
	else if (bPartyTypeIsLocal)
	{
		return eGVPT_Local;
	}
	// Else get the value from the profile setting
	else if (GetProfileSettingValueId(`VERSUS_PARTY_TYPE, Value))
	{
		return EGearVersusPartyType(Value);
	}

	return eGVPT_FriendsOnly;
}

/**
 * Accessor function to set the currently selected party type (this value should never be accessed directly because of the
 * relationship between what we actually save and what we use as settings during play
 */
final function SetPartyType(EGearVersusPartyType PartyType)
{
	// If system link was passed in, we just want to set the transient system link flag
	if (PartyType == eGVPT_SystemLink)
	{
		bPartyTypeIsSystemLink = true;
		bPartyTypeIsLocal = false;
	}
	// If local was selected, we just want to set the transient local flag
	else if (PartyType == eGVPT_Local)
	{
		bPartyTypeIsSystemLink = false;
		bPartyTypeIsLocal = true;
	}
	// Else set the profile setting and make sure the system link flag is cleared
	else
	{
		bPartyTypeIsSystemLink = false;
		bPartyTypeIsLocal = false;
		SetProfileSettingValueId(`VERSUS_PARTY_TYPE, PartyType);
	}
}

/**
 * Marks this profile as having earned or not the Rookie Gear achievement from Gears2
 *
 * @param bWasAchieved whether they had that achievement or not
 */
function SetRookieGear(bool bWasAchieved)
{
	SetProfileSettingValueInt(`HasRookieGear,int(bWasAchieved));
}

/** @return true if the user unlocked rookie gear, false otherwise */
function bool HasRookieGear()
{
	local int WasAchieved;
	GetProfileSettingValueInt(`HasRookieGear,WasAchieved);
	return WasAchieved > 0;
}

/** @return true if we've enumerated achievements for unlocks, false otherwise */
function bool HasReadAchievements()
{
	local int Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec;
	local int EnumDay;

	GetSystemTime(Year,Month,DayOfWeek,Day,Hour,Min,Sec,MSec);

	if (GetProfileSettingValueInt(`HasEnumedCheevos,EnumDay))
	{
		return !bForceAchievementRead && EnumDay == Day;
	}
	return false;
}

/**
 * Marks this profile as having enumerated achievements for unlocks
 */
function MarkHasReadAchievements()
{
	local int Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec;
	GetSystemTime(Year,Month,DayOfWeek,Day,Hour,Min,Sec,MSec);

	SetProfileSettingValueInt(`HasEnumedCheevos,Day);
}

defaultproperties
{
	// If you change any profile ids, increment this number!!!!
	VersionNumber=84

	// Only read the properties that we care about
	ProfileSettingIds(0)=PSI_ControllerVibration
	ProfileSettingIds(1)=PSI_YInversion
	ProfileSettingIds(2)=PSI_ControllerSensitivity

	// Defaults for the values if not specified by the online service
	DefaultSettings(0)=(Owner=OPPO_OnlineService,ProfileSetting=(PropertyId=PSI_ControllerVibration,Data=(Type=SDT_Int32,Value1=PCVTO_On)))
	DefaultSettings(1)=(Owner=OPPO_OnlineService,ProfileSetting=(PropertyId=PSI_YInversion,Data=(Type=SDT_Int32,Value1=PYIO_Off)))
	DefaultSettings(2)=(Owner=OPPO_OnlineService,ProfileSetting=(PropertyId=PSI_ControllerSensitivity,Data=(Type=SDT_Int32,Value1=PCSO_Medium)))

	// Base profile mapping (the other two come from the base class)
	ProfileMappings(2)=(Id=PSI_ControllerSensitivity,Name="Controller Sensitivity",MappingType=PVMT_IdMapped,ValueMappings=((Id=PCSO_Low),(Id=PCSO_Medium),(Id=PCSO_High)))

	// Custom game settings follow
	//
	// To read the data
	ProfileSettingIds(22)=`ProfileMode
	ProfileSettingIds(23)=`HudOnOff
	ProfileSettingIds(24)=`MatureLang
	ProfileSettingIds(25)=`GearStickConfig
	ProfileSettingIds(26)=`GearTriggerConfig
	ProfileSettingIds(27)=`Subtitles
	ProfileSettingIds(28)=`MusicVolume
	ProfileSettingIds(29)=`FxVolume
	ProfileSettingIds(30)=`DialogueVolume
	ProfileSettingIds(31)=`CogMPCharacter
	ProfileSettingIds(32)=`LocustMPCharacter
	ProfileSettingIds(33)=`Gore
	ProfileSettingIds(34)=`GameIntensity
	ProfileSettingIds(35)=`PictogramTooltips
	ProfileSettingIds(36)=`GammaSetting
	ProfileSettingIds(37)=`DefaultMPWeapon
	ProfileSettingIds(38)=`GearControlScheme
	ProfileSettingIds(40)=`TelevisionType
	ProfileSettingIds(41)=`VERSUS_GAMETYPE
	ProfileSettingIds(42)=`VERSUS_MATCH_MODE
	ProfileSettingIds(43)=`VERSUS_PARTY_TYPE
	ProfileSettingIds(44)=`VERSUS_SELECTED_MAP
	ProfileSettingIds(45)=`MPFriendlyFire
	ProfileSettingIds(46)=`MPRoundTime
	ProfileSettingIds(47)=`MPBleedout
	ProfileSettingIds(48)=`MPWeaponSwap
	ProfileSettingIds(49)=`MPRoundsToWin
	ProfileSettingIds(50)=`MPBotDiff
	ProfileSettingIds(51)=`NewbieRoundScore
	ProfileSettingIds(52)=`KOTHRoundScore
	ProfileSettingIds(53)=`WingmanScore
	ProfileSettingIds(54)=`HordeEnemyDiff
	ProfileSettingIds(55)=`SPTutorials1
	ProfileSettingIds(56)=`SPTutorials2
	ProfileSettingIds(57)=`MPTutorials1
	ProfileSettingIds(58)=`MPTutorials2
	ProfileSettingIds(59)=`TurnInversion
	ProfileSettingIds(60)=`TargetSensitivity
	ProfileSettingIds(61)=`ZoomSensitivity
	ProfileSettingIds(62)=`MPNumBots
	ProfileSettingIds(63)=`HordeWave
	ProfileSettingIds(64)=`DiscoverFound1
	ProfileSettingIds(65)=`DiscoverFound2
	ProfileSettingIds(66)=`DiscoverNeedsViewed1
	ProfileSettingIds(67)=`DiscoverNeedsViewed2
	ProfileSettingIds(68)=`MAP_SELECTION_MODE
	ProfileSettingIds(69)=`WeapSwap_FragGrenade
	ProfileSettingIds(70)=`WeapSwap_InkGrenade
	ProfileSettingIds(71)=`WeapSwap_Boomshot
	ProfileSettingIds(72)=`WeapSwap_Flame
	ProfileSettingIds(73)=`WeapSwap_Sniper
	ProfileSettingIds(74)=`WeapSwap_Bow
	ProfileSettingIds(75)=`WeapSwap_Mulcher
	ProfileSettingIds(76)=`WeapSwap_Mortar
	ProfileSettingIds(77)=`WeapSwap_HOD
	ProfileSettingIds(78)=`WeapSwap_Gorgon
	ProfileSettingIds(79)=`WeapSwap_Boltok
	ProfileSettingIds(80)=`CompletedChaptersCasual1
	ProfileSettingIds(81)=`CompletedChaptersCasual2
	ProfileSettingIds(82)=`CompletedChaptersNormal1
	ProfileSettingIds(83)=`CompletedChaptersNormal2
	ProfileSettingIds(84)=`CompletedChaptersHard1
	ProfileSettingIds(85)=`CompletedChaptersHard2
	ProfileSettingIds(86)=`CompletedChaptersInsane1
	ProfileSettingIds(87)=`CompletedChaptersInsane2
	ProfileSettingIds(88)=`CompletedChaptersArcadeCasual1
	ProfileSettingIds(89)=`CompletedChaptersArcadeCasual2
	ProfileSettingIds(90)=`CompletedChaptersArcadeNormal1
	ProfileSettingIds(91)=`CompletedChaptersArcadeNormal2
	ProfileSettingIds(92)=`CompletedChaptersArcadeHard1
	ProfileSettingIds(93)=`CompletedChaptersArcadeHard2
	ProfileSettingIds(94)=`CompletedChaptersArcadeInsane1
	ProfileSettingIds(95)=`CompletedChaptersArcadeInsane2
	ProfileSettingIds(96)=`UnlockedUnlockables
	ProfileSettingIds(97)=`UnlockableNeedsViewed
	ProfileSettingIds(98)=`CoopInviteType
	ProfileSettingIds(99)=`CampCheckpointUsage
	ProfileSettingIds(100)=`LastCheckpointSlot
	ProfileSettingIds(101)=`CoopCompletedChapters1
	ProfileSettingIds(102)=`CoopCompletedChapters2
	ProfileSettingIds(103)=`MPMapsCompleted
	ProfileSettingIds(104)=`NumEnemiesKilled
	ProfileSettingIds(105)=`PlaylistId
	ProfileSettingIds(106)=`PlayerSkill
	ProfileSettingIds(107)=`ProfileDataUploaded
	ProfileSettingIds(108)=`CAMP_MODE
	ProfileSettingIds(109)=`HordeWavesBeat1
	ProfileSettingIds(110)=`HordeWavesBeat2
	ProfileSettingIds(111)=`UnlockedChapterAccess1
	ProfileSettingIds(112)=`UnlockedChapterAccess2
	ProfileSettingIds(113)=`WeapTutorialsOn
	ProfileSettingIds(114)=`WeapSwap_Shield
	ProfileSettingIds(115)=`SPTutorials3
	ProfileSettingIds(116)=`MPTutorials3
	ProfileSettingIds(117)=`TrainTutorials1
	ProfileSettingIds(118)=`TrainTutorials2
	ProfileSettingIds(119)=`TrainTutorials3
	ProfileSettingIds(120)=`COMPLETED_ACHIEVEMENT_MASK_A
	ProfileSettingIds(121)=`COMPLETED_ACHIEVEMENT_MASK_B
	ProfileSettingIds(122)=`UNVIEWED_ACHIEVEMENT_MASK_A
	ProfileSettingIds(123)=`UNVIEWED_ACHIEVEMENT_MASK_B
 	ProfileSettingIds(124)=`SelectedMedal
 	ProfileSettingIds(125)=`AccessedMPPrefs
	ProfileSettingIds(126)=`DefaultSecondaryMPWeapon
	ProfileSettingIds(127)=`SPTutorials4
	ProfileSettingIds(128)=`MPTutorials4
	ProfileSettingIds(129)=`TrainTutorials4
	ProfileSettingIds(130)=`BandwidthTestTimestamp
	ProfileSettingIds(131)=`UpstreamBandwidth1
	ProfileSettingIds(132)=`UpstreamBandwidth2
	ProfileSettingIds(133)=`UpstreamBandwidth3
	ProfileSettingIds(134)=`UpstreamBandwidth4
	ProfileSettingIds(135)=`UpstreamBandwidth5
	ProfileSettingIds(136)=`BandwidthHistorySize
	ProfileSettingIds(137)=`GoodHostRatio
	ProfileSettingIds(138)=`PlaylistIdRanked
	ProfileSettingIds(139)=`StandByDemerits
	ProfileSettingIds(140)=`QuitDemerits
	ProfileSettingIds(141)=`SiegeTutorials1
	ProfileSettingIds(142)=`SiegeTutorials2
	ProfileSettingIds(143)=`SiegeTutorials3
	ProfileSettingIds(144)=`SiegeTutorials4
	ProfileSettingIds(145)=`WeaponSkin_Lancer
	ProfileSettingIds(146)=`WeaponSkin_Hammerburst
	ProfileSettingIds(147)=`WeaponSkin_Retro
	ProfileSettingIds(148)=`WeaponSkin_Gnasher
	ProfileSettingIds(149)=`WeaponSkin_SawedOff
	ProfileSettingIds(150)=`IsBanned
	ProfileSettingIds(151)=`IsEpicDev
	ProfileSettingIds(152)=`SiegeEnemyDiff
	ProfileSettingIds(153)=`SiegeWave
	ProfileSettingIds(154)=`RecentDiscover1
	ProfileSettingIds(155)=`RecentDiscover2
	ProfileSettingIds(156)=`RecentDiscover3
	ProfileSettingIds(157)=`RecentDiscover4
	ProfileSettingIds(158)=`RecentDiscover5
	ProfileSettingIds(159)=`OmniDirEvade
	ProfileSettingIds(160)=`RecentChallenge1
	ProfileSettingIds(161)=`RecentChallenge2
	ProfileSettingIds(162)=`RecentChallenge3
	ProfileSettingIds(163)=`RecentChallenge4
	ProfileSettingIds(164)=`RecentChallenge5
	ProfileSettingIds(165)=`TDMKills
	ProfileSettingIds(166)=`HordeMiniChallenges
	ProfileSettingIds(167)=`HighestScoreArcade
	ProfileSettingIds(168)=`SiegeWavesBeat
	ProfileSettingIds(169)=`FullCoopCompletedChapters1
	ProfileSettingIds(170)=`FullCoopCompletedChapters2
	ProfileSettingIds(171)=`HasRookieGear
	ProfileSettingIds(172)=`HasVeteranGear
	ProfileSettingIds(173)=`HasEnumedCheevos
	ProfileSettingIds(174)=`HasHoardTheHorde
	ProfileSettingIds(175)=`HasGearsPCCheevo
	ProfileSettingIds(176)=`HasUT3Cheevo
	ProfileSettingIds(177)=`HasSCCheevo
	ProfileSettingIds(178)=`HasBSCheevo
	ProfileSettingIds(179)=`HasGears1Camp
	ProfileSettingIds(180)=`HasGears2Camp
	ProfileSettingIds(181)=`HasGears3Camp
	ProfileSettingIds(182)=`ConfiguredVideoSettings
	ProfileSettingIds(183)=`DisconnectCount

	// These are defaults for first time read
	DefaultSettings(22)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`ProfileMode,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(23)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`HudOnOff,Data=(Type=SDT_Int32,Value1=WOOO_On)))
	DefaultSettings(24)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`MatureLang,Data=(Type=SDT_Int32,Value1=WOOO_On)))
	DefaultSettings(25)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`GearStickConfig,Data=(Type=SDT_Int32,Value1=WSCO_Default)))
	DefaultSettings(26)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`GearTriggerConfig,Data=(Type=SDT_Int32,Value1=WTCO_Default)))
	DefaultSettings(27)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`Subtitles,Data=(Type=SDT_Int32,Value1=WOOO_On)))
	DefaultSettings(28)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`MusicVolume,Data=(Type=SDT_Float,Value1=1058642330)))		// 0.6
	DefaultSettings(29)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`FxVolume,Data=(Type=SDT_Float,Value1=1061997773)))			// 0.8
	DefaultSettings(30)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`DialogueVolume,Data=(Type=SDT_Float,Value1=1061997773)))	// 0.8
	DefaultSettings(31)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`CogMPCharacter,Data=(Type=SDT_Int32,Value1=CMPC_Marcus)))
	DefaultSettings(32)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`LocustMPCharacter,Data=(Type=SDT_Int32,Value1=LMPC_Drone)))
	DefaultSettings(33)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`Gore,Data=(Type=SDT_Int32,Value1=WOOO_On)))
	DefaultSettings(34)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`GameIntensity,Data=(Type=SDT_Int32,Value1=DL_Hardcore)))
	DefaultSettings(35)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`PictogramTooltips,Data=(Type=SDT_Int32,Value1=WOOO_On)))
	DefaultSettings(36)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`GammaSetting,Data=(Type=SDT_Float,Value1=1074580685)))		// 2.2
	DefaultSettings(37)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`DefaultMPWeapon,Data=(Type=SDT_Int32,Value1=WC_Lancer)))
	DefaultSettings(38)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`GearControlScheme,Data=(Type=SDT_Int32,Value1=GCS_Default)))
	DefaultSettings(40)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`TelevisionType,Data=(Type=SDT_Int32,Value1=TVT_Default)))
	DefaultSettings(41)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`VERSUS_GAMETYPE,Data=(Type=SDT_Int32,Value1=eGEARMP_Warzone)))
	DefaultSettings(42)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`VERSUS_MATCH_MODE,Data=(Type=SDT_Int32,Value1=eGVMT_Official)))
	DefaultSettings(43)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`VERSUS_PARTY_TYPE,Data=(Type=SDT_Int32,Value1=eGVPT_FriendsOnly)))
	DefaultSettings(44)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`VERSUS_SELECTED_MAP,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(45)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`MPFriendlyFire,Data=(Type=SDT_Int32,Value1=CONTEXT_FRIENDLYFIRE_NO)))
	DefaultSettings(46)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`MPRoundTime,Data=(Type=SDT_Int32,Value1=CONTEXT_ROUNDTIME_FIVE)))
	DefaultSettings(47)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`MPBleedout,Data=(Type=SDT_Int32,Value1=CONTEXT_BLEEDOUTTIME_FIFTEEN)))
	DefaultSettings(48)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`MPWeaponSwap,Data=(Type=SDT_Int32,Value1=CONTEXT_WEAPONSWAP_CYCLE)))
	DefaultSettings(49)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`MPRoundsToWin,Data=(Type=SDT_Int32,Value1=CONTEXT_ROUNDSTOWIN_TWO)))
	DefaultSettings(50)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`MPBotDiff,Data=(Type=SDT_Int32,Value1=CONTEXT_AIDIFFICULTY_NORMAL)))
	DefaultSettings(51)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`NewbieRoundScore,Data=(Type=SDT_Int32,Value1=CONTEXT_ROUNDSCORE_NEWB_15)))
	DefaultSettings(52)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`KOTHRoundScore,Data=(Type=SDT_Int32,Value1=CONTEXT_ROUNDSCORE_KOTH_170)))
	DefaultSettings(53)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`WingmanScore,Data=(Type=SDT_Int32,Value1=CONTEXT_WINGMAN_SCOREGOAL_15)))
	DefaultSettings(54)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`HordeEnemyDiff,Data=(Type=SDT_Int32,Value1=CONTEXT_AIDIFFICULTY_HARDCORE)))
	DefaultSettings(55)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`SPTutorials1,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(56)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`SPTutorials2,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(57)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`MPTutorials1,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(58)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`MPTutorials2,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(59)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`TurnInversion,Data=(Type=SDT_Int32,Value1=PXIO_Off)))
	DefaultSettings(60)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`TargetSensitivity,Data=(Type=SDT_Int32,Value1=PCSO_Medium)))
	DefaultSettings(61)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`ZoomSensitivity,Data=(Type=SDT_Int32,Value1=PCSO_Medium)))
	DefaultSettings(62)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`MPNumBots,Data=(Type=SDT_Int32,Value1=CONTEXT_NUMBOTS_0)))
	DefaultSettings(63)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`HordeWave,Data=(Type=SDT_Int32,Value1=CONTEXT_HORDE_WAVE_0)))
	DefaultSettings(64)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`DiscoverFound1,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(65)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`DiscoverFound2,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(66)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`DiscoverNeedsViewed1,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(67)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`DiscoverNeedsViewed2,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(68)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`MAP_SELECTION_MODE,Data=(Type=SDT_Int32,Value1=eGEARMAPSELECT_HOSTSELECT)))
	DefaultSettings(69)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`WeapSwap_FragGrenade,Data=(Type=SDT_Int32,Value1=eGEARWEAP_FragGrenade)))
	DefaultSettings(70)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`WeapSwap_InkGrenade,Data=(Type=SDT_Int32,Value1=eGEARWEAP_InkGrenade)))
	DefaultSettings(71)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`WeapSwap_Boomshot,Data=(Type=SDT_Int32,Value1=eGEARWEAP_Boomshot)))
	DefaultSettings(72)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`WeapSwap_Flame,Data=(Type=SDT_Int32,Value1=eGEARWEAP_Flame)))
	DefaultSettings(73)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`WeapSwap_Sniper,Data=(Type=SDT_Int32,Value1=eGEARWEAP_Sniper)))
	DefaultSettings(74)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`WeapSwap_Bow,Data=(Type=SDT_Int32,Value1=eGEARWEAP_Bow)))
	DefaultSettings(75)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`WeapSwap_Mulcher,Data=(Type=SDT_Int32,Value1=eGEARWEAP_Mulcher)))
	DefaultSettings(76)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`WeapSwap_Mortar,Data=(Type=SDT_Int32,Value1=eGEARWEAP_Mortar)))
	DefaultSettings(77)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`WeapSwap_HOD,Data=(Type=SDT_Int32,Value1=eGEARWEAP_HOD)))
	DefaultSettings(78)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`WeapSwap_Gorgon,Data=(Type=SDT_Int32,Value1=eGEARWEAP_Gorgon)))
	DefaultSettings(79)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`WeapSwap_Boltok,Data=(Type=SDT_Int32,Value1=eGEARWEAP_Boltok)))
	DefaultSettings(80)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`CompletedChaptersCasual1,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(81)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`CompletedChaptersCasual2,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(82)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`CompletedChaptersNormal1,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(83)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`CompletedChaptersNormal2,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(84)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`CompletedChaptersHard1,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(85)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`CompletedChaptersHard2,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(86)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`CompletedChaptersInsane1,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(87)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`CompletedChaptersInsane2,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(88)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`CompletedChaptersArcadeCasual1,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(89)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`CompletedChaptersArcadeCasual2,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(90)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`CompletedChaptersArcadeNormal1,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(91)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`CompletedChaptersArcadeNormal2,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(92)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`CompletedChaptersArcadeHard1,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(93)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`CompletedChaptersArcadeHard2,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(94)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`CompletedChaptersArcadeInsane1,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(95)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`CompletedChaptersArcadeInsane2,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(96)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`UnlockedUnlockables,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(97)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`UnlockableNeedsViewed,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(98)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`CoopInviteType,Data=(Type=SDT_Int32,Value1=eGCIT_FriendsOnly)))
	DefaultSettings(99)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`CampCheckpointUsage,Data=(Type=SDT_Int32,Value1=eGEARCHECKPOINT_UseLast)))
	DefaultSettings(100)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`LastCheckpointSlot,Data=(Type=SDT_Int32,Value1=-1)))
	DefaultSettings(101)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`CoopCompletedChapters1,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(102)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`CoopCompletedChapters2,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(103)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`MPMapsCompleted,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(104)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`NumEnemiesKilled,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(105)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`PlaylistId,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(106)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`PlayerSkill,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(107)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`ProfileDataUploaded,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(108)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`CAMP_MODE,Data=(Type=SDT_Int32,Value1=eGCM_LivePrivate)))
	DefaultSettings(109)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`HordeWavesBeat1,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(110)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`HordeWavesBeat2,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(111)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`UnlockedChapterAccess1,Data=(Type=SDT_Int32,Value1=1)))
	DefaultSettings(112)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`UnlockedChapterAccess2,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(113)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`WeapTutorialsOn,Data=(Type=SDT_Int32,Value1=WOOO_On)))
	DefaultSettings(114)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`WeapSwap_Shield,Data=(Type=SDT_Int32,Value1=eGEARWEAP_Shield)))
	DefaultSettings(115)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`SPTutorials3,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(116)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`MPTutorials3,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(117)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`TrainTutorials1,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(118)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`TrainTutorials2,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(119)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`TrainTutorials3,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(120)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`COMPLETED_ACHIEVEMENT_MASK_A,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(121)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`COMPLETED_ACHIEVEMENT_MASK_B,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(122)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`UNVIEWED_ACHIEVEMENT_MASK_A,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(123)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`UNVIEWED_ACHIEVEMENT_MASK_B,Data=(Type=SDT_Int32,Value1=0)))
 	DefaultSettings(124)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`SelectedMedal,Data=(Type=SDT_Int32,Value1=-1)))
 	DefaultSettings(125)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`AccessedMPPrefs,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(126)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`DefaultSecondaryMPWeapon,Data=(Type=SDT_Int32,Value1=WC_Gnasher)))
	DefaultSettings(127)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`SPTutorials4,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(128)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`MPTutorials4,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(129)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`TrainTutorials4,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(130)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`BandwidthTestTimestamp,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(131)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`UpstreamBandwidth1,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(132)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`UpstreamBandwidth2,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(133)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`UpstreamBandwidth3,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(134)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`UpstreamBandwidth4,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(135)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`UpstreamBandwidth5,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(136)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`BandwidthHistorySize,Data=(Type=SDT_Int32,Value1=0)))		// default to 0 entries
	DefaultSettings(137)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`GoodHostRatio,Data=(Type=SDT_Float,Value1=1065353216)))	// 1.0
	DefaultSettings(138)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`PlaylistIdRanked,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(139)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`StandByDemerits,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(140)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`QuitDemerits,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(141)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`SiegeTutorials1,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(142)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`SiegeTutorials2,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(143)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`SiegeTutorials3,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(144)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`SiegeTutorials4,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(145)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`WeaponSkin_Lancer,Data=(Type=SDT_Int32,Value1=-1)))
	DefaultSettings(146)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`WeaponSkin_Hammerburst,Data=(Type=SDT_Int32,Value1=-1)))
	DefaultSettings(147)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`WeaponSkin_Retro,Data=(Type=SDT_Int32,Value1=-1)))
	DefaultSettings(148)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`WeaponSkin_Gnasher,Data=(Type=SDT_Int32,Value1=-1)))
	DefaultSettings(149)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`WeaponSkin_SawedOff,Data=(Type=SDT_Int32,Value1=-1)))
	DefaultSettings(150)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`IsBanned,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(151)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`IsEpicDev,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(152)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`SiegeEnemyDiff,Data=(Type=SDT_Int32,Value1=CONTEXT_AIDIFFICULTY_HARDCORE)))
	DefaultSettings(153)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`SiegeWave,Data=(Type=SDT_Int32,Value1=CONTEXT_SIEGE_WAVE_0)))
	DefaultSettings(154)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`RecentDiscover1,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(155)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`RecentDiscover2,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(156)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`RecentDiscover3,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(157)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`RecentDiscover4,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(158)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`RecentDiscover5,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(159)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`OmniDirEvade,Data=(Type=SDT_Int32,Value1=PODI_On)))
	DefaultSettings(160)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`RecentChallenge1,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(161)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`RecentChallenge2,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(162)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`RecentChallenge3,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(163)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`RecentChallenge4,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(164)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`RecentChallenge5,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(165)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`TDMKills,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(166)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`HordeMiniChallenges,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(167)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`HighestScoreArcade,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(168)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`SiegeWavesBeat,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(169)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`FullCoopCompletedChapters1,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(170)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`FullCoopCompletedChapters2,Data=(Type=SDT_Int32,Value1=0)))

	DefaultSettings(171)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`HasRookieGear,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(172)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`HasVeteranGear,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(173)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`HasEnumedCheevos,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(174)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`HasHoardTheHorde,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(175)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`HasGearsPCCheevo,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(176)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`HasUT3Cheevo,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(177)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`HasSCCheevo,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(178)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`HasBSCheevo,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(179)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`HasGears1Camp,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(180)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`HasGears2Camp,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(181)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`HasGears3Camp,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(182)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`ConfiguredVideoSettings,Data=(Type=SDT_Int32,Value1=0)))
	DefaultSettings(183)=(Owner=OPPO_Game,ProfileSetting=(PropertyId=`DisconnectCount,Data=(Type=SDT_Int32,Value1=0)))

	// These tell the UI what to display
	ProfileMappings(23)=(Id=`HudOnOff,Name="Hud",MappingType=PVMT_IdMapped,ValueMappings=((Id=WOOO_On),(Id=WOOO_Off)))
	ProfileMappings(24)=(Id=`MatureLang,Name="Mature Language",MappingType=PVMT_IdMapped,ValueMappings=((Id=WOOO_On),(Id=WOOO_Off)))
	ProfileMappings(25)=(Id=`Subtitles,Name="Subtitles",MappingType=PVMT_IdMapped,ValueMappings=((Id=WOOO_On),(Id=WOOO_Off)))
	ProfileMappings(26)=(Id=`Gore,Name="Gore",MappingType=PVMT_IdMapped,ValueMappings=((Id=WOOO_On),(Id=WOOO_Off)))
	ProfileMappings(27)=(Id=`MusicVolume,Name="Music Volume",MappingType=PVMT_RawValue)
	ProfileMappings(28)=(Id=`FxVolume,Name="FX Volume",MappingType=PVMT_RawValue)
	ProfileMappings(29)=(Id=`DialogueVolume,Name="Dialogue Volume",MappingType=PVMT_RawValue)
	ProfileMappings(30)=(Id=`GearStickConfig,Name="Stick Configuration",MappingType=PVMT_IdMapped,ValueMappings=((Id=WSCO_Default),(Id=WSCO_Legacy),(Id=WSCO_SouthPaw),(Id=WSCO_LegacySouthpaw)))
	ProfileMappings(31)=(Id=`GearTriggerConfig,Name="Trigger Configuration",MappingType=PVMT_IdMapped,ValueMappings=((Id=WTCO_Default),(Id=WTCO_SouthPaw)))
	ProfileMappings(32)=(Id=`CogMPCharacter,Name="Preferred COG Character",MappingType=PVMT_RawValue)
	ProfileMappings(33)=(Id=`LocustMPCharacter,Name="Preferred Locust Character",MappingType=PVMT_RawValue)
	ProfileMappings(34)=(Id=`GameIntensity,Name="Game Intensity",MappingType=PVMT_IdMapped,ValueMappings=((Id=DL_Casual),(Id=DL_Normal),(Id=DL_Hardcore),(Id=DL_Insane)))
	ProfileMappings(35)=(Id=`PictogramTooltips,Name="PictogramTooltips",MappingType=PVMT_IdMapped,ValueMappings=((Id=WOOO_On),(Id=WOOO_Off)))
	ProfileMappings(36)=(Id=`GammaSetting,Name="GammaSetting",MappingType=PVMT_RawValue)
	ProfileMappings(37)=(Id=`DefaultMPWeapon,Name="DefaultMPWeapon",MappingType=PVMT_RawValue)
	ProfileMappings(38)=(Id=`GearControlScheme,Name="ControlScheme",MappingType=PVMT_IdMapped,ValueMappings=((Id=GCS_Default),(Id=GCS_Alternate)))
	ProfileMappings(40)=(Id=`TelevisionType,Name="TelevisionType",MappingType=PVMT_IdMapped,ValueMappings=((Id=TVT_Default),(Id=TVT_Soft),(Id=TVT_Lucent),(Id=TVT_Vibrant)))
	ProfileMappings(41)=(Id=`VERSUS_GAMETYPE,Name="VersusGameType",MappingType=PVMT_IdMapped,ValueMappings=((Id=eGEARMP_Newbie),(Id=eGEARMP_Warzone),(Id=eGEARMP_Wingman),(Id=eGEARMP_Horde),(Id=eGEARMP_Siege),(Id=eGEARMP_Execution),(Id=eGEARMP_KOTH),(Id=eGEARMP_CTL)))
	ProfileMappings(42)=(Id=`VERSUS_MATCH_MODE,Name="VersusMatchMode",MappingType=PVMT_IdMapped,ValueMappings=((Id=eGVMT_Official),(Id=eGVMT_Player),(Id=eGVMT_Custom),(Id=eGVMT_SystemLink),(Id=eGVMT_Local)))
	ProfileMappings(43)=(Id=`VERSUS_PARTY_TYPE,Name="VersusPartyType",MappingType=PVMT_IdMapped,ValueMappings=((Id=eGVPT_InviteRequired),(Id=eGVPT_FriendsOnly),(Id=eGVPT_Public)))
	ProfileMappings(44)=(Id=`VERSUS_SELECTED_MAP,Name="VersusSelectedMap",MappingType=PVMT_IdMapped,ValueMappings=((Id=CONTEXT_MAPNAME_FLOOD),(Id=CONTEXT_MAPNAME_GRIDLOCK),(Id=CONTEXT_MAPNAME_HAIL),(Id=CONTEXT_MAPNAME_WAYSTATION)))
	ProfileMappings(45)=(Id=`MPFriendlyFire,Name="MPFriendlyFire",MappingType=PVMT_RawValue)
	ProfileMappings(46)=(Id=`MPRoundTime,Name="MPRoundTime",MappingType=PVMT_RawValue)
	ProfileMappings(47)=(Id=`MPBleedout,Name="MPBleedout",MappingType=PVMT_RawValue)
	ProfileMappings(48)=(Id=`MPWeaponSwap,Name="MPWeaponSwap",MappingType=PVMT_RawValue)
	ProfileMappings(49)=(Id=`MPRoundsToWin,Name="MPRoundsToWin",MappingType=PVMT_RawValue)
	ProfileMappings(50)=(Id=`MPBotDiff,Name="MPBotDiff",MappingType=PVMT_RawValue)
	ProfileMappings(51)=(Id=`NewbieRoundScore,Name="NewbieRoundScore",MappingType=PVMT_RawValue)
	ProfileMappings(52)=(Id=`KOTHRoundScore,Name="KOTHRoundScore",MappingType=PVMT_RawValue)
	ProfileMappings(53)=(Id=`WingmanScore,Name="WingmanScore",MappingType=PVMT_RawValue)
	ProfileMappings(54)=(Id=`HordeEnemyDiff,Name="HordeEnemyDiff",MappingType=PVMT_RawValue)
	ProfileMappings(55)=(Id=`SPTutorials1,Name="SPTutorials1",MappingType=PVMT_RawValue)
	ProfileMappings(56)=(Id=`SPTutorials2,Name="SPTutorials2",MappingType=PVMT_RawValue)
	ProfileMappings(57)=(Id=`MPTutorials1,Name="MPTutorials1",MappingType=PVMT_RawValue)
	ProfileMappings(58)=(Id=`MPTutorials2,Name="MPTutorials2",MappingType=PVMT_RawValue)
	ProfileMappings(59)=(Id=`TurnInversion,Name="TurnInverion",MappingType=PVMT_IdMapped,ValueMappings=((Id=PXIO_Off),(Id=PXIO_On)))
	ProfileMappings(60)=(Id=`TargetSensitivity,Name="TargetSensitivity",MappingType=PVMT_IdMapped,ValueMappings=((Id=PCSO_Low),(Id=PCSO_Medium),(Id=PCSO_High)))
	ProfileMappings(61)=(Id=`ZoomSensitivity,Name="ZoomSensitivity",MappingType=PVMT_IdMapped,ValueMappings=((Id=PCSO_Low),(Id=PCSO_Medium),(Id=PCSO_High)))
	ProfileMappings(62)=(Id=`MPNumBots,Name="MPNumBots",MappingType=PVMT_RawValue)
	ProfileMappings(63)=(Id=`HordeWave,Name="HordeWave",MappingType=PVMT_IdMapped,ValueMappings=((Id=CONTEXT_HORDE_WAVE_0),(Id=CONTEXT_HORDE_WAVE_1),(Id=CONTEXT_HORDE_WAVE_2),(Id=CONTEXT_HORDE_WAVE_3),(Id=CONTEXT_HORDE_WAVE_4),(Id=CONTEXT_HORDE_WAVE_5),(Id=CONTEXT_HORDE_WAVE_6),(Id=CONTEXT_HORDE_WAVE_7),(Id=CONTEXT_HORDE_WAVE_8),(Id=CONTEXT_HORDE_WAVE_9),(Id=CONTEXT_HORDE_WAVE_10),(Id=CONTEXT_HORDE_WAVE_11),(Id=CONTEXT_HORDE_WAVE_12),(Id=CONTEXT_HORDE_WAVE_13),(Id=CONTEXT_HORDE_WAVE_14),(Id=CONTEXT_HORDE_WAVE_15),(Id=CONTEXT_HORDE_WAVE_16),(Id=CONTEXT_HORDE_WAVE_17),(Id=CONTEXT_HORDE_WAVE_18),(Id=CONTEXT_HORDE_WAVE_19),(Id=CONTEXT_HORDE_WAVE_20),(Id=CONTEXT_HORDE_WAVE_21),(Id=CONTEXT_HORDE_WAVE_22),(Id=CONTEXT_HORDE_WAVE_23),(Id=CONTEXT_HORDE_WAVE_24),(Id=CONTEXT_HORDE_WAVE_25),(Id=CONTEXT_HORDE_WAVE_26),(Id=CONTEXT_HORDE_WAVE_27),(Id=CONTEXT_HORDE_WAVE_28),(Id=CONTEXT_HORDE_WAVE_29),(Id=CONTEXT_HORDE_WAVE_30),(Id=CONTEXT_HORDE_WAVE_31),(Id=CONTEXT_HORDE_WAVE_32),(Id=CONTEXT_HORDE_WAVE_33),(Id=CONTEXT_HORDE_WAVE_34),(Id=CONTEXT_HORDE_WAVE_35),(Id=CONTEXT_HORDE_WAVE_36),(Id=CONTEXT_HORDE_WAVE_37),(Id=CONTEXT_HORDE_WAVE_38),(Id=CONTEXT_HORDE_WAVE_39),(Id=CONTEXT_HORDE_WAVE_40),(Id=CONTEXT_HORDE_WAVE_41),(Id=CONTEXT_HORDE_WAVE_42),(Id=CONTEXT_HORDE_WAVE_43),(Id=CONTEXT_HORDE_WAVE_44),(Id=CONTEXT_HORDE_WAVE_45),(Id=CONTEXT_HORDE_WAVE_46),(Id=CONTEXT_HORDE_WAVE_47),(Id=CONTEXT_HORDE_WAVE_48),(Id=CONTEXT_HORDE_WAVE_49)))
	ProfileMappings(64)=(Id=`DiscoverFound1,Name="DiscoverFound1",MappingType=PVMT_RawValue)
	ProfileMappings(65)=(Id=`DiscoverFound2,Name="DiscoverFound2",MappingType=PVMT_RawValue)
	ProfileMappings(66)=(Id=`DiscoverNeedsViewed1,Name="DiscoverNeedsViewed1",MappingType=PVMT_RawValue)
	ProfileMappings(67)=(Id=`DiscoverNeedsViewed2,Name="DiscoverNeedsViewed2",MappingType=PVMT_RawValue)
	ProfileMappings(68)=(Id=`MAP_SELECTION_MODE,Name="MapSelectionMode",MappingType=PVMT_IdMapped,ValueMappings=((Id=eGEARMAPSELECT_VOTE),(Id=eGEARMAPSELECT_HOSTSELECT)))
	ProfileMappings(69)=(Id=`WeapSwap_FragGrenade,Name="WeapSwap_FragGrenade",MappingType=PVMT_IdMapped,ValueMappings=((Id=eGEARWEAP_FragGrenade),(Id=eGEARWEAP_InkGrenade),(Id=eGEARWEAP_SmokeGrenade),(Id=eGEARWEAP_Boomshot),(Id=eGEARWEAP_Flame),(Id=eGEARWEAP_Sniper),(Id=eGEARWEAP_Bow),(Id=eGEARWEAP_Mulcher),(Id=eGEARWEAP_Mortar),(Id=eGEARWEAP_HOD),(Id=eGEARWEAP_Gorgon),(Id=eGEARWEAP_Boltok),(Id=eGEARWEAP_Pistol),(Id=eGEARWEAP_Lancer),(Id=eGEARWEAP_Hammerburst),(Id=eGEARWEAP_Shotgun),(Id=eGEARWEAP_Shield),(Id=eGEARWEAP_Disabled)))
	ProfileMappings(70)=(Id=`WeapSwap_InkGrenade,Name="WeapSwap_InkGrenade",MappingType=PVMT_IdMapped,ValueMappings=((Id=eGEARWEAP_FragGrenade),(Id=eGEARWEAP_InkGrenade),(Id=eGEARWEAP_SmokeGrenade),(Id=eGEARWEAP_Boomshot),(Id=eGEARWEAP_Flame),(Id=eGEARWEAP_Sniper),(Id=eGEARWEAP_Bow),(Id=eGEARWEAP_Mulcher),(Id=eGEARWEAP_Mortar),(Id=eGEARWEAP_HOD),(Id=eGEARWEAP_Gorgon),(Id=eGEARWEAP_Boltok),(Id=eGEARWEAP_Pistol),(Id=eGEARWEAP_Lancer),(Id=eGEARWEAP_Hammerburst),(Id=eGEARWEAP_Shotgun),(Id=eGEARWEAP_Shield),(Id=eGEARWEAP_Disabled)))
	ProfileMappings(71)=(Id=`WeapSwap_Boomshot,Name="WeapSwap_Boomshot",MappingType=PVMT_IdMapped,ValueMappings=((Id=eGEARWEAP_FragGrenade),(Id=eGEARWEAP_InkGrenade),(Id=eGEARWEAP_SmokeGrenade),(Id=eGEARWEAP_Boomshot),(Id=eGEARWEAP_Flame),(Id=eGEARWEAP_Sniper),(Id=eGEARWEAP_Bow),(Id=eGEARWEAP_Mulcher),(Id=eGEARWEAP_Mortar),(Id=eGEARWEAP_HOD),(Id=eGEARWEAP_Gorgon),(Id=eGEARWEAP_Boltok),(Id=eGEARWEAP_Pistol),(Id=eGEARWEAP_Lancer),(Id=eGEARWEAP_Hammerburst),(Id=eGEARWEAP_Shotgun),(Id=eGEARWEAP_Shield),(Id=eGEARWEAP_Disabled)))
	ProfileMappings(72)=(Id=`WeapSwap_Flame,Name="WeapSwap_Flame",MappingType=PVMT_IdMapped,ValueMappings=((Id=eGEARWEAP_FragGrenade),(Id=eGEARWEAP_InkGrenade),(Id=eGEARWEAP_SmokeGrenade),(Id=eGEARWEAP_Boomshot),(Id=eGEARWEAP_Flame),(Id=eGEARWEAP_Sniper),(Id=eGEARWEAP_Bow),(Id=eGEARWEAP_Mulcher),(Id=eGEARWEAP_Mortar),(Id=eGEARWEAP_HOD),(Id=eGEARWEAP_Gorgon),(Id=eGEARWEAP_Boltok),(Id=eGEARWEAP_Pistol),(Id=eGEARWEAP_Lancer),(Id=eGEARWEAP_Hammerburst),(Id=eGEARWEAP_Shotgun),(Id=eGEARWEAP_Shield),(Id=eGEARWEAP_Disabled)))
	ProfileMappings(73)=(Id=`WeapSwap_Sniper,Name="WeapSwap_Sniper",MappingType=PVMT_IdMapped,ValueMappings=((Id=eGEARWEAP_FragGrenade),(Id=eGEARWEAP_InkGrenade),(Id=eGEARWEAP_SmokeGrenade),(Id=eGEARWEAP_Boomshot),(Id=eGEARWEAP_Flame),(Id=eGEARWEAP_Sniper),(Id=eGEARWEAP_Bow),(Id=eGEARWEAP_Mulcher),(Id=eGEARWEAP_Mortar),(Id=eGEARWEAP_HOD),(Id=eGEARWEAP_Gorgon),(Id=eGEARWEAP_Boltok),(Id=eGEARWEAP_Pistol),(Id=eGEARWEAP_Lancer),(Id=eGEARWEAP_Hammerburst),(Id=eGEARWEAP_Shotgun),(Id=eGEARWEAP_Shield),(Id=eGEARWEAP_Disabled)))
	ProfileMappings(74)=(Id=`WeapSwap_Bow,Name="WeapSwap_Bow",MappingType=PVMT_IdMapped,ValueMappings=((Id=eGEARWEAP_FragGrenade),(Id=eGEARWEAP_InkGrenade),(Id=eGEARWEAP_SmokeGrenade),(Id=eGEARWEAP_Boomshot),(Id=eGEARWEAP_Flame),(Id=eGEARWEAP_Sniper),(Id=eGEARWEAP_Bow),(Id=eGEARWEAP_Mulcher),(Id=eGEARWEAP_Mortar),(Id=eGEARWEAP_HOD),(Id=eGEARWEAP_Gorgon),(Id=eGEARWEAP_Boltok),(Id=eGEARWEAP_Pistol),(Id=eGEARWEAP_Lancer),(Id=eGEARWEAP_Hammerburst),(Id=eGEARWEAP_Shotgun),(Id=eGEARWEAP_Shield),(Id=eGEARWEAP_Disabled)))
	ProfileMappings(75)=(Id=`WeapSwap_Mulcher,Name="WeapSwap_Mulcher",MappingType=PVMT_IdMapped,ValueMappings=((Id=eGEARWEAP_FragGrenade),(Id=eGEARWEAP_InkGrenade),(Id=eGEARWEAP_SmokeGrenade),(Id=eGEARWEAP_Boomshot),(Id=eGEARWEAP_Flame),(Id=eGEARWEAP_Sniper),(Id=eGEARWEAP_Bow),(Id=eGEARWEAP_Mulcher),(Id=eGEARWEAP_Mortar),(Id=eGEARWEAP_HOD),(Id=eGEARWEAP_Gorgon),(Id=eGEARWEAP_Boltok),(Id=eGEARWEAP_Pistol),(Id=eGEARWEAP_Lancer),(Id=eGEARWEAP_Hammerburst),(Id=eGEARWEAP_Shotgun),(Id=eGEARWEAP_Shield),(Id=eGEARWEAP_Disabled)))
	ProfileMappings(76)=(Id=`WeapSwap_Mortar,Name="WeapSwap_Mortar",MappingType=PVMT_IdMapped,ValueMappings=((Id=eGEARWEAP_FragGrenade),(Id=eGEARWEAP_InkGrenade),(Id=eGEARWEAP_SmokeGrenade),(Id=eGEARWEAP_Boomshot),(Id=eGEARWEAP_Flame),(Id=eGEARWEAP_Sniper),(Id=eGEARWEAP_Bow),(Id=eGEARWEAP_Mulcher),(Id=eGEARWEAP_Mortar),(Id=eGEARWEAP_HOD),(Id=eGEARWEAP_Gorgon),(Id=eGEARWEAP_Boltok),(Id=eGEARWEAP_Pistol),(Id=eGEARWEAP_Lancer),(Id=eGEARWEAP_Hammerburst),(Id=eGEARWEAP_Shotgun),(Id=eGEARWEAP_Shield),(Id=eGEARWEAP_Disabled)))
	ProfileMappings(77)=(Id=`WeapSwap_HOD,Name="WeapSwap_HOD",MappingType=PVMT_IdMapped,ValueMappings=((Id=eGEARWEAP_FragGrenade),(Id=eGEARWEAP_InkGrenade),(Id=eGEARWEAP_SmokeGrenade),(Id=eGEARWEAP_Boomshot),(Id=eGEARWEAP_Flame),(Id=eGEARWEAP_Sniper),(Id=eGEARWEAP_Bow),(Id=eGEARWEAP_Mulcher),(Id=eGEARWEAP_Mortar),(Id=eGEARWEAP_HOD),(Id=eGEARWEAP_Gorgon),(Id=eGEARWEAP_Boltok),(Id=eGEARWEAP_Pistol),(Id=eGEARWEAP_Lancer),(Id=eGEARWEAP_Hammerburst),(Id=eGEARWEAP_Shotgun),(Id=eGEARWEAP_Shield),(Id=eGEARWEAP_Disabled)))
	ProfileMappings(78)=(Id=`WeapSwap_Gorgon,Name="WeapSwap_Gorgon",MappingType=PVMT_IdMapped,ValueMappings=((Id=eGEARWEAP_FragGrenade),(Id=eGEARWEAP_InkGrenade),(Id=eGEARWEAP_SmokeGrenade),(Id=eGEARWEAP_Boomshot),(Id=eGEARWEAP_Flame),(Id=eGEARWEAP_Sniper),(Id=eGEARWEAP_Bow),(Id=eGEARWEAP_Mulcher),(Id=eGEARWEAP_Mortar),(Id=eGEARWEAP_HOD),(Id=eGEARWEAP_Gorgon),(Id=eGEARWEAP_Boltok),(Id=eGEARWEAP_Pistol),(Id=eGEARWEAP_Lancer),(Id=eGEARWEAP_Hammerburst),(Id=eGEARWEAP_Shotgun),(Id=eGEARWEAP_Shield),(Id=eGEARWEAP_Disabled)))
	ProfileMappings(79)=(Id=`WeapSwap_Boltok,Name="WeapSwap_Boltok",MappingType=PVMT_IdMapped,ValueMappings=((Id=eGEARWEAP_FragGrenade),(Id=eGEARWEAP_InkGrenade),(Id=eGEARWEAP_SmokeGrenade),(Id=eGEARWEAP_Boomshot),(Id=eGEARWEAP_Flame),(Id=eGEARWEAP_Sniper),(Id=eGEARWEAP_Bow),(Id=eGEARWEAP_Mulcher),(Id=eGEARWEAP_Mortar),(Id=eGEARWEAP_HOD),(Id=eGEARWEAP_Gorgon),(Id=eGEARWEAP_Boltok),(Id=eGEARWEAP_Pistol),(Id=eGEARWEAP_Lancer),(Id=eGEARWEAP_Hammerburst),(Id=eGEARWEAP_Shotgun),(Id=eGEARWEAP_Shield),(Id=eGEARWEAP_Disabled)))
	ProfileMappings(80)=(Id=`CompletedChaptersCasual1,Name="CompletedChaptersCasual1",MappingType=PVMT_RawValue)
	ProfileMappings(81)=(Id=`CompletedChaptersCasual2,Name="CompletedChaptersCasual2",MappingType=PVMT_RawValue)
	ProfileMappings(82)=(Id=`CompletedChaptersNormal1,Name="CompletedChaptersNormal1",MappingType=PVMT_RawValue)
	ProfileMappings(83)=(Id=`CompletedChaptersNormal2,Name="CompletedChaptersNormal2",MappingType=PVMT_RawValue)
	ProfileMappings(84)=(Id=`CompletedChaptersHard1,Name="CompletedChaptersHard1",MappingType=PVMT_RawValue)
	ProfileMappings(85)=(Id=`CompletedChaptersHard2,Name="CompletedChaptersHard2",MappingType=PVMT_RawValue)
	ProfileMappings(86)=(Id=`CompletedChaptersInsane1,Name="CompletedChaptersInsane1",MappingType=PVMT_RawValue)
	ProfileMappings(87)=(Id=`CompletedChaptersInsane2,Name="CompletedChaptersInsane2",MappingType=PVMT_RawValue)
	ProfileMappings(88)=(Id=`CompletedChaptersArcadeCasual1,Name="CompletedChaptersArcadeCasual1",MappingType=PVMT_RawValue)
	ProfileMappings(89)=(Id=`CompletedChaptersArcadeCasual2,Name="CompletedChaptersArcadeCasual2",MappingType=PVMT_RawValue)
	ProfileMappings(90)=(Id=`CompletedChaptersArcadeNormal1,Name="CompletedChaptersArcadeNormal1",MappingType=PVMT_RawValue)
	ProfileMappings(91)=(Id=`CompletedChaptersArcadeNormal2,Name="CompletedChaptersArcadeNormal2",MappingType=PVMT_RawValue)
	ProfileMappings(92)=(Id=`CompletedChaptersArcadeHard1,Name="CompletedChaptersArcadeHard1",MappingType=PVMT_RawValue)
	ProfileMappings(93)=(Id=`CompletedChaptersArcadeHard2,Name="CompletedChaptersArcadeHard2",MappingType=PVMT_RawValue)
	ProfileMappings(94)=(Id=`CompletedChaptersArcadeInsane1,Name="CompletedChaptersArcadeInsane1",MappingType=PVMT_RawValue)
	ProfileMappings(95)=(Id=`CompletedChaptersArcadeInsane2,Name="CompletedChaptersArcadeInsane2",MappingType=PVMT_RawValue)
	ProfileMappings(96)=(Id=`UnlockedUnlockables,Name="UnlockedUnlockables",MappingType=PVMT_RawValue)
	ProfileMappings(97)=(Id=`UnlockableNeedsViewed,Name="UnlockableNeedsViewed",MappingType=PVMT_RawValue)
	ProfileMappings(98)=(Id=`CoopInviteType,Name="CoopInviteType",MappingType=PVMT_IdMapped,ValueMappings=((Id=eGCIT_InviteRequired),(Id=eGCIT_FriendsOnly),(Id=eGCIT_Public)))
	ProfileMappings(99)=(Id=`CampCheckpointUsage,Name="CampCheckpointUsage",MappingType=PVMT_IdMapped,ValueMappings=((Id=eGEARCHECKPOINT_UseLast),(Id=eGEARCHECKPOINT_Restart)))
	ProfileMappings(100)=(Id=`LastCheckpointSlot,Name="LastCheckpointSlot",MappingType=PVMT_RawValue)
	ProfileMappings(101)=(Id=`CoopCompletedChapters1,Name="CoopCompletedChapters1",MappingType=PVMT_RawValue)
	ProfileMappings(102)=(Id=`CoopCompletedChapters2,Name="CoopCompletedChapters2",MappingType=PVMT_RawValue)
	ProfileMappings(103)=(Id=`MPMapsCompleted,Name="MPMapsCompleted",MappingType=PVMT_RawValue)
	ProfileMappings(104)=(Id=`NumEnemiesKilled,Name="NumEnemiesKilled",MappingType=PVMT_RawValue)
	ProfileMappings(105)=(Id=`PlaylistId,Name="PlaylistId",MappingType=PVMT_RawValue)
	ProfileMappings(106)=(Id=`PlayerSkill,Name="PlayerSkill",MappingType=PVMT_RawValue)
	ProfileMappings(107)=(Id=`ProfileDataUploaded,Name="ProfileUploaded",MappingType=PVMT_RawValue)
	ProfileMappings(108)=(Id=`CAMP_MODE,Name="CampaignMode",MappingType=PVMT_IdMapped,ValueMappings=((Id=eGCM_LivePublic),(Id=eGCM_LivePrivate),(Id=eGCM_SystemLink)))
	ProfileMappings(109)=(Id=`HordeWavesBeat1,Name="HordeWavesBeat1",MappingType=PVMT_RawValue)
	ProfileMappings(110)=(Id=`HordeWavesBeat2,Name="HordeWavesBeat2",MappingType=PVMT_RawValue)
	ProfileMappings(111)=(Id=`UnlockedChapterAccess1,Name="UnlockedChapterAccess1",MappingType=PVMT_RawValue)
	ProfileMappings(112)=(Id=`UnlockedChapterAccess2,Name="UnlockedChapterAccess2",MappingType=PVMT_RawValue)
	ProfileMappings(113)=(Id=`WeapTutorialsOn,Name="WeapTutorialsOn",MappingType=PVMT_IdMapped,ValueMappings=((Id=WOOO_On),(Id=WOOO_Off)))
	ProfileMappings(114)=(Id=`WeapSwap_Shield,Name="WeapSwap_Shield",MappingType=PVMT_IdMapped,ValueMappings=((Id=eGEARWEAP_FragGrenade),(Id=eGEARWEAP_InkGrenade),(Id=eGEARWEAP_SmokeGrenade),(Id=eGEARWEAP_Boomshot),(Id=eGEARWEAP_Flame),(Id=eGEARWEAP_Sniper),(Id=eGEARWEAP_Bow),(Id=eGEARWEAP_Mulcher),(Id=eGEARWEAP_Mortar),(Id=eGEARWEAP_HOD),(Id=eGEARWEAP_Gorgon),(Id=eGEARWEAP_Boltok),(Id=eGEARWEAP_Pistol),(Id=eGEARWEAP_Lancer),(Id=eGEARWEAP_Hammerburst),(Id=eGEARWEAP_Shotgun),(Id=eGEARWEAP_Shield),(Id=eGEARWEAP_Disabled)))
	ProfileMappings(115)=(Id=`SPTutorials3,Name="SPTutorials3",MappingType=PVMT_RawValue)
	ProfileMappings(116)=(Id=`MPTutorials3,Name="MPTutorials3",MappingType=PVMT_RawValue)
	ProfileMappings(117)=(Id=`TrainTutorials1,Name="TrainTutorials1",MappingType=PVMT_RawValue)
	ProfileMappings(118)=(Id=`TrainTutorials2,Name="TrainTutorials2",MappingType=PVMT_RawValue)
	ProfileMappings(119)=(Id=`TrainTutorials3,Name="TrainTutorials3",MappingType=PVMT_RawValue)
	ProfileMappings(120)=(Id=`COMPLETED_ACHIEVEMENT_MASK_A,Name="CompletedAchievementMask1",MappingType=PVMT_RawValue)
	ProfileMappings(121)=(Id=`COMPLETED_ACHIEVEMENT_MASK_B,Name="CompletedAchievementMask2",MappingType=PVMT_RawValue)
	ProfileMappings(122)=(Id=`UNVIEWED_ACHIEVEMENT_MASK_A,Name="UnviewedAchievementMask1",MappingType=PVMT_RawValue)
	ProfileMappings(123)=(Id=`UNVIEWED_ACHIEVEMENT_MASK_B,Name="UnviewedAchievementMask2",MappingType=PVMT_RawValue)
 	ProfileMappings(124)=(Id=`SelectedMedal,Name="SelectedMedal",MappingType=PVMT_RawValue)
 	ProfileMappings(125)=(Id=`AccessedMPPrefs,Name="AccessedMPPrefs",MappingType=PVMT_RawValue)
	ProfileMappings(126)=(Id=`DefaultSecondaryMPWeapon,Name="DefaultSecondaryMPWeapon",MappingType=PVMT_RawValue)
	ProfileMappings(127)=(Id=`SPTutorials4,Name="SPTutorials4",MappingType=PVMT_RawValue)
	ProfileMappings(128)=(Id=`MPTutorials4,Name="MPTutorials4",MappingType=PVMT_RawValue)
	ProfileMappings(129)=(Id=`TrainTutorials4,Name="TrainTutorials4",MappingType=PVMT_RawValue)
	ProfileMappings(130)=(Id=`BandwidthTestTimestamp,Name="BandwidthTestTimestamp",MappingType=PVMT_RawValue)
	ProfileMappings(131)=(Id=`UpstreamBandwidth1,Name="UpstreamBandwidth1",MappingType=PVMT_RawValue)
	ProfileMappings(132)=(Id=`UpstreamBandwidth2,Name="UpstreamBandwidth2",MappingType=PVMT_RawValue)
	ProfileMappings(133)=(Id=`UpstreamBandwidth3,Name="UpstreamBandwidth3",MappingType=PVMT_RawValue)
	ProfileMappings(134)=(Id=`UpstreamBandwidth4,Name="UpstreamBandwidth4",MappingType=PVMT_RawValue)
	ProfileMappings(135)=(Id=`UpstreamBandwidth5,Name="UpstreamBandwidth5",MappingType=PVMT_RawValue)
	ProfileMappings(136)=(Id=`BandwidthHistorySize,Name="BandwidthHistorySize",MappingType=PVMT_RawValue)
	ProfileMappings(137)=(Id=`GoodHostRatio,Name="GoodHostRatio",MappingType=PVMT_RawValue)
	ProfileMappings(138)=(Id=`PlaylistIdRanked,Name="PlaylistIdRanked",MappingType=PVMT_RawValue)
	ProfileMappings(139)=(Id=`StandByDemerits,Name="StandByDemerits",MappingType=PVMT_RawValue)
	ProfileMappings(140)=(Id=`QuitDemerits,Name="QuitDemerits",MappingType=PVMT_RawValue)
	ProfileMappings(141)=(Id=`SiegeTutorials1,Name="SiegeTutorials1",MappingType=PVMT_RawValue)
	ProfileMappings(142)=(Id=`SiegeTutorials2,Name="SiegeTutorials2",MappingType=PVMT_RawValue)
	ProfileMappings(143)=(Id=`SiegeTutorials3,Name="SiegeTutorials3",MappingType=PVMT_RawValue)
	ProfileMappings(144)=(Id=`SiegeTutorials4,Name="SiegeTutorials4",MappingType=PVMT_RawValue)
	ProfileMappings(145)=(Id=`WeaponSkin_Lancer,Name="WeaponSkin_Lancer",MappingType=PVMT_RawValue)
	ProfileMappings(146)=(Id=`WeaponSkin_Hammerburst,Name="WeaponSkin_Hammerburst",MappingType=PVMT_RawValue)
	ProfileMappings(147)=(Id=`WeaponSkin_Retro,Name="WeaponSkin_Retro",MappingType=PVMT_RawValue)
	ProfileMappings(148)=(Id=`WeaponSkin_Gnasher,Name="WeaponSkin_Gnasher",MappingType=PVMT_RawValue)
	ProfileMappings(149)=(Id=`WeaponSkin_SawedOff,Name="WeaponSkin_SawedOff",MappingType=PVMT_RawValue)
	ProfileMappings(150)=(Id=`IsBanned,Name="IsBanned",MappingType=PVMT_RawValue)
	ProfileMappings(151)=(Id=`IsEpicDev,Name="bIsEpicDev",MappingType=PVMT_RawValue)
	ProfileMappings(152)=(Id=`SiegeEnemyDiff,Name="SiegeEnemyDiff",MappingType=PVMT_RawValue)
	ProfileMappings(153)=(Id=`SiegeWave,Name="SiegeWave",MappingType=PVMT_IdMapped,ValueMappings=((Id=CONTEXT_SIEGE_WAVE_0),(Id=CONTEXT_SIEGE_WAVE_1),(Id=CONTEXT_SIEGE_WAVE_2),(Id=CONTEXT_SIEGE_WAVE_3),(Id=CONTEXT_SIEGE_WAVE_4),(Id=CONTEXT_SIEGE_WAVE_5),(Id=CONTEXT_SIEGE_WAVE_6),(Id=CONTEXT_SIEGE_WAVE_7),(Id=CONTEXT_SIEGE_WAVE_8),(Id=CONTEXT_SIEGE_WAVE_9),(Id=CONTEXT_SIEGE_WAVE_10),(Id=CONTEXT_SIEGE_WAVE_11)))
	ProfileMappings(154)=(Id=`RecentDiscover1,Name="RecentDiscover1",MappingType=PVMT_RawValue)
	ProfileMappings(155)=(Id=`RecentDiscover2,Name="RecentDiscover2",MappingType=PVMT_RawValue)
	ProfileMappings(156)=(Id=`RecentDiscover3,Name="RecentDiscover3",MappingType=PVMT_RawValue)
	ProfileMappings(157)=(Id=`RecentDiscover4,Name="RecentDiscover4",MappingType=PVMT_RawValue)
	ProfileMappings(158)=(Id=`RecentDiscover5,Name="RecentDiscover5",MappingType=PVMT_RawValue)
	ProfileMappings(159)=(Id=`OmniDirEvade,Name="OmniDirEvade",MappingType=PVMT_IdMapped,ValueMappings=((Id=PODI_On),(Id=PODI_Off)))
	ProfileMappings(160)=(Id=`RecentChallenge1,Name="RecentChallenge1",MappingType=PVMT_RawValue)
	ProfileMappings(161)=(Id=`RecentChallenge2,Name="RecentChallenge2",MappingType=PVMT_RawValue)
	ProfileMappings(162)=(Id=`RecentChallenge3,Name="RecentChallenge3",MappingType=PVMT_RawValue)
	ProfileMappings(163)=(Id=`RecentChallenge4,Name="RecentChallenge4",MappingType=PVMT_RawValue)
	ProfileMappings(164)=(Id=`RecentChallenge5,Name="RecentChallenge5",MappingType=PVMT_RawValue)
	ProfileMappings(165)=(Id=`TDMKills,Name="TDMKills",MappingType=PVMT_RawValue)
	ProfileMappings(166)=(Id=`HordeMiniChallenges,Name="HordeMiniChallenges",MappingType=PVMT_RawValue)
	ProfileMappings(167)=(Id=`HighestScoreArcade,Name="HighestScoreArcade",MappingType=PVMT_RawValue)
	ProfileMappings(168)=(Id=`SiegeWavesBeat,Name="SiegeWavesBeat",MappingType=PVMT_RawValue)
	ProfileMappings(169)=(Id=`FullCoopCompletedChapters1,Name="FullCoopCompletedChapters1",MappingType=PVMT_RawValue)
	ProfileMappings(170)=(Id=`FullCoopCompletedChapters2,Name="FullCoopCompletedChapters2",MappingType=PVMT_RawValue)

	ProfileMappings(171)=(Id=`HasRookieGear,Name="HasRookieGear",MappingType=PVMT_RawValue)
	ProfileMappings(172)=(Id=`HasVeteranGear,Name="HasVeteranGear",MappingType=PVMT_RawValue)
	ProfileMappings(173)=(Id=`HasEnumedCheevos,Name="HasEnumedCheevos",MappingType=PVMT_RawValue)
	ProfileMappings(174)=(Id=`HasHoardTheHorde,Name="HasHoardTheHorde",MappingType=PVMT_RawValue)
	ProfileMappings(175)=(Id=`HasGearsPCCheevo,Name="HasGearsPCCheevo",MappingType=PVMT_RawValue)
	ProfileMappings(176)=(Id=`HasUT3Cheevo,Name="HasUT3Cheevo",MappingType=PVMT_RawValue)
	ProfileMappings(177)=(Id=`HasSCCheevo,Name="HasSCCheevo",MappingType=PVMT_RawValue)
	ProfileMappings(178)=(Id=`HasBSCheevo,Name="HasBSCheevo",MappingType=PVMT_RawValue)
	ProfileMappings(179)=(Id=`HasGears1Camp,Name="HasGears1Camp",MappingType=PVMT_RawValue)
	ProfileMappings(180)=(Id=`HasGears2Camp,Name="HasGears2Camp",MappingType=PVMT_RawValue)
	ProfileMappings(181)=(Id=`HasGears3Camp,Name="HasGears3Camp",MappingType=PVMT_RawValue)
	ProfileMappings(182)=(Id=`ConfiguredVideoSettings,Name="ConfiguredVideoSettings",MappingType=PVMT_RawValue)
	ProfileMappings(183)=(Id=`DisconnectCount,Name="DisconnectCount",MappingType=PVMT_RawValue)
}
