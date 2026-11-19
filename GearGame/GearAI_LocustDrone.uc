/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 */
class GearAI_LocustDrone extends GearAI_Locust;

event bool CanUseJumpLink(JumpLink Link)
{
	return Link.bAllowLocustDrone;
}

defaultproperties
{
}
