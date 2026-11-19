/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearHUDLocator_HunterHat extends GearHUDLocator;

function bool ShouldDeleteLocator()
{
	return (LocatorSubject == None || LocatorSubject.bDeleteMe);
}

function DrawLocator()
{
	// only show hat locators when the hat is onscreen unless all remaining hats not owned by this team are on the ground
	// or the hat's been around for a long time (indicating players don't know where it is)
	if ( (bSubjectIsInScreen && bSubjectIsVisible) || LocatorSubject.WorldInfo.TimeSeconds - LocatorSubject.CreationTime > 15.0 ||
		GearHUDHunter(OwningHUD).LeaderLocator == None )
	{
		Super.DrawLocator();
	}
}

defaultproperties
{
	Priority=100
}