class TurokStickyProjectile extends TurokProjectile
    abstract
    native
    nativereplication
    config(Projectile)
    hidecategories(Navigation);

struct native StickHitInfo
{
    var @NULL Location;
    var @NULL Normal;
    var @NULL Rotation;
    var @NULL Actor;
    var name bone;
    var export editinline @NULL HitComponent;

    structdefaultproperties
    {
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Normal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(Pitch=0,Yaw=0,Roll=0)
        Actor=none
        bone="None"
        HitComponent=none
    }
};

struct native ReplicatedStickyHit
{
    var @NULL Location;
    var @NULL Normal;
    var @NULL Rotation;
    var @NULL Actor;

    structdefaultproperties
    {
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Normal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(Pitch=0,Yaw=0,Roll=0)
        Actor=none
    }
};

var const bool mbStickDamage;
var const bool mbStickPersistent;
var protected bool mbIsStuckToPawn;
var protected @NULL mSpawnLocation;
var protected @NULL mStuckToPawn;
var protected @NULL mStuckToVehicle;
var protected @NULL mStuckToDoor;
var protected @NULL mStuckToDynamic;
var protected @NULL mStuckToDestroyableActorBase;
var protected @NULL mStickInfo;
var protected export editinline @NULL mStuckToDesComponent;
var protected @NULL mStuckToDynamicPos;
var(DelayedExplosion) float mDelayExplosionTime;
var(DelayedExplosion) float mDelayExplosionTimeMP;
var protected repnotify @NULL mReplicatedStickyHit;

replication
{
    // Pos:0x000
    if(bNetDirty
        mReplicatedStickyHit;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x1B
    if(VarName == 'mReplicatedStickyHit')
    {
        OnReplicatedStickyHit();
        return;
    }
    super.ReplicatedEvent(VarName);
    //return;    
}

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    mSpawnLocation = Location;
    //return;    
}

simulated event Destroyed()
{
    super(Actor).Destroyed();
    //return;    
}

simulated function Tick(float DeltaTime)
{
    local @NULL turokProjStickyGun;

    super.Tick(DeltaTime);
    turokProjStickyGun = TurokProjStickyGunNative(self);
    // End:0x22
    if(mbStickPersistent)
    {
        return;
    }
    // End:0x9B
    if(((mStuckToPawn != none) && !Instigator.CanHurt(mStuckToPawn)) || (mbIsStuckToPawn == true) && (mStuckToPawn == none) || mStuckToPawn.bDeleteMe)
    {
        SetPhysics(2);
        bCollideWorld = true;
        mStuckToPawn = none;
        mbIsStuckToPawn = false;        
    }
    else
    {
        // End:0xD5
        if((mStuckToDoor != none) && mStuckToDoor.IsDoorMoving())
        {
            SetPhysics(2);
            bCollideWorld = true;
            mStuckToDoor = none;            
        }
        else
        {
            // End:0x10E
            if((mStuckToDynamic != none) && mStuckToDynamic.bHidden == true)
            {
                SetPhysics(2);
                bCollideWorld = true;
                mStuckToDynamic = none;                
            }
            else
            {
                // End:0x167
                if(((mStuckToVehicle != none) && turokProjStickyGun != none) && turokProjStickyGun.mTriggerMode == true)
                {
                    SetPhysics(2);
                    bCollideWorld = true;
                    mStuckToVehicle = none;
                    turokProjStickyGun.Kaboom();                    
                }
                else
                {
                    // End:0x1A4
                    if((mStuckToVehicle != none) && mStuckToVehicle.NumPassengers() > 0)
                    {
                        SetPhysics(2);
                        bCollideWorld = true;
                        mStuckToVehicle = none;                        
                    }
                    else
                    {
                        // End:0x1DE
                        if((mStuckToDesComponent != none) && mStuckToDesComponent.IsDestroyed())
                        {
                            SetPhysics(2);
                            bCollideWorld = true;
                            mStuckToDesComponent = none;                            
                        }
                        else
                        {
                            // End:0x218
                            if((mStuckToDestroyableActorBase != none) && int(mStuckToDestroyableActorBase.mBaseDestroyableState) != int(0))
                            {
                                SetPhysics(2);
                                bCollideWorld = true;
                                mStuckToDestroyableActorBase = none;
                            }
                        }
                    }
                }
            }
        }
    }
    //return;    
}

simulated function DelayedExplosionTimer()
{
    local @NULL explodeLoc, explodeNorm;

    explodeLoc = mStickInfo.Location;
    explodeNorm = mStickInfo.Normal;
    // End:0x9E
    if(TurokPawn(mStickInfo.Actor) != none)
    {
        // End:0x9E
        if(mStickInfo.bone != 'None')
        {
            explodeLoc = TurokPawn(mStickInfo.Actor).Mesh.GetBoneLocation(mStickInfo.bone);
        }
    }
    SpawnExplosionEffects(explodeLoc, explodeNorm);
    RecordHitStat(explodeLoc, explodeNorm);
    MakeNoise(mImpactNoiseLevel, 'NOISE_ProjectileImpact');
    // End:0x112
    if((MyDamageType != none) && MyDamageType.default.DamageRadius > 0.0000000)
    {
        BlowUp(explodeLoc, explodeNorm);
    }
    Destroy();
    //return;    
}

simulated function ApplyStickImpact(@NULL HitLocation, @NULL tPawn, out @NULL HitInfo)
{
    local float locdamage;

    locdamage = Damage;
    // End:0x54
    if(tPawn != none)
    {
        tPawn.TakeImpact(MyDamageType, locdamage, HitLocation, MyDamageType.default.RadialDamageImpulse * Normal(Velocity), HitInfo);
    }
    //return;    
}

simulated function ApplyStickDamage(float hitDamage, @NULL HitLoc, @NULL HitInfo)
{
    // End:0x51
    if(ImpactedActor != none)
    {
        ImpactedActor.TakeDamage(int(hitDamage), InstigatorController, HitLoc, MyDamageType.default.RadialDamageImpulse * Normal(Velocity), MyDamageType, HitInfo);
    }
    //return;    
}

simulated event TornOff()
{
    //return;    
}

protected function SetPendingDestroy()
{
    super.SetPendingDestroy();
    bTearOff = true;
    //return;    
}

protected final simulated function OnReplicatedStickyHit()
{
    local @NULL HitInfo, tPawn;

    mStickInfo.Location = mReplicatedStickyHit.Location;
    mStickInfo.Normal = mReplicatedStickyHit.Normal / 100.0000000;
    mStickInfo.Rotation = mReplicatedStickyHit.Rotation;
    mStickInfo.Actor = mReplicatedStickyHit.Actor;
    tPawn = TurokPawn(mStickInfo.Actor);
    // End:0x127
    if(tPawn != none)
    {
        tPawn.CheckHitInfo(HitInfo, tPawn.Mesh, mStickInfo.Normal, mStickInfo.Location, true);
        mStickInfo.bone = HitInfo.BoneName;
        mStickInfo.HitComponent = HitInfo.HitComponent;
    }
    OnStickyProjectileHit(mStickInfo, HitInfo);
    //return;    
}

protected final function SetReplicatedStickyHit(@NULL stickyHit)
{
    local @NULL ReplicatedHit;

    mStickInfo = stickyHit;
    ReplicatedHit.Location = mStickInfo.Location;
    ReplicatedHit.Normal = mStickInfo.Normal * float(100);
    ReplicatedHit.Rotation = mStickInfo.Rotation;
    ReplicatedHit.Actor = mStickInfo.Actor;
    mReplicatedStickyHit = ReplicatedHit;
    bReplicateMovement = false;
    //return;    
}

simulated function OnStickyProjectileHit(@NULL stickyHit, @NULL HitInfo)
{
    local @NULL tPawn, tDoor, tDesActor, tVehicle;
    local float explodeDelay;
    local @NULL tDestroyableActor, tDestroyableActorBase;

    // End:0x17
    if(mbIsMultiPlayer)
    {
        explodeDelay = mDelayExplosionTimeMP;        
    }
    else
    {
        explodeDelay = mDelayExplosionTime;
    }
    // End:0x47
    if(explodeDelay > 0.0000000)
    {
        SetTimer(explodeDelay, false, 'DelayedExplosionTimer');        
    }
    else
    {
        // End:0x7D
        if(mPlayAmbienceOnSpawn)
        {
            SpawnExplosionEffects(stickyHit.Location, stickyHit.Normal);            
        }
        else
        {
            SetAmbience(mProjAmbientSndCue);
        }
    }
    RecordHitStat(stickyHit.Location, stickyHit.Normal);
    mStuckToPawn = none;
    mStuckToVehicle = none;
    mStuckToDoor = none;
    mStuckToDynamic = none;
    mStuckToDesComponent = none;
    tPawn = TurokPawn(stickyHit.Actor);
    tDoor = TurokDoorActor(stickyHit.Actor);
    tDesActor = DynamicSMActor(stickyHit.Actor);
    tVehicle = TurokVehicle(stickyHit.Actor);
    tDestroyableActor = TurokDestroyableActor(stickyHit.Actor);
    tDestroyableActorBase = TurokDestroyableActorBase(stickyHit.Actor);
    mbIsStuckToPawn = false;
    bCollideWorld = false;
    // End:0x261
    if(tPawn != none)
    {
        // End:0x25E
        if(stickyHit.bone != 'None')
        {
            SetBase(none);
            SetHardAttach(true);
            SetPhysics(0);
            SetLocation(stickyHit.Location);
            SetBase(tPawn,, tPawn.Mesh, stickyHit.bone);
            mStuckToPawn = tPawn;
            mbIsStuckToPawn = true;
            // End:0x25E
            if(mbStickDamage)
            {
                // End:0x25E
                if((Instigator == none) || Instigator.CanHurt(tPawn))
                {
                    ApplyStickImpact(stickyHit.Location, tPawn, HitInfo);
                }
            }
        }        
    }
    else
    {
        // End:0x2B4
        if(tVehicle != none)
        {
            SetBase(none);
            SetHardAttach(true);
            SetPhysics(0);
            SetLocation(stickyHit.Location);
            SetBase(stickyHit.Actor);
            mStuckToVehicle = tVehicle;            
        }
        else
        {
            // End:0x318
            if(tDoor != none)
            {
                SetBase(none);
                SetHardAttach(true);
                SetPhysics(0);
                SetLocation(stickyHit.Location);
                SetBase(tDoor,, tDoor.mPryDoorMesh, stickyHit.bone);
                mStuckToDoor = tDoor;                
            }
            else
            {
                // End:0x375
                if(tDesActor != none)
                {
                    SetBase(none);
                    SetHardAttach(true);
                    SetPhysics(0);
                    SetLocation(stickyHit.Location);
                    SetBase(tDesActor);
                    mStuckToDynamic = tDesActor;
                    mStuckToDynamicPos = mStuckToDynamic.Location;                    
                }
                else
                {
                    // End:0x3CD
                    if(tDestroyableActor != none)
                    {
                        SetBase(none);
                        SetHardAttach(true);
                        SetPhysics(0);
                        SetLocation(stickyHit.Location);
                        SetBase(tDestroyableActor);
                        mStuckToDesComponent = TurokDestroyableComponent(stickyHit.HitComponent);                        
                    }
                    else
                    {
                        // End:0x416
                        if(tDestroyableActorBase != none)
                        {
                            SetBase(none);
                            SetHardAttach(true);
                            SetPhysics(0);
                            SetLocation(stickyHit.Location);
                            SetBase(tDestroyableActorBase);
                            mStuckToDestroyableActorBase = tDestroyableActorBase;                            
                        }
                        else
                        {
                            SetBase(none);
                            SetHardAttach(true);
                            SetPhysics(0);
                            SetLocation(stickyHit.Location);
                            SetRotation(stickyHit.Rotation);
                            SetBase(stickyHit.Actor);
                        }
                    }
                }
            }
        }
    }
    // End:0x4B8
    if(int(Role) == int(ROLE_Authority))
    {
        MakeNoise(mImpactNoiseLevel, 'NOISE_ProjectileImpact');
        stickyHit.Location = Location;
        stickyHit.Rotation = Rotation;
        SetReplicatedStickyHit(stickyHit);
    }
    //return;    
}

simulated function Explode(@NULL HitLocation, @NULL HitNormal)
{
    local @NULL HitInfo, stickyHit, tPawn, tDesActor;

    // End:0x0B
    if(mbExploded)
    {
        return;
    }
    mbExploded = true;
    StopAmbience();
    stickyHit.Location = HitLocation;
    stickyHit.Normal = HitNormal;
    stickyHit.Rotation = Rotation;
    stickyHit.Actor = ImpactedActor;
    // End:0x1A9
    if((ImpactedActor != none) && ImpactedActor != Base)
    {
        tPawn = TurokPawn(ImpactedActor);
        tDesActor = TurokDestroyableActor(ImpactedActor);
        // End:0x13D
        if(tPawn != none)
        {
            ImpactedActor.CheckHitInfo(HitInfo, tPawn.Mesh, Normal(Velocity), HitLocation, true);
            stickyHit.Location = HitLocation;
            stickyHit.bone = HitInfo.BoneName;
            stickyHit.HitComponent = HitInfo.HitComponent;            
        }
        else
        {
            // End:0x1A9
            if(tDesActor != none)
            {
                // End:0x18A
                if(HitInfo.HitComponent == none)
                {
                    HitInfo.HitComponent = tDesActor.TraceDestroyableComponents(HitLocation, HitNormal);
                }
                stickyHit.HitComponent = HitInfo.HitComponent;
            }
        }
    }
    // End:0x1FF
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x1E5
        if(mbStickDamage)
        {
            ApplyStickDamage(Damage, stickyHit.Location, HitInfo);
        }
        SetCollision(false, false);
        OnStickyProjectileHit(stickyHit, HitInfo);
    }
    //return;    
}

defaultproperties
{
    // Reference: TurokSoundController'Default__TurokStickyProjectile.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    mbReplicateProjectileHit=false
    // Reference: TurokRadialShakeComponent'Default__TurokStickyProjectile.Shakey'
    begin object name=Shakey
    end object
    mExplosionShake=Shakey
    // Reference: CylinderComponent'Default__TurokStickyProjectile.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    bOnlyDirtyReplication=true
    bHardAttach=true
    // Reference: SpriteComponent'Default__TurokStickyProjectile.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    Components[2]=TurokSoundControllerComponent
    CollisionComponent=CollisionCylinder
}