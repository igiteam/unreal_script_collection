class OLAnimCameraSpace extends AnimNodeBlendPerBone
	native(Anim);

var transient AnimNodeSlot ChildSlot; // either ChildSlot or ChildBlend should be valid
var transient OLAnimCustomBlend ChildBlend;
var transient int CameraBoneIdx;
var transient array<int> StartBoneIndices;
var transient array<int> ParentChain;

cpptext
{
	virtual void InitAnim(USkeletalMeshComponent* MeshComp, UAnimNodeBlendBase* Parent);
	virtual void TickAnim(FLOAT deltaTime);
	virtual void GetBoneAtoms(FBoneAtomArray& Atoms, const TArray<BYTE>& DesiredBones, FBoneAtom& RootMotionDelta, INT& bHasRootMotion, FCurveKeyArray& CurveKeys);	
	virtual void BuildWeightList();
}

defaultproperties
{
	CategoryDesc="Outlast"
}
