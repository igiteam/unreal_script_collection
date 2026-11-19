class OLAnimNotify_LeftHandIK extends AnimNotify
	native(Anim)
	dependson(OLHero);

var() IKTargetType TargetType;
var() float FadeInTime;
var() float FadeOutTime;
var() vector EffectorOffset; 

var editconst float Duration;

cpptext
{
	virtual void Notify( class UAnimNodeSequence* NodeSeq );
	virtual FString GetEditorComment() { return TEXT("LeftHandIK"); }
	virtual void AnimNotifyEventChanged(class UAnimNodeSequence* NodeSeq, FAnimNotifyEvent* OwnerEvent);
}

defaultproperties
{
	Duration=0.0
	FadeInTime=0.15
	FadeOutTime=0.15
}