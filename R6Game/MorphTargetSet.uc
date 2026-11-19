class MorphTargetSet extends Object
    native;

var array<MorphTarget> Targets;
var SkeletalMesh BaseSkelMesh;

// Export UMorphTargetSet::execFindMorphTarget(FFrame&, void* const)
native final function MorphTarget FindMorphTarget(name MorphTargetName);
