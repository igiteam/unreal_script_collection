class AdvGhostingSkeletalMeshActor extends SkeletalMeshActor
    hidecategories(Navigation);

var() export editinline AdvGhostingEffectComponent GhostingComponent;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    GhostingComponent.Init(SkeletalMeshComponent);
    //return;    
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    super(Actor).PostInitAnimTree(SkelComp);
    // End:0x52
    if(SkelComp == SkeletalMeshComponent)
    {
        GhostingComponent.Init(SkelComp);
    }
    //return;    
}

simulated event Tick(float DeltaTime)
{
    super(Actor).Tick(DeltaTime);
    GhostingComponent.Tick(DeltaTime);
    //return;    
}

simulated event Destroyed()
{
    GhostingComponent.Destroy();
    super.Destroyed();
    //return;    
}

simulated function OnTeleport(SeqAct_Teleport Action)
{
    local Vector PreTeleportLocation;
    local Rotator PreTeleportRotation;

    PreTeleportLocation = Location;
    PreTeleportRotation = Rotation;
    super(Actor).OnTeleport(Action);
    // End:0x9C
    if(VSizeSq(Location - PreTeleportLocation) > 1.0000000)
    {
        GhostingComponent.CreateTeleportTrail(PreTeleportLocation, Location, PreTeleportRotation, Rotation);
    }
    //return;    
}

defaultproperties
{
    // Reference: AdvGhostingEffectComponent'Default__AdvGhostingSkeletalMeshActor.GhostingComponent0'
    begin object name=GhostingComponent0 class=Class'AdvGhostingEffectComponent'
        GhostCount=8
        GhostFadeTime=0.0750000
        GhostInitialOpacity=0.7500000
    end object
    GhostingComponent=GhostingComponent0
    // Reference: SkeletalMeshComponent'Default__AdvGhostingSkeletalMeshActor.SkeletalMeshComponent0'
    begin object name=SkeletalMeshComponent0
        // Reference: AnimNodeSequence'Default__AdvGhostingSkeletalMeshActor.SkeletalMeshComponent0.AnimNodeSeq0'
        begin object name=AnimNodeSeq0
        end object
        Animations=AnimNodeSeq0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvGhostingSkeletalMeshActor.MyLightEnvironment'
    end object
    SkeletalMeshComponent=SkeletalMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvGhostingSkeletalMeshActor.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: AudioComponent'Default__AdvGhostingSkeletalMeshActor.FaceAudioComponent'
    begin object name=FaceAudioComponent
    end object
    FacialAudioComp=FaceAudioComponent
    Components[0]=MyLightEnvironment
    Components[1]=SkeletalMeshComponent0
    Components[2]=FaceAudioComponent
    Components[3]=GhostingComponent0
    CollisionComponent=SkeletalMeshComponent0
}