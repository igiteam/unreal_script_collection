class SkyCameraNodeBlendByCoverEnterDistance extends SkyCameraNodeBlendList
    native;

var transient float CachedDistance;

// Export USkyCameraNodeBlendByCoverEnterDistance::execUpdateChildren(FFrame&, void* const)
native function UpdateChildren();

event OnInit()
{
    UpdateChildren();
    //return;    
}
