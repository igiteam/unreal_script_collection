/**
 * Class: GUDBank
 * A GUDSBank is a
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GUDBank extends Object
	dependson(GUDTypes)
	native(Sound);

/** Different Types of GUD Builds we want to run */
enum EGUDBuildType
{
	EGUDB_Root,
	EGUDB_SinglePlayer,
	EGUDB_MultiPlayer,
	EGUDB_Horde,
	EGUDB_Siege
};

/** Defines flags that determine when a line is loaded */
struct native GUDLoadFlags
{
	/** Load line in competitive MP */
	var byte		bLoadInMP;
	/** Load line in single player/coop */
	var byte		bLoadInSP;
	/** Load line in Horde */
	var byte		bLoadInHorde;
	/** Load line in Beast/Siege */
	var byte		bLoadInSiege;
	
	structcpptext
	{
		/** 
		* Sees if all the flags that are enabled in this struct are also enabled in another struct
		* @param FlagsToCheck     Other struct to check flags in
		*/
		UBOOL CheckAllEnabledFlags(const FGUDLoadFlags &FlagsToCheck)
		{
			if (bLoadInSP && !FlagsToCheck.bLoadInSP) return FALSE;
			if (bLoadInMP && !FlagsToCheck.bLoadInMP) return FALSE;
			if (bLoadInHorde && !FlagsToCheck.bLoadInHorde) return FALSE;
			if (bLoadInSiege && !FlagsToCheck.bLoadInSiege) return FALSE;
			return TRUE;
		}		
	}
};

struct native GUDLine
{
	var init string	DevText;			// can remove this at ship time, used only for dev/debugging
	var	SoundCue	Audio;
	var	EGUDRole	Addressee;
	/** Used mainly in responses, to handle a line directed at one person, but referring to another. */
	var EGUDRole	ReferringTo;
	/** TRUE if this line should be in the "core" streaming package for this character, which is always loaded. */
	var byte		bAlwaysLoad;
	/** Used by cooker. Fits in the padding, shouldn't eat memory. */
	var byte		bCookerProcessed;

	/** Under what conditions we will load this GUDLine. If all are set to True, load this in the base package */
	var GUDLoadFlags LoadFlags;

	/** GUDEvent(s) to trigger upon completion of this action.  One will be chosen randomly from the list. */
	var init array<EGUDEventID>	ResponseEventIDs;

	structdefaultproperties
	{
		Addressee=GUDRole_None
	}
};
var array<GUDLine>		GUDLines;

struct native GUDAction
{
	/** Line will be chosen randomly from these if in combat, otherwise it will default to LineIndices */
	var array<int>	CombatOnlyLineIndices;
	var array<int>	NonCombatOnlyLineIndices;
	/** Line will be chosen randomly from these */
	var array<int>	LineIndices;
};
var array<GUDAction>	GUDActions;

/** for cooked GUDBank objects, the class path to the GUDBank subclass that was used to generate it */
var string SourceGUDBankPath;

defaultproperties
{
}
