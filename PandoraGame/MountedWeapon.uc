class MountedWeapon extends SkeletalMeshActor
    abstract
    native;

const MAX_TIME_BETWEEN_SHOTS = 0.1;

var() SoundCue Sound_BeginFire;
var() SoundCue Sound_Fire;
var() SoundCue Sound_EndFire;
var() SoundCue Sound_WeaponEmpty;
var() float WeaponRange;
var export editinline PointLightComponent MuzzleLight;
var class<Projectile> BulletProjectileClass;
var export editinline AudioComponent Sound_Looping;
var bool Firing;
var bool ForcedFire;
var name FireAnimation;
var Actor Target;
var Rotator WeaponRotation;
var float timeBetweenShots;
/** Normal weapon damage (propagates to projectile) */
var() float Damage;
/** Allows designer specified damage modifiers based on the bullet hitting a particular class (Note: Must be using an SPBulletPersistent for this functionality) */
var() array<DmgModEntry> DmgTable;
var SPEmitter BulletParticles;
var ParticleSystem BulletParticleTemplate_First;
var ParticleSystem BulletParticleTemplate_Third;
var ParticleSystem BulletParticleTemplate;
var class<SPShellCasingPersistent> ShellCasingClass;
var(YawControl) float MinYaw;
var(YawControl) float MaxYaw;
var(PitchControl) float MinPitch;
var(PitchControl) float maxPitch;

// Export UMountedWeapon::execAttachPlayer(FFrame&, void* const)
native function bool AttachPlayer(Actor Player);

// Export UMountedWeapon::execDetachPlayer(FFrame&, void* const)
native function bool DetachPlayer(Actor Player);

function SwitchTracerMode(bool bFirstPerson)
{
    // End:0x17
    if(bFirstPerson)
    {
        BulletParticleTemplate = BulletParticleTemplate_First;        
    }
    else
    {
        BulletParticleTemplate = BulletParticleTemplate_Third;
    }
    //return;    
}

function Tick(float Time)
{
    super(Actor).Tick(Time);
    // End:0xAC
    if(ForcedFire)
    {
        // End:0x38
        if((Target == none) || Firing == false)
        {
            ForcedFire = false;            
        }
        else
        {
            // End:0x81
            if(Target.bDeleteMe || (Pawn(Target) != none) && Pawn(Target).Health <= 0)
            {
                ForcedFire = false;
            }
        }
        // End:0xAC
        if(!ForcedFire)
        {
            ClearLatentAction(Class'SeqAct_AIStartForceFireAtTarget', true);
            // End:0xAC
            if(Firing)
            {
                StopFire();
            }
        }
    }
    // End:0xE5
    if(Firing)
    {
        timeBetweenShots += Time;
        // End:0xE5
        if(timeBetweenShots > 0.1000000)
        {
            UpdateFiring();
            timeBetweenShots = 0.0000000;
        }
    }
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x2F
    if(MuzzleLight != none)
    {
        SkeletalMeshComponent.AttachComponentToSocket(MuzzleLight, 'flash');
    }
    WeaponRotation = Rotation;
    //return;    
}

function OnMount(SeqAct_Mount Action)
{
    local Actor Player;
    local array<Object> objVars;

    Player = none;
    Action.GetObjectVars(objVars, "Player");
    // End:0x42
    if(objVars.Length > 0)
    {
        Player = Actor(objVars[0]);
    }
    Mount(Player);
    PandoraPlayerController(Player).SetMountedWeapon(self);
    //return;    
}

function OnDismount(SeqAct_Dismount Action)
{
    local Actor Player;
    local array<Object> objVars;

    Player = none;
    Action.GetObjectVars(objVars, "Player");
    // End:0x42
    if(objVars.Length > 0)
    {
        Player = Actor(objVars[0]);
    }
    // End:0x8A
    if(PandoraPlayerController(Player).GetMountedWeapon() != none)
    {
        Dismount(Player);
        PandoraPlayerController(Player).SetMountedWeapon(none);
    }
    //return;    
}

function Mount(Actor Player)
{
    local PandoraPlayerController playerControl;
    local HeliPawnPersistent hPawn;

    Target = none;
    StopFire();
    playerControl = PandoraPlayerController(Player);
    // End:0x10A
    if(playerControl != none)
    {
        Player.SetRotation(SkeletalMeshComponent.Rotation);
        // End:0x78
        if(playerControl.CurrentWeapon != none)
        {
            playerControl.CurrentWeapon.SetHidden(true);
        }
        playerControl.ResetPlayerAim();
        // End:0xFC
        if(playerControl.Pawn != none)
        {
            playerControl.Pawn.SetRotation(SkeletalMeshComponent.Rotation);
            playerControl.HidePlayer(true);
            playerControl.Pawn.StopFire(0);
        }
        SwitchTracerMode(true);        
    }
    else
    {
        SwitchTracerMode(false);
    }
    AttachPlayer(Player);
    // End:0x173
    if(Base != none)
    {
        hPawn = HeliPawnPersistent(Base);
        // End:0x173
        if(hPawn != none)
        {
            hPawn.MountedPlayer = PlayerPawn(PandoraPlayerController(Player).Pawn);
        }
    }
    Instigator = Controller(Player).Pawn;
    SetCollision(false, false);
    //return;    
}

function Vector GetParentVelocity()
{
    // End:0x1E
    if(Base != none)
    {
        return Base.Velocity;        
    }
    else
    {
        return vect(0.0000000, 0.0000000, 0.0000000);
    }
    //return ReturnValue;    
}

function Dismount(Actor Player)
{
    local Rotator Rot;
    local HeliPawnPersistent hPawn;

    DetachPlayer(Player);
    // End:0x46
    if(Base != none)
    {
        hPawn = HeliPawnPersistent(Base);
        // End:0x46
        if(hPawn != none)
        {
            hPawn.MountedPlayer = none;
        }
    }
    Instigator = none;
    SetCollision(true, true);
    Rot = SkeletalMeshComponent.Rotation - SkeletalMeshComponent.SkeletalMesh.RotOrigin;
    Player.SetRotation(Rot);
    PandoraPlayerController(Player).Pawn.SetRotation(Rot);
    PandoraPlayerController(Player).HidePlayer(false);
    StopMWAnim();
    StopFire();
    // End:0x122
    if(Sound_Looping != none)
    {
        Sound_Looping.Stop();
        Sound_Looping = none;
        // End:0x122
        if(Sound_EndFire != none)
        {
            PlaySound(Sound_EndFire);
        }
    }
    //return;    
}

function StartFire()
{
    // End:0x7C
    if(!Firing)
    {
        Firing = true;
        PlayMWAnim();
        StartFiringAmmo();
        Sound_Looping = none;
        // End:0x7C
        if(Sound_BeginFire != none)
        {
            Sound_Looping = CreateAudioComponent(Sound_BeginFire, false, true);
            // End:0x7C
            if(Sound_Looping != none)
            {
                Sound_Looping.bAutoDestroy = true;
                Sound_Looping.Play();
            }
        }
    }
    //return;    
}

function StopFire()
{
    // End:0x13
    if(Firing)
    {
        StopFiringAmmo();
    }
    Firing = false;
    StopMWAnim();
    // End:0x47
    if(Sound_Looping != none)
    {
        Sound_Looping.Stop();
        Sound_Looping = none;
    }
    // End:0x62
    if(Sound_EndFire != none)
    {
        PlaySound(Sound_EndFire);
    }
    //return;    
}

function PlayMWAnim()
{
    local AnimNodeSequence SeqNode;

    SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
    // End:0x5A
    if(SeqNode != none)
    {
        SeqNode.SetAnim(FireAnimation);
        SeqNode.PlayAnim(true, 1.0000000);
    }
    //return;    
}

function StopMWAnim()
{
    local AnimNodeSequence SeqNode;

    SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
    // End:0x39
    if(SeqNode != none)
    {
        SeqNode.StopAnim();
    }
    //return;    
}

function StartFiringAmmo()
{
    local Vector RealStartLoc;
    local Rotator AimRot;

    FireProjectile();
    GetFireStartPosAndAim(RealStartLoc, AimRot);
    // End:0x103
    if((BulletParticleTemplate != none) && SkeletalMeshComponent.GetSocketWorldLocationAndRotation('Fire', RealStartLoc, AimRot))
    {
        BulletParticles = Spawn(Class'SPEmitterSpawnable',,, RealStartLoc, AimRot);
        // End:0x103
        if(BulletParticles != none)
        {
            BulletParticles.SetOwner(self);
            BulletParticles.SetTemplate(BulletParticleTemplate, true);
            BulletParticles.bDestroyOnSystemFinish = true;
            BulletParticles.ParticleSystemComponent.SecondsBeforeInactive = 0.0000000;
            BulletParticles.ParticleSystemComponent.ActivateSystem();
            BulletParticles.bKillDuringLevelTransition = true;
        }
    }
    //return;    
}

function UpdateMuzzleFlash()
{
    // End:0x62
    if(MuzzleLight != none)
    {
        MuzzleLight.SetEnabled(true);
        MuzzleLight.SetLightProperties(1.0000000, MuzzleLight.LightColor, MuzzleLight.Function);
        SetTimer(0.0160000, true, 'FadeMuzzleLight');
    }
    //return;    
}

function UpdateShellCasing()
{
    local Rotator Rot;
    local Vector pos;
    local SPShellCasingPersistent shell;

    // End:0xAC
    if(ShellCasingClass != none)
    {
        SkeletalMeshComponent.GetSocketWorldLocationAndRotation('shell', pos, Rot);
        shell = Spawn(ShellCasingClass,,, pos, Rot);
        // End:0xAC
        if(shell != none)
        {
            shell.Init(Vector(Rot), Vector(Rot), 0.0000000);
            shell.Velocity = shell.Velocity + (GetParentVelocity());
        }
    }
    //return;    
}

function UpdateParticles()
{
    local Vector RealStartLoc;
    local Rotator AimRot;

    GetFireStartPosAndAim(RealStartLoc, AimRot);
    SkeletalMeshComponent.GetSocketWorldLocationAndRotation('Fire', RealStartLoc, AimRot);
    BulletParticles.SetLocation(RealStartLoc);
    BulletParticles.SetRotation(AimRot);
    //return;    
}

function UpdateFiring()
{
    FireProjectile();
    UpdateParticles();
    UpdateMuzzleFlash();
    UpdateShellCasing();
    //return;    
}

function StopFiringAmmo()
{
    BulletParticles.ParticleSystemComponent.DeactivateSystem();
    return;
    //return;    
}

function GetFireStartPosAndAim(out Vector pos, out Rotator Rot)
{
    SkeletalMeshComponent.GetSocketWorldLocationAndRotation('Fire', pos, Rot);
    //return;    
}

function Projectile FireProjectile()
{
    local Vector RealStartLoc;
    local Rotator AimRot;
    local Vector AimDir;
    local Projectile SpawnedProjectile;
    local Actor TheActor;

    GetFireStartPosAndAim(RealStartLoc, AimRot);
    AimDir = Vector(AimRot);
    TheActor = WorldInfo.MyActorPool.GetActorFromPool(GetProjectileClass(), 'None', RealStartLoc, Rotation, none, false, false, self, none, false, 0, false);
    SpawnedProjectile = Projectile(TheActor);
    // End:0x175
    if((SpawnedProjectile != none) && !SpawnedProjectile.bDeleteMe)
    {
        SpawnedProjectile.Init(AimDir);
        SpawnedProjectile.Damage = Damage;
        // End:0x115
        if(SpawnedProjectile.IsA('SPBulletPersistent') && DmgTable.Length > 0)
        {
            SPBulletPersistent(SpawnedProjectile).DIM.DmgTable = DmgTable;
        }
        SpawnedProjectile.Velocity = (AimDir * SpawnedProjectile.Speed) + (GetParentVelocity());
        // End:0x167
        if(Instigator != none)
        {
            SpawnedProjectile.SetOwner(Instigator);            
        }
        else
        {
            SpawnedProjectile.SetOwner(self);
        }
    }
    return SpawnedProjectile;
    //return ReturnValue;    
}

simulated function ImpactInfo CalcWeaponFire(Vector StartTrace, Vector EndTrace, optional out array<ImpactInfo> ImpactList)
{
    local Vector HitLocation, HitNormal;
    local Actor HitActor;
    local TraceHitInfo HitInfo;
    local ImpactInfo CurrentImpact;

    HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true, vect(0.0000000, 0.0000000, 0.0000000), HitInfo,, true);
    // End:0x49
    if(HitActor == none)
    {
        HitLocation = EndTrace;
    }
    CurrentImpact.HitActor = HitActor;
    CurrentImpact.HitLocation = HitLocation;
    CurrentImpact.HitNormal = HitNormal;
    CurrentImpact.RayDir = Normal(HitLocation - StartTrace);
    CurrentImpact.HitInfo = HitInfo;
    ImpactList[ImpactList.Length] = CurrentImpact;
    // End:0x154
    if((HitActor != none) && HitActor.IsA('Trigger') || HitActor.IsA('TriggerVolume'))
    {
        HitActor.bProjTarget = true;
        CurrentImpact = CalcWeaponFire(HitLocation, EndTrace, ImpactList);
        HitActor.bProjTarget = false;
    }
    return CurrentImpact;
    //return ReturnValue;    
}

function FadeMuzzleLight()
{
    local float Brightness;

    // End:0xBA
    if(MuzzleLight != none)
    {
        // End:0x66
        if(MuzzleLight.Brightness > 0.2000000)
        {
            Brightness -= 0.2000000;
            MuzzleLight.SetLightProperties(Brightness, MuzzleLight.LightColor, MuzzleLight.Function);            
        }
        else
        {
            MuzzleLight.SetLightProperties(0.0000000, MuzzleLight.LightColor, MuzzleLight.Function);
            MuzzleLight.SetEnabled(false);
            ClearTimer('FadeMuzzleLight');
        }
    }
    //return;    
}

function class<Projectile> GetProjectileClass()
{
    return BulletProjectileClass;
    //return ReturnValue;    
}

function SetWeaponRotation(Rotator Rot)
{
    WeaponRotation = Rot;
    //return;    
}

function OnAIForceTarget(SeqAct_AIForceTarget Action)
{
    local array<Object> objVars;

    Action.GetObjectVars(objVars, "Thing To Target");
    // End:0x8D
    if(objVars.Length > 0)
    {
        // End:0x63
        if(Controller(objVars[0]) != none)
        {
            Target = Controller(objVars[0]).Pawn;            
        }
        else
        {
            Target = Actor(objVars[0]);
        }
        // End:0x8A
        if(Target != none)
        {
            StartFire();
        }        
    }
    else
    {
        Target = none;
    }
    //return;    
}

function OnAIStartForceFireAtTarget(SeqAct_AIStartForceFireAtTarget Action)
{
    // End:0x94
    if(Target != none)
    {
        // End:0x94
        if(!Target.bDeleteMe || (Pawn(Target) != none) && Pawn(Target).Health <= 0)
        {
            // End:0x82
            if(Action.m_optionalDuration > float(0))
            {
                SetTimer(Action.m_optionalDuration, false, 'StopFire');
            }
            ForcedFire = true;
            StartFire();
        }
    }
    //return;    
}

function OnAIStopForceFireAtTarget(SeqAct_AIStopForceFireAtTarget Action)
{
    StopFire();
    //return;    
}

function OnAIStartForceAimAtTarget(SeqAct_AIStartForceAimAtTarget Action)
{
    //return;    
}

function OnAIStopForceAimAtTarget(SeqAct_AIStopForceAimAtTarget Action)
{
    //return;    
}

function OnSetMountedWeaponFiringArc(SeqAct_SetMountedWeaponFiringArc Action)
{
    MinYaw = Action.MinYaw;
    MaxYaw = Action.MaxYaw;
    MinPitch = Action.MinPitch;
    maxPitch = Action.maxPitch;
    //return;    
}
