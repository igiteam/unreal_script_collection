class EvilProjectile_Base extends UDKProjectile
    abstract
    native
    hidecategories(Navigation);

var repnotify bool bInit;
var transient bool bPendingExplode;
var bool bExploded;
var bool bSuppressSounds;
var bool bImportantAmbientSound;
var bool bAdvanceExplosionEffect;
var bool bSuppressExplosionFX;
var bool bSuppressAllFX;
var bool bWaitForEffects;
var bool bAddVelocityFromInstigator;
var bool bAddOnlyForwardVelocityFromInstigator;
var bool bAttachExplosionToVehicles;
var bool bInWater;
var bool bNotifyControllersAboutExplosion;
var() repnotify float TimeToExplode;
var float ToExplodeTimer;
var SoundCue AmbientSound;
var export editinline AudioComponent AmbientComponent;
var SoundCue ExplosionSound;
var EvilExplosion ExplosionTemplate;
var EvilExplosion ExplosionArchetype;
var EvilExplosion ExplosionWaterArchetype;
var export editinline ParticleSystemComponent ProjEffects;
var ParticleSystem ProjFlightTemplate;
var ParticleSystem ProjExplosionTemplate;
var MaterialInterface ExplosionDecal;
var float DecalWidth;
var float DecalHeight;
var float DurationOfDecal;
var name DecalDissolveParamName;
var float MaxEffectDistance;
var float TossZ;
var float GlobalCheckRadiusTweak;
var class<PointLightComponent> ProjectileLightClass;
var export editinline PointLightComponent ProjectileLight;
var EvilLightActor ProjectileLightArchetype;
var EvilLightActor ProjectileLightActor;
var class<UDKExplosionLight> ExplosionLightClass;
var float MaxExplosionLightDistance;
var() int DamageVSPlayer;
var float DamageVSPlayerDistance;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority)
        TimeToExplode, bInit;

    // Pos:0x011
    if(bNetDirty
        bSuppressAllFX;
}

simulated event CreateProjectileLight()
{
    // End:0x49
    if(WorldInfo.bDropDetail || WorldInfo.IsConsoleBuild())
    {
        return;
    }
    // End:0x83
    if(ProjectileLightArchetype == none)
    {
        ProjectileLight = new (self) ProjectileLightClass;
        AttachComponent(ProjectileLight);
    }
    //return;    
}

simulated event Landed(Vector HitNormal, Actor FloorActor)
{
    HitWall(HitNormal, FloorActor, none);
    //return;    
}

simulated function bool CanSplash()
{
    return false;
    //return ReturnValue;    
}

event PreBeginPlay()
{
    local UTWeaponPawn WeaponPawn;

    // End:0x6C
    if(UTDummyPawn(Instigator) != none)
    {
        RemoteRole = ROLE_None;
        bSuppressSounds = UTDummyPawn(Instigator).FireAction.bSuppressSounds;
    }
    WeaponPawn = UTWeaponPawn(Instigator);
    // End:0xC2
    if(WeaponPawn != none)
    {
        InstigatorBaseVehicle = WeaponPawn.MyVehicle;        
    }
    else
    {
        // End:0x11F
        if((Instigator != none) && Instigator.DrivenVehicle != none)
        {
            InstigatorBaseVehicle = Instigator.DrivenVehicle;
        }
    }
    // End:0x143
    if(DamageVSPlayer == 0)
    {
        DamageVSPlayer = int(Damage);
    }
    super(Projectile).PreBeginPlay();
    //return;    
}

simulated function PostBeginPlay()
{
    bInit = false;
    // End:0xEE
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x43
        if(!bWideCheck)
        {
            CheckRadius *= GlobalCheckRadiusTweak;
        }
        bWideCheck = bWideCheck || (((CheckRadius > float(0)) && Instigator != none) && UTPlayerController(Instigator.Controller) != none) && UTPlayerController(Instigator.Controller).AimingHelp(false);
    }
    super(Projectile).PostBeginPlay();
    // End:0x116
    if(bDeleteMe || bShuttingDown)
    {
        return;
    }
    // End:0x212
    if(((AmbientSound != none) && int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && !bSuppressSounds)
    {
        // End:0x212
        if(bImportantAmbientSound || !WorldInfo.bDropDetail && int(WorldInfo.GetDetailMode()) != int(0))
        {
            AmbientComponent = CreateAudioComponent(AmbientSound, true, true);
            // End:0x212
            if(AmbientComponent != none)
            {
                AmbientComponent.bShouldRemainActiveIfDropped = true;
            }
        }
    }
    SpawnFlightEffects();
    // End:0x265
    if(WorldInfo.IsConsoleBuild(3))
    {
        LifeSpan = FMin(LifeSpan, 0.5000000 * default.LifeSpan);
    }
    //return;    
}

simulated event SetInitialState()
{
    bScriptInitialized = true;
    // End:0x46
    if((int(Role) < int(ROLE_Authority)) && AccelRate != 0.0000000)
    {
        GotoState('WaitingForVelocity');        
    }
    else
    {
        GotoState(((InitialState != 'None') ? InitialState : 'Auto'));
    }
    //return;    
}

function Init(Vector Direction)
{
    local Vector X, Y, Z;
    local Vector2D DotDist;

    SetRotation(Rotator(Direction));
    Velocity = Speed * Direction;
    Velocity.Z += TossZ;
    Acceleration = AccelRate * Normal(Velocity);
    // End:0x1AA
    if(bAddVelocityFromInstigator && Instigator != none)
    {
        // End:0x181
        if(bAddOnlyForwardVelocityFromInstigator)
        {
            GetAxes(Instigator.GetBaseAimRotation(), X, Y, Z);
            // End:0x17E
            if(GetDotDistance(DotDist, Normal(Instigator.Velocity), X, Y, Z) && Abs(DotDist.X) >= 0.5000000)
            {
                Velocity += Instigator.Velocity;
            }            
        }
        else
        {
            Velocity += Instigator.Velocity;
        }
    }
    ToExplodeTimer = TimeToExplode;
    bInit = true;
    RepInit();
    //return;    
}

simulated function RepInit()
{
    local Controller C;

    // End:0xBA
    foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
    {
        // End:0x78
        if(EvilPlayerController(C) != none)
        {
            EvilPlayerController(C).NotifyProjectileFire(self);
            // End:0xB9
            continue;
        }
        // End:0xB9
        if(EvilAIController(C) != none)
        {
            EvilAIController(C).NotifyProjectileFire(self);
        }        
    }    
    //return;    
}

simulated function Tick(float DeltaTime)
{
    local Controller C;

    super(Actor).Tick(DeltaTime);
    // End:0x122
    if((bInit && ToExplodeTimer > float(0)) && !bExploded)
    {
        ToExplodeTimer -= DeltaTime;
        // End:0xF1
        if((ToExplodeTimer < 1.0000000) || VSizeSq(Velocity) < 256.0000000)
        {
            // End:0xF1
            if(bNotifyControllersAboutExplosion)
            {
                // End:0xE4
                foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
                {
                    C.WarnProjExplode(self);                    
                }                
                bNotifyControllersAboutExplosion = false;
            }
        }
        // End:0x122
        if(ToExplodeTimer <= float(0))
        {
            Explode(Location, vect(0.0000000, 0.0000000, 1.0000000));
        }
    }
    //return;    
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    local TraceHitInfo THitInfo;

    // End:0x9C
    if((EvilPawn(Other) != none) && EvilPawn(Other).CanPlayDirectHitByProjectile())
    {
        EvilPawn(Other).DirectHitByProjectile();
        // End:0x9C
        if(!EvilPawn(Other).bBlockActors)
        {
            return;
        }
    }
    // End:0xCC
    if(ExplosionArchetype != none)
    {
        Explode(HitLocation, HitNormal);
        return;        
    }
    else
    {
        // End:0x29A
        if(Damage > float(0))
        {
            Trace(HitLocation, HitNormal, HitLocation + Velocity, HitLocation, true, vect(0.0000000, 0.0000000, 0.0000000), THitInfo);
            // End:0x19A
            if(EvilWeap_Base(Instigator.Weapon) != none)
            {
                EvilWeap_Base(Instigator.Weapon).CheckAndUpdateHitEnemyIndicator(Other);
            }
            // End:0x229
            if(NotEqual_InterfaceInterface(EvilPlayer_interface(Other), EvilPlayer_interface(none)))
            {
                Other.TakeDamage(DamageVSPlayer, InstigatorController, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType, THitInfo, self);                
            }
            else
            {
                Other.TakeDamage(int(Damage), InstigatorController, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType, THitInfo, self);
            }
            bSuppressExplosionFX = true;
        }
        ShutDown();
    }
    //return;    
}

singular simulated event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    local KActorFromStatic NewKActor;
    local editinline StaticMeshComponent HitStaticMesh;

    super(Actor).HitWall(HitNormal, Wall, WallComp);
    // End:0xEA
    if(Wall.bWorldGeometry)
    {
        HitStaticMesh = StaticMeshComponent(WallComp);
        // End:0xEA
        if((HitStaticMesh != none) && HitStaticMesh.CanBecomeDynamic())
        {
            NewKActor = Class'Engine.KActorFromStatic'.static.MakeDynamic(HitStaticMesh);
            // End:0xEA
            if(NewKActor != none)
            {
                Wall = NewKActor;
            }
        }
    }
    ImpactedActor = Wall;
    // End:0x138
    if(ExplosionArchetype != none)
    {
        Explode(Location, HitNormal);
        ImpactedActor = none;
        return;        
    }
    else
    {
        // End:0x2D2
        if(!Wall.bStatic && Damage > float(0))
        {
            // End:0x1E2
            if(EvilWeap_Base(Instigator.Weapon) != none)
            {
                EvilWeap_Base(Instigator.Weapon).CheckAndUpdateHitEnemyIndicator(Wall);
            }
            // End:0x269
            if(NotEqual_InterfaceInterface(EvilPlayer_interface(Wall), EvilPlayer_interface(none)))
            {
                Wall.TakeDamage(DamageVSPlayer, InstigatorController, Location, MomentumTransfer * Normal(Velocity), MyDamageType,, self);                
            }
            else
            {
                Wall.TakeDamage(int(Damage), InstigatorController, Location, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
            }
            bSuppressExplosionFX = true;
        }
        ShutDown();
        ImpactedActor = none;
    }
    //return;    
}

simulated event FellOutOfWorld(class<DamageType> dmgType)
{
    super(Projectile).FellOutOfWorld(dmgType);
    //return;    
}

simulated function Explode(Vector HitLocation, Vector HitNormal)
{
    local Controller C;
    local EvilPlayerController PC;

    // End:0x179
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        // End:0x178
        foreach WorldInfo.AllControllers(Class'EvilPlayerController', PC)
        {
            // End:0x177
            if(PC != none)
            {
                // End:0x177
                if(PC.bCinematicMode)
                {
                    ExplosionArchetype = none;
                    // End:0xD1
                    if(AmbientComponent != none)
                    {
                        AmbientComponent.FadeOut(0.1000000, 0.0000000);
                    }
                    // End:0xFF
                    if(ProjEffects != none)
                    {
                        ProjEffects.DeactivateSystem();
                    }
                    // End:0x12C
                    if(ProjectileLight != none)
                    {
                        DetachComponent(ProjectileLight);
                        ProjectileLight = none;
                    }
                    // End:0x15E
                    if(ProjectileLightActor != none)
                    {
                        ProjectileLightActor.Destroy();
                        ProjectileLightActor = none;
                    }
                    HideProjectile();
                    bExploded = true;                    
                    return;
                }
            }            
        }        
    }
    // End:0x233
    foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
    {
        // End:0x1F1
        if(EvilPlayerController(C) != none)
        {
            EvilPlayerController(C).NotifyProjectileExplode(self);
            // End:0x232
            continue;
        }
        // End:0x232
        if(EvilAIController(C) != none)
        {
            EvilAIController(C).NotifyProjectileExplode(self);
        }        
    }    
    // End:0x251
    if(int(Role) == int(ROLE_Authority))
    {
        MakeNoise(1.0000000);
    }
    SpawnExplosionEffects(HitLocation, HitNormal);
    ShutDown();
    bExploded = true;
    //return;    
}

simulated function SpawnFlightEffects()
{
    // End:0x1EF
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0x14B
        if(ProjFlightTemplate != none)
        {
            ProjEffects = WorldInfo.MyEmitterPool.SpawnEmitterCustomLifetime(ProjFlightTemplate);
            ProjEffects.SetAbsolute(false, false, false);
            ProjEffects.SetLODLevel(((WorldInfo.bDropDetail) ? 1 : 0));
            ProjEffects.__OnSystemFinished__Delegate = MyOnParticleSystemFinished;
            ProjEffects.bUpdateComponentInTick = true;
            AttachComponent(ProjEffects);
        }
        // End:0x1EF
        if((ProjectileLightArchetype != none) && !WorldInfo.IsConsoleBuild())
        {
            ProjectileLightActor = Spawn(Class'EvilLightActor', self,, Location,, ProjectileLightArchetype);
            ProjectileLightActor.SetBase(self);
            ProjectileLightActor.Activate();
        }
    }
    //return;    
}

simulated function ReSpawnFlightEffects()
{
    // End:0x16D
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0x16D
        if(ProjFlightTemplate != none)
        {
            // End:0x5A
            if(ProjEffects != none)
            {
                DetachComponent(ProjEffects);
            }
            ProjEffects = WorldInfo.MyEmitterPool.SpawnEmitterCustomLifetime(ProjFlightTemplate);
            ProjEffects.SetAbsolute(false, false, false);
            ProjEffects.SetLODLevel(((WorldInfo.bDropDetail) ? 1 : 0));
            ProjEffects.__OnSystemFinished__Delegate = MyOnParticleSystemFinished;
            ProjEffects.bUpdateComponentInTick = true;
            AttachComponent(ProjEffects);
        }
    }
    //return;    
}

simulated function SetExplosionEffectParameters(ParticleSystemComponent ProjExplosion)
{
    //return;    
}

simulated function SpawnExplosionEffects(Vector HitLocation, Vector HitNormal)
{
    local EvilExplosionActor ExplosionActor;

    // End:0x88
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0x56
        if(ProjectileLight != none)
        {
            DetachComponent(ProjectileLight);
            ProjectileLight = none;
        }
        // End:0x88
        if(ProjectileLightActor != none)
        {
            ProjectileLightActor.Destroy();
            ProjectileLightActor = none;
        }
    }
    // End:0x230
    if(ExplosionArchetype != none)
    {
        ExplosionActor = Spawn(Class'EvilExplosionActor', self,, HitLocation + (HitNormal * float(20)), MakeRotator(0, 0, 0));
        ExplosionActor.SetInstigatorController(InstigatorController);
        // End:0x15D
        if(bInWater && ExplosionWaterArchetype != none)
        {
            ExplosionTemplate = new (self) ExplosionWaterArchetype.Class (ExplosionWaterArchetype);            
        }
        else
        {
            ExplosionTemplate = new (self) ExplosionArchetype.Class (ExplosionArchetype);
        }
        ExplosionTemplate.HitNormal = HitNormal;
        ExplosionTemplate.HitActor = ImpactedActor;
        ExplosionActor.Explode(ExplosionTemplate);
        ExplosionTemplate = none;
        bExploded = true;
        bSuppressExplosionFX = true;        
    }
    //return;    
}

simulated function bool ShouldSpawnExplosionLight(Vector HitLocation, Vector HitNormal)
{
    local PlayerController P;
    local float Dist;

    // End:0x14A
    foreach LocalPlayerControllers(Class'Engine.PlayerController', P)
    {
        Dist = VSize(P.ViewTarget.Location - Location);
        // End:0x149
        if(((P.Pawn == Instigator) || Dist < ExplosionLightClass.default.Radius) || (Dist < MaxExplosionLightDistance) && (Vector(P.Rotation) Dot (Location - P.ViewTarget.Location)) > float(0))
        {            
            return true;
        }        
    }    
    return false;
    //return ReturnValue;    
}

simulated function ShutDown()
{
    local Vector HitLocation, HitNormal;

    bShuttingDown = true;
    HitNormal = Normal(Velocity * float(-1));
    Trace(HitLocation, HitNormal, Location + (HitNormal * float(-32)), Location + (HitNormal * float(32)), true, vect(0.0000000, 0.0000000, 0.0000000));
    SetPhysics(0);
    // End:0xB9
    if(ProjEffects != none)
    {
        ProjEffects.DeactivateSystem();
    }
    // End:0x120
    if(((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && !bSuppressExplosionFX) && !bSuppressAllFX)
    {
        SpawnExplosionEffects(Location, HitNormal);
    }
    // End:0x158
    if(AmbientComponent != none)
    {
        AmbientComponent.FadeOut(0.1000000, 0.0000000);
    }
    HideProjectile();
    SetCollision(false, false);
    // End:0x23E
    if(bWaitForEffects)
    {
        // End:0x1DA
        if(bNetTemporary)
        {
            // End:0x1B1
            if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
            {
                Destroy();                
            }
            else
            {
                RemoteRole = ROLE_None;
                LifeSpan = FMax(LifeSpan, 2.0000000);
            }            
        }
        else
        {
            bTearOff = true;
            // End:0x221
            if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
            {
                LifeSpan = 0.1500000;                
            }
            else
            {
                LifeSpan = FMax(LifeSpan, 2.0000000);
            }
        }        
    }
    else
    {
        Destroy();
    }
    //return;    
}

simulated function ShutdownNoFX()
{
    bSuppressAllFX = true;
    bNetDirty = true;
    ShutDown();
    //return;    
}

event TornOff()
{
    super(Actor).TornOff();
    //return;    
}

simulated function HideProjectile()
{
    local editinline MeshComponent ComponentIt;

    // End:0x40
    foreach ComponentList(Class'Engine.MeshComponent', ComponentIt)
    {
        ComponentIt.SetHidden(true);        
    }    
    //return;    
}

simulated function Destroyed()
{
    // End:0x72
    if(((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && !bSuppressExplosionFX) && !bSuppressAllFX)
    {
        SpawnExplosionEffects(Location, Vector(Rotation) * float(-1));
    }
    // End:0xDC
    if(ProjEffects != none)
    {
        DetachComponent(ProjEffects);
        WorldInfo.MyEmitterPool.OnParticleSystemFinished(ProjEffects);
        ProjEffects = none;
    }
    super(Actor).Destroyed();
    //return;    
}

simulated function MyOnParticleSystemFinished(ParticleSystemComponent PSC)
{
    // End:0xAA
    if(PSC == ProjEffects)
    {
        // End:0x4F
        if(bWaitForEffects)
        {
            // End:0x43
            if(bShuttingDown)
            {
                LifeSpan = 0.0100000;                
            }
            else
            {
                bWaitForEffects = false;
            }
        }
        DetachComponent(ProjEffects);
        WorldInfo.MyEmitterPool.OnParticleSystemFinished(ProjEffects);
        ProjEffects = none;
    }
    //return;    
}

simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    out_CamLoc = Location + (CylinderComponent.CollisionHeight * vect(0.0000000, 0.0000000, 1.0000000));
    return true;
    //return ReturnValue;    
}

event Actor GetHomingTarget(EvilProjectile_Base Seeker, Controller InstigatedBy)
{
    return self;
    //return ReturnValue;    
}

simulated function Pawn GetPawnOwner()
{
    //return ReturnValue;    
}

static final function float CalculateTravelTime(float Dist, float MoveSpeed, float MaxMoveSpeed, float AccelMag)
{
    local float ProjTime, AccelTime, AccelDist;

    // End:0x2B
    if(AccelMag == 0.0000000)
    {
        return Dist / MoveSpeed;        
    }
    else
    {
        ProjTime = (-MoveSpeed + Sqrt(Square(MoveSpeed) - ((2.0000000 * AccelMag) * -Dist))) / AccelMag;
        AccelTime = (MaxMoveSpeed - MoveSpeed) / AccelMag;
        // End:0x12A
        if(ProjTime > AccelTime)
        {
            AccelDist = (MoveSpeed * AccelTime) + ((0.5000000 * AccelMag) * Square(AccelTime));
            ProjTime = AccelTime + ((Dist - AccelDist) / MaxMoveSpeed);
        }
        return ProjTime;
    }
    //return ReturnValue;    
}

static simulated function float StaticGetTimeToLocation(Vector TargetLoc, Vector StartLoc, Controller RequestedBy)
{
    return CalculateTravelTime(VSize(TargetLoc - StartLoc), default.Speed, default.MaxSpeed, default.AccelRate);
    //return ReturnValue;    
}

simulated function float GetTimeToLocation(Vector TargetLoc)
{
    return CalculateTravelTime(VSize(TargetLoc - Location), Speed, MaxSpeed, AccelRate);
    //return ReturnValue;    
}

static simulated function float GetRange()
{
    local float AccelTime;

    // End:0x1C
    if(default.LifeSpan == 0.0000000)
    {
        return 15000.0000000;        
    }
    else
    {
        // End:0x47
        if(default.AccelRate == 0.0000000)
        {
            return default.Speed * default.LifeSpan;            
        }
        else
        {
            AccelTime = (default.MaxSpeed - default.Speed) / default.AccelRate;
            // End:0xE8
            if(AccelTime < default.LifeSpan)
            {
                return ((((0.5000000 * default.AccelRate) * AccelTime) * AccelTime) + (default.Speed * AccelTime)) + (default.MaxSpeed * (default.LifeSpan - AccelTime));                
            }
            else
            {
                return (((0.5000000 * default.AccelRate) * default.LifeSpan) * default.LifeSpan) + (default.Speed * default.LifeSpan);
            }
        }
    }
    //return ReturnValue;    
}

simulated function EnteredWaterVolume()
{
    bInWater = true;
    //return;    
}

simulated function ExitedWaterVolume()
{
    bInWater = false;
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x24
    if(VarName == 'bInit')
    {
        RepInit();        
    }
    else
    {
        // End:0x51
        if(VarName == 'TimeToExplode')
        {
            ToExplodeTimer = TimeToExplode;            
        }
        else
        {
            super(Actor).ReplicatedEvent(VarName);
        }
    }
    //return;    
}

state WaitingForVelocity
{
    simulated function Tick(float DeltaTime)
    {
        // End:0x61
        if(!IsZero(Velocity))
        {
            Acceleration = AccelRate * Normal(Velocity);
            GotoState(((InitialState != 'None') ? InitialState : 'Auto'));
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    bAttachExplosionToVehicles=true
    bNotifyControllersAboutExplosion=true
    DurationOfDecal=24.0000000
    DecalDissolveParamName="DissolveAmount"
    MaxEffectDistance=10000.0000000
    GlobalCheckRadiusTweak=1.0000000
    MaxExplosionLightDistance=4000.0000000
    DamageVSPlayerDistance=-1.0000000
    TerminalVelocity=3500.0000000
    CustomGravityScaling=1.0000000
    bSwitchToZeroCollision=true
    bBlockedByInstigator=false
    DamageRadius=1.0000000
    // Reference: CylinderComponent'Default__EvilProjectile_Base.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    bCollideComplex=true
    CollisionComponent=CollisionCylinder
}