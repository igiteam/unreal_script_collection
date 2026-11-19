class MOHAProj_Explosive extends Projectile
    abstract
    native
    nativereplication
    config(Weapon)
    hidecategories(Navigation);

var() config float bounceDamping;
var() config float RotationAmount;
var() config float CustomGravityScale;
var() config float ExplosiveDamage;
var() config float ExplosiveDamageRadius;
var() config float ExplosiveMomentumTransfer;
var() config float fSpeed;
var() config float fMaxSpeed;
var export editinline StaticMeshComponent Mesh;
var SoundCue ExplosionSound;
var export editinline AudioComponent ExplosiveAudioComponent;
var export editinline AudioComponent ExplosiveImpactAudioComponent;
var Emitter ProjExplosion;
var ParticleSystem ProjExplosionTemplate;
var export editinline ParticleSystemComponent ProjectileSmokePSComponent;
var export editinline AudioComponent AmbientSound;
var MaterialInstance ExplosionDecal;
var float DecalWidth;
var float DecalHeight;
var repnotify float fFuseTime;
var export editinline PointLightComponent ExplosionLight;
var float LightFalloffSpeed;
var float LightLifespan;
var float LightCreationDelay;
var() bool bShowExplosionSphere;
var bool bSpawnCSATrigger;
var bool bNotifyHUDIndicator;
var bool FirstFrame;
var bool bDud;
var bool bExplodeOnImpactWithPawn;
var bool bStimTriggered;
var bool bEnabled;
var export editinline WhizSenderComponent WhizComponent;
var MOHAGrenadeCSA CSATrigger;
var Vector LastLocation;
var float fMinSpeedForImpactExplosion;
var export editinline StimulusComponent Stimulus;
var float PitchClamp;
var() ParticleSystem ProjectileSmokeTrailTemplate;
var class<DamageType> MyKickedDamageType;
var class<DamageType> MyCookedDamageType;

replication
{
    // Pos:0x000
    if((!bNetDirty || bNetInitial) && int(Role) == int(ROLE_Authority)
        fFuseTime;
}

simulated function SetFuseTime(float newFuseTime)
{
    fFuseTime = newFuseTime;
    SetTimer(newFuseTime);
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x25
    if(VarName == 'fFuseTime')
    {
        SetFuseTime(fFuseTime);        
    }
    else
    {
        super(Actor).ReplicatedEvent(VarName);
    }
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    InitProj();
    // End:0x31
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        bBlockedByInstigator = false;
    }
    //return;    
}

simulated function InitProj()
{
    // End:0x0B
    if(bEnabled)
    {
        return;
    }
    Mesh.SetHidden(false);
    SetPhysics(default.Physics);
    Speed = fSpeed;
    MaxSpeed = fMaxSpeed;
    ExplosiveAudioComponent = WorldInfo.CreateAudioComponent(ExplosionSound, false, false, false);
    ExplosiveAudioComponent.bUseOwnerLocation = false;
    ExplosiveAudioComponent.bAutoDestroy = true;
    // End:0x99
    if(ExplosiveImpactAudioComponent == none)
    {
        ExplosiveImpactAudioComponent = CreateAudioComponent(ImpactSound, false, true, false);
    }
    RotationRate.Pitch = int(-RotationAmount);
    Damage = ExplosiveDamage;
    DamageRadius = ExplosiveDamageRadius;
    MomentumTransfer = ExplosiveMomentumTransfer;
    AttachSmokeTrail();
    // End:0xF7
    if(AmbientSound != none)
    {
        AmbientSound.Play();
    }
    bCollideComplex = (EALAWeapon(Owner) != none) && MOHAPlayerPawn(EALAWeapon(Owner).Instigator) != none;
    SetEnabled(true);
    //return;    
}

simulated function SetEnabled(bool Enabled)
{
    bEnabled = Enabled;
    // End:0x67
    if(int(WorldInfo.WorldInfo.NetMode) == int(NM_Standalone))
    {
        // End:0x53
        if(bEnabled)
        {
            bStasis = false;
            ClearTimer('ActivateStasis');            
        }
        else
        {
            SetTimer(5.0000000,, 'ActivateStasis');
        }
    }
    //return;    
}

function ActivateStasis()
{
    bStasis = true;
    //return;    
}

function Init(Vector Direction)
{
    InitProj();
    super.Init(Direction);
    //return;    
}

simulated function AttachSmokeTrail()
{
    // End:0x0D
    if(none == ProjectileSmokeTrailTemplate)
    {
        return;
    }
    // End:0x5C
    if(ProjectileSmokePSComponent == none)
    {
        ProjectileSmokePSComponent = new (Outer) Class'Engine.ParticleSystemComponent';
        AttachComponent(ProjectileSmokePSComponent);
        ProjectileSmokePSComponent.SetDepthPriorityGroup(1);
        ProjectileSmokePSComponent.SetTemplate(ProjectileSmokeTrailTemplate);
    }
    ProjectileSmokePSComponent.ActivateSystem();
    //return;    
}

simulated function InitRotator(Rotator Direction)
{
    SetRotation(Direction);
    Velocity = Speed * Vector(Direction);
    //return;    
}

simulated function Explode(Vector HitLocation, Vector HitNormal)
{
    local PlayerController LocalPlayer;
    local MOHAStimulusSender StimulusSender;

    // End:0x0D
    if(!bEnabled)
    {
        return;
    }
    // End:0x2C
    if(!bDud)
    {
        ExplodeEffects(HitLocation, HitNormal);
    }
    // End:0x85
    if(CSATrigger != none)
    {
        // End:0x73
        foreach LocalPlayerControllers(LocalPlayer)
        {
            // End:0x72
            if(MOHAPlayerController(LocalPlayer) != none)
            {
                MOHAPlayerController(LocalPlayer).RemoveCSA(CSATrigger);
            }            
        }        
        CSATrigger.bEnabled = false;
    }
    // End:0xCF
    foreach LocalPlayerControllers(LocalPlayer)
    {
        // End:0xCE
        if(MOHAHUD(LocalPlayer.myHUD) != none)
        {
            MOHAHUD(LocalPlayer.myHUD).RemoveGrenadeIndicator(self);
        }        
    }    
    // End:0xEA
    if(ProjectileSmokePSComponent != none)
    {
        ProjectileSmokePSComponent.DeactivateSystem();
    }
    // End:0x104
    if(AmbientSound != none)
    {
        AmbientSound.Stop();
    }
    // End:0x21A
    if(!bDud)
    {
        StimulusSender = __NFUN_278__(Class'MOHAStimulusSender',,, Location);
        // End:0x1CB
        if(StimulusSender != none)
        {
            StimulusSender.SendStimulus('NearbyExplosion', 2.0000000,, true, true);
            StimulusSender.Stimulus.AttachSender('BulletImpact', 'ExplosiveImpact', Location, rot(0, 0, 0),,, true, true);
            StimulusSender.Stimulus.PushStimuliSenderParamFloat('BulletImpact', 'threat', 6.0000000);
        }
        // End:0x20D
        if((Damage > float(0)) && DamageRadius > float(0))
        {
            HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
        }
        RecycleProjectile();        
    }
    else
    {
        RecycleProjectile();
    }
    //return;    
}

simulated function bool HurtRadius(float DamageAmount, float InDamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, optional Actor IgnoredActor, optional Controller InstigatedByController, optional bool bDoFullDamage)
{
    local bool bCausedDamage, bResult;

    // End:0x0E
    if(bHurtEntry)
    {
        return false;
    }
    bCausedDamage = false;
    // End:0x2C
    if(InstigatedByController == none)
    {
        InstigatedByController = InstigatorController;
    }
    // End:0x8D
    if((ImpactedActor != none) && ImpactedActor != self)
    {
        ImpactedActor.TakeRadiusDamage(InstigatedByController, DamageAmount, InDamageRadius, DamageType, Momentum, HurtOrigin, true, self);
        bCausedDamage = ImpactedActor.bProjTarget;
    }
    // End:0xDF
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        bResult = super(Actor).HurtRadius(DamageAmount, InDamageRadius, DamageType, Momentum, HurtOrigin, ImpactedActor, InstigatedByController, bDoFullDamage);        
    }
    else
    {
        bResult = HurtRadiusMP(DamageAmount, InDamageRadius, DamageType, Momentum, HurtOrigin, ImpactedActor, InstigatedByController, bDoFullDamage);
    }
    // End:0x13F
    if(bResult || bCausedDamage)
    {
        UpdateHitStats(bCausedDamage);
        return true;
    }
    return false;
    //return ReturnValue;    
}

// Export UMOHAProj_Explosive::execHurtRadiusMP(FFrame&, void* const)
native simulated function bool HurtRadiusMP(float DamageAmount, float InDamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, Actor IgnoredActor, Controller InstigatedByController, bool bDoFullDamage);

simulated function RecycleProjectile()
{
    // End:0x94
    if(((int(WorldInfo.WorldInfo.NetMode) == int(NM_Standalone)) && EALAWeapon(Owner) != none) && EALAWeapon(Owner).AddProjectileToPool(self))
    {
        SetEnabled(false);
        Mesh.SetHidden(true);
        Stimulus.DetachSender('Grenade');
        bStimTriggered = false;        
    }
    else
    {
        Destroy();
    }
    //return;    
}

simulated function ExplodeEffects(Vector HitLocation, Vector HitNormal)
{
    ProjExplosion = __NFUN_278__(Class'MOHAExplodeEmitter', self,, HitLocation, Rotator(HitNormal));
    // End:0xA1
    if(ProjExplosion != none)
    {
        ProjExplosion.LifeSpan = 12.5000000;
        ProjExplosion.SetTemplate(ProjExplosionTemplate, true);
        // End:0xA1
        if(ExplosionLight != none)
        {
            MOHAExplodeEmitter(ProjExplosion).SetLight(ExplosionLight, LightLifespan, LightCreationDelay);
            MOHAExplodeEmitter(ProjExplosion).FalloffSpeed = LightFalloffSpeed;
        }
    }
    ExplosiveAudioComponent.Location = Location;
    ExplosiveAudioComponent.Play();
    //return;    
}

simulated event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    ProcessHit(HitNormal, Wall);
    //return;    
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    // End:0x43
    if((Other != none) && (int(Other.CollisionType) == int(6)) || int(Other.CollisionType) == int(9))
    {
        return;
    }
    ProcessHit(HitNormal, Other);
    //return;    
}

simulated function ProcessHit(Vector HitNormal, Actor Other)
{
    // End:0x0D
    if(!bEnabled)
    {
        return;
    }
    ActivateStimulus();
    ImpactedActor = Other;
    Velocity = bounceDamping * ((((Velocity Dot HitNormal) * HitNormal) * -2.0000000) + Velocity);
    Speed = VSize(Velocity);
    // End:0xBA
    if((((Speed > fMinSpeedForImpactExplosion) && bExplodeOnImpactWithPawn) && MOHAPawn(Other) != none) && Other != Instigator)
    {
        ClearTimer();
        Explode(Location, Normal(Velocity));
        return;
    }
    // End:0xCD
    if(Speed < float(20))
    {
        SetPhysics(0);
    }
    // End:0x10E
    if(ExplosiveImpactAudioComponent != none)
    {
        ExplosiveImpactAudioComponent.VolumeMultiplier = FClamp(Speed / 200.0000000, 0.2500000, 1.5000000);
        ExplosiveImpactAudioComponent.Play();
    }
    //return;    
}

simulated function Timer()
{
    Explode(Location, Normal(Velocity));
    //return;    
}

function ActivateStimulus()
{
    // End:0x57
    if(!bStimTriggered)
    {
        Stimulus.AttachSender('Grenade', 'Grenade', vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0));
        bStimTriggered = true;
    }
    //return;    
}

simulated function CreateLight(Color LightColor, float LightSize, float LightLife, float LightBrightness, float FalloffSpeed, float LightFalloffExponent, float LightDelay)
{
    ExplosionLight = new Class'Engine.PointLightComponent';
    ExplosionLight.SetLightProperties(LightBrightness, LightColor);
    ExplosionLight.Radius = LightSize;
    ExplosionLight.CastDynamicShadows = false;
    ExplosionLight.SetEnabled(false);
    ExplosionLight.FalloffExponent = LightFalloffExponent;
    LightLifespan = LightLife;
    LightFalloffSpeed = FalloffSpeed;
    LightCreationDelay = LightDelay;
    //return;    
}

simulated function Tick(float DeltaTime)
{
    local float currentSpeed, LocalPlayerDistance;
    local PlayerController LocalPlayer;

    // End:0x0D
    if(!bEnabled)
    {
        return;
    }
    // End:0x37
    if(!FirstFrame)
    {
        WhizComponent.SendWhizEvent(LastLocation, Location, 2);
    }
    FirstFrame = false;
    LastLocation = Location;
    // End:0x6E
    if(bShowExplosionSphere)
    {
        DrawDebugSphere(Location, DamageRadius, 10, 0, 0, byte(255), false);
    }
    currentSpeed = VSize(Velocity);
    // End:0x24A
    if(currentSpeed < float(50))
    {
        // End:0xF0
        if((bSpawnCSATrigger && CSATrigger == none) && int(WorldInfo.NetMode) == int(NM_Standalone))
        {
            CSATrigger = __NFUN_278__(Class'MOHAGrenadeCSA',,, Location);
            // End:0xED
            if(CSATrigger != none)
            {
                CSATrigger.explosiveOwner = self;
            }            
        }
        else
        {
            // End:0x133
            if((CSATrigger != none) && !CSATrigger.bEnabled)
            {
                CSATrigger.bEnabled = true;
                CSATrigger.SetLocation(Location);
            }
        }
        // End:0x230
        if(bNotifyHUDIndicator)
        {
            // End:0x22F
            foreach LocalPlayerControllers(LocalPlayer)
            {
                // End:0x162
                if(LocalPlayer.Pawn == none)
                {
                    continue;                    
                }
                LocalPlayerDistance = VSize2D(LocalPlayer.Pawn.Location - Location);
                // End:0x1F3
                if(LocalPlayerDistance < (DamageRadius + Class'MOHAHUDGrenadeIndicator'.default.WarningZoneDistance))
                {
                    // End:0x1F0
                    if(MOHAHUD(LocalPlayer.myHUD) != none)
                    {
                        MOHAHUD(LocalPlayer.myHUD).AddGrenadeIndicator(self, LocalPlayerDistance, DamageRadius);
                    }
                    // End:0x22E
                    continue;
                }
                // End:0x22E
                if(MOHAHUD(LocalPlayer.myHUD) != none)
                {
                    MOHAHUD(LocalPlayer.myHUD).RemoveGrenadeIndicator(self);
                }                
            }            
        }
        // End:0x24A
        if(none != ProjectileSmokePSComponent)
        {
            ProjectileSmokePSComponent.DeactivateSystem();
        }
    }
    //return;    
}

defaultproperties
{
    CustomGravityScale=1.0000000
    ExplosiveDamage=100.0000000
    ExplosiveDamageRadius=500.0000000
    ExplosiveMomentumTransfer=100.0000000
    fSpeed=200.0000000
    fMaxSpeed=200000000.0000000
    // Reference: StaticMeshComponent'Default__MOHAProj_Explosive.ProjectileMesh'
    begin object name=ProjectileMesh class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'GCm_Wpn_US_FragGrenade.StaticMesh.US_FragGrenade_thrown'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAProj_Explosive.MyLightEnvironment'
        LightingChannels=(bInitialized=true,CompositeDynamic=true,Characters_Weapons_Vehicles=true)
    end object
    Mesh=ProjectileMesh
    ExplosionSound=SoundCue'Aud_GCm_FakeWAV.Grenade.Grenade_Explo'
    FirstFrame=true
    // Reference: WhizSenderComponent'Default__MOHAProj_Explosive.whiz'
    begin object name=whiz class=Class'WhizSenderComponent'
    end object
    WhizComponent=whiz
    fMinSpeedForImpactExplosion=20.0000000
    // Reference: StimulusComponent'Default__MOHAProj_Explosive.Stimulus0'
    begin object name=Stimulus0 class=Class'EAKynapse.StimulusComponent'
    end object
    Stimulus=Stimulus0
    PitchClamp=16384.0000000
    ImpactSound=SoundCue'Aud_GCm_FakeWAV.Grenade.ProjImpact_Grenade_Bounce_Default'
    // Reference: CylinderComponent'Default__MOHAProj_Explosive.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHAProj_Explosive.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAProj_Explosive.MyLightEnvironment'
    begin object name=MyLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
    end object
    Components[2]=MyLightEnvironment
    Components[3]=ProjectileMesh
    Components[4]=Stimulus0
    Physics=2
    ActorType=30
    bAlwaysRelevant=true
    bCollideComplex=true
    bBounce=true
    LifeSpan=0.0000000
    CollisionComponent=CollisionCylinder
}