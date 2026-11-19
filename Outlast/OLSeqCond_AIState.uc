/**
 * Copyright 2012 Red Barrels Inc. All Rights Reserved.
 */
class OLSeqCond_AIState extends SequenceCondition
	native(Sequence);

cpptext
{
	void Activated();
};

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjName="AI State"
	ObjCategory="AI"
	
	InputLinks(0)=(LinkDesc="In")

	OutputLinks(0)=(LinkDesc="Idle")
	OutputLinks(1)=(LinkDesc="Patrolling")
	OutputLinks(2)=(LinkDesc="Investigating")
	OutputLinks(3)=(LinkDesc="Chasing")

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Bot",bWriteable=false,MinVars=1,MaxVars=1)
}
