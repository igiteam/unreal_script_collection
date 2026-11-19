/**
 * Copyright 2013 Red Barrels Inc. All Rights Reserved.
 */
class OLSeqAct_OverrideAIMusic extends SequenceAction;

var() EAIMusicState MusicState;
var() float MusicDistance;

defaultproperties
{
	ObjName="Override AI Music"
	ObjCategory="AI"

	MusicState=EAIMS_Chase
	MusicDistance=500.f

	InputLinks(0)=(LinkDesc="Start")
	InputLinks(1)=(LinkDesc="Stop")
}
