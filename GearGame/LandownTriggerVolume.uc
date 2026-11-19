/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class LandownTriggerVolume extends DynamicTriggerVolume;

// Turn off navigation points as you go
event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	local NavigationPoint Nav;
	
	Nav = NavigationPoint(Other);
	if( Nav != None && !Nav.bBlocked )
	{
		Nav.bBlocked = TRUE;
		WorldInfo.Game.NotifyNavigationChanged(Nav);
	}

	Super.Touch( Other, OtherComp, HitLocation, HitNormal );
}

defaultproperties
{
}