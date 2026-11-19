class TurokProjectile extends Projectile
    native
    nativereplication
    config(Projectile)
    hidecategories(Navigation);

struct native ReplicatedProjectileHit
{
    var @NULL Location;
    var @NULL Normal;

    structdefaultproperties
    {
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Normal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native ProjectilePawnDamageOverride
{
    var() name mHitPawnName;
    var() float mHitDamage;

    structdefaultproperties
    {
        mHitPawnName="None"
        mHitDamage=0.0000000
    }
};

struct native ProjectileGrassEffectSettings
{
    var float mProjectileRadius;
    var float mTrailRadius;
    var float mCentralForce;
    var float mMinimumForce;

    structdefaultproperties
    {
        mProjectileRadius=0.0000000
        mTrailRadius=0.0000000
        mCentralForce=0.0000000
        mMinimumForce=0.0000000
    }
};

var export editinline @NULL mSoundController;
var int mProjAmbienceSndChannel;
var(Sound) @NULL mProjAmbientSndCue;
var(Noise) config float mImpactNoiseLevel;
var(Sound) float mAmbienceStartOffsetSecs;
var const bool mPlayAmbienceOnSpawn;
var(ExplosionShake) bool mExplosionShakeEnable;
var protected const bool mbRotationFollowsVelocity;
var protected const bool mbRotatePath;
var config bool mCauseBluntImpact;
var(RadiusDamage) bool mbDoTraceToTopOfHurtActor;
var(AI) config bool mShouldAIAvoid;
var protected const bool mbReplicateProjectileHit;
var protected bool mbExploded;
var protected bool mbIsMultiPlayer;
var(trajectory) bool mbDrawTrajectoryLines;
var bool mbOddFrame;
var(Effects) config @NULL mGrassSettings;
var(Effects) @NULL mExplosionTemplate;
var(Effects) @NULL mExplosionTemplateSecondary;
var(Effects) editinline array mImpactEffects;
var(ExplosionShake) export editinline @NULL mExplosionShake;
var(Movement) protected config float mSpeedBonus;
var(Decent) float mSlowDecentSpeed;
var(Decent) float mDescendSpeed;
var(Decent) float mHorizontalDeceleration;
var(AI) config float mAIDamage;
var(AI) config array mAIPawnDamageOverride;
var config float mMultiplayerDamageRadius;
var config float mMultiplayerDamage;
var config float mMultiplayerMaxSpeed;
var config float mProjectileSpeed;
var config float mProjectileSpeedMP;
var protected const float mPendingCleanupLifeSpan;
var protected @NULL mPreviousLocation;
var protected repnotify @NULL mReplicatedHitInfo;

replication
{
    // Pos:0x000
    if(bNetDirty && mbReplicateProjectileHit
        mReplicatedHitInfo;
}

// Export UTurokProjectile::execGetSpeedBonus(FFrame&, void* const)
native final function float GetSpeedBonus();

simulated event ReplicatedEvent(name VarName)
{
    // End:0x24
    if(VarName == 'mReplicatedHitInfo')
    {
        OnProjectileHit(mReplicatedHitInfo);
        return;
    }
    super(Actor).ReplicatedEvent(VarName);
    //return;    
}

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x20
    if(Class'TurokUtil'.static.IsMultiplayerGame())
    {
        mbIsMultiPlayer = true;
    }
    // End:0x36
    if(bDeleteMe || mbExploded)
    {
        return;
    }
    // End:0x6F
    if(mPlayAmbienceOnSpawn)
    {
        // End:0x64
        if(mAmbienceStartOffsetSecs > 0.0000000)
        {
            SetTimer(mAmbienceStartOffsetSecs, false, 'SetAmbience');            
        }
        else
        {
            SetAmbience();
        }
    }
    //return;    
}

function Init(@NULL Direction)
{
    // End:0x43
    if((mbIsMultiPlayer && mProjectileSpeedMP != 0.0000000) && TurokCoopGameReplicationInfo(WorldInfo.GRI) == none)
    {
        Speed = mProjectileSpeedMP;        
    }
    else
    {
        // End:0x5D
        if(mProjectileSpeed != 0.0000000)
        {
            Speed = mProjectileSpeed;
        }
    }
    super.Init(Direction);
    //return;    
}

simulated event Tick(float DeltaTime)
{
    // End:0xC6
    if(mbDrawTrajectoryLines || ((Instigator != none) && TurokPlayerController(Instigator.Controller) != none) && TurokPlayerController(Instigator.Controller).IsShowWeaponDebug())
    {
        // End:0xBB
        if(mPreviousLocation != vect(0.0000000, 0.0000000, 0.0000000))
        {
            // End:0x93
            if(mbOddFrame)
            {
                DrawDebugLine(Location, mPreviousLocation, byte(255), 0, 0, true);                
            }
            else
            {
                DrawDebugLine(Location, mPreviousLocation, 0, byte(255), 0, true);
            }
            mbOddFrame = !mbOddFrame;
        }
        mPreviousLocation = Location;
    }
    super(Actor).Tick(DeltaTime);
    //return;    
}

simulated function SetAmbience(optional @NULL sc)
{
    local @NULL cue;

    // End:0x1A
    if(sc != none)
    {
        cue = sc;        
    }
    else
    {
        // End:0x33
        if(mProjAmbientSndCue != none)
        {
            cue = mProjAmbientSndCue;            
        }
        else
        {
            return;
        }
    }
    // End:0x67
    if(mProjAmbienceSndChannel == -1)
    {
        mProjAmbienceSndChannel = mSoundController.CreateAudioChannel(cue, true, true);        
    }
    else
    {
        mSoundController.ChangeAudioChannel(mProjAmbienceSndChannel, cue, true, true);
    }
    //return;    
}

simulated function StopAmbience()
{
    // End:0x24
    if(mProjAmbientSndCue != none)
    {
        mSoundController.StopAudioChannel(mProjAmbienceSndChannel);
    }
    //return;    
}

simulated event Landed(@NULL HitNormal, @NULL FloorActor)
{
    // End:0x13
    if(mPlayAmbienceOnSpawn)
    {
        StopAmbience();
    }
    super(Actor).Landed(HitNormal, FloorActor);
    Explode(Location, HitNormal);
    //return;    
}

simulated function bool HurtRadius(float DamageAmount, float InDamageRadius, class<Class> DamageType, float Momentum, @NULL HurtOrigin, optional @NULL IgnoredActor, optional @NULL InstigatedByController = ((Instigator != none) ? Instigator.Controller : none), optional bool bDoFullDamage, optional bool bTraceToTopOfBBox)
{
    // End:0x5C
    if(TurokPlayerController(InstigatedByController) != none)
    {
        TurokPlayerController(InstigatedByController).RecordExplosionHit(self, InDamageRadius, HurtOrigin, bTraceToTopOfBBox);
    }
    return super.HurtRadius(DamageAmount, InDamageRadius, DamageType, Momentum, HurtOrigin, IgnoredActor, InstigatedByController, bDoFullDamage, bTraceToTopOfBBox);
    //return ReturnValue;    
}

simulated function BlowUp(@NULL HitLocation, @NULL HitNormal)
{
    local float locdamage;
    local @NULL instCtrl;

    // End:0x38
    if((Instigator != none) && Instigator.Controller != none)
    {
        instCtrl = Instigator.Controller;        
    }
    else
    {
        // End:0x51
        if(InstigatorController != none)
        {
            instCtrl = InstigatorController;            
        }
        else
        {
            instCtrl = none;
        }
    }
    // End:0x76
    if(TurokPlayerController(instCtrl) != none)
    {
        locdamage = Damage;        
    }
    else
    {
        locdamage = mAIDamage;
    }
    // End:0xA3
    if(mExplosionShakeEnable)
    {
        Class'TurokRadialParametricShake'.static.BroadcastRadialShake(self, mExplosionShake);
    }
    // End:0x13C
    if((TurokPlayerController(instCtrl) != none) && TurokPlayerController(instCtrl).mbDrawExplosionDebug)
    {
        DrawDebugSphere(HitLocation, MyDamageType.default.DamageRadius, 16, 0, byte(255), byte(255), true);
        DrawDebugSphere(HitLocation, MyDamageType.default.DamageKnockdownRadius, 16, byte(255), byte(255), 0, true);
        DrawDebugSphere(HitLocation, MyDamageType.default.DamageGibRadius, 16, byte(255), 0, 0, true);
    }
    // End:0x164
    if(TurokPlayerController(instCtrl) != none)
    {
        Class'TurokAchievementTracker'.static.BeginExplosion(MyDamageType);
    }
    HurtRadius(locdamage, MyDamageType.default.DamageRadius, MyDamageType, MyDamageType.default.RadialDamageImpulse, HitLocation, none, instCtrl, false, mbDoTraceToTopOfHurtActor);
    // End:0x1C9
    if(TurokPlayerController(instCtrl) != none)
    {
        Class'TurokAchievementTracker'.static.EndExplosion();
    }
    //return;    
}

simulated function Explode(@NULL HitLocation, @NULL HitNormal)
{
    local @NULL HitInfo;

    HitInfo.Location = HitLocation;
    HitInfo.Normal = HitNormal;
    ProjectileBluntImpact(HitInfo);
    // End:0x59
    if((int(Role) != int(ROLE_Authority)) && bNetTemporary == false)
    {
        return;
    }
    // End:0x64
    if(mbExploded)
    {
        return;
    }
    mbExploded = true;
    SetLocation(HitLocation);
    OnProjectileHit(HitInfo);
    //return;    
}

simulated function OnProjectileHit(@NULL HitInfo)
{
    mReplicatedHitInfo = HitInfo;
    SpawnExplosionEffects(mReplicatedHitInfo.Location, mReplicatedHitInfo.Normal);
    MakeNoise(mImpactNoiseLevel, 'NOISE_ProjectileImpact');
    // End:0x96
    if((MyDamageType != none) && MyDamageType.default.DamageRadius > 0.0000000)
    {
        BlowUp(mReplicatedHitInfo.Location, mReplicatedHitInfo.Normal);        
    }
    else
    {
        RecordHitStat(mReplicatedHitInfo.Location, mReplicatedHitInfo.Normal);
    }
    // End:0xF9
    if((int(Role) == int(ROLE_Authority)) && !bNetTemporary || NetUpdateTime == 0.0000000)
    {
        SetPendingDestroy();        
    }
    else
    {
        Destroy();
    }
    //return;    
}

protected function SetPendingDestroy()
{
    NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
    LifeSpan = mPendingCleanupLifeSpan;
    SetPhysics(0);
    SetCollision(false, false);
    // End:0x4C
    if(CollisionComponent != none)
    {
        CollisionComponent.SetBlockRigidBody(false);
    }
    SetHidden(true);
    //return;    
}

simulated function ProjectileBluntImpact(@NULL repHitInfo)
{
    local @NULL TP, HitInfo;

    // End:0x99
    if(mCauseBluntImpact)
    {
        TP = TurokPawn(ImpactedActor);
        // End:0x99
        if(TP != none)
        {
            HitInfo.HitComponent = TP.Mesh;
            HitInfo.BoneName = 'jt_Cog_C';
            TP.TakeImpact(Class'TurokDamageTypeProjBluntImpact', 0.0000000, repHitInfo.Location, vect(0.0000000, 0.0000000, 0.0000000), HitInfo);
        }
    }
    //return;    
}

function float (@NULL HitActor)
{
    local float hitDamage;
    local int hitIndex;
    local @NULL hitPawn;

    hitPawn = TurokPawn(HitActor);
    hitDamage = mAIDamage;
    // End:0x7F
    if((hitPawn != none) && mAIPawnDamageOverride.Length > 0)
    {
        hitIndex = mAIPawnDamageOverride.Find(self, @NULL);
        @NULL
        hitPawn.mPawnName
        // End:0x7F
        if(hitIndex >= 0)
        {
            hitDamage = mAIPawnDamageOverride[hitIndex].mHitDamage;
            return hitDamage;
        }
    }
    //return ReturnValue;    
    @NULL
    default.@NULL
    @NULL
}

simulated function OverrideDamage(@NULL Victim, out float currentDamage)
{
    // End:0x70
    if((((Instigator != none) && Instigator.Controller != none) && TurokPlayerController(Instigator.Controller) == none) || (InstigatorController != none) && TurokPlayerController(InstigatorController) == none)
    {
        currentDamage = GetAIHitDamage(Victim);
    }
    //return;    
}

simulated function bool GetExploded()
{
    return mbExploded;
    //return ReturnValue;    
}

simulated function SetExploded(bool bExploded)
{
    mbExploded = bExploded;
    //return;    
}

function @NULL (@NULL hitMaterial)
{
    local int impactIndex;
    local @NULL physProperty;

    impactIndex = 0;
    // End:0x35
    if(hitMaterial != none)
    {
        physProperty = TurokPhysMatProperty(hitMaterial.GetPhysicalMaterialProperty(Class'TurokPhysMatProperty'));
    }
    // End:0x86
    if((physProperty != none) && physProperty.mPhysMaterialName != 'None')
    {
        impactIndex = Max(0, mImpactEffects.Find(self, @NULL), @NULL, physProperty.mPhysMaterialName);
        return mImpactEffects[impactIndex];
    }
    //return ReturnValue;    
    @NULL
    default.@NULL
    @NULL
}

simulated function bool ShouldPlayExplosionEffect()
{
    return true;
    //return ReturnValue;    
}

simulated function bool RandomizeExplosionDecal()
{
    return true;
    //return ReturnValue;    
}

simulated function GetSpawnExplosionTraceExtents(@NULL HitLocation, @NULL HitNormal, out @NULL StartTrace, out @NULL EndTrace)
{
    StartTrace = HitLocation;
    EndTrace = HitLocation + (HitNormal * 20.0000000);
    //return;    
}

simulated function bool DoSecondarySpawnExplosionTrace()
{
    return true;
    //return ReturnValue;    
}

simulated function SpawnDecalImpactEffects(@NULL HitLocation, @NULL HitNormal)
{
    local @NULL HitInfo, HitActor, hitPawn;
    local float decalSize;
    local @NULL StartTrace, EndTrace, newHitLocation, newHitNormal, impactRot, ImpactEffect,
	    cachedDecal, emitterPool, hitMaterial, boneMaterial;

    // End:0x2E
    if((Instigator != none) && !Instigator.EffectIsRelevant(HitLocation, false))
    {
        return;
    }
    emitterPool = Class'TurokPlayerController'.static.GetLocalPlayerController().GetEmitterManager();
    GetSpawnExplosionTraceExtents(HitLocation, HitNormal, StartTrace, EndTrace);
    HitActor = Trace(newHitLocation, newHitNormal, EndTrace, StartTrace, true,, HitInfo);
    // End:0x114
    if((HitActor == none) && DoSecondarySpawnExplosionTrace())
    {
        EndTrace = HitLocation + (-HitNormal * 20.0000000);
        HitActor = Trace(newHitLocation, newHitNormal, EndTrace, StartTrace, true,, HitInfo);
        // End:0x111
        if(HitActor == none)
        {
            newHitLocation = HitLocation;
            newHitNormal = HitNormal;
        }        
    }
    else
    {
        // End:0x135
        if(HitActor == none)
        {
            newHitLocation = HitLocation;
            newHitNormal = HitNormal;
        }
    }
    // End:0x1D1
    if(mImpactEffects.Length > 0)
    {
        hitMaterial = HitInfo.PhysMaterial;
        hitPawn = TurokPawn(HitActor);
        // End:0x1BC
        if(hitPawn != none)
        {
            boneMaterial = hitPawn.GetImpactMaterial(hitPawn.Mesh.PhysicsAsset, HitInfo);
            // End:0x1BC
            if(boneMaterial != none)
            {
                hitMaterial = boneMaterial;
            }
        }
        ImpactEffect = GetImpactEffect(hitMaterial);
    }
    // End:0x2F2
    if((HitActor != none) && ImpactEffect.mDecalMaterial != none)
    {
        impactRot = Rotator(-newHitNormal);
        // End:0x26A
        if(RandomizeExplosionDecal())
        {
            impactRot.Roll = int(FRand() * float(65535));
            decalSize = ImpactEffect.mDecalMinSize + ((ImpactEffect.mDecalMaxSize - ImpactEffect.mDecalMinSize) * FRand());            
        }
        else
        {
            decalSize = ImpactEffect.mDecalMinSize;
        }
        cachedDecal = emitterPool.GetDecal(newHitLocation);
        HitActor.AddDecal(ImpactEffect.mDecalMaterial, newHitLocation, impactRot, 0.0000000, decalSize, decalSize, 10.0000000, false, HitInfo.HitComponent, none, false, false, cachedDecal);
    }
    //return;    
}

simulated function SpawnExplosionEffects(@NULL HitLocation, @NULL HitNormal, optional bool EnableDecalImpactEffect = true, optional bool EnableImpactEffect = true)
{
    local @NULL HitInfo, HitActor, hitPawn;
    local float decalSize;
    local @NULL StartTrace, EndTrace, newHitLocation, newHitNormal, impactRot, ImpactEffect,
	    cachedDecal, emitterPool, hitMaterial, boneMaterial;

    StopAmbience();
    // End:0x42
    if((Instigator != none) && !Instigator.EffectIsRelevant(HitLocation, false))
    {
        return;
    }
    emitterPool = Class'TurokPlayerController'.static.GetLocalPlayerController().GetEmitterManager();
    GetSpawnExplosionTraceExtents(HitLocation, HitNormal, StartTrace, EndTrace);
    HitActor = Trace(newHitLocation, newHitNormal, EndTrace, StartTrace, true,, HitInfo);
    // End:0x128
    if((HitActor == none) && DoSecondarySpawnExplosionTrace())
    {
        EndTrace = HitLocation + (-HitNormal * 20.0000000);
        HitActor = Trace(newHitLocation, newHitNormal, EndTrace, StartTrace, true,, HitInfo);
        // End:0x125
        if(HitActor == none)
        {
            newHitLocation = HitLocation;
            newHitNormal = HitNormal;
        }        
    }
    else
    {
        // End:0x149
        if(HitActor == none)
        {
            newHitLocation = HitLocation;
            newHitNormal = HitNormal;
        }
    }
    // End:0x1B1
    if((mExplosionTemplate != none) && ShouldPlayExplosionEffect())
    {
        impactRot = Rotator(newHitNormal);
        impactRot.Pitch -= 16384;
        TurokEmitter(emitterPool.GetEmitter(mExplosionTemplate, Instigator, newHitLocation, impactRot));
    }
    // End:0x2E0
    if((mImpactEffects.Length > 0) && EnableImpactEffect)
    {
        hitMaterial = HitInfo.PhysMaterial;
        hitPawn = TurokPawn(HitActor);
        // End:0x243
        if(hitPawn != none)
        {
            boneMaterial = hitPawn.GetImpactMaterial(hitPawn.Mesh.PhysicsAsset, HitInfo);
            // End:0x243
            if(boneMaterial != none)
            {
                hitMaterial = boneMaterial;
            }
        }
        ImpactEffect = GetImpactEffect(hitMaterial);
        // End:0x2E0
        if((HitActor != none) && ImpactEffect.mImpactSystem != none)
        {
            impactRot = Rotator(newHitNormal);
            impactRot.Pitch -= 16384;
            TurokEmitter(emitterPool.GetEmitter(ImpactEffect.mImpactSystem, Instigator, newHitLocation, impactRot, ImpactEffect.mImpactSystemSortMethod));
        }
    }
    // End:0x40F
    if(((HitActor != none) && ImpactEffect.mDecalMaterial != none) && EnableDecalImpactEffect == true)
    {
        impactRot = Rotator(-newHitNormal);
        // End:0x387
        if(RandomizeExplosionDecal())
        {
            impactRot.Roll = int(FRand() * float(65535));
            decalSize = ImpactEffect.mDecalMinSize + ((ImpactEffect.mDecalMaxSize - ImpactEffect.mDecalMinSize) * FRand());            
        }
        else
        {
            decalSize = ImpactEffect.mDecalMinSize;
        }
        cachedDecal = emitterPool.GetDecal(newHitLocation);
        HitActor.AddDecal(ImpactEffect.mDecalMaterial, newHitLocation, impactRot, 0.0000000, decalSize, decalSize, 10.0000000, false, HitInfo.HitComponent, none, false, false, cachedDecal);
    }
    // End:0x454
    if(ImpactEffect.mImpactSound.Length > 0)
    {
        mSoundController.TryPlayLocalSoundAt(ImpactEffect.mImpactSound[0], newHitLocation, false);        
    }
    //return;    
}

simulated function RecordHitStat(@NULL HitLocation, @NULL HitNormal)
{
    local @NULL StartTrace, EndTrace, HitActor, HitInfo, Impact;

    local array ImpactList;

    // End:0x147
    if((TurokWeapon(Owner) != none) && TurokPlayerController(InstigatorController) != none)
    {
        StartTrace = HitLocation + (HitNormal * 5.0000000);
        EndTrace = StartTrace + (-HitNormal * 20.0000000);
        HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true,, HitInfo);
        // End:0x147
        if(HitActor != none)
        {
            Impact.HitActor = HitActor;
            Impact.HitLocation = HitLocation;
            Impact.HitNormal = HitNormal;
            Impact.RayDir = Normal(HitLocation - StartTrace);
            Impact.HitInfo = HitInfo;
            ImpactList[ImpactList.Length] = Impact;
            // End:0x147
            if(TurokPlayerController(InstigatorController) != none)
            {
                TurokPlayerController(InstigatorController).RecordShotHit(TurokWeapon(Owner), ImpactList, Class);
            }
        }
    }
    //return;    
}

simulated function PlayImpactSound(@NULL impactSoundCue)
{
    // End:0x2E
    if(impactSoundCue != none)
    {
        mSoundController.TryPlayLocalSoundAt(impactSoundCue, Location);        
    }
    //return;    
}

simulated function ApplyImpulse(@NULL Impulse)
{
    //return;    
}

defaultproperties
{
    // Reference: TurokSoundController'Default__TurokProjectile.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent class=Class'TurokSoundController'
    end object
    mSoundController=TurokSoundControllerComponent
    mProjAmbienceSndChannel=-1
    mPlayAmbienceOnSpawn=true
    mbDoTraceToTopOfHurtActor=true
    mbReplicateProjectileHit=true
    // Reference: TurokRadialShakeComponent'Default__TurokProjectile.Shakey'
    begin object name=Shakey class=Class'TurokRadialShakeComponent'
        Duration=5.0000000
        Radius=2500.0000000
        mParams=(mRollAmplitude=0.5000000,mRollFrequency=4.0000000,mPitchAmplitude=0.7500000,mPitchFrequency=3.0000000,mYawAmplitude=1.0000000,mYawFrequency=3.0000000,mXAmplitude=0.0000000,mXFrequency=0.0000000,mYAmplitude=0.0000000,mYFrequency=0.0000000,mZAmplitude=0.8000000,mZFrequency=2.0000000)
    end object
    mExplosionShake=Shakey
    mPendingCleanupLifeSpan=1.5000000
    MyDamageType=Class'TurokDamageTypeDefault'
    // Reference: CylinderComponent'Default__TurokProjectile.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    mDefaultTraceTypeFlags=65536
    mDefaultTraceSourceFlags=4100
    bNetTemporary=false
    // Reference: SpriteComponent'Default__TurokProjectile.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    Components[2]=TurokSoundControllerComponent
    CollisionComponent=CollisionCylinder
}