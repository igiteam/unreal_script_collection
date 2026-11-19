/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NDT_NanoStaff extends NDT_Melee
    abstract;


defaultproperties
{
	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformSwordImpact
		Samples(0)=(LeftAmplitude=100,RightAmplitude=100,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.100)
	End Object
	DamagedFFWaveform=ForceFeedbackWaveformSwordImpact

	
}