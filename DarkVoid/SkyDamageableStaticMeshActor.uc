class SkyDamageableStaticMeshActor extends Actor
    native
    placeable;

var(Damage) int Health;
var(Damage) int MaxHealthDeduction;
var(Damage) editinline array<editinline DamageStateEffect> DamageStateEffects;
var(Damage) export editinline array<export editinline StaticMeshComponent> AdditionalMeshes;
var(Damage) float DestroyDelay;
var(Damage) float CollisionDamageMult;
var(Damage) bool bReducedFallingCollisionDamage;
var transient int FullHealth;
var transient Vector DelayHitLocation;
var transient DamageStateEffect DelayDamageEffect;
var transient float DelayTime;
var() const editconst export editinline StaticMeshComponent StaticMeshComponent;

simulated event PreBeginPlay()
{
    super.PreBeginPlay();
    FullHealth = Health;
    //return;    
}

simulated function PostBeginPlay()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x60 [Loop If]
    if(I < AdditionalMeshes.Length)
    {
        // End:0x56
        if((AdditionalMeshes[I] != none) && AdditionalMeshes[I].Owner == none)
        {
            AttachComponent(AdditionalMeshes[I]);
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

event Tick(float DeltaTime)
{
    // End:0x3F
    if(DelayTime > 0.0000000)
    {
        DelayTime -= DeltaTime;
        // End:0x3F
        if(DelayTime <= 0.0000000)
        {
            TriggerDamageEffectTimer();
            DelayTime = 0.0000000;
        }
    }
    //return;    
}

event bool ApplyEffectDamage(Vector HitLocation, int DamageApplied, int NewHealth, class<DamageType> DamageType)
{
    local float HealthPctBefore, HealthPctAfter;
    local int I;
    local float HealthPct;
    local bool bDelayedEffect;

    HealthPctBefore = float(NewHealth + DamageApplied) / float(FullHealth);
    HealthPctAfter = float(NewHealth) / float(FullHealth);
    I = 0;
    J0x3A:

    // End:0xBA [Loop If]
    if(I < DamageStateEffects.Length)
    {
        HealthPct = DamageStateEffects[I].HealthPercentage;
        // End:0xB0
        if((HealthPct < HealthPctBefore) && HealthPct >= HealthPctAfter)
        {
            // End:0xB0
            if(PlayDamageEffect(HitLocation, DamageStateEffects[I], DamageType))
            {
                bDelayedEffect = true;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x3A;
    }
    return bDelayedEffect;
    //return ReturnValue;    
}

function float GetDelayTime(class<DamageType> DamageType, DamageStateEffect DamageEffect)
{
    local float DelayMin, DelayMax, Temp;

    // End:0x51
    if((class<SkyDmgType_SmallExplosives>(DamageType) == none) && class<SkyDmgType_LargeExplosives>(DamageType) == none)
    {
        DelayMin = DamageEffect.DelaySecondsMin;
        DelayMax = DamageEffect.DelaySecondsMax;        
    }
    else
    {
        DelayMin = DamageEffect.DelaySecondsSplashMin;
        DelayMax = DamageEffect.DelaySecondsSplashMax;
    }
    // End:0xAD
    if(DelayMin > DelayMax)
    {
        Temp = DelayMin;
        DelayMin = DelayMax;
        DelayMax = Temp;
    }
    return DelayMin + (FRand() * (DelayMax - DelayMin));
    //return ReturnValue;    
}

function bool PlayDamageEffect(Vector HitLocation, DamageStateEffect DamageEffect, class<DamageType> DamageType)
{
    local float InDelayTime;

    InDelayTime = GetDelayTime(DamageType, DamageEffect);
    // End:0x42
    if(InDelayTime == 0.0000000)
    {
        TriggerDamageEffect(HitLocation, DamageEffect);
        return false;        
    }
    else
    {
        PlayDelayedDamageEffect(HitLocation, DamageEffect, InDelayTime);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function PlayDelayedDamageEffect(Vector HitLocation, DamageStateEffect DamageEffect, float InDelayTime)
{
    DelayHitLocation = HitLocation;
    DelayDamageEffect = DamageEffect;
    // End:0x2D
    if(bStatic)
    {
        DelayTime = InDelayTime;        
    }
    else
    {
        SetTimer(InDelayTime, false, 'TriggerDamageEffectTimer');
    }
    //return;    
}

function TriggerDamageEffectTimer()
{
    TriggerDamageEffect(DelayHitLocation, DelayDamageEffect);
    //return;    
}

// Export USkyDamageableStaticMeshActor::execTakeDamage(FFrame&, void* const)
native function TakeDamage(int DamageAmount, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);

function float GetCollisionDamageModifier(const out array<RigidBodyContactInfo> ContactInfos)
{
    local float Multiplier, Angle;
    local Vector X, Y, Z;

    // End:0x7D
    if(bReducedFallingCollisionDamage)
    {
        GetAxes(Rotation, X, Y, Z);
        Angle = ContactInfos[0].ContactNormal Dot Z;
        // End:0x62
        if(Angle < 0.0000000)
        {
            Multiplier = 1.0000000 + Angle;            
        }
        else
        {
            Multiplier = 1.0000000;
        }
        return CollisionDamageMult * Multiplier;        
    }
    else
    {
        return CollisionDamageMult;
    }
    //return ReturnValue;    
}

simulated event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData RigidCollisionData, int ContactIndex)
{
    local int Damage;

    super.RigidBodyCollision(HitComponent, OtherComponent, RigidCollisionData, ContactIndex);
    Damage = int(VSize(RigidCollisionData.ContactInfos[0].ContactVelocity[ContactIndex]) * (GetCollisionDamageModifier(RigidCollisionData.ContactInfos)));
    // End:0xAF
    if(Damage > 0)
    {
        TakeDamage(Damage, none, RigidCollisionData.ContactInfos[0].ContactPosition, vect(0.0000000, 0.0000000, 0.0000000), Class'SkyDmgType_Collision');
    }
    //return;    
}

simulated function TriggerDamageEffect(Vector Loc, DamageStateEffect Effect)
{
    local editinline AudioComponent AudioComponent;
    local PlayerController LocalPlayerController;
    local SkyPawn SkyPawn;
    local Vehicle Vehicle;
    local SkyGameReplicationInfo GRI;
    local KAssetSpawnable PhysSpawned;

    // End:0x80
    if(Effect.SoundEffect != none)
    {
        AudioComponent = CreateAudioComponent(Effect.SoundEffect, false, false);
        AudioComponent.bUseOwnerLocation = false;
        AudioComponent.Location = Loc;
        AudioComponent.bAutoDestroy = true;
        AudioComponent.Play();
    }
    // End:0x21E
    if(Effect.EffectTemplate != none)
    {
        GRI = SkyGameReplicationInfo(WorldInfo.GRI);
        // End:0x128
        if(GRI.SOP != none)
        {
            Effect.EffectEmitter = GRI.SOP.CreateEmitter(Effect.EffectTemplate, self, Loc + (Effect.EffectOffset >> Rotation), Rotation);            
        }
        else
        {
            Effect.EffectEmitter = Spawn(Class'Engine.EmitterSpawnable', self,, Loc + (Effect.EffectOffset >> Rotation), Rotation);
            // End:0x1B2
            if(Effect.EffectEmitter != none)
            {
                Effect.EffectEmitter.SetTemplate(Effect.EffectTemplate, true);
            }
        }
        // End:0x21E
        if(Effect.EffectEmitter != none)
        {
            Effect.EffectEmitter.ParticleSystemComponent.ActivateSystem();
            // End:0x21E
            if(Effect.bEffectSticks)
            {
                Effect.EffectEmitter.SetBase(self);
            }
        }
    }
    // End:0x2FA
    if(Effect.bUseLocalEffect)
    {
        Effect.LocalEffectSettings.SourceLocation = Location;
        // End:0x2F9
        foreach LocalPlayerControllers(Class'Engine.PlayerController', LocalPlayerController)
        {
            SkyPawn = SkyPawn(LocalPlayerController.Pawn);
            // End:0x2C9
            if(SkyPawn == none)
            {
                Vehicle = Vehicle(LocalPlayerController.Pawn);
                // End:0x2C9
                if(Vehicle != none)
                {
                    SkyPawn = SkyPawn(Vehicle.Driver);
                }
            }
            // End:0x2F8
            if(SkyPawn != none)
            {
                SkyPawn.AddLocalEffect(Effect.LocalEffectSettings);
            }            
        }        
    }
    // End:0x335
    if(Effect.DamageMesh != none)
    {
        StaticMeshComponent.SetStaticMesh(Effect.DamageMesh);
    }
    // End:0x3A6
    if((Effect.StaticMeshToHide >= 0) && Effect.StaticMeshToHide < AdditionalMeshes.Length)
    {
        // End:0x3A6
        if(AdditionalMeshes[Effect.StaticMeshToHide] != none)
        {
            AdditionalMeshes[Effect.StaticMeshToHide].SetHidden(true);
        }
    }
    HurtRadius(Effect.SplashDamage, Effect.SplashDamageRadius, 0.0000000, Effect.SplashDamageType, Effect.SplashMomentumTransfer, Loc);
    // End:0x4B3
    if((Effect.PhysAsset != none) && Effect.PhysMesh != none)
    {
        PhysSpawned = Spawn(Class'Engine.KAssetSpawnable',,, Loc, Rotation,, true);
        // End:0x4B3
        if(PhysSpawned != none)
        {
            PhysSpawned.SkeletalMeshComponent.SetSkeletalMesh(Effect.PhysMesh);
            PhysSpawned.SkeletalMeshComponent.EnablePhysics(Effect.PhysAsset, 1.0000000);            
        }
    }
    // End:0x4C9
    if(Health == 0)
    {
        LifeSpan = DestroyDelay;
    }
    //return;    
}

simulated function Destroyed()
{
    local int J;
    local DamageStateEffect Effect;

    J = 0;
    J0x07:

    // End:0x6D [Loop If]
    if(J < DamageStateEffects.Length)
    {
        Effect = DamageStateEffects[J];
        // End:0x63
        if(Effect.EffectEmitter != none)
        {
            Effect.EffectEmitter.ParticleSystemComponent.DeactivateSystem();
        }
        J++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}
