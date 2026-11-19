/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/*****************************************************************************
 SeqAct_ManageObjectives - Manages the objective system

 Inputs:
	Add Objective - Adds an objective to the system
	Completed Objective - Completes an already existing objective
	Failed Objective - Fails an already existing objective
	Abort Objective - Silently aborts an already existing objective
	Clear All Objectives - Silently clears all objectives from the system

 Outputs:
	Out - Just an action pass through
*****************************************************************************/
class SeqAct_ManageObjectives extends SequenceAction
	native(Sequence);

cpptext
{
	virtual void Activated();
}

/** Name of objective for scripting */
var() Name ObjectiveName;

/** Description of the objective */
var() string ObjectiveDesc;

/** Whether to notify the player about the objective */
var() bool bNotifyPlayer;

/** Whether or not to show this objective in the objective list in taccom */
var() bool bShowInList;

/** Whether or not this objective should be shown outside of taccom (e.g. always drawn) */
var() bool bShowAlways;

defaultproperties
{
	ObjName="Manage Objectives"
	ObjCategory="Gear"

	ObjectiveName=DefaultObjective
	bNotifyPlayer=true
	bShowInList=true

	InputLinks(0)=(LinkDesc="Add/Update Objective")
	InputLinks(1)=(LinkDesc="Completed Objective")
	InputLinks(2)=(LinkDesc="Failed Objective")

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Objective Locator (Max 10)",PropertyName=ObjectiveLocator,bHidden=FALSE)
}
