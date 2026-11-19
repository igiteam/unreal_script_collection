
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearAnim_BlendByWeaponClass extends GearAnim_BlendList
	native(Anim);

/** Internal cached pointer to GearPawn Owner */
var const	transient	GearPawn		MyGearPawn;
/** Internal cached pointer to owner's weapon */
var const	transient	GearWeapon		MyGearWeapon;
/** Cached bool to track holstering changes */
var const   transient   bool            bTemporaryHolster;

/** List Weapon Classes. Matches size of Children array - 1 */
var() editfixedsize Array<Class<GearWeapon> >	WeaponClassList<AllowAbstract>;
/** When moving the slider, keep nodes with same property in sync. */
var(Editor)	bool	bSynchronizeNodesInEditor;

cpptext
{
	virtual void InitAnim(USkeletalMeshComponent* MeshComp, UAnimNodeBlendBase* Parent);
	virtual void TickAnim(FLOAT DeltaSeconds);
	/**
	 * @return	TRUE if this object is of the specified type.
	 * If SomeBase is a parent class of CheckClass, then Depth will tell how many generations between both.
	 */
	UBOOL IsA_AndDepth(UClass* CheckClass, const UClass* SomeBase, INT& Depth) const;

	/** Looks at current weapon, and default classes, and makes a suggestion on Channel to use. */
	INT SuggestTargetChannelForClass(UClass* CheckClass) const;

	/** Track Changes, and trigger updates */
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
	virtual void HandleSliderMove(INT SliderIndex, INT ValueIndex, FLOAT NewSliderValue);

	/** Rename Child connectors upon edit/remove */
	virtual void	RenameChildConnectors();

	// AnimNodeBlendBase interface
	virtual void	OnAddChild(INT ChildNum);
	virtual void	OnRemoveChild(INT ChildNum);
};

defaultproperties
{
	bSynchronizeNodesInEditor=TRUE

	Children(0)=(Name="Default")
	Children(1)=(Name="AssaultRifle")

	WeaponClassList(0)=class'GearWeap_AssaultRifle'
}
