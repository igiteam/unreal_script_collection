class TurokProjStickyGunNative extends TurokStickyProjectile
    native
    config(WeapStickyGun)
    hidecategories(Navigation);

var config float mTriggerRadius;
var config int mTriggerFragmentNum;
var config float mTriggerFragmentRadius;
var config float mTriggerDelayTime;
var config float mFalloffDistance;
var config float mFalloffDistanceMP;
var config float mExplosionNoise;
var config float mBlowUpDelayTime;
var const bool mTriggerMode;
var protected bool mTriggerActive;
var protected bool mTriggerExploded;
var protected const bool mbDebugDraw;
var protected const export editinline @NULL mGrenadePS;
var protected const @NULL mFragmentPS;
var protected const @NULL mClusterExplosionTemplate;
var protected const @NULL mSingleBlobAmbienceSndCue;
var protected const @NULL mMultiBlobAmbienceSndCue;
var protected const @NULL mSingleBlobStuckSndCue;
var protected const @NULL mMultiBlobStuckSndCue;
var protected const @NULL mSingleBlobExplodeSndCue;
var protected const @NULL mMultiBlobExplodeSndCue;
var protected export editinline array mFragmentPSs;
var protected @NULL mCreator;

// Export UTurokProjStickyGunNative::execFragmentsTrace(FFrame&, void* const)
native function @NULL FragmentsTrace(out @NULL HitLocation, out @NULL HitNormal, @NULL TraceEnd, @NULL TraceStart);

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x35
    if(mbIsMultiPlayer && TurokCoopGameReplicationInfo(WorldInfo.GRI) == none)
    {
        mFalloffDistance = mFalloffDistanceMP;
    }
    // End:0x49
    if(mTriggerMode)
    {
        mExplosionTemplate = mExplosionTemplateSecondary;
    }
    //return;    
}

simulated event Destroyed()
{
    TriggerDestroy();
    super.Destroyed();
    //return;    
}

simulated function Tick(float DeltaTime)
{
    local float Distance, RndDelayTime;

    // End:0x38
    if((mStuckToPawn != none) && mStuckToPawn.Health <= 0)
    {
        SetPhysics(2);
        bCollideWorld = true;
        mStuckToPawn = none;        
    }
    else
    {
        // End:0xCC
        if((mStuckToDoor != none) && mStuckToDoor.IsDoorMoving())
        {
            // End:0xB5
            if(int(Role) == int(ROLE_Authority))
            {
                // End:0xB5
                if(((mTriggerMode == true) && mTriggerActive == true) && mTriggerExploded == false)
                {
                    RndDelayTime = FRand() * mTriggerDelayTime;
                    SetTimer(RndDelayTime, false, 'DelayedTriggerBlowUp');
                }
            }
            SetPhysics(2);
            bCollideWorld = true;
            mStuckToDoor = none;            
        }
        else
        {
            // End:0x129
            if((mStuckToDynamic != none) && mStuckToDynamic.Location != mStuckToDynamicPos)
            {
                // End:0x122
                if((int(Role) == int(ROLE_Authority)) && mCreator != none)
                {
                    mCreator.SMDynamicActorMovedTriggerProjCleanup(self);
                }
                mStuckToDynamic = none;
            }
        }
    }
    super.Tick(DeltaTime);
    // End:0x16C
    if(int(Physics) == int(6))
    {
        Distance = VSize(mSpawnLocation - Location);
        // End:0x16C
        if(Distance > mFalloffDistance)
        {
            SetPhysics(2);
        }
    }
    //return;    
}

simulated event TornOff()
{
    super.TornOff();
    Kaboom();
    Destroy();
    //return;    
}

simulated function bool HurtRadius(float DamageAmount, float InDamageRadius, class<Class> DamageType, float Momentum, @NULL HurtOrigin, optional @NULL IgnoredActor, optional @NULL InstigatedByController = ((Instigator != none) ? Instigator.Controller : none), optional bool bDoFullDamage, optional bool bTraceToTopOfBBox)
{
    local int stuckPawnHealth;
    local bool bCausedDamage;
    local @NULL Victim;

    // End:0x42
    if(mStuckToPawn != none)
    {
        stuckPawnHealth = mStuckToPawn.Health;
    }
    bCausedDamage = super(TurokProjectile).HurtRadius(DamageAmount, InDamageRadius, DamageType, Momentum, HurtOrigin, IgnoredActor, InstigatedByController, bDoFullDamage, bTraceToTopOfBBox);
    // End:0xEA
    if(mStuckToPawn != none)
    {
        // End:0xEA
        if(mStuckToPawn.Health == stuckPawnHealth)
        {
            mStuckToPawn.TakeDamage(int(DamageAmount), InstigatedByController, mStuckToPawn.Location, vect(0.0000000, 0.0000000, 0.0000000), DamageType,, self);
            bCausedDamage = true;
        }
    }
    // End:0x150
    foreach OverlappingActors(Class'TurokProjStickyGunNative', Victim, mTriggerRadius)
    {
        // End:0x14F
        if(Victim != self)
        {
            Victim.TakeDamage(int(DamageAmount), InstigatedByController, Location, vect(0.0000000, 0.0000000, 0.0000000), DamageType,, self);
            bCausedDamage = true;
        }        
    }    
    return bCausedDamage;
    //return ReturnValue;    
}

private final function TriggerActivate()
{
    mTriggerActive = true;
    // End:0x2C
    if(mbDebugDraw)
    {
        DrawDebugSphere(Location, mTriggerRadius, 10, 0, byte(255), 0, true);
    }
    //return;    
}

private final function TriggerDestroy()
{
    mTriggerActive = false;
    //return;    
}

private final function TriggerBlowUp()
{
    TriggerDestroy();
    DetonateStickyProjectile();
    //return;    
}

event TakeDamage(int DamageAmount, @NULL EventInstigator, @NULL HitLocation, @NULL Momentum, class<Class> DamageType, optional @NULL HitInfo, optional @NULL DamageCauser)
{
    // End:0x4C
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x4C
        if(((mTriggerMode == true) && mTriggerActive == true) && mTriggerExploded == false)
        {
            mTriggerActive = false;
            Kaboom();
        }
    }
    //return;    
}

simulated function BlowUp(@NULL HitLocation, @NULL HitNormal)
{
    StopAmbience();
    super(TurokProjectile).BlowUp(HitLocation, HitNormal);
    // End:0x34
    if(int(Role) == int(ROLE_Authority))
    {
        SetPendingDestroy();
    }
    //return;    
}

simulated function PlayProjStickyGunExplosion()
{
    local @NULL cue;

    // End:0x17
    if(mTriggerMode)
    {
        cue = mMultiBlobExplodeSndCue;        
    }
    else
    {
        cue = mSingleBlobExplodeSndCue;
    }
    // End:0x50
    if(cue != none)
    {
        mSoundController.TryPlayLocalSoundAt(cue, Location);        
    }
    //return;    
}

function DetonateStickyProjectile()
{
    // End:0x0B
    if(mTriggerExploded)
    {
        return;
    }
    mTriggerExploded = true;
    Kaboom();
    //return;    
}

simulated function SpawnFragments(@NULL Hit)
{
    local int I;
    local @NULL Offset, Mesh, startLoc, endLoc, HitLoc, HitNorm,
	    HitActor, impactRot, emitterPool;

    mGrenadePS.SetHidden(true);
    // End:0x3E
    if(mbDebugDraw)
    {
        DrawDebugSphere(Hit.Location, mTriggerFragmentRadius, 4, 0, 0, byte(255), true);
    }
    I = 0;
    J0x45:

    // End:0x25A [Loop If]
    if(I < mTriggerFragmentNum)
    {
        Offset.X = (FRand() - 0.5000000) * mTriggerFragmentRadius;
        Offset.Y = (FRand() - 0.5000000) * mTriggerFragmentRadius;
        Offset.Z = (FRand() - 0.5000000) * mTriggerFragmentRadius;
        startLoc = (Hit.Location + Offset) + ((2.0000000 * mTriggerFragmentRadius) * Hit.Normal);
        endLoc = (Hit.Location + Offset) - ((2.0000000 * mTriggerFragmentRadius) * Hit.Normal);
        // End:0x17C
        if(mbDebugDraw)
        {
            DrawDebugSphere(Hit.Location + Offset, 2.0000000, 4, byte(255), byte(255), 0, true);
            DrawDebugLine(startLoc, endLoc, byte(255), byte(255), 0, true);
        }
        HitActor = FragmentsTrace(HitLoc, HitNorm, endLoc, startLoc);
        // End:0x250
        if(HitActor != none)
        {
            // End:0x1CF
            if(mbDebugDraw)
            {
                DrawDebugSphere(HitLoc, 2.0000000, 4, byte(255), 0, 0, true);
            }
            Mesh = new (self) Class'Engine.ParticleSystemComponent';
            Mesh.SetTranslation(HitLoc - Hit.Location);
            Mesh.SetRotation(RotRand());
            Mesh.SetTemplate(mFragmentPS);
            AttachComponent(Mesh);
            mFragmentPSs[mFragmentPSs.Length] = Mesh;
        }
        I++;
        // [Loop Continue]
        goto J0x45;
    }
    // End:0x2D7
    if(mExplosionTemplate != none)
    {
        impactRot = Rotator(Hit.Normal);
        impactRot.Pitch -= 16384;
        emitterPool = Class'TurokPlayerController'.static.GetLocalPlayerController().GetEmitterManager();
        emitterPool.GetEmitter(mClusterExplosionTemplate, self, Location, impactRot);
    }
    //return;    
}

simulated function OnStickyProjectileHit(@NULL stickyHit, @NULL HitInfo)
{
    // End:0x32
    if(mTriggerMode)
    {
        mProjAmbientSndCue = mMultiBlobAmbienceSndCue;
        mSoundController.TryPlayLocalSound(mMultiBlobStuckSndCue);        
    }
    else
    {
        mProjAmbientSndCue = mSingleBlobAmbienceSndCue;
        mSoundController.TryPlayLocalSound(mSingleBlobStuckSndCue);
    }
    super.OnStickyProjectileHit(stickyHit, HitInfo);
    mCreator = TurokWeapStickyGunNative(Owner);
    // End:0xD4
    if(mTriggerMode)
    {
        TriggerActivate();
        bProjTarget = true;
        LifeSpan = 0.0000000;
        SetOwner(none);
        bCollideWorld = true;
        SetCollisionSize(mTriggerFragmentRadius, mTriggerFragmentRadius);
        SetCollision(true, false);
        SetBase(none);
        CylinderComponent.SetTraceBlocking(true, true);        
    }
    else
    {
        SetCollision(false, false);
    }
    // End:0x194
    if(mTriggerMode == true)
    {
        SetRotation(rot(0, 0, 0));
        SpawnFragments(stickyHit);
        // End:0x153
        if(mbDebugDraw)
        {
            DrawDebugLine(stickyHit.Location, stickyHit.Location + (20.0000000 * stickyHit.Normal), byte(255), 0, 0, true);
        }
        // End:0x194
        if((int(Role) == int(ROLE_Authority)) && mStuckToPawn != none)
        {
            // End:0x194
            if((mTriggerActive == true) && mTriggerExploded == false)
            {
                Kaboom();
            }
        }
    }
    //return;    
}

simulated function Kaboom()
{
    local int I;
    local bool bEnableImpactEffect;

    // End:0x30
    if(mTriggerMode && TurokPawn(mStickInfo.Actor) != none)
    {
        bEnableImpactEffect = false;        
    }
    else
    {
        bEnableImpactEffect = true;
    }
    SpawnExplosionEffects(Location, mStickInfo.Normal, true, bEnableImpactEffect);
    PlayProjStickyGunExplosion();
    mGrenadePS.SetHidden(true);
    I = 0;
    J0x7E:

    // End:0xA9 [Loop If]
    if(I < mFragmentPSs.Length)
    {
        DetachComponent(mFragmentPSs[I]);
        I++;
        // [Loop Continue]
        goto J0x7E;
    }
    mFragmentPSs.Length = 0;
    // End:0x15F
    if(MyDamageType.default.DamageRadius > 0.0000000)
    {
        // End:0x15F
        if(int(Role) == int(ROLE_Authority))
        {
            MakeNoise(mExplosionNoise, 'NOISE_ProjectileImpact');
            // End:0x141
            if(((mTriggerMode == true) && !IsTimerActive('DelayedTriggerBlowUp')) && TurokPawn(mStickInfo.Actor) == none)
            {
                SetTimer(mBlowUpDelayTime, false, 'DelayedTriggerBlowUp');
                return;                
            }
            else
            {
                BlowUp(Location, mStickInfo.Normal);
            }
        }
    }
    //return;    
}

private final function DelayedTriggerBlowUp()
{
    ClearTimer('DelayedTriggerBlowUp');
    BlowUp(Location, mStickInfo.Normal);
    //return;    
}

simulated event Touch(@NULL Other, @NULL HitLocation, @NULL HitNormal)
{
    // End:0x50
    if((!mTriggerActive || TurokPawn(Other) == none) || Instigator.GetStateName() == 'CinematicState')
    {
        super(Projectile).Touch(Other, HitLocation, HitNormal);
        return;
    }
    super(Projectile).Touch(Other, HitLocation, HitNormal);
    // End:0x85
    if(FastTrace(Other.Location, Location))
    {
        TriggerBlowUp();
    }
    //return;    
}

defaultproperties
{
    // Reference: TurokSoundController'Default__TurokProjStickyGunNative.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    mExplosionShakeEnable=true
    // Reference: TurokRadialShakeComponent'Default__TurokProjStickyGunNative.Shakey'
    begin object name=Shakey
    end object
    mExplosionShake=Shakey
    // Reference: CylinderComponent'Default__TurokProjStickyGunNative.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokProjStickyGunNative.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    Components[2]=TurokSoundControllerComponent
    LifeSpan=0.0000000
    CollisionComponent=CollisionCylinder
}