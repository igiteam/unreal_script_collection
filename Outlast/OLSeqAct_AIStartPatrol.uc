/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLSeqAct_AIStartPatrol extends SeqAct_Latent
	native(Sequence);

cpptext
{
	virtual UBOOL UpdateOp(FLOAT deltaTime);
	virtual void  Activated();
}

/** List of destinations to pick from */
var() Route PatrolRoute;
var() bool bStartAtClosestPoint;

var() EEnemyMode PatrolMode;

var() bool FollowPlayer;
var() float FollowDistance;
var() float FollowUpdateRate;

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
	return Super.GetObjClassVersion() + 2;
}

defaultproperties
{
	ObjName="Start Patrol"
	ObjCategory="AI"

	InputLinks(1)=(LinkDesc="GotoPlayer")

	OutputLinks(2)=(LinkDesc="Out")

	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Route",PropertyName=PatrolRoute)

	PatrolMode=EM_Patrol

	FollowDistance=160
	FollowUpdateRate=0.0
}
