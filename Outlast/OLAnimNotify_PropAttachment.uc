class OLAnimNotify_PropAttachment extends AnimNotify
	native(Anim)
	dependson(OLHero);

var() bool bHideWhenDone;
var() float BlendInTime;
var() float BlendOutTime;
var() bool bDiscardOffsets;

// hidden because unsupported ATM.
var vector PositionOffset; 
var rotator OrientationOffset; 

var editconst float Duration;

cpptext
{
	virtual void Notify( class UAnimNodeSequence* NodeSeq );
	virtual FString GetEditorComment() { return TEXT("CSA Prop"); }
	virtual void AnimNotifyEventChanged(class UAnimNodeSequence* NodeSeq, FAnimNotifyEvent* OwnerEvent);
}

defaultproperties
{
	Duration=0.0
	BlendInTime=0.0
	BlendOutTime=0.0
	bHideWhenDone=true
}