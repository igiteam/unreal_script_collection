/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ModifyMeleeCircleValues extends SequenceAction;


var() bool bResetToDefaults;

var() int NewNumMeleeEngage;

var() int NewNumMeleeStandby;

var() int NewNumMeleeSpectator;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

/**
 * Called when this event is activated.
 */
event Activated()
{

	if( bResetToDefaults == TRUE )
	{
// 		NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).AIBlackboard.NumMeleeEngage = class'NanoAIBlackboard'.default.NumMeleeEngage;
// 		NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).AIBlackboard.NumMeleeStandby = class'NanoAIBlackboard'.default.NumMeleeStandby;
// 		NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).AIBlackboard.NumMeleeSpectator = class'NanoAIBlackboard'.default.NumMeleeSpectator;
	}
	else
	{
// 		NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).AIBlackboard.NumMeleeEngage = NewNumMeleeEngage;
// 		NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).AIBlackboard.NumMeleeStandby = NewNumMeleeStandby;
// 		NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).AIBlackboard.NumMeleeSpectator = NewNumMeleeSpectator;
	}
}



defaultproperties
{
	ObjName="Modify Melee Circle Values"
	ObjCategory="Nano Procedural"

	bCallHandler=FALSE

	VariableLinks.Empty()
}


