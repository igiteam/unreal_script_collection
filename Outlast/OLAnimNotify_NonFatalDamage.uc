class OLAnimNotify_NonFatalDamage extends AnimNotify
	native(Anim);

var() int DamageAmount;	

cpptext
{
	virtual void Notify( class UAnimNodeSequence* NodeSeq );
	virtual FString GetEditorComment() { return TEXT("NonFatalDamage"); }
}

defaultproperties
{
	DamageAmount=40
}
