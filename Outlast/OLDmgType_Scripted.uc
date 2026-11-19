class OLDmgType_Scripted extends OLDmgType
	native;

defaultproperties
{
	bCausedByWorld=false

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveform0
		Samples(0)=(LeftAmplitude=100,RightAmplitude=100,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.75)
	End Object
	DamagedFFWaveform=ForceFeedbackWaveform0
}
