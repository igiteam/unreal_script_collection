class OLDmgType_SoldierPunch extends OLDmgType
	native;

defaultproperties
{
	bCausedByWorld=false

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveform0
		Samples(0)=(LeftAmplitude=100,RightAmplitude=100,LeftFunction=WF_LinearDecreasing,RightFunction=WF_Constant,Duration=0.8)
	End Object
	DamagedFFWaveform=ForceFeedbackWaveform0
}
