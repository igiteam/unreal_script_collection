class SPRocketLauncherPersistent extends SPWeapon
    abstract
    native
    config(Game);

var SPRocketPersistent Rocket;
var SPWeaponLockOn m_lock;
var Actor LockedTarget;
var SoundCue RocketFirePlayerCue;
var float BlinkTime;
var bool BlinkToggle;
var bool bLockRequestChanged;
var bool bLockTargetChanged;
var bool bLockOnChanged;
var Vector MyFirePos;
var Rotator MyFireRotation;
var Material LockOnMaterial;
var MaterialInstanceConstant LockOnMaterialInstance;
var MaterialInterface AimDownSightMaterial;
var MaterialInstanceConstant AimDownSightMaterialInstance;
var float LockOnSpriteScreenSize;

function DBG_Msg(string Str)
{
    local PlayerController PC;

    // End:0x7A
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x79
        if(PC.Pawn != none)
        {
            // End:0x79
            if(PC.myHUD != none)
            {
                PC.myHUD.Message(PC.PlayerReplicationInfo, Str, 'None');
            }
        }        
    }    
    //return;    
}

function PlayTargetLockSound()
{
    //return;    
}

function PlayTargetPaintSound()
{
    //return;    
}

function StopTargetLockSound()
{
    //return;    
}

function StopTargetPaintSound()
{
    //return;    
}

function StopAllTargetLockSounds()
{
    //return;    
}

simulated function bool HideReticleInAds()
{
    // End:0x31
    if(m_lock.m_requested && m_lock.m_target != none)
    {
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

simulated function CleanupPreMapChange()
{
    super.CleanupPreMapChange();
    Class'SPWeapon'.static.ReleaseLock(m_lock, WorldInfo.TimeSeconds);
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    StopADSEffects();
    StopPaintEffects();
    StopLockedEffects();
    SetUpMaterials();
    //return;    
}

simulated function SetUpMaterials()
{
    local editinline SPSkeletalMeshComponent SkeletalMeshComp;
    local SkeletalMesh SkeletalMesh;
    local MaterialInterface MaterialInterface;
    local int Idx;

    // End:0x41
    if((LockOnMaterial != none) && LockOnMaterialInstance == none)
    {
        LockOnMaterialInstance = new (none) Class'Engine.MaterialInstanceConstant';
        LockOnMaterialInstance.SetParent(LockOnMaterial);
    }
    // End:0x13F
    if(AimDownSightMaterialInstance == none)
    {
        SkeletalMeshComp = SPSkeletalMeshComponent(Mesh);
        // End:0x7C
        if(SkeletalMeshComp != none)
        {
            SkeletalMesh = SkeletalMeshComp.SkeletalMesh;
        }
        // End:0x13F
        if(SkeletalMesh != none)
        {
            Idx = 0;
            J0x8E:

            // End:0x13F [Loop If]
            if(Idx < SkeletalMesh.Materials.Length)
            {
                MaterialInterface = SkeletalMesh.Materials[Idx];
                // End:0x135
                if(MaterialInterface.Name == 'RocketLauncher_mat')
                {
                    AimDownSightMaterial = MaterialInterface;
                    AimDownSightMaterialInstance = new (none) Class'Engine.MaterialInstanceConstant';
                    AimDownSightMaterialInstance.SetParent(AimDownSightMaterial);
                    SkeletalMeshComp.SetMaterial(Idx, AimDownSightMaterialInstance);
                    // [Explicit Break]
                    goto J0x13F;
                }
                Idx++;
                // [Loop Continue]
                goto J0x8E;
            }
        }
    }
    J0x13F:

    //return;    
}

simulated function Projectile SPProjectileFire(bool bUseFakeFire)
{
    // End:0x2C
    if(Rocket != none)
    {
        // End:0x2C
        if(!m_bUsingUnlimitedAmmo)
        {
            Rocket.ClientExplode();
            return none;
        }
    }
    Rocket = SPRocketPersistent(super.SPProjectileFire(false));
    ServerOnlyPostProjectileFire();
    CreateAudioComponent(RocketFirePlayerCue, true, true);
    return Rocket;
    //return ReturnValue;    
}

simulated function GetGuidance(out SPRocketGuidance guidance)
{
    guidance.Mode = 1;
    //return;    
}

function TryLock()
{
    local Vector Direction, StartTrace, EndTrace;

    // End:0x14
    if(!IsInState('Active'))
    {
        return;
    }
    StartTrace = Instigator.GetWeaponStartTraceLocation();
    EndTrace = StartTrace + (Vector(Instigator.GetAdjustedAimFor(self, StartTrace)) * (GetTraceRange()));
    Direction = Normal(EndTrace - StartTrace);
    AttemptLock(StartTrace, Direction, m_lock, WorldInfo.TimeSeconds);
    //return;    
}

function UpdateGuidance()
{
    local Pawn myPawn;

    myPawn = Pawn(Owner);
    // End:0x52
    if(myPawn != none)
    {
        MyFirePos = myPawn.GetPawnViewLocation();
        MyFireRotation = myPawn.GetViewRotation();        
    }
    else
    {
        MyFirePos = Location;
        MyFireRotation = Rotation;
    }
    // End:0x8A
    if(!IsActiveWeapon())
    {
        m_lock.m_requested = false;
    }
    m_lock.m_owner = Owner;
    // End:0xF9
    if(!m_lock.m_requested)
    {
        // End:0xF4
        if(m_lock.m_target != none)
        {
            Class'SPWeapon'.static.ReleaseLock(m_lock, WorldInfo.TimeSeconds);
        }
        return;        
    }
    else
    {
        m_lock.m_isAllowedToLock = Rocket == none;
        TryLock();
        UpdateRocketTarget(m_lock.m_target);
    }
    //return;    
}

function StartLockedEffects()
{
    PlayTargetLockSound();
    // End:0x59
    if(LockOnMaterialInstance != none)
    {
        LockOnMaterialInstance.SetScalarParameterValue('Rocket_Lock_on', 1.0000000);
        LockOnMaterialInstance.SetScalarParameterValue('Rocket_Active', 0.0000000);
    }
    // End:0xA8
    if(AimDownSightMaterialInstance != none)
    {
        AimDownSightMaterialInstance.SetScalarParameterValue('tracking', 1.0000000);
        AimDownSightMaterialInstance.SetScalarParameterValue('Locked', 1.0000000);
    }
    //return;    
}

function StopLockedEffects()
{
    StopTargetLockSound();
    // End:0x59
    if(LockOnMaterialInstance != none)
    {
        LockOnMaterialInstance.SetScalarParameterValue('Rocket_Lock_on', 0.0000000);
        LockOnMaterialInstance.SetScalarParameterValue('Rocket_Active', 0.0000000);
    }
    // End:0xA8
    if(AimDownSightMaterialInstance != none)
    {
        AimDownSightMaterialInstance.SetScalarParameterValue('tracking', 0.0000000);
        AimDownSightMaterialInstance.SetScalarParameterValue('Locked', 0.0000000);
    }
    //return;    
}

function StartPaintEffects()
{
    PlayTargetPaintSound();
    // End:0x59
    if(LockOnMaterialInstance != none)
    {
        LockOnMaterialInstance.SetScalarParameterValue('Rocket_Lock_on', 0.0000000);
        LockOnMaterialInstance.SetScalarParameterValue('Rocket_Active', 1.0000000);
    }
    // End:0xA8
    if(AimDownSightMaterialInstance != none)
    {
        AimDownSightMaterialInstance.SetScalarParameterValue('tracking', 1.0000000);
        AimDownSightMaterialInstance.SetScalarParameterValue('Locked', 0.0000000);
    }
    //return;    
}

function StopPaintEffects()
{
    StopTargetPaintSound();
    // End:0x59
    if(LockOnMaterialInstance != none)
    {
        LockOnMaterialInstance.SetScalarParameterValue('Rocket_Lock_on', 0.0000000);
        LockOnMaterialInstance.SetScalarParameterValue('Rocket_Active', 0.0000000);
    }
    // End:0xA8
    if(AimDownSightMaterialInstance != none)
    {
        AimDownSightMaterialInstance.SetScalarParameterValue('tracking', 0.0000000);
        AimDownSightMaterialInstance.SetScalarParameterValue('Locked', 0.0000000);
    }
    //return;    
}

function StartADSEffects()
{
    // End:0x2D
    if(AimDownSightMaterialInstance != none)
    {
        AimDownSightMaterialInstance.SetScalarParameterValue('ADS_Activated', 1.0000000);
    }
    //return;    
}

function StopADSEffects()
{
    // End:0x2D
    if(AimDownSightMaterialInstance != none)
    {
        AimDownSightMaterialInstance.SetScalarParameterValue('ADS_Activated', 0.0000000);
    }
    //return;    
}

function UpdateLockOnEffects()
{
    // End:0xE2
    if(m_lock.m_requested)
    {
        // End:0x32
        if(m_lock.m_bChangedRequested)
        {
            StartADSEffects();
        }
        // End:0x9E
        if(m_lock.m_bChangedLock)
        {
            // End:0x71
            if(m_lock.m_bLocked)
            {
                StopPaintEffects();
                StartLockedEffects();                
            }
            else
            {
                StopLockedEffects();
                // End:0x9B
                if(m_lock.m_target != none)
                {
                    StartPaintEffects();
                }
            }            
        }
        else
        {
            // End:0xDF
            if(m_lock.m_bChangedTarget)
            {
                // End:0xD5
                if(m_lock.m_target == none)
                {
                    StopPaintEffects();                    
                }
                else
                {
                    StartPaintEffects();
                }
            }
        }        
    }
    else
    {
        // End:0x114
        if(m_lock.m_bChangedRequested)
        {
            StopLockedEffects();
            StopPaintEffects();
            StopADSEffects();
        }
    }
    //return;    
}

simulated function Tick(float DeltaTime)
{
    // End:0x38
    if(!bIsNPCWeapon)
    {
        UpdateGuidance();
        Class'SPWeapon'.static.UpdateStateChanges(m_lock);
        UpdateLockOnEffects();
    }
    super.Tick(DeltaTime);
    //return;    
}

function UpdateRocketTarget(Actor Target)
{
    // End:0x62
    if((Rocket != none) && LockedTarget != m_lock.m_target)
    {
        LockedTarget = m_lock.m_target;
        // End:0x62
        if(Rocket != none)
        {
            Rocket.SetHomingTarget(LockedTarget, false);
        }
    }
    //return;    
}

function ServerOnlyPostProjectileFire()
{
    Rocket.SetRocketLauncher(self);
    // End:0x131
    if((Pawn(Owner) != none) && Pawn(Owner).IsA('SPBulletGeneratorPawnPersistent'))
    {
        // End:0x118
        if((Pawn(Owner).Controller != none) && Pawn(Owner).Controller.Target != none)
        {
            // End:0xC3
            if(m_bRocketsHomingForGenerators)
            {
                Rocket.SetHomingTarget(Pawn(Owner).Controller.Target, true);                
            }
            else
            {
                Rocket.SetRocketRotationFromGenerator(Pawn(Owner).Controller.Target.Location);
                Rocket.SetHomingTarget(none, true);
            }            
        }
        else
        {
            Rocket.SetHomingTarget(none, true);
        }        
    }
    else
    {
        Rocket.SetHomingTarget(m_lock.m_target, false);
    }
    // End:0x199
    if(m_lock.m_bLocked)
    {
        Rocket = none;
        Class'SPWeapon'.static.ReleaseLock(m_lock, WorldInfo.TimeSeconds);
    }
    //return;    
}

simulated function AttachWeapon(SkeletalMeshComponent parentMesh, name BoneName)
{
    super.AttachWeapon(parentMesh, BoneName);
    //return;    
}

simulated function CustomFire()
{
    //return;    
}

simulated function RocketExploded()
{
    Rocket = none;
    m_bExplosionEnabled = false;
    //return;    
}

simulated function bool StillFiring(byte FireMode)
{
    // End:0x39
    if(int(FireMode) == int(0))
    {
        // End:0x39
        if((Rocket != none) && !m_bUsingUnlimitedAmmo)
        {
            ClearPendingFire(int(FireMode));
        }
    }
    // End:0x65
    if(int(FireMode) == int(1))
    {
        // End:0x65
        if(Rocket == none)
        {
            ClearPendingFire(int(FireMode));
        }
    }
    return super(Weapon).StillFiring(FireMode);
    //return ReturnValue;    
}

function bool NotReadyToFire(byte FireModeNum)
{
    // End:0x12
    if(PlayerPawn(Owner) == none)
    {
        return false;
    }
    // End:0x3C
    if(int(FireModeNum) == int(0))
    {
        // End:0x3C
        if((Rocket != none) && !m_bUsingUnlimitedAmmo)
        {
            return true;
        }
    }
    // End:0x59
    if(int(FireModeNum) == int(1))
    {
        // End:0x59
        if(Rocket == none)
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function ConsumeAmmo(byte FireModeNum, optional int ammount)
{
    // End:0x25
    if((int(FireModeNum) == int(0)) && !m_bUsingUnlimitedAmmo)
    {
        ammoInMagazine--;
    }
    //return;    
}

function TriggerExplosionEnabled()
{
    m_bExplosionEnabled = true;
    //return;    
}

function ExplodeRocketFromTrigger()
{
    // End:0x22
    if(Rocket != none)
    {
        Rocket.ClientExplode();        
    }
    //return;    
}

simulated function DrawLockonOverlays(HUD H)
{
    local Vector screenCoord;
    local Box boundBox;
    local Vector actorLocation;

    // End:0x0D
    if(H == none)
    {
        return;
    }
    // End:0x1A2
    if(LockOnMaterialInstance != none)
    {
        // End:0xA5
        if(m_lock.m_target != none)
        {
            m_lock.m_target.GetComponentsBoundingBox(boundBox);
            actorLocation = (boundBox.Min + boundBox.Max) * 0.5000000;
            screenCoord = H.Canvas.Project(actorLocation);            
        }
        else
        {
            screenCoord.X = float(H.Canvas.SizeX) * 0.5000000;
            screenCoord.Y = float(H.Canvas.SizeY) * 0.5000000;
            screenCoord.Z = 0.0000000;
        }
        H.Canvas.SetPos(screenCoord.X - (LockOnSpriteScreenSize / float(2)), screenCoord.Y - (LockOnSpriteScreenSize / float(2)));
        H.Canvas.DrawMaterialTile(LockOnMaterialInstance, LockOnSpriteScreenSize, LockOnSpriteScreenSize);
    }
    //return;    
}

simulated function ActiveRenderOverlays(HUD H)
{
    super.ActiveRenderOverlays(H);
    DrawLockonOverlays(H);
    //return;    
}

simulated state WeaponFiring
{
    simulated function BeginState(name PreviousStateName)
    {
        // End:0x1A
        if(int(CurrentFireMode) == int(1))
        {
            FireAmmunition();
        }
        // End:0x40
        if(!m_bUsingUnlimitedAmmo)
        {
            m_bExplosionEnabled = false;
            SetTimer(0.2500000, false, 'TriggerExplosionEnabled');
        }
        super.BeginState(PreviousStateName);
        //return;        
    }
    stop;    
}
