class OLRecordingMarker extends OLGameplayMarker
	native
	placeable;

var() float Radius;
var() name MomentName;
var() float MinRecordingDuration;
var() bool bAllowNonContinuousRecording;
var() float NotificationDelay;

var transient bool bRecorded;
var transient bool bRecording;
var transient float StartedRecordingTime;
var transient float AccumulatedRecordingTime;

var DrawSphereComponent PreviewComp;

cpptext
{
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);

	virtual UBOOL IsValid() const;
	void RecordingComplete();
	
}

defaultproperties
{
	Radius=100.0
	MinRecordingDuration=0.75
	NotificationDelay=0.0

	Begin Object Name=Sprite
		Sprite=Texture2D'Utility.RecordingMoment-01_D'
		Scale=0.1
	End Object

	Begin Object Class=DrawSphereComponent Name=SphereComp
		CollideActors=False
		BlockActors=False
		BlockZeroExtent=False
		BlockNonZeroExtent=False
		BlockRigidBody=False
		SphereRadius=100.0
	End Object
	PreviewComp=SphereComp
	Components.Add(SphereComp)

	SupportedEvents.Add(class'OLSeqEvent_RecordingComplete')

}
