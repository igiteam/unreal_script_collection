/**
 * Gears version of the LocalPlayer
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearLocalPlayer extends LocalPlayer;

var GearAlertManager AlertManager;

/** Flag that tells us whether we've already been in the front end before */
var bool bIsFirstFrontEndLoad;

/** Flag telling us to play the credits when returning to the main menu */
var bool bDisplayCredits;

/** Whether the player should be returning to the front end in a party (used for determining if the history should get wiped) */
var bool bWasPlayingWithParty;

/** Whether the front end should automatically display the postgame stats screen when returning */
var bool bAutoDisplayPostGameStats;

/** The number of mutators that can be selected */
const NUM_SELECTED_MUTATORS = 3;
/** The value that denotes an unused mutator selection slot */
const NO_MUTATOR = 255;

/** Array of indices into the MutatorClassArray int UIWidget_MainMenu that denotes which mutators are selected */
var byte ArcadeSelectedMutators[NUM_SELECTED_MUTATORS];
/** Array of indices into the MutatorClassArray in UIWidget_MainMenu that denotes which mutators are selected */
var byte HordeSelectedMutators[NUM_SELECTED_MUTATORS];

/** Whether the user has decided to skip all saves or not */
var bool bWantsToSkipSaves;

/** 
 *  Function that constructs the string that should be appended to the url to support the given mutators
 *  
 *  @param SelectedMutatorsArray - an array NUM_SELECTED_MUTATORS long of bytes representing the mutators to be used
 *  
 *  @return The string that should be appended to the URL to use the given mutators
 */
static function string BuildMutatorURLSection(const out byte SelectedMutatorsArray[NUM_SELECTED_MUTATORS])
{
	local int i;

	local string MutatorsURLString;
	local bool bFirstMutator;

	bFirstMutator = true;
	for (i = 0; i < NUM_SELECTED_MUTATORS; i++)
	{
		if (SelectedMutatorsArray[i] != NO_MUTATOR)
		{
			if (bFirstMutator)
			{
				bFirstMutator = false;
				MutatorsURLString = "?mutator=" $ class'UIWidget_MainMenu'.default.MutatorClassArray[SelectedMutatorsArray[i]];
			}
			else
			{
				MutatorsURLString $= "," $ class'UIWidget_MainMenu'.default.MutatorClassArray[SelectedMutatorsArray[i]];
			}
		}
	}
	return MutatorsURLString;
}

defaultproperties
{
	ArcadeSelectedMutators[0]=NO_MUTATOR;
	ArcadeSelectedMutators[1]=NO_MUTATOR;
	ArcadeSelectedMutators[2]=NO_MUTATOR;

	HordeSelectedMutators[0]=NO_MUTATOR;
	HordeSelectedMutators[1]=NO_MUTATOR;
	HordeSelectedMutators[2]=NO_MUTATOR;

	bIsFirstFrontEndLoad=true
}
