class MOHAParachuteActor extends Actor
    native
    placeable
    hidecategories(Navigation);

var() export editinline SkeletalMeshComponent NPCParachuteMesh;
var() export editinline SkeletalMeshComponent PlayerParachuteMesh;
var export editinline AudioComponent Airdrop_Freefall_Loop;
var export editinline AudioComponent AirdropParachuteSoundMP;
var MOHAPawn ParachuteOwner;
var bool bShowDebugChuteMessages;
var bool bFading;
var bool bFadeOutLighting;
var export editinline SkeletalMeshComponent playerArmsMesh;
var name AttachBoneName;
var float fParachuteFadeTime;
var float fMaxParachuteFadeTime;
var float fStartFadeTime;
var MaterialInstanceConstant ParachuteMaterialInstance;
var MaterialInstance FadeMaterialInstance;
var MaterialInstanceConstant FadeMaterialInstanceConstant;

function Ghost()
{
    bCollideWorld = false;
    //return;    
}

function PlayChuteOpenSound()
{
    local MOHAPlayerPawn myMOHAPlayerPawn;

    myMOHAPlayerPawn = MOHAPlayerPawn(ParachuteOwner);
    // End:0x6D
    if((myMOHAPlayerPawn != none) && myMOHAPlayerPawn.IsLocallyControlled())
    {
        // End:0x6D
        if(myMOHAPlayerPawn.AirdropComponent != none)
        {
            myMOHAPlayerPawn.PlaySound(myMOHAPlayerPawn.AirdropComponent.AirdropParachuteOpenSoundCue, true);
        }
    }
    //return;    
}

function PlayChuteFlareSound()
{
    local MOHAPlayerPawn myMOHAPlayerPawn;

    myMOHAPlayerPawn = MOHAPlayerPawn(ParachuteOwner);
    // End:0x6D
    if((myMOHAPlayerPawn != none) && myMOHAPlayerPawn.IsLocallyControlled())
    {
        // End:0x6D
        if(myMOHAPlayerPawn.AirdropComponent != none)
        {
            myMOHAPlayerPawn.PlaySound(myMOHAPlayerPawn.AirdropComponent.AirdropParachuteFlareSoundCue, true);
        }
    }
    //return;    
}

function PlayChuteCutSound()
{
    local MOHAPlayerPawn myMOHAPlayerPawn;

    myMOHAPlayerPawn = MOHAPlayerPawn(ParachuteOwner);
    // End:0x59
    if(myMOHAPlayerPawn != none)
    {
        // End:0x59
        if(myMOHAPlayerPawn.AirdropComponent != none)
        {
            myMOHAPlayerPawn.PlaySound(myMOHAPlayerPawn.AirdropComponent.AirdropParachuteCutSoundCue, true);
        }
    }
    //return;    
}

function EnableFreefallLoop(bool bEnable)
{
    local MOHAPlayerPawn myMOHAPlayerPawn;

    myMOHAPlayerPawn = MOHAPlayerPawn(ParachuteOwner);
    // End:0x45
    if(myMOHAPlayerPawn != none)
    {
        // End:0x36
        if(bEnable)
        {
            Airdrop_Freefall_Loop.Play();            
        }
        else
        {
            Airdrop_Freefall_Loop.Stop();
        }
    }
    //return;    
}

function EnableParachuteSound(bool bEnable)
{
    local MOHAPlayerPawn myMOHAPlayerPawn;

    myMOHAPlayerPawn = MOHAPlayerPawn(ParachuteOwner);
    // End:0x45
    if(myMOHAPlayerPawn != none)
    {
        // End:0x36
        if(bEnable)
        {
            AirdropParachuteSoundMP.Play();            
        }
        else
        {
            AirdropParachuteSoundMP.Stop();
        }
    }
    //return;    
}

function EnableRadialBlur(bool bEnable)
{
    local MOHAPlayerPawn myMOHAPlayerPawn;

    myMOHAPlayerPawn = MOHAPlayerPawn(ParachuteOwner);
    // End:0x34
    if(myMOHAPlayerPawn != none)
    {
        myMOHAPlayerPawn.EnableRadialBlur(bEnable);
    }
    //return;    
}

function PrintToScreen(string S)
{
    local MOHAPlayerPawn myMOHAPlayerPawn;
    local PlayerController myPlayerController;

    myMOHAPlayerPawn = MOHAPlayerPawn(ParachuteOwner);
    // End:0x59
    if(myMOHAPlayerPawn != none)
    {
        myPlayerController = PlayerController(myMOHAPlayerPawn.Controller);
        // End:0x59
        if(myPlayerController != none)
        {
            myPlayerController.ClientMessage(S);
        }
    }
    //return;    
}

function CameraShake(float Duration, Vector newRotAmplitude, Vector newRotFrequency, Vector newLocAmplitude, Vector newLocFrequency, float newFOVAmplitude, float newFOVFrequency)
{
    local MOHAPlayerController myPlayerController;

    // End:0x76
    if(ParachuteOwner.IsA('MOHAPlayerPawn'))
    {
        myPlayerController = MOHAPlayerController(MOHAPlayerPawn(ParachuteOwner).Controller);
        // End:0x76
        if(myPlayerController != none)
        {
            myPlayerController.CameraShake(Duration, newRotAmplitude, newRotFrequency, newLocAmplitude, newLocFrequency, newFOVAmplitude, newFOVFrequency);
        }
    }
    //return;    
}

function EndCameraShake()
{
    local Vector RotAmplitude, RotFrequency, LocAmplitude, LocFrequency;
    local float FOVAmplitude, FOVFrequency;

    FOVAmplitude = 3.0000000;
    FOVFrequency = 35.0000000;
    RotAmplitude.X = 10.0000000;
    RotAmplitude.Y = 10.0000000;
    RotAmplitude.Z = 10.0000000;
    RotFrequency.X = 44.0000000;
    RotFrequency.Y = 36.0000000;
    RotFrequency.Z = 29.0000000;
    LocAmplitude.X = 1.0000000;
    LocAmplitude.Y = 1.0000000;
    LocAmplitude.Z = 1.0000000;
    LocFrequency.X = 42.0000000;
    LocFrequency.Y = 34.0000000;
    LocFrequency.Z = 26.0000000;
    CameraShake(-1.0000000, RotAmplitude, RotFrequency, LocAmplitude, LocFrequency, FOVAmplitude, FOVFrequency);
    //return;    
}

function DoFreefallCameraShake()
{
    local Vector RotAmplitude, RotFrequency, LocAmplitude, LocFrequency;
    local float FOVAmplitude, FOVFrequency;

    FOVAmplitude = 1.0000000;
    FOVFrequency = 32.0000000 + (FRand() * 10.0000000);
    RotAmplitude.X = 42.0000000 + (FRand() * 10.0000000);
    RotAmplitude.Y = 32.0000000 + (FRand() * 10.0000000);
    RotAmplitude.Z = 43.0000000 + (FRand() * 10.0000000);
    RotFrequency.X = 44.0000000 + (FRand() * 10.0000000);
    RotFrequency.Y = 36.0000000 + (FRand() * 10.0000000);
    RotFrequency.Z = 29.0000000 + (FRand() * 10.0000000);
    LocAmplitude.X = 1.0000000;
    LocAmplitude.Y = 1.0000000;
    LocAmplitude.Z = 1.0000000;
    LocFrequency.X = 42.0000000 + (FRand() * 10.0000000);
    LocFrequency.Y = 34.0000000 + (FRand() * 10.0000000);
    LocFrequency.Z = 26.0000000 + (FRand() * 10.0000000);
    CameraShake(10.0000000, RotAmplitude, RotFrequency, LocAmplitude, LocFrequency, FOVAmplitude, FOVFrequency);
    //return;    
}

function ShowParachute(bool show)
{
    NPCParachuteMesh.SetHidden(!show);
    // End:0x39
    if(PlayerParachuteMesh != none)
    {
        PlayerParachuteMesh.SetHidden(!show);
    }
    //return;    
}

event DestroyParachute()
{
    EnableParachuteSound(false);
    Destroy();
    //return;    
}

function PlayChuteIdleAnimation()
{
    //return;    
}

simulated function PlayChuteLandingAnimation()
{
    // End:0x64
    if(ParachuteOwner.IsA('MOHAMultiplayerPawn'))
    {
        // End:0x37
        if(ParachuteOwner.IsLocallyControlled() == false)
        {
            EnableParachuteSound(false);
        }
        MOHASkeletalMeshComponent(NPCParachuteMesh).PlayAnimAtRate('ad_chute_land1', 1.0000000, 0.0000000, false, true);
    }
    //return;    
}

function SetupMaterialInstance()
{
    local MaterialInstance ParachuteMaterial;

    // End:0x7F
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        ParachuteMaterial = NPCParachuteMesh.GetMaterial(0);
        // End:0x7F
        if(ParachuteMaterial != none)
        {
            ParachuteMaterialInstance = new (Outer) Class'Engine.MaterialInstanceConstant';
            NPCParachuteMesh.SetMaterial(0, ParachuteMaterialInstance);
            ParachuteMaterialInstance.SetParent(ParachuteMaterial);
        }
    }
    //return;    
}

simulated function UpdateParachuteFade(float DeltaTime)
{
    local float fadePct;

    fParachuteFadeTime += DeltaTime;
    // End:0x26
    if(fParachuteFadeTime > fMaxParachuteFadeTime)
    {
        fParachuteFadeTime = fMaxParachuteFadeTime;
    }
    fadePct = 1.0000000 - (fParachuteFadeTime / fMaxParachuteFadeTime);
    // End:0x58
    if(fadePct <= 0.0000000)
    {
        DoneFading();
    }
    //return;    
}

simulated function TimerEnd()
{
    //return;    
}

event UnStuck()
{
    //return;    
}

event ReleaseGearDone()
{
    //return;    
}

event HitGround()
{
    //return;    
}

event FlareChute()
{
    //return;    
}

event SimulationOn()
{
    //return;    
}

event HungUpDetected()
{
    //return;    
}

event ChuteButton()
{
    //return;    
}

event CutChuteDone()
{
    //return;    
}

event FlareChuteDone()
{
    //return;    
}

event LandingDone()
{
    //return;    
}

event OpenChute()
{
    //return;    
}

event ChuteOpenAnimDone()
{
    //return;    
}

event ExitPlaneIGCFinished()
{
    //return;    
}

event Initialize(MOHAPawn MyOwner, optional bool bSkipITP)
{
    //return;    
}

event DoneFading()
{
    //return;    
}

auto state UnInitializedState
{
    event Initialize(MOHAPawn MyOwner, optional bool bSkipITP)
    {
        local MOHAPlayerPawn myMOHAPlayerPawn;
        local editinline SkeletalMeshComponent AttachMesh;
        local Vector zeroVector, upVector;

        upVector.X = 0.0000000;
        upVector.Y = 0.0000000;
        upVector.Z = 1.0000000;
        zeroVector.X = 0.0000000;
        zeroVector.Y = 0.0000000;
        zeroVector.Z = 0.0000000;
        ParachuteOwner = MyOwner;
        myMOHAPlayerPawn = MOHAPlayerPawn(ParachuteOwner);
        // End:0x1A7
        if(myMOHAPlayerPawn != none)
        {
            // End:0x11A
            if(int(WorldInfo.NetMode) == int(NM_Standalone))
            {
                AttachMesh = myMOHAPlayerPawn.FPArms;
                playerArmsMesh = AttachMesh;
                AttachComponent(PlayerParachuteMesh);
                // End:0x117
                if(AttachMesh != none)
                {
                    MOHASkeletalMeshComponent(PlayerParachuteMesh).PlayAnim('ITP');
                }                
            }
            else
            {
                // End:0x17D
                if(myMOHAPlayerPawn.IsLocallyControlled())
                {
                    AttachMesh = myMOHAPlayerPawn.FPArms;
                    AttachComponent(PlayerParachuteMesh);
                    // End:0x17A
                    if(AttachMesh != none)
                    {
                        MOHASkeletalMeshComponent(PlayerParachuteMesh).PlayAnim('ITP');
                    }                    
                }
                else
                {
                    AttachMesh = myMOHAPlayerPawn.Mesh;
                    AttachComponent(NPCParachuteMesh);
                    EnableParachuteSound(true);
                }
            }
        }
        bIgnoreBaseRotation = true;
        // End:0x25A
        if(AttachMesh != none)
        {
            // End:0x205
            if(ParachuteOwner.IsA('MOHAMultiplayerPawn') && !myMOHAPlayerPawn.IsLocallyControlled())
            {
                SetBase(ParachuteOwner, upVector, AttachMesh, 'Spine2');                
            }
            else
            {
                // End:0x237
                if(ParachuteOwner.IsA('MOHAPlayerPawn'))
                {
                    SetBase(ParachuteOwner, upVector, AttachMesh, 'Spine');
                }
            }
            NPCParachuteMesh.SetTranslation(vect(0.0000000, 0.0000000, -100.0000000));            
        }
        else
        {
            SetBase(ParachuteOwner);
        }
        SetRelativeLocation(zeroVector);
        // End:0x299
        if((myMOHAPlayerPawn != none) && !bSkipITP)
        {
            GotoState('InPlaneState');            
        }
        else
        {
            GotoState('ChuteOpenState');
        }
        //return;        
    }
Begin:

    stop;                
}

state InPlaneState
{
    event ExitPlaneIGCFinished()
    {
        GotoState('FreefallState');
        //return;        
    }
    stop;    
}

state ExitingPlaneState
{    stop;    
}

state ChuteOpenState
{
    event HitGround()
    {
        GotoState('LandingState');
        //return;        
    }

    event ChuteOpenAnimDone()
    {
        GotoState('ChuteState');
        //return;        
    }
Begin:

    // End:0x09
    if(bShowDebugChuteMessages)
    {
    }
    PlayChuteOpenSound();
    // End:0x44
    if(ParachuteOwner.AirdropComponent != none)
    {
        ParachuteOwner.AirdropComponent.SetChuteOpenAirdropParameters();
    }
    ShowParachute(true);
    Sleep(2.0000000);
    GotoState('ChuteState');
    stop;            
}

state FreefallState
{
    event HitGround()
    {
        GotoState('LandingNoChuteState');
        //return;        
    }

    event ChuteButton()
    {
        GotoState('ChuteOpenState');
        //return;        
    }

    event EndState(name NextStateName)
    {
        EnableFreefallLoop(false);
        EndCameraShake();
        //return;        
    }
Begin:

    // End:0x09
    if(bShowDebugChuteMessages)
    {
    }
    EnableFreefallLoop(true);
    // End:0x45
    if(ParachuteOwner.AirdropComponent != none)
    {
        ParachuteOwner.AirdropComponent.SetFreefallAirdropParameters();
    }
    J0x45:

    // End:0x5E [Loop If]
    if(true)
    {
        DoFreefallCameraShake();
        Sleep(10.0000000);
        // [Loop Continue]
        goto J0x45;
    }
    stop;        
}

state LandingNoChuteState
{
    event LandingDone()
    {
        GotoState('ExitState');
        //return;        
    }
    stop;    
}

state ChuteState
{
    function BeginState(name PreviousStateName)
    {
        // End:0x3B
        if(ParachuteOwner.IsA('MOHAPlayerPawn'))
        {
            MOHASkeletalMeshComponent(PlayerParachuteMesh).PlayAnim('descend');
        }
        //return;        
    }

    event HitGround()
    {
        GotoState('LandingState');
        //return;        
    }

    simulated event FlareChute()
    {
        GotoState('ChuteFlareState');
        //return;        
    }

    event SimulationOn()
    {
        GotoState('ChuteSimulatedState');
        //return;        
    }

    event HungUpDetected()
    {
        local MOHAPlayerPawn PlayerPawn;

        PlayerPawn = MOHAPlayerPawn(ParachuteOwner);
        // End:0x48
        if(PlayerPawn != none)
        {
            PlayerPawn.AirdropComponent.bAirdropParachuteHungUp = true;
            PlayerPawn.AirDrop_ParachuteHungUpEvent();
        }
        GotoState('HungUpState');
        //return;        
    }

    event ChuteButton()
    {
        // End:0x2F
        if(ParachuteOwner.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(ParachuteOwner).AirDrop_CutChuteEvent();
        }
        GotoState('CutChuteState');
        //return;        
    }
Begin:

    // End:0x2E
    if(bShowDebugChuteMessages)
    {
        PrintToScreen("Entering chute open state");
    }
    stop;        
}

state ChuteFlareState
{
    event HitGround()
    {
        GotoState('LandingState');
        //return;        
    }

    simulated event FlareChuteDone()
    {
        // End:0x2F
        if(ParachuteOwner.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(ParachuteOwner).AirDrop_DecendEvent();
        }
        // End:0x60
        if(ParachuteOwner.AirdropComponent != none)
        {
            ParachuteOwner.AirdropComponent.SetChuteOpenAirdropParameters();
        }
        GotoState('ChuteState');
        //return;        
    }
Begin:

    // End:0x09
    if(bShowDebugChuteMessages)
    {
    }
    PlayChuteFlareSound();
    // End:0x44
    if(ParachuteOwner.AirdropComponent != none)
    {
        ParachuteOwner.AirdropComponent.SetChuteFlaringAirdropParameters();
    }
End:


    stop;                
}

state HungUpState
{
    event ChuteButton()
    {
        // End:0x2F
        if(ParachuteOwner.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(ParachuteOwner).AirDrop_CutChuteEvent();
        }
        GotoState('CutChuteState');
        //return;        
    }
Begin:

    stop;                
}

state CutChuteState
{
    event CutChuteDone()
    {
        local MOHAPlayerPawn PlayerPawn;

        PlayerPawn = MOHAPlayerPawn(ParachuteOwner);
        // End:0x35
        if(PlayerPawn != none)
        {
            PlayerPawn.AirdropComponent.bAirdropParachuteHungUp = false;
        }
        GotoState('FreefallState');
        //return;        
    }
Begin:

    // End:0x09
    if(bShowDebugChuteMessages)
    {
    }
    PlayChuteCutSound();
    Sleep(1.0000000);
    ShowParachute(false);
    stop;        
}

state ChuteSimulatedState
{
    event HungUpDetected()
    {
        GotoState('HungUpState');
        //return;        
    }

    event HitGround()
    {
        GotoState('LandingState');
        //return;        
    }

    event ChuteButton()
    {
        GotoState('CutChuteState');
        //return;        
    }
    stop;    
}

simulated state LandingState
{
    event StuckLanding()
    {
        GotoState('LandingStuckState');
        //return;        
    }

    event GreasedLanding()
    {
        GotoState('ExitState');
        //return;        
    }

    simulated function Tick(float dt)
    {
        // End:0x18
        if(bFading)
        {
            UpdateParachuteFade(dt);
        }
        //return;        
    }

    simulated function TimerEnd()
    {
        bFading = true;
        //return;        
    }

    simulated event DoneFading()
    {
        GotoState('ExitState');
        //return;        
    }
Begin:

    // End:0x8A
    if(ParachuteOwner.IsA('MOHAMultiplayerPawn'))
    {
        MOHAMultiplayerPawn(ParachuteOwner).Mesh.DetachComponent(PlayerParachuteMesh);
        // End:0x74
        if(MOHAPlayerPawn(ParachuteOwner).FPArms != none)
        {
            MOHAPlayerPawn(ParachuteOwner).FPArms.DetachComponent(PlayerParachuteMesh);
        }
        fMaxParachuteFadeTime = 1.0000000;
        bFading = true;        
    }
    else
    {
        // End:0xE7
        if(ParachuteOwner.IsA('MOHAPlayerPawn'))
        {
            // End:0xDC
            if(MOHAPlayerPawn(ParachuteOwner).FPArms != none)
            {
                MOHAPlayerPawn(ParachuteOwner).FPArms.DetachComponent(PlayerParachuteMesh);
            }
            ShowParachute(false);
        }
    }
    stop;                    
}

state LandingStuckState
{
    event UnStuck()
    {
        GotoState('ReleaseJumpGearState');
        //return;        
    }
    stop;    
}

state ReleaseJumpGearState
{
    event ReleaseGearDone()
    {
        GotoState('ExitState');
        //return;        
    }
    stop;    
}

simulated state ExitState
{
    simulated function BeginState(name PreviousStateName)
    {
        Destroy();
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: MOHASkeletalMeshComponent'Default__MOHAParachuteActor.NPCParachuteSkeletalMeshComponent'
    begin object name=NPCParachuteSkeletalMeshComponent class=Class'MOHASkeletalMeshComponent'
        SkeletalMesh=SkeletalMesh'Gcm_Wpn_US_Parachute.SkeletalMesh.US_Parachute_rigged'
        Animations=AnimNodeSequence'Default__MOHAParachuteActor.AnimNodeSeq0'
        AnimSets[0]=AnimSet'Anim_AI_AirdropAnimSet.AnimSet.AirdropCHUTEAnimSet'
        bUpdateSkelWhenNotRendered=true
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAParachuteActor.MyLightEnvironment'
        CastShadow=false
        LightingChannels=(bInitialized=true,Characters_Weapons_Vehicles=true)
        BlockNonZeroExtent=true
    end object
    NPCParachuteMesh=NPCParachuteSkeletalMeshComponent
    // Reference: MOHASkeletalMeshComponent'Default__MOHAParachuteActor.PlayerParachuteSkeletalMeshComponent'
    begin object name=PlayerParachuteSkeletalMeshComponent class=Class'MOHASkeletalMeshComponent'
        FOV=65.0000000
        SkeletalMesh=SkeletalMesh'GCm_Wpn_US_VM_Parachute.SkeletalMesh.US_VM_Parachute_rigged'
        Animations=AnimNodeSequence'Default__MOHAParachuteActor.AnimNodeSeq0'
        AnimSets[0]=AnimSet'GCm_Wpn_US_VM_Parachute.AnimSet.US_VM_Parachute_AnimSet'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAParachuteActor.MyLightEnvironment'
        DepthPriorityGroup=2
        LightingChannels=(bInitialized=true,Characters_Weapons_Vehicles=true)
        CollideActors=true
        BlockNonZeroExtent=true
    end object
    PlayerParachuteMesh=PlayerParachuteSkeletalMeshComponent
    // Reference: AudioComponent'Default__MOHAParachuteActor.AirdropFreefallSound'
    begin object name=AirdropFreefallSound class=Class'Engine.AudioComponent'
        SoundCue=SoundCue'Aud_GCm_FakeWAV.Airdrop.Free_Fall_LP'
    end object
    Airdrop_Freefall_Loop=AirdropFreefallSound
    // Reference: AudioComponent'Default__MOHAParachuteActor.AirdropParachuteSoundMP'
    begin object name=AirdropParachuteSoundMP class=Class'Engine.AudioComponent'
        SoundCue=SoundCue'Aud_GCm_FakeWAV.Parachute.Parachute_InAir_NPC_LP'
    end object
    AirdropParachuteSoundMP=AirdropParachuteSoundMP
    AttachBoneName="Spine2"
    fMaxParachuteFadeTime=2.5000000
    fStartFadeTime=0.7500000
    FadeMaterialInstance=Material'Gcm_Wpn_US_Parachute.Texture.US_Parachute_CM_Mat'
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAParachuteActor.MyLightEnvironment'
    begin object name=MyLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
    end object
    Components[0]=MyLightEnvironment
    Components[1]=AirdropFreefallSound
    Components[2]=AirdropParachuteSoundMP
    CollisionType=0
}