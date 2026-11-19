class SkyAnimBlendByConstraintBase extends SkyAnimBlendBase
    native;

var transient float CurrentValue;
var() bool bSnapToChildren;

// Export USkyAnimBlendByConstraintBase::execUpdateChildren(FFrame&, void* const)
native function UpdateChildren();

event OnInit()
{
    super(AnimNode).OnInit();
    UpdateChildren();
    //return;    
}
