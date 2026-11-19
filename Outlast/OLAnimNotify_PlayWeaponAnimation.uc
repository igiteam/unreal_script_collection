class OLAnimNotify_PlayWeaponAnimation extends AnimNotify
	native(Anim)
	dependson(OLHero);

cpptext
{
	virtual void Notify( class UAnimNodeSequence* NodeSeq );
	virtual FString GetEditorComment() { return TEXT("PlayWeaponAnim"); }
}

defaultproperties
{
}