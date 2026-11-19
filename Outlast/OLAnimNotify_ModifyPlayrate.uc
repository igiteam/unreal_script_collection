class OLAnimNotify_ModifyPlayrate extends AnimNotify
	native(Anim);

var() float NewRate;

cpptext
{
	virtual void Notify( class UAnimNodeSequence* NodeSeq );
	virtual FString GetEditorComment() { return TEXT("PlayRate"); }
}

defaultproperties
{
	NewRate=0.001
}
