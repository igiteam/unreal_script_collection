/** 
 * This class plays Gear waveforms through Kismet
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_PlayWaveForm extends SequenceAction;

var() editinline ForceFeedbackWaveform WaveForm;

defaultproperties
{
	ObjName="Play Waveform"
	ObjCategory="Misc"
}