
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_AISetupEnemyRange extends SequenceAction;

var() float EnemyDistance_Short;
var() float EnemyDistance_Medium;
var() float EnemyDistance_Long;
var() float EnemyDistance_Melee;
var() float EnemyDistance_MeleeCharge;

/**
 * Return the version number for this class.  Child classes should increment this method by calling Super then adding
 * a individual class version to the result.  When a class is first created, the number should be 0; each time one of the
 * link arrays is modified (VariableLinks, OutputLinks, InputLinks, etc.), the number that is added to the result of
 * Super.GetObjClassVersion() should be incremented by 1.
 *
 * @return	the version number for this specific class.
 */
static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 0;
}

defaultproperties
{
	ObjName="AI: Setup Enemy Ranges"
	ObjCategory="AI"

	VariableLinks(1)=(ExpectedType=class'SeqVar_Float',LinkDesc="Short",PropertyName=EnemyDistance_Short)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Float',LinkDesc="Medium",PropertyName=EnemyDistance_Medium)
	VariableLinks(3)=(ExpectedType=class'SeqVar_Float',LinkDesc="Long",PropertyName=EnemyDistance_Long)
	VariableLinks(4)=(ExpectedType=class'SeqVar_Float',LinkDesc="Melee",PropertyName=EnemyDistance_Melee)
	VariableLinks(5)=(ExpectedType=class'SeqVar_Float',LinkDesc="MeleeCharge",PropertyName=EnemyDistance_MeleeCharge)

	EnemyDistance_Short=-1.f
	EnemyDistance_Medium=-1.f
	EnemyDistance_Long=-1.f
	EnemyDistance_Melee=-1.f
	EnemyDistance_MeleeCharge=-1.f
}
