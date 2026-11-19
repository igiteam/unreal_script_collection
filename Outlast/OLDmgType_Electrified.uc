class OLDmgType_Electrified extends OLDmgType
	native;

defaultproperties
{
   bCausedByWorld=true

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveform0
		Samples(0)=(LeftAmplitude=80,RightAmplitude=30,LeftFunction=WF_Constant,RightFunction=WF_LinearDecreasing,Duration=0.5)
	End Object
	DamagedFFWaveform=ForceFeedbackWaveform0
}
