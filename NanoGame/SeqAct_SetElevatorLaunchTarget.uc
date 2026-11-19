/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
 
class SeqAct_SetElevatorLaunchTarget extends SequenceAction;

/** Target that the pawn should be launched to for doing an override jump off an elevator*/
var Actor   LaunchTarget;

/** How close the player must be to the target in order to launch to it **/
var() float   LaunchRange;

/** How long to hang the player in the air after launch **/
var() float   HangTime;

/** If TRUE, the elevator will not be destroyed at launch */
var() bool    bDoNotDestroyAtLaunch;

defaultproperties
{
	ObjName="Set Elevator Launch Target"
	ObjCategory="Nano"
	
	LaunchRange=5000.0
	HangTime=2.0

	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Launch Target",PropertyName=LaunchTarget,MaxVars=1)
}