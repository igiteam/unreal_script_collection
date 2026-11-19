class SkyTouchEffectStaticMeshActor extends StaticMeshActor
    native;

var() Vector TraceDirectionOverride;
var transient array<TouchEffectInstance> TouchEffectInstances;

// Export USkyTouchEffectStaticMeshActor::execProcessTouch(FFrame&, void* const)
native function ProcessTouch(Actor Other, PrimitiveComponent OtherComp, const out Vector OtherBodyLocation, const out Vector TraceDirection);

// Export USkyTouchEffectStaticMeshActor::execProcessUntouch(FFrame&, void* const)
native function ProcessUntouch(Actor Other);

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    ProcessTouch(Other, OtherComp, HitLocation, HitNormal);
    super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
    //return;    
}

simulated event UnTouch(Actor Other)
{
    ProcessUntouch(Other);
    super(Actor).UnTouch(Other);
    //return;    
}
