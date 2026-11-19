/**
 * AI for the Bloodmount that runs along an interpolation path
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAI_BloodmountChase extends GearAI;

defaultproperties
{
	DefaultCommand=AICommand

	DefaultReactConditions.Empty
	DefaultReactConditionClasses.Empty
	
	bCanRevive=FALSE
	bCanExecute=FALSE
}
