class OLAnimNotify_Blur extends AnimNotify
	native(Anim);

var() float Amount;	
var() float Duration;
var() float BlendInTime;
var() float BlendOutTime;
var() float Desaturation;

cpptext
{
	virtual void Notify( class UAnimNodeSequence* NodeSeq );
	virtual FString GetEditorComment() { return TEXT("Blur"); }
}

defaultproperties
{
	Amount=1.0
	Duration=5.0
	BlendInTime=0.1
	BlendOutTime=4.0
	Desaturation=0.7f;
}
