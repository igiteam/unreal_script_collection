class TurokCullDistanceActor extends Actor
    native
    placeable
    hidecategories(Navigation)
    autoexpandcategories(CullingInformation);

struct native MinMax
{
    var() float mMin;
    var() float mMax;

    structdefaultproperties
    {
        mMin=0.0000000
        mMax=1000.0000000
    }
};

struct native CullingInformation
{
    var() @NULL mTargetMesh;
    var() float mCullDistance;
    var() float mDistToStartScalingDown;
    var() @NULL mCullOnlyAffectsWithinScaleRange;
    var @NULL mOriginalScale;

    structdefaultproperties
    {
        mTargetMesh=none
        mCullDistance=8000.0000000
        mDistToStartScalingDown=0.0000000
        mCullOnlyAffectsWithinScaleRange=(mMin=0.0000000,mMax=10000.0000000)
        mOriginalScale=(X=1.0000000,Y=1.0000000,Z=1.0000000)
    }
};

var(CullingInformation) bool mbForceOverrideOfLevelSettings;
var(CullingInformation) float mFarCullingPlane;
var(CullingInformation) const array CullingTargets;

// Export UTurokCullDistanceActor::execSetFarCullingPlane(FFrame&, void* const)
native function SetFarCullingPlane();

simulated function SetCullDistance()
{
    local @NULL StaticMeshActor, terrainActor;
    local int IsReferencing, Index;

    SetFarCullingPlane();
    // End:0xD8
    foreach AllActors(Class'Engine.StaticMeshActor', StaticMeshActor)
    {
        Index = 0;
        J0x21:

        // End:0xD7 [Loop If]
        if(Index < CullingTargets.Length)
        {
            StaticMeshActor.StaticMeshComponent.IsReferencing(CullingTargets[Index].mTargetMesh, IsReferencing);
            // End:0xCD
            if((IsReferencing == 1) && (StaticMeshActor.StaticMeshComponent.CullDistance == 0.0000000) || mbForceOverrideOfLevelSettings)
            {
                StaticMeshActor.StaticMeshComponent.CullDistance = CullingTargets[Index].mCullDistance;
            }
            ++Index;
            // [Loop Continue]
            goto J0x21;
        }        
    }    
    // End:0x148
    foreach AllActors(Class'Engine.Terrain', terrainActor)
    {
        Index = 0;
        J0xF0:

        // End:0x147 [Loop If]
        if(Index < CullingTargets.Length)
        {
            terrainActor.SetReferencedMeshCullDistance(CullingTargets[Index].mTargetMesh, CullingTargets[Index].mCullDistance);
            ++Index;
            // [Loop Continue]
            goto J0xF0;
        }        
    }    
    //return;    
}

simulated function OnSetCullDistance(@NULL Action)
{
    SetCullDistance();
    //return;    
}

defaultproperties
{
    mFarCullingPlane=4000.0000000
    bStatic=true
    bNoDelete=true
}