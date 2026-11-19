class OLAnimNotify_Door extends AnimNotify
	native(Anim);

enum EDoorInteraction
{
	DI_Open,
	DI_Close,
};

var() EDoorInteraction Interaction;

var() float AngleWhenOpen;

var editconst float Duration;

cpptext
{
	virtual void Notify( class UAnimNodeSequence* NodeSeq );
	virtual FString GetEditorComment() { return Interaction == DI_Open ? TEXT("Open Door") : TEXT("Close Door"); }
	virtual void AnimNotifyEventChanged(class UAnimNodeSequence* NodeSeq, FAnimNotifyEvent* OwnerEvent);
}

defaultproperties
{
	Duration=0.0
	AngleWhenOpen=95.0
}