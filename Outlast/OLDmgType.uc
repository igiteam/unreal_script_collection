class OLDmgType extends DamageType
	config(Game)
	native;

var config float SpeedPenaltyPctOnDamage; // pct of speed lost on any damage event
var config float SpeedPenaltyDuration;

defaultproperties
{
	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveform0
		Samples(0)=(LeftAmplitude=64,RightAmplitude=96,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.25)
	End Object
	DamagedFFWaveform=ForceFeedbackWaveform0

	// Pretty violent rumble
	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveform1
		Samples(0)=(LeftAmplitude=100,RightAmplitude=100,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=1.25)
		Samples(1)=(LeftAmplitude=100,RightAmplitude=50,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=1.75)
	End Object
	KilledFFWaveform=ForceFeedbackWaveform1
}
