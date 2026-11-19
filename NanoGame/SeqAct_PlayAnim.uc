/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_PlayAnim extends SeqAct_Latent
	native(Sequence);

/** Custom anim sets needed to play this animation */
var() array<AnimSet> CustomAnimSets;
/** Rate to play the animation */
var() float Rate;
/** Time to blend into this animation */
var() float BlendInTime;
/** Time to blend out of this animation on completion, -1.f to never blend out */
var() float BlendOutTime;
/** Should this animation loop */
var() bool bLooping;
/** Should this animation only play on the upper body? */
var() bool bUpperBodyOnly;
/** What animation to play */
var() Name AnimName;

cpptext
{
	virtual UBOOL UpdateOp(FLOAT deltaTime);
};

event Activated()
{
	Super.Activated();

	// Activate the Out output manually, since bAutoActivateOutputLinks is turned off
	ActivateOutputLink(0);
}

function OnAnimEnd()
{
	// Activate the AnimFinished output
	ActivateOutputLink(1);

	// Finish the latent action
	bAborted=TRUE;
}

defaultproperties
{
	ObjName="Play Anim"
	ObjCategory="Pawn"

	InputLinks(0)=(LinkDesc="Play")
	InputLinks(1)=(LinkDesc="Stop")

	OutputLinks(1)=(LinkDesc="Anim Finished")

	bAutoActivateOutputLinks=FALSE

	Rate=1.f
	BlendInTime=0.25f
	BlendOutTime=0.25f
}
