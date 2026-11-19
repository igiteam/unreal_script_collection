/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class OLSeqAct_SetEnemyMoveSpeed extends SequenceAction
	native(Sequence)
	dependsOn(OLEnemyPawn);

var() EMoveSpeedMode MoveSpeedMode;
var() float PatrolSpeedOverride;
var() float InvestigateSpeedOverride;
var() float ChaseSpeedOverride;
var() float AccelRate; // cm/s^2
var() float DecelRate; // positive
var() float SpeedNoVisibility;
var() float ChaseSpeedAtMinDist;
var() float ChaseSpeedAtMaxDist;
var() float ChaseDistMin;
var() float ChaseDistMax;

cpptext
{
	virtual void Activated();
}

defaultproperties
{
	ObjName="Set Move Speed"
	ObjCategory="AI"

	PatrolSpeedOverride=120.0
	InvestigateSpeedOverride=150.0
	ChaseSpeedOverride=325.0
	AccelRate=30.0
	DecelRate=30.0
	SpeedNoVisibility=200.0
	ChaseSpeedAtMinDist=150.0
	ChaseSpeedAtMaxDist=350.0
	ChaseDistMin=300.0
	ChaseDistMax=750.0

	InputLinks(0)=(LinkDesc="Set")
	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Bot",bWriteable=false,MinVars=1,MaxVars=1, PropertyName=None)
}