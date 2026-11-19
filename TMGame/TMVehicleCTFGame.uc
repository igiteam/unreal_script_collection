/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMVehicleCTFGame extends TMCTFGame
	abstract;

// Returns whether a mutator should be allowed with this gametype
static function bool AllowMutator( string MutatorClassName )
{
	if ( (MutatorClassName ~= "TMGame.TMMutator_WeaponsRespawn")
		|| (MutatorClassName ~= "TMGame.TMMutator_LowGrav") )
	{
		return false;
	}
	return Super.AllowMutator(MutatorClassName);
}

