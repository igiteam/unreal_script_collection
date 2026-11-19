class OLAnimNotify_Fade extends AnimNotify
	native(Anim);

var() bool bFadeIn;
var() bool bForceStartValue;

var() float Opacity;
var() color FadeColor;
var() float Duration;


cpptext
{
	virtual void Notify( class UAnimNodeSequence* NodeSeq );
	virtual FString GetEditorComment() { return TEXT("Fade"); }
}

defaultproperties
{
	bFadeIn=true
	Opacity=1.0
	Duration=2.0
}
