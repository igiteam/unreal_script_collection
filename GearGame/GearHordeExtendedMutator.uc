/**
 * mutator for Horde extended waves that applies a variable multiplier to some aspect of gameplay
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearHordeExtendedMutator extends GearMutator;

/** extended wave iteration at which this mutator was added */
var int IterationAdded;

var protectedwrite float Multiplier;

var Texture2D MutatorIcon;

var bool ShowMultiplier;

function SetMultiplier(float InMultiplier)
{
	Multiplier = InMultiplier;
}

defaultproperties
{
	Multiplier=1.0
	MutatorIcon=Texture2D'Warfare_HUD.Horde_Enemies'
	ShowMultiplier=true
}
