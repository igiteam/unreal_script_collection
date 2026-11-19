class SPDAction_SpawnActor extends SPDAction_Spawn
    abstract
    native
    editinlinenew
    collapsecategories;

/** STRUCT DECLARATIONS VARIABLE DECLARATIONS */
var(SPDAction) float LifeSpanLimit;
var(SPDAction) bool bCollideActors;
var(SPDAction) bool bBlockActors;
var(SPDAction) bool bDisablePathBlocking;
/** If this is set to true, use bLightEnvironmentComponentSetting, otherwise use baseActor's setting. */
var(SPDAction) bool bUseLightEnvironmentComponentSetting;
var(SPDAction) bool bLightEnvironmentComponentSetting;
var(SPDAction) SPDestructibleProperties Destructproperties;
var(SPDAction) int HitPoints;
var(SPDAction) OverriddenLightingParams Lighting;
var(SPDAction) float Scale;
/**  
 *Setting this to true will tell the engine that static lighting only needs to be updated once (or when lights 
 *   are added or removed from the scene). This is a great optimization for things which are bDynamic
 */
var(SPDAction) EnableOverride UpdateStaticLightsOnlyOnce;

// Export USPDAction_SpawnActor::execSetCollisionFlags(FFrame&, void* const)
native function SetCollisionFlags(Actor Actor);

// Export USPDAction_SpawnActor::execMatchBoneOrientations(FFrame&, void* const)
native function MatchBoneOrientations(SkeletalMeshComponent Source, SkeletalMeshComponent Destination);

// Export USPDAction_SpawnActor::execSetLightingFlags(FFrame&, void* const)
native function SetLightingFlags(Actor newActor, Actor baseActor);

// Export USPDAction_SpawnActor::execSetScaleValue(FFrame&, void* const)
native function SetScaleValue(Actor newActor);

function MatchActorBoneOrientations(Actor SrcActor, Actor destActor)
{
    local editinline SkeletalMeshComponent SrcComponent, DestComponent;

    SrcComponent = SrcActor.GetSkeletalMeshComponent();
    DestComponent = destActor.GetSkeletalMeshComponent();
    MatchBoneOrientations(SrcComponent, DestComponent);
    //return;    
}

function SetDestructComponent(Actor SrcActor)
{
    local editinline SPActorDestructComponent spComponent;

    spComponent = SPActorDestructComponent(SrcActor.GetActorDestructComponent());
    // End:0x9D
    if(spComponent != none)
    {
        spComponent.HitPoints = HitPoints;
        // End:0x9D
        if(Destructproperties != none)
        {
            spComponent.SetProperties(Destructproperties);
            spComponent.MinCollisionVelocity = Destructproperties.MinCollisionVelocity;
            spComponent.MaxCollisionVelocity = Destructproperties.MaxCollisionVelocity;
        }
    }
    //return;    
}

function Actor CreateActorInternal(SPDProcessManager Manager, Vector SpawnLocation, Rotator SpawnRotation, Actor baseActor)
{
    local Actor newActor;

    // End:0x53
    if(int(Manager.GetWorldInfo().NetMode) == int(NM_Standalone))
    {
        newActor = Manager.SPSpawn(NewActorClass, baseActor,, SpawnLocation, SpawnRotation);        
    }
    else
    {
        newActor = Manager.SPSpawn(NewActorClassMP, baseActor,, SpawnLocation, SpawnRotation);
    }
    // End:0xDF
    if(newActor != none)
    {
        SetCollisionFlags(newActor);
        SetDestructComponent(newActor);
        newActor.LifeSpan = LifeSpanLimit;
        SetLightingFlags(newActor, baseActor);
        SetScaleValue(newActor);
    }
    return newActor;
    //return ReturnValue;    
}

defaultproperties
{
    bCollideActors=true
    bBlockActors=true
    bUseLightEnvironmentComponentSetting=true
    bLightEnvironmentComponentSetting=true
    HitPoints=100
    Lighting=(bOverrideLighting=false,bDisableInheritBaseLighting=false,CastShadow=false,bForceDirectLightMap=false,bCastDynamicShadow=true,bAcceptsLights=true,bAcceptsDynamicLights=true,bUsePrecomputedShadows=true,LightingChannels=(bInitialized=false,BSP=true,Static=true,Dynamic=false,CompositeDynamic=false,Skybox=false,Unnamed_1=false,Unnamed_2=false,Unnamed_3=false,Unnamed_4=false,Unnamed_5=false,Unnamed_6=false,Cinematic_1=false,Cinematic_2=false,Cinematic_3=false,Cinematic_4=false,Cinematic_5=false,Cinematic_6=false,Gameplay_1=false,Gameplay_2=false,Gameplay_3=false,Gameplay_4=false,Crowd=false))
    Scale=1.0000000
}