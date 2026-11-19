class OLDmgType_SoldierThrow extends OLDmgType
	native;

defaultproperties
{
	bCausedByWorld=true

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveform0
		Samples(0)=(LeftAmplitude=50,RightAmplitude=80,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.6)
	End Object
	DamagedFFWaveform=ForceFeedbackWaveform0
}
