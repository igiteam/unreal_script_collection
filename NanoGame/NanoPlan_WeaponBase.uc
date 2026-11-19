/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * Plans for equippable weapons
 */
class NanoPlan_WeaponBase extends NanoPlan
    config(Game)
	abstract;

/** Class of weapon to spawn */
var class<NanoWeapon>   WeaponClass; // needs to be a name so we can DLO it

function StartForge(optional delegate<NanoPawn.OnForgeFinished> OnFinishCallback)
{
	local NanoPC PC;

	PC = NanoPC(PawnOwner.Controller);
	if (PC != None)
	{
		PC.SwitchToWeapon( default.WeaponClass, OnFinishCallback );
	}

	Super.StartForge(OnFinishCallback);
}


defaultproperties
{

}