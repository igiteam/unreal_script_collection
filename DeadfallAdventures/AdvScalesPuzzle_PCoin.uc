class AdvScalesPuzzle_PCoin extends KActorSpawnable;

var export editinline AudioComponent FallingSoundComponent;
var export editinline AudioComponent FallingSoundComponentPouch;

simulated function PostBeginPlay()
{
    super(KActor).PostBeginPlay();
    Class'EvilGame.EvilPhysicsHelpers'.static.SetRBCCDThreshold(StaticMeshComponent, 50.0000000);
    SetCollisionSize(1.0000000, 1.0000000);
    //return;    
}

event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
    super(Actor).Bump(Other, OtherComp, HitNormal);
    // End:0xB9
    if(OtherComp.BlockZeroExtent)
    {
        // End:0xB6
        if(FallingSoundComponentPouch != none)
        {
            // End:0x97
            if(FallingSoundComponentPouch.IsPlaying())
            {
                FallingSoundComponentPouch.Stop();
            }
            FallingSoundComponentPouch.Play();
        }        
    }
    else
    {
        // End:0x128
        if(FallingSoundComponent != none)
        {
            // End:0x109
            if(FallingSoundComponent.IsPlaying())
            {
                FallingSoundComponent.Stop();
            }
            FallingSoundComponent.Play();
        }
    }
    //return;    
}

defaultproperties
{
    // Reference: AudioComponent'Default__AdvScalesPuzzle_PCoin.FallingAudioComponent0'
    begin object name=FallingAudioComponent0 class=Class'Engine.AudioComponent'
        SoundCue=SoundCue'a_Puzzles.Cue.a_Coin'
    end object
    FallingSoundComponent=FallingAudioComponent0
    // Reference: AudioComponent'Default__AdvScalesPuzzle_PCoin.FallingAudioComponent1'
    begin object name=FallingAudioComponent1 class=Class'Engine.AudioComponent'
        SoundCue=SoundCue'a_Puzzles.Cue.a_Coins'
    end object
    FallingSoundComponentPouch=FallingAudioComponent1
    bDamageAppliesImpulse=false
    // Reference: StaticMeshComponent'Default__AdvScalesPuzzle_PCoin.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        StaticMesh=StaticMesh'adv_en_mini_Balance_01.Meshes.sm_en_mini_BalanceCoin_01_01'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvScalesPuzzle_PCoin.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvScalesPuzzle_PCoin.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    Components[2]=FallingAudioComponent0
    Components[3]=FallingAudioComponent1
    Physics=EPhysics.PHYS_Falling
    CollisionComponent=StaticMeshComponent0
}