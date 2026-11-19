class MOHAHeavyArtilleryWeapon extends Actor
    native
    notplaceable
    hidecategories(Navigation)
    implements(SpawnInOIRInterface);

struct native FireTiming
{
    var() float MinIdleTime;
    var() float MaxIdleTime;
    var() float MinFireTime;
    var() float MaxFireTime;

    structdefaultproperties
    {
        MinIdleTime=0.0000000
        MaxIdleTime=0.0000000
        MinFireTime=0.0000000
        MaxFireTime=0.0000000
    }
};

var() array< class<DamageType> > MyDamageTypes;
var() bool bUseFiringSounds;
var bool bStopFiring;
var() bool bEnabled;
var() bool bLockRotation;
var() SoundCue fireSoundCue;
var export editinline AudioComponent fireSoundAudioComponent;
var() SoundCue rapportSoundCue;
var export editinline AudioComponent rapportSoundAudioComponent;
var() SoundCue explodeSoundCue;
var export editinline AudioComponent explodeAudioComponent;
var SkelControlSingleBone BaseYawControl;
var SkelControlSingleBone BarrelPitchControl;
var() export editinline SkeletalMeshComponent AAGunMesh;
var() export editinline PrimitiveComponent AADestroyedMesh;
var AAGunEmitter TracerEmitter;
var() ParticleSystem TracerTemplate;
var AAGunEmitter MuzzleFlashEmitter;
var() ParticleSystem MuzzleFlashTemplate;
var Emitter ExplosionEmitter;
var() ParticleSystem ExplosionTemplate;
var Pawn OIRPawn;
var(oir) AnimSet OIRAnimSet;
var(oir) AnimTree OIRAnimTree;
var export editinline SpawnInOIRImpl SImpl;
var() FireTiming InAirFireTiming;
var() FireTiming OnGroundFireTiming;
var FireTiming CurrentFireTiming;
var() Rotator CurrentRotation;
var float OffsetAngle;
var float YawDirection;
var float PitchDirection;
var() float MinYawSpeed;
var() float MaxYawSpeed;
var float YawSpeed;
var() float MinPitchSpeed;
var() float MaxPitchSpeed;
var float PitchSpeed;
var() float JumpTimerMin;
var() float JumpTimerMax;
var Vector MountOffset;
var() float Health;
var MOHADemoChargeCSA DemoChargeCSA;
var() name DemoChargeSocket;
var name TracerSocket;
var name MuzzleFlashSocket;
var name IdleAnimationName;
var name FireAnimationName;
var float FireAnimationTime;

simulated function BeginOnGround()
{
    CurrentFireTiming = OnGroundFireTiming;
    //return;    
}

simulated function PostBeginPlay()
{
    CurrentFireTiming = InAirFireTiming;
    SetTimer(RandRange(JumpTimerMin, JumpTimerMax), true, 'BeginOnGround');
    // End:0x56
    if(AADestroyedMesh != none)
    {
        AADestroyedMesh.SetHidden(true);
        AADestroyedMesh.SetActorCollision(false, false);
    }
    // End:0xBC
    if((DemoChargeCSA == none) && DemoChargeSocket != 'None')
    {
        DemoChargeCSA = __NFUN_278__(Class'MOHADemoChargeCSA');
        DemoChargeCSA.AttachToParent(self, AAGunMesh, DemoChargeSocket);
        DemoChargeCSA.SetEnabled(false);
    }
    SImpl.Init(self);
    MuzzleFlashEmitter = __NFUN_278__(Class'AAGunEmitter', self);
    MuzzleFlashEmitter.SetTemplate(MuzzleFlashTemplate);
    MuzzleFlashEmitter.LifeSpan = 0.0000000;
    MuzzleFlashEmitter.ParticleSystemComponent.DeactivateSystem();
    explodeAudioComponent = self.CreateAudioComponent(explodeSoundCue, false, false);
    explodeAudioComponent.bUseOwnerLocation = true;
    explodeAudioComponent.bAutoDestroy = true;
    explodeAudioComponent.bFinished = true;
    BaseYawControl = SkelControlSingleBone(AAGunMesh.FindSkelControl('BaseYawControl'));
    // End:0x1F7
    if(BaseYawControl != none)
    {
        BaseYawControl.ControlStrength = 1.0000000;
        BaseYawControl.SetSkelControlActive(!bLockRotation);
        BaseYawControl.BoneRotation.Yaw = CurrentRotation.Yaw;
    }
    BarrelPitchControl = SkelControlSingleBone(AAGunMesh.FindSkelControl('BarrelPitchControl'));
    // End:0x271
    if(BarrelPitchControl != none)
    {
        BarrelPitchControl.ControlStrength = 1.0000000;
        BarrelPitchControl.SetSkelControlActive(true);
        BarrelPitchControl.BoneRotation.Roll = CurrentRotation.Pitch;
    }
    //return;    
}

event StartFiring()
{
    bEnabled = true;
    GotoState('Firing');
    //return;    
}

event StopFiring()
{
    bStopFiring = true;
    //return;    
}

event DisableWeapon()
{
    bEnabled = false;
    GotoState('Disabled');
    //return;    
}

function DoneFiring()
{
    //return;    
}

function TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    // End:0x11
    if(Health <= float(0))
    {
        return;
    }
    // End:0x35
    if(!Class'MOHAUtilities'.static.MatchingDamageType(MyDamageTypes, DamageType))
    {
        return;
    }
    // End:0x50
    if(!InstigatedBy.IsA('MOHAPlayerController'))
    {
        return;
    }
    super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    Health -= float(Damage);
    // End:0xB6
    if(Health <= float(0))
    {
        CreateExplosion(HitLocation, DamageType);
        GotoState('Dead');
    }
    //return;    
}

function CreateExplosion(Vector ExplosionLocation, class<DamageType> DamageType)
{
    local Rotator ExplosionRotation;

    // End:0x73
    if(!ClassIsChildOf(DamageType, Class'MOHACompBDamageType') && ExplosionTemplate != none)
    {
        ExplosionEmitter = __NFUN_278__(Class'MOHAExplodeEmitter', self,, ExplosionLocation, ExplosionRotation);
        // End:0x73
        if(ExplosionEmitter != none)
        {
            ExplosionEmitter.LifeSpan = 5.0000000;
            ExplosionEmitter.SetTemplate(ExplosionTemplate, true);
        }
    }
    fireSoundAudioComponent.Stop();
    rapportSoundAudioComponent.Stop();
    explodeAudioComponent.Location = Location;
    explodeAudioComponent.Play();
    //return;    
}

function CheckPawnDied()
{
    // End:0x36
    if((OIRPawn != none) && float(OIRPawn.Health) <= 0.0000000)
    {
        NPCLeavingOIR(OIRPawn);
    }
    //return;    
}

function OnSetFinalState(SeqAct_SetFinalState inAction)
{
    GotoState('Final');
    //return;    
}

function PlayIdleAnimation()
{
    // End:0x4E
    if((MOHASkeletalMeshComponent(AAGunMesh) != none) && IdleAnimationName != 'None')
    {
        MOHASkeletalMeshComponent(AAGunMesh).PlayAnimAtRate(IdleAnimationName, 1.0000000, 0.0000000, true, false);
    }
    //return;    
}

function PlayFireAnimation()
{
    // End:0x62
    if((MOHASkeletalMeshComponent(AAGunMesh) != none) && FireAnimationName != 'None')
    {
        MOHASkeletalMeshComponent(AAGunMesh).PlayAnimAtRate(FireAnimationName, 1.0000000, 0.0000000, true, false);
        SetTimer(FireAnimationTime, true, 'DoneFiring');
    }
    //return;    
}

simulated function UpdateEmitterPosAndRot(out AAGunEmitter GunEmitter, name EmitterSocket)
{
    local Vector vPos;
    local Rotator rRot;

    // End:0x39
    if(!AAGunMesh.GetSocketWorldLocationAndRotation(EmitterSocket, vPos, rRot))
    {
        vPos = Location;
        rRot = Rotation;
    }
    // End:0x66
    if(GunEmitter != none)
    {
        GunEmitter.SetLocation(vPos);
        GunEmitter.SetRotation(rRot);
    }
    //return;    
}

function OnMuzzleFlash()
{
    UpdateEmitterPosAndRot(MuzzleFlashEmitter, MuzzleFlashSocket);
    MuzzleFlashEmitter.ParticleSystemComponent.ActivateSystem();
    //return;    
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0x13
    if(GetStateName() == 'Final')
    {
        return;
    }
    // End:0x3E
    if(Action.InputLinks[0].bHasImpulse)
    {
        StartFiring();        
    }
    else
    {
        // End:0x69
        if(Action.InputLinks[1].bHasImpulse)
        {
            DisableWeapon();            
        }
        else
        {
            // End:0xB0
            if(Action.InputLinks[2].bHasImpulse)
            {
                // End:0xA6
                if(GetStateName() == 'Disabled')
                {
                    StartFiring();                    
                }
                else
                {
                    DisableWeapon();
                }
            }
        }
    }
    //return;    
}

function SetOIRData(out OIRData oir)
{
    AAGunMesh.GetSocketWorldLocationAndRotation('oirAttach', oir.OIRPosition, oir.OIRRotation);
    oir.OIRAnimSet = OIRAnimSet;
    oir.OIRAnimTree = OIRAnimTree;
    oir.OIRCollideWorldRadius = 10.0000000;
    //return;    
}

function SetAttachData(out Actor out_Actor, optional out SkeletalMeshComponent out_SkelMesh, optional out name out_AttachName)
{
    out_Actor = self;
    out_SkelMesh = AAGunMesh;
    out_AttachName = 'oirAttach';
    //return;    
}

function name GetActivityPose(name InName)
{
    return 'None';
    //return ReturnValue;    
}

function name GetInitialActivity()
{
    return 'Idle';
    //return ReturnValue;    
}

function class<AxonBrainState> GetSpawnTransplantBrain()
{
    return Class'AAGunBrainState';
    //return ReturnValue;    
}

function Actor SpawnOIRPawn(class<Pawn> PawnClass)
{
    local MOHAAIPawn AIPawn;

    SImpl.GetOIRData();
    OIRPawn = __NFUN_278__(PawnClass, self,, SImpl.oir.OIRPosition, SImpl.oir.OIRRotation);
    AIPawn = MOHAAIPawn(OIRPawn);
    // End:0x81
    if(AIPawn != none)
    {
        AIPawn.bMeshAdj_Enabled = false;
    }
    MOHAAIController(OIRPawn.Controller).ABSS.AddTransplantBrainState(GetSpawnTransplantBrain(), InitBrainState, true);
    return OIRPawn;
    //return ReturnValue;    
}

event NPCLeavingOIR(Pawn P)
{
    DisableWeapon();
    //return;    
}

function InitBrainState(AxonBrainState Abs)
{
    // End:0x3E
    if(OIRBrainState(Abs) != none)
    {
        OIRBrainState(Abs).OIROwningObject = self;
        OIRBrainState(Abs).SImpl = SImpl;
    }
    //return;    
}

simulated function OnSpawnOIRPawn(SeqAct_SpawnOIRPawn Action)
{
    Action.ReportSpawned(SpawnOIRPawn(Action.SpawnOIRPawnClass));
    //return;    
}

simulated function OnExitOIR(SeqAct_ExitOIR Action)
{
    // End:0x55
    if((OIRPawn != none) && KynapseAIController(OIRPawn.Controller) != none)
    {
        KynapseAIController(OIRPawn.Controller).ABSS.TripNamedScriptEvent('DismountGun');
    }
    //return;    
}

event StreamOutCleanup()
{
    // End:0x17
    if(OIRPawn != none)
    {
        OIRPawn.Destroy();
    }
    // End:0x2E
    if(DemoChargeCSA != none)
    {
        DemoChargeCSA.Destroy();
    }
    // End:0x45
    if(MuzzleFlashEmitter != none)
    {
        MuzzleFlashEmitter.Destroy();
    }
    //return;    
}

function VerifyRespawnCleanup()
{
    PrintRespawnWarning();
    StreamOutCleanup();
    //return;    
}

auto state Idle
{
    function BeginState(name PreviousStateName)
    {
        // End:0x1C
        if(!bEnabled)
        {
            GotoState('Disabled');            
        }
        else
        {
            SetTimer(RandRange(CurrentFireTiming.MinIdleTime, CurrentFireTiming.MaxIdleTime), false, 'StartFiring');
            PlayIdleAnimation();
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('StartFiring');
        //return;        
    }
    stop;    
}

state Firing
{
    function BeginState(name PreviousStateName)
    {
        SetTimer(RandRange(CurrentFireTiming.MinFireTime, CurrentFireTiming.MaxFireTime), false, 'StopFiring');
        PlayFireAnimation();
        TriggerEventClass(Class'SeqEvent_ArtilleryWeaponFired', self);
        //return;        
    }

    function DoneFiring()
    {
        // End:0x1F
        if(bStopFiring)
        {
            bStopFiring = false;
            GotoState('Idle');
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('StopFiring');
        // End:0x33
        if(MuzzleFlashEmitter != none)
        {
            MuzzleFlashEmitter.ParticleSystemComponent.DeactivateSystem();
        }
        //return;        
    }
    stop;    
}

state Dead
{
    function BeginState(name PreviousStateName)
    {
        TriggerEventClass(Class'Engine.SeqEvent_Death', self);
        GotoState('Final');
        //return;        
    }
    stop;    
}

state Final
{
    event StartFiring()
    {
        //return;        
    }

    event StopFiring()
    {
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        ClearTimer('StartFiring');
        ClearTimer('StopFiring');
        // End:0x3B
        if(AAGunMesh != none)
        {
            AAGunMesh.SetHidden(true);
        }
        // End:0x67
        if(AADestroyedMesh != none)
        {
            AADestroyedMesh.SetHidden(false);
            AADestroyedMesh.SetActorCollision(true, true);
        }
        // End:0x92
        if(DemoChargeCSA != none)
        {
            DemoChargeCSA.SetEnabled(false);
            DemoChargeCSA.Destroy();
        }
        //return;        
    }
    stop;    
}

state Disabled
{
    function BeginState(name PreviousStateName)
    {
        // End:0x1F
        if(DemoChargeCSA != none)
        {
            DemoChargeCSA.SetEnabled(true);
        }
        ClearTimer('StartFiring');
        ClearTimer('StopFiring');
        fireSoundAudioComponent.Stop();
        rapportSoundAudioComponent.Stop();
        PlayIdleAnimation();
        //return;        
    }
    stop;    
}

defaultproperties
{
    MyDamageTypes[0]=Class'MOHACompBDamageType'
    MyDamageTypes[1]=Class'MOHAGammonGrenadeDamageType'
    MyDamageTypes[2]=Class'MOHAPanzerschreckDamageType'
    MyDamageTypes[3]=Class'MOHAM18RecoillessRifleDamageType'
    bEnabled=true
    // Reference: SpawnInOIRImpl'Default__MOHAHeavyArtilleryWeapon.SImpl0'
    begin object name=SImpl0 class=Class'SpawnInOIRImpl'
    end object
    SImpl=SImpl0
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAHeavyArtilleryWeapon.MyLightEnvironment'
    begin object name=MyLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
    end object
    Components[0]=MyLightEnvironment
    ActorType=9
    UniversalLODMethod=6
    bTakesRadiusDamage=true
    bCollideActors=true
    bCollideWorld=true
    bBlockActors=true
    CollisionType=0
    UniversalLOD_MaximumDeltaTime=2.0000000
    SupportedEvents=/* Array type was not detected. */
}