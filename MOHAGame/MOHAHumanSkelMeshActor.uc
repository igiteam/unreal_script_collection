class MOHAHumanSkelMeshActor extends SkeletalMeshActor
    abstract
    native
    hidecategories(Navigation);

var() export editinline SkeletalMeshComponent headMeshComponent;
var() bool bUseForcedLOD;
var() int forcedLODLevel;

// Export UMOHAHumanSkelMeshActor::execGetNumHeadLods(FFrame&, void* const)
native function int GetNumHeadLods();

// Export UMOHAHumanSkelMeshActor::execGetNumBodyLods(FFrame&, void* const)
native function int GetNumBodyLods();

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
    super(Actor).OnToggleHidden(Action);
    bStasis = bHidden;
    //return;    
}

function PostBeginPlay()
{
    super.PostBeginPlay();
    headMeshComponent.SetShadowParent(SkeletalMeshComponent);
    // End:0xA9
    if(bUseForcedLOD)
    {
        // End:0xA9
        if((forcedLODLevel > -1) && forcedLODLevel < (GetNumBodyLods()))
        {
            SkeletalMeshComponent.ForcedLodModel = forcedLODLevel + 1;
            // End:0x8D
            if(forcedLODLevel < (GetNumHeadLods()))
            {
                headMeshComponent.ForcedLodModel = forcedLODLevel + 1;                
            }
            else
            {
                headMeshComponent.ForcedLodModel = GetNumHeadLods();
            }            
        }
    }
    // End:0xBA
    if(bHidden)
    {
        bStasis = true;
    }
    //return;    
}

defaultproperties
{
    // Reference: MOHASkeletalMeshComponent'Default__MOHAHumanSkelMeshActor.PawnHeadMeshComponent'
    begin object name=PawnHeadMeshComponent class=Class'MOHASkeletalMeshComponent'
        bMatchLODWithParentAnimComponent=true
        ParentAnimComponent=SkeletalMeshComponent'Default__MOHAHumanSkelMeshActor.SkeletalMeshComponent0'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAHumanSkelMeshActor.MyLightEnvironment'
        LightingChannels=(bInitialized=true,Characters_Weapons_Vehicles=true)
    end object
    headMeshComponent=PawnHeadMeshComponent
    forcedLODLevel=1
    // Reference: SkeletalMeshComponent'Default__MOHAHumanSkelMeshActor.SkeletalMeshComponent0'
    begin object name=SkeletalMeshComponent0
        // Reference: AnimNodeSequence'Default__MOHAHumanSkelMeshActor.SkeletalMeshComponent0.AnimNodeSeq0'
        begin object name=AnimNodeSeq0
        end object
        Animations=AnimNodeSeq0
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAHumanSkelMeshActor.MyLightEnvironment'
        LightingChannels=(bInitialized=true,Characters_Weapons_Vehicles=true)
    end object
    SkeletalMeshComponent=SkeletalMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAHumanSkelMeshActor.MyLightEnvironment'
    begin object name=MyLightEnvironment
        bEnabled=true
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: AudioComponent'Default__MOHAHumanSkelMeshActor.MyFaceAudioComponent'
    begin object name=MyFaceAudioComponent class=Class'Engine.AudioComponent'
    end object
    FacialAudioComp=MyFaceAudioComponent
    Components[0]=MyLightEnvironment
    Components[1]=SkeletalMeshComponent0
    // Reference: AudioComponent'Default__MOHAHumanSkelMeshActor.FaceAudioComponent'
    begin object name=FaceAudioComponent
    end object
    Components[2]=FaceAudioComponent
    Components[3]=FaceAudioComponent
    Components[4]=PawnHeadMeshComponent
    Components[5]=SkeletalMeshComponent0
    CollisionComponent=SkeletalMeshComponent0
}