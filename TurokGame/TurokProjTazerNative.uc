class TurokProjTazerNative extends TurokProjectile
    native
    nativereplication
    config(Projectile)
    hidecategories(Navigation);

var(TazerBolt) float mBoltTargetRange;
var(TazerBolt) byte mMaxNumAffectedPawns;
var byte mPawnIndex;
var byte mNumAffectedPawns;
var(TazerBolt) float mMaxStunTime;
var(TazerBolt) float mStunReductionPct;
var(TazerBolt) float mBoltDurationBetweenPawns;
var(TazerBolt) @NULL mBoltPositionOffset;
var array mAffectedPawnList;
var bool mbBoltActivated;
var export editinline @NULL mCanisterMesh;
var export editinline @NULL mElectricalBoltMesh;
var @NULL mTazerFxFrontControl;
var @NULL mTazerFxBackControl;
var class<Class> TazerElectricalBoltDamageType;
var() float mRestitution;
var() float mProjectileSlowRate;
var() @NULL mMinQuietBounce;
var protected repnotify @NULL mElectricalBoltLoc;

replication
{
    // Pos:0x000
    if(bNetDirty
        mElectricalBoltLoc;
}

// Export UTurokProjTazerNative::execBuildElectricalBoltPawnList(FFrame&, void* const)
native function BuildElectricalBoltPawnList();

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    mElectricalBoltMesh.SetHidden(true);
    mTazerFxFrontControl = SkelControlSingleBone(mElectricalBoltMesh.FindSkelControl('TazerBoltRootBoneControl'));
    mTazerFxBackControl = SkelControlSingleBone(mElectricalBoltMesh.FindSkelControl('TazerBoltEndBoneControl'));
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x24
    if(VarName == 'mElectricalBoltLoc')
    {
        DetonateElectricalBolt(mElectricalBoltLoc);
        return;
    }
    super.ReplicatedEvent(VarName);
    //return;    
}

simulated event Tick(float DeltaTime)
{
    local @NULL target1, target2, StartTrace, EndTrace, HitLoc, HitNorm;

    local float stunTime;
    local int I;
    local @NULL target2Pawn, fxMeshRotation, impactFXRotation, boltFXEmitter;
    local name ClosestBoneName;
    local @NULL HitInfo;

    super.Tick(DeltaTime);
    // End:0x368
    if(mbBoltActivated)
    {
        // End:0x32A
        if(int(mPawnIndex) < mAffectedPawnList.Length)
        {
            // End:0x41
            if(int(mPawnIndex) == 0)
            {
                target1 = Location;                
            }
            else
            {
                target1 = mAffectedPawnList[int(mPawnIndex) - 1].Location;
            }
            target2Pawn = TurokPawn(mAffectedPawnList[int(mPawnIndex)]);
            target2 = target2Pawn.Location;
            target2 = target2 + mBoltPositionOffset;
            // End:0x299
            if(!IsTimerActive('ElectricalBoltTimer'))
            {
                SetTimer(mBoltDurationBetweenPawns, false, 'ElectricalBoltTimer');
                // End:0x1FC
                if(int(Role) == int(ROLE_Authority))
                {
                    // End:0x1FC
                    if(target2Pawn != none)
                    {
                        // End:0x1FC
                        if(TurokPawn(Instigator).mTargetingSystem.ConsiderTarget(Instigator, target2Pawn))
                        {
                            stunTime = mMaxStunTime;
                            I = 0;
                            J0x122:

                            // End:0x150 [Loop If]
                            if(I < int(mPawnIndex))
                            {
                                stunTime *= (1.0000000 - mStunReductionPct);
                                ++I;
                                // [Loop Continue]
                                goto J0x122;
                            }
                            EndTrace = target2Pawn.Location;
                            StartTrace = target2 - (float(32) * Normal(target2 - target1));
                            Trace(HitLoc, HitNorm, EndTrace, StartTrace, true,, HitInfo);
                            target2Pawn.HitByTazer(stunTime, TurokPawn(Instigator));
                            target2Pawn.TakeImpact(TazerElectricalBoltDamageType, stunTime, target2, Normal(target2 - target1), HitInfo);
                        }
                    }
                }
                impactFXRotation = Rotator(target2 - target1);
                boltFXEmitter = __NFUN_278__(Class'TurokEmitter',,, target2Pawn.Location, impactFXRotation);
                boltFXEmitter.SetTemplate(ParticleSystem'FXWeaponFire.ParticleSystems.Tazer.TazerShockPS', true);
                ClosestBoneName = target2Pawn.Mesh.FindClosestBone(target2Pawn.Location);
                boltFXEmitter.attachTo(target2Pawn, ClosestBoneName);
            }
            // End:0x301
            if(mTazerFxFrontControl != none)
            {
                SetLocation(target1);
                fxMeshRotation = Rotator(target1 - target2);
                fxMeshRotation.Roll = 16384;
                mElectricalBoltMesh.SetRotation(fxMeshRotation);
                mTazerFxFrontControl.BoneTranslation = target1;
            }
            // End:0x327
            if(mTazerFxBackControl != none)
            {
                mTazerFxBackControl.BoneTranslation = target2 - Location;
            }            
        }
        else
        {
            // End:0x365
            if((int(Role) == int(ROLE_Authority)) && !bNetTemporary || NetUpdateTime == 0.0000000)
            {
                SetPendingDestroy();                
            }
            else
            {
                Destroy();
            }
        }
    }
    //return;    
}

simulated function ElectricalBoltTimer()
{
    mPawnIndex++;
    //return;    
}

simulated function DetonateElectricalBolt(@NULL Loc)
{
    BuildElectricalBoltPawnList();
    mPawnIndex = 0;
    mbBoltActivated = true;
    mElectricalBoltMesh.SetHidden(false);
    SpawnExplosionEffects(Loc, vect(0.0000000, 0.0000000, 1.0000000));
    MakeNoise(mImpactNoiseLevel, 'NOISE_ProjectileImpact');
    RecordHitStat(Loc, vect(0.0000000, 0.0000000, 1.0000000));
    mCanisterMesh.SetHidden(true);
    // End:0xA0
    if(int(Role) == int(ROLE_Authority))
    {
        mElectricalBoltLoc = Loc;
    }
    //return;    
}

simulated function SpawnExplosionEffects(@NULL HitLocation, @NULL HitNormal, optional bool EnableDecalImpactEffect = true, optional bool EnableImpactEffect = true)
{
    local @NULL impactEmitter, HitInfo, HitActor, StartTrace, EndTrace, newHitLocation,
	    newHitNormal, impactRot, ImpactEffect;

    StopAmbience();
    StartTrace = HitLocation + (HitNormal * 5.0000000);
    EndTrace = StartTrace + (-HitNormal * 20.0000000);
    HitActor = Trace(newHitLocation, newHitNormal, EndTrace, StartTrace, true,, HitInfo);
    // End:0x9B
    if(newHitLocation == vect(0.0000000, 0.0000000, 0.0000000))
    {
        newHitLocation = HitLocation;
        newHitNormal = HitNormal;
    }
    impactRot = Rotator(newHitNormal);
    impactRot.Pitch -= 16384;
    impactEmitter = __NFUN_278__(Class'TurokEmitter',,, newHitLocation, impactRot);
    // End:0xFF
    if(mbBoltActivated)
    {
        impactEmitter.SetTemplate(ParticleSystem'FXWeaponFire.ParticleSystems.Tazer.TazerSourcePS', true);        
    }
    else
    {
        impactEmitter.SetTemplate(ParticleSystem'FXWeaponFire.ParticleSystems.Tazer.TazerFlashbangPS', true);
    }
    // End:0x166
    if((HitActor != none) && ImpactEffect.mDecalMaterial != none)
    {
        impactRot = Rotator(-newHitNormal);
        impactRot.Roll = int(FRand() * float(65535));
    }
    // End:0x1AF
    if(ImpactEffect.mImpactSound.Length > 0)
    {
        impactEmitter.mSoundController.TryPlayLocalSound(ImpactEffect.mImpactSound[0]);        
    }
    //return;    
}

simulated function ExplodeWithElectricalBolt()
{
    DetonateElectricalBolt(Location);
    //return;    
}

simulated function ExplodeWithFlashBang()
{
    local @NULL HitInfo;

    HitInfo.Location = Location;
    HitInfo.Normal = vect(0.0000000, 0.0000000, 1.0000000);
    OnProjectileHit(HitInfo);
    //return;    
}

simulated function Explode(@NULL HitLocation, @NULL HitNormal)
{
    //return;    
}

simulated function BlowUp(@NULL HitLocation, @NULL HitNormal)
{
    local float locdamage;

    // End:0x17
    if(mbIsMultiPlayer)
    {
        locdamage = mMultiplayerDamage;        
    }
    else
    {
        locdamage = Damage;
    }
    // End:0x44
    if(mExplosionShakeEnable)
    {
        Class'TurokRadialParametricShake'.static.BroadcastRadialShake(self, mExplosionShake);
    }
    HurtRadius(locdamage, MyDamageType.default.DamageRadius, MyDamageType, MyDamageType.default.RadialDamageImpulse, HitLocation);
    //return;    
}

simulated function OnProjectileHit(@NULL HitInfo)
{
    mReplicatedHitInfo = HitInfo;
    SpawnExplosionEffects(mReplicatedHitInfo.Location, mReplicatedHitInfo.Normal);
    MakeNoise(mImpactNoiseLevel, 'NOISE_ProjectileImpact');
    RecordHitStat(mReplicatedHitInfo.Location, mReplicatedHitInfo.Normal);
    // End:0xAE
    if(MyDamageType.default.DamageRadius > 0.0000000)
    {
        BlowUp(mReplicatedHitInfo.Location, mReplicatedHitInfo.Normal);
    }
    // End:0xE9
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

simulated event HitWall(@NULL HitNormal, @NULL Wall)
{
    local @NULL HitInfo, StartTrace, EndTrace, HitLocation, ImpactEffect;

    Velocity = MirrorVectorByNormal(Velocity, HitNormal) * mRestitution;
    HitLocation = Location;
    StartTrace = HitLocation + (HitNormal * 5.0000000);
    EndTrace = StartTrace + (-HitNormal * 20.0000000);
    Trace(HitLocation, HitNormal, EndTrace, StartTrace, true,, HitInfo);
    ImpactEffect = GetImpactEffect(HitInfo.PhysMaterial);
    // End:0xF7
    if(((Abs(Velocity.X) <= mProjectileSlowRate) && Abs(Velocity.Y) <= mProjectileSlowRate) && Abs(Velocity.Z) <= mProjectileSlowRate)
    {
        StopAmbience();
    }
    // End:0x194
    if(((Abs(Velocity.X) >= mMinQuietBounce.X) && Abs(Velocity.Y) >= mMinQuietBounce.Y) && Abs(Velocity.Z) >= mMinQuietBounce.Z)
    {
        PlayImpactSound(ImpactEffect.mBounceSound);
        MakeNoise(mImpactNoiseLevel, 'NOISE_ProjectileImpact');
    }
    //return;    
}

defaultproperties
{
    // Reference: TurokSoundController'Default__TurokProjTazerNative.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    // Reference: TurokRadialShakeComponent'Default__TurokProjTazerNative.Shakey'
    begin object name=Shakey
    end object
    mExplosionShake=Shakey
    // Reference: CylinderComponent'Default__TurokProjTazerNative.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokProjTazerNative.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    Components[2]=TurokSoundControllerComponent
    CollisionComponent=CollisionCylinder
}