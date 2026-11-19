class OLAnimNotify_ProceduralAdjust extends AnimNotify
	native(Anim);

var editconst float Duration;

cpptext
{
	virtual void Notify( class UAnimNodeSequence* NodeSeq );
	virtual FString GetEditorComment() { return TEXT("Procedural Adjust"); }
	virtual void AnimNotifyEventChanged(class UAnimNodeSequence* NodeSeq, FAnimNotifyEvent* OwnerEvent);
}

defaultproperties
{
	Duration=0.0
}