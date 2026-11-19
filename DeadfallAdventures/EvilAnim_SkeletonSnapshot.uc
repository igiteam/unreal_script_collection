class EvilAnim_SkeletonSnapshot extends AnimNodeSequence
    native(Anim)
    hidecategories(Object,Object,Object);

struct native SkeletonSnapshot
{
    var init array<init BoneAtom> CachedBoneAtoms;
    var byte CachedNumDesiredBones;
    var BoneAtom CachedRootMotionDelta;
    var int bCachedHasRootMotion;
    var init array<init CurveKey> CachedCurveKeys;

    structdefaultproperties
    {
        CachedBoneAtoms=none
        CachedNumDesiredBones=0
        CachedRootMotionDelta=(Rotation=(X=0.0000000,Y=0.0000000,Z=0.0000000,W=0.0000000),Translation=(X=0.0000000,Y=0.0000000,Z=0.0000000),Scale=0.0000000)
        bCachedHasRootMotion=0
        CachedCurveKeys=none
    }
};

// Export UEvilAnim_SkeletonSnapshot::execTakeSnapshot(FFrame&, void* const)
native final function TakeSnapshot(AnimTree Other, optional bool bResetRootAtom);

// Export UEvilAnim_SkeletonSnapshot::execTakeSnapshotCopy(FFrame&, void* const)
native static final function SkeletonSnapshot TakeSnapshotCopy(SkeletalMeshComponent Other, optional bool bResetRootAtom);

// Export UEvilAnim_SkeletonSnapshot::execSetSnapshot(FFrame&, void* const)
native final function SetSnapshot(out SkeletonSnapshot Snapshot);
