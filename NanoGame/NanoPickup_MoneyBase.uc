/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPickup_MoneyBase extends NanoPickupFactory
	abstract;

/** The amount of money given by this pickup */
var() int Amount;

var SoundCue PickupSound;

var string PickUpName;


simulated event SetInitialState()
{
	Super(Actor).SetInitialState();
}

simulated function InitializePickup()
{

}

auto state Pickup
{
	function bool ValidTouch( Pawn Other )
	{
		if(NanoPawn_RebelsBase(Other) != none)
		{
			return TRUE;
		}
	}
}

function GiveTo( Pawn P )
{
	local NanoPawn NP;

	NP = NanoPawn(P);
	if(NP != none)
	{
		NP.GetPRI().AwardCurrency( Amount, PickUpName );

		NP.PlaySound( PickupSound );

		GotoState('Disabled');
	}
}


defaultproperties
{

	PickUpName="Pickup"
}