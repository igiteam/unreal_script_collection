/**
 * This class must be used for our Fan Volumes so we can modify it later
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoFan_ThroughBase extends NanoFanBase
	abstract
	native;


/** This is the number of units to translate the plume and volume below the fan base. **/
var(NanoFan) int NumberOfUnitsToTranslatePlumeAndVolumeDown;


cpptext
{
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
}


defaultproperties
{

}