/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ModifyNanoPower extends SequenceAction;

/** Amount of NanoPower buckets to give **/
var() int Amount;
/** If there is not enough power to do the action, allow use of what is there */
var() bool bAllowPartial;
/** New recovery rate for nano power... negative will drain, positive will replenish */
var() float RecoveryRate;
/** Do not modify actual power just test if would be successful */
var() bool bTest;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

defaultproperties
{
	ObjName="Modify Nano Power"
	ObjCategory="Nano Skill Resources"

	InputLinks(0)=(LinkDesc="Give")
	InputLinks(1)=(LinkDesc="Consume")
	InputLinks(2)=(LinkDesc="Set Recovery Rate")
	InputLinks(3)=(LinkDesc="Reset Recovery Rate")

	OutputLinks(0)=(LinkDesc="Success")
	OutputLinks(1)=(LinkDesc="Full Power")
	OutputLinks(2)=(LinkDesc="Empty Power")
	OutputLinks(3)=(LinkDesc="Not Enough")

	VariableLinks(1)=(ExpectedType=class'SeqVar_Int',LinkDesc="# Buckets",PropertyName=Amount,bHidden=TRUE)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Bool',LinkDesc="Allow Partial",PropertyName=bAllowPartial,bHidden=TRUE)
	VariableLinks(3)=(ExpectedType=class'SeqVar_Float',LinkDesc="Recovery Rate",PropertyName=RecoveryRate,bHidden=TRUE)
	VariableLinks(4)=(ExpectedType=class'SeqVar_Bool',LinkDesc="Only Test",PropertyName=bTest,bHidden=TRUE)
	
	bAutoActivateOutputLinks=FALSE
}