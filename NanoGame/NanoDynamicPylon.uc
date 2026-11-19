/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoDynamicPylon extends DynamicPylon
	native
	placeable;


var() bool bExpandMantleChecks;
var() bool bExpandJumpChecks;

cpptext
{		
		//we prob need to add the various Simulate Destination functions here

}

defaultproperties
{
	bExpandMantleChecks=TRUE
	bExpandJumpChecks=TRUE
}