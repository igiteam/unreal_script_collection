/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ModifyDefensivePoint extends SequenceAction;


/** The new radius for the defensive point. Set to -1 to cause it have NO radius **/
var() float NewRadius;

/** The new num points this guy has to spend.  Set to -1 to cause it have NO points to spend **/
var() int NewNumPointsToSpendToDefend;

/** If you want to take the current num points to spend this defensive point has and just modify it (e.g. +/- N)**/
var() int ModifyNumPointsToSpendToDefendBy;

/** The new number of points needed for a wave to spawn.  Set to -1 to cause it to not do a wave **/
var() int NewNumPointsForAWave;

/** This will add all of these reinforcement points to the list the defensive point has. **/
var() array<NanoReinforcementPoint> ReinforcementPointsToAdd;

/** This will remove all of these reinforcement points to the list the defensive point has. **/
var() array<NanoReinforcementPoint> ReinforcementPointsToRemove;



defaultproperties
{
	ObjName="Modify Defensive Point"
	ObjCategory="Nano Procedural"


	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="DefensivePoint ",PropertyName=Targets,MaxVars=1)
}