/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_DrudgeControl extends SequenceAction;

/** Drudge will set its enemy to one from this array */
var array<Pawn> Enemies;
/** Target to charge to on death */
var Actor ChargeTarget;
/** Timer starts when the drudge starts its suicide charge. When it expires, the drudge will explode regardless if it reached its destination */
var() float MaxChargingTime;
/** True if drudge should have infinite health during the suicide charge */
var() bool bUnlimitedHealthCharge;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

defaultproperties
{
	ObjName="Drudge Control"
	ObjCategory="Gear"

	InputLinks.Empty
	InputLinks(0)=(LinkDesc="Charge")
	InputLinks(1)=(LinkDesc="Mutate")
	InputLinks(2)=(LinkDesc="Spew")
	InputLinks(3)=(LinkDesc="Explode")
	InputLinks(4)=(LinkDesc="Pre-Mutate (no transform animation)")
	InputLinks(5)=(LinkDesc="Post-Mutate (no transform animation)")	
	InputLinks(6)=(LinkDesc="Set Charge Parameters")	

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target",PropertyName=Targets)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="EnemyOverride",PropertyName=Enemies)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Object',LinkDesc="Charge Target",PropertyName=ChargeTarget)
}
