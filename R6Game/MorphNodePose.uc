class MorphNodePose extends MorphNodeBase
    native
    hidecategories(Object,Object);

var transient MorphTarget Target;
var() name MorphName;

// Export UMorphNodePose::execSetMorphTarget(FFrame&, void* const)
native final function SetMorphTarget(name MorphTargetName);
