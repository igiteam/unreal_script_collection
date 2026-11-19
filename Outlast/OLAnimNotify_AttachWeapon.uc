class OLAnimNotify_AttachWeapon extends AnimNotify
	native(Anim);

var() SkeletalMesh WeaponSkelMesh;
var() string AttachBoneName;

var editconst float Duration;

cpptext
{
	virtual void Notify( class UAnimNodeSequence* NodeSeq );
	virtual void NotifyEnd( class UAnimNodeSequence* NodeSeq, FLOAT AnimCurrentTime );
	virtual FString GetEditorComment() { return TEXT("AttachWeapon"); }
	virtual void AnimNotifyEventChanged(class UAnimNodeSequence* NodeSeq, FAnimNotifyEvent* OwnerEvent);
}

defaultproperties
{
	AttachBoneName="NPCLarge-L-Hand_aux"
}