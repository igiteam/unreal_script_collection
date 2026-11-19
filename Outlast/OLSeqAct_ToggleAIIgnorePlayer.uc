/**
 * Copyright 2012 Red Barrels Inc. All Rights Reserved.
 */
class OLSeqAct_ToggleAIIgnorePlayer extends SequenceAction;

var() bool bSetOnGroup;

defaultproperties
{
	ObjName="Toggle AI Ignore Player"
	ObjCategory="AI"

	bSetOnGroup=false

	InputLinks(0)=(LinkDesc="Ignore Player")
	InputLinks(1)=(LinkDesc="Stop Ignoring")
}
