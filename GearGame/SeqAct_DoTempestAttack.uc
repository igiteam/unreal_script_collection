/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class SeqAct_DoTempestAttack extends SeqAct_Latent 
	native (Sequence);

/** How long this should last */
var() float SweepAttackTime;

/** Location to start the beam attack */
var Actor StartSweep;

/** Location to end the beam attack */
var Actor EndSweep;

cpptext
{
public:
	virtual UBOOL UpdateOp(FLOAT DeltaTime);
};

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

/** Triggered by script, letting it know that it's all done **/
function TriggerStopped()
{
	ActivateOutputLink(0);
	// trigger started/finished
	ActivateOutputLink(2);
}

/** Triggered by script, letting it know that it has started, but hasn't finished yet. Waiting for ending. **/
function TriggerStarted()
{
	// trigger started
	ActivateOutputLink(0);
}

/** Triggered by script, letting it know that it's all done **/
function TriggerFailed()
{
	`warn(self@" Failed triggering Tempest Attack");
	// activate fail output
	ActivateOutputLink(0);
	ActivateOutputLink(3);
}

defaultproperties
{
	ObjName="Do Tempest Sweep Attack"
	ObjCategory="Gear"

	SweepAttackTime=4

	InputLinks.Empty
	InputLinks(0)=(LinkDesc="Start Beam Attack")
	InputLinks(1)=(LinkDesc="Stop Beam Attack")

	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Start Location",PropertyName=StartSweep)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Object',LinkDesc="End Location",PropertyName=EndSweep)

	OutputLinks.Empty
	OutputLinks(0)=(LinkDesc="Out")
	OutputLinks(1)=(LinkDesc="Finished")
	OutputLinks(2)=(LinkDesc="Stopped")
	OutputLinks(3)=(LinkDesc="Failed")
}
