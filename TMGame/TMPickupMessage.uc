/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
//
// OptionalObject is an Pickup class
//
class TMPickupMessage extends TMLocalMessage;

static simulated function ClientReceive( 
	PlayerController P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	local TMHUD HUD;

	Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

	HUD = TMHUD(P.MyHUD);
	if ( HUD != None )
	{
		if ( class<TMPickupFactory>(OptionalObject) != None )
		{
			class<TMPickupFactory>(OptionalObject).static.UpdateHUD(HUD);
		}
		else if ( class<TMWeapon>(OptionalObject) != None )
		{
			HUD.LastWeaponBarDrawnTime = HUD.WorldInfo.TimeSeconds + 2.0;
			HUD.LastPickupTime = HUD.WorldInfo.TimeSeconds;
		}
		else
		{
			HUD.LastPickupTime = HUD.WorldInfo.TimeSeconds;
		}
	}		
}

