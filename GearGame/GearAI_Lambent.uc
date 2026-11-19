/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAI_Lambent extends GearAI_Cover
	native(AI);

cpptext 
{
	// overidden to not mess with rotation rate during roadierun(charge)
	virtual FLOAT GetRoadieRunRotationRateModifier(){ return 1.0f; }
	
};
defaultproperties
{
}