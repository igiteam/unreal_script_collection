/** 
 * This class is the base class for Gear waveforms
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearWaveForms extends GameWaveForms;


/** The forcefeedback waveform to play when you are killed by this damage type */
var ForceFeedbackWaveform ActiveReloadSuccess;

/** The forcefeedback waveform to play when you are killed by this damage type */
var ForceFeedbackWaveform ActiveReloadSuperSuccess;

/** The forcefeedback waveform to play when you are killed by this damage type */
var ForceFeedbackWaveform EnterCoverHard;



/** The forcefeedback waveform to play when you are killed by this damage type */
var ForceFeedbackWaveform MeleeHit;

/** The forcefeedback waveform to play when you are killed by this damage type */
var ForceFeedbackWaveform ChainSawCutting;

/** The forcefeedback waveform to play when you are killed by this damage type */
var ForceFeedbackWaveform ChainSawRev;


/** The forcefeedback waveform to play when you are killed by this damage type */
var ForceFeedbackWaveform EmergenceHoleOpening;

/** The forcefeedback waveform to play when you are killed by this damage type */
var ForceFeedbackWaveform EmergenceHoleClosing;


defaultproperties
{
	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveform1
		Samples(0)=(LeftAmplitude=50,RightAmplitude=50,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.100)
	End Object
	ActiveReloadSuccess=ForceFeedbackWaveform1

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveform2
	    Samples(0)=(LeftAmplitude=100,RightAmplitude=100,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.100)
	End Object
	ActiveReloadSuperSuccess=ForceFeedbackWaveform2


	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveform3
	    Samples(0)=(LeftAmplitude=100,RightAmplitude=100,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.300)
	End Object
	EnterCoverHard=ForceFeedbackWaveform3


	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveform4
	    Samples(0)=(LeftAmplitude=100,RightAmplitude=100,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.200)
	End Object
	MeleeHit=ForceFeedbackWaveform4


	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveform5
	    Samples(0)=(LeftAmplitude=100,RightAmplitude=100,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=2.800)
	End Object
	ChainSawCutting=ForceFeedbackWaveform5

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveform6
	     Samples(0)=(LeftAmplitude=100,RightAmplitude=100,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.800)
	End Object
	ChainSawRev=ForceFeedbackWaveform6
}






