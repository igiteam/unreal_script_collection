/**
 * Class to hold resources needed by GearGame infos shared across multiple gametypes
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearMPResources_Base extends Object
	native
	config(Game);


/** used when the player's selection is invalid or we're not in a phase where we can load it */
var class<GearPawn> DefaultCOGClass, DefaultLocustClass;

/** COG team class data */
var config array<string> COGClassPaths;

/** Locust team class data */
var config array<string> LocustClassPaths;

/** Weapon lookup table for performing weapon replacement */
var array<ProfileToWeaponLookupTableData> WeaponLookupTable;

/** Data for end-of-round encouragements */
var const array<TeamEncouragementData> EncouragementData;

var SoundCue EndOfGameMusic;

/** played when spawns swap (for gametypes that do so) */
var SoundCue SpawnSwapSound;

/** Reference to the Personal Progression screen*/
var class<UIScene_PersonalProgression> PPUISceneClass;