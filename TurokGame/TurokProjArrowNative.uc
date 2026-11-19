class TurokProjArrowNative extends TurokStickyProjectile
    native
    config(WeapBow)
    hidecategories(Navigation);

enum ETurokArrowDamageType
{
    ETADT_ArrowBreaks,              // 0
    ETADT_ArrowRemovedByPawn,       // 1
    ETADT_CauseLegLimp,             // 2
    ETADT_Normal,                   // 3
    ETADT_MAX                       // 4
};

var() export editinline @NULL mArrowMesh;
var export editinline @NULL mArrowTrailPS;
var export editinline @NULL mArrowTrailPS3P;
var bool mbDragBody;
var bool mbStickBody;
var(TurokProjArrow) bool mbStickRagdolls;
var @NULL mLastLocation;
var @NULL mAttachLocation;
var @NULL mStickTarget;
var @NULL mStickRot;
var @NULL mDragDir;
var name mAttachBoneName;
var byte mArrowDamageType;
var(TurokProjArrow) float mDragSpeed;
var(TurokProjArrow) float mStickRagdollTimeout;
var(TurokProjArrow) config float mMaxStickWallDist;
var(TurokProjArrow) config float mMaxTensionStickWallDist;
var(TurokProjArrow) config float mMinStickWallDist;
var(TurokProjArrow) config float mMaxImpulse;
var(TurokProjArrow) float mMinStickTargetHeightFromGround;
var(TurokProjArrow) float mStickHeightAdjustLowLimit;
var(TurokProjArrow) float mBowTensionMomentumTransfer;
var(TurokProjArrow) float mStuckPawnToWallDist;
var(TurokProjArrow) float mVertSurfacePinningTolerance;
var(TurokProjArrow) config float mMaxSpeedFullTensionShot;
var float mMaxDistance;
var export editinline @NULL mStuckToComponent;
var @NULL mBodyImpactTreeSndCue;
var @NULL mLastController;
var export editinline @NULL mArrowCollisionCylinder;

// Export UTurokProjArrowNative::execMakePersistent(FFrame&, void* const)
native function MakePersistent();

// Export UTurokProjArrowNative::execRemovePersistent(FFrame&, void* const)
native function RemovePersistent();

// Export UTurokProjArrowNative::execTermComponentRBPhys(FFrame&, void* const)
native function TermComponentRBPhys(@NULL Arrow);

// Export UTurokProjArrowNative::execCheckArrowPath(FFrame&, void* const)
native function CheckArrowPath();

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    MakePersistent();
    mArrowTrailPS.DeactivateSystem();
    mArrowTrailPS3P.DeactivateSystem();
    SetTimer(0.0200000, false, 'ActivateArrowPSTimer');
    //return;    
}

simulated event Destroyed()
{
    local @NULL tpStuckToPawn;

    tpStuckToPawn = TurokPawn(mStuckToPawn);
    // End:0x6B
    if(tpStuckToPawn != none)
    {
        // End:0x6B
        if(tpStuckToPawn.mbStuckToWorld && tpStuckToPawn.mStickingArrow == self)
        {
            tpStuckToPawn.ReleasePawnFromSticking(mAttachBoneName);
            tpStuckToPawn.mStickingArrow = none;
        }
    }
    ClearTimer('UnStickPawn');
    super.Destroyed();
    //return;    
}

simulated event Tick(float DeltaTime)
{
    local @NULL NewLoc, vel, dirToTarget, tpStuckToPawn;

    super.Tick(DeltaTime);
    // End:0x3C
    if(int(Physics) == int(6))
    {
        // End:0x3C
        if(VSize2D(Location - mSpawnLocation) >= mMaxDistance)
        {
            SetPhysics(2);
        }
    }
    // End:0x70
    if(mStuckToComponent != none)
    {
        // End:0x70
        if(mStuckToComponent.IsDestroyed())
        {
            RemovePersistent();
            mStuckToComponent = none;
            return;
        }
    }
    // End:0xA4
    if(mStuckToDoor != none)
    {
        // End:0xA4
        if(mStuckToDoor.IsDoorMoving())
        {
            RemovePersistent();
            mStuckToDoor = none;
            return;
        }
    }
    // End:0xD9
    if((mStuckToDynamic != none) && mStuckToDynamic.bHidden == true)
    {
        RemovePersistent();
        mStuckToDynamic = none;
        return;
    }
    tpStuckToPawn = TurokPawn(mStuckToPawn);
    // End:0x387
    if((mbDragBody && tpStuckToPawn != none) && !tpStuckToPawn.mbStuckToWorld)
    {
        vel = mDragDir * mDragSpeed;
        NewLoc = Location + (vel * DeltaTime);
        SetLocation(NewLoc);
        SetRotation(mStickRot);
        NewLoc = mAttachLocation + (vel * DeltaTime);
        mAttachLocation = NewLoc;
        dirToTarget = mAttachLocation - mStickTarget;
        // End:0x31A
        if((mDragDir Dot dirToTarget) > 0.0000000)
        {
            SetLocation(mStickTarget - (mDragDir * 8.0000000));
            NewLoc = (mStickTarget + (tpStuckToPawn.Mesh.GetBoneLocation('jt_Cog_C') - tpStuckToPawn.Mesh.GetBoneLocation(mAttachBoneName))) - (mDragDir * mStuckPawnToWallDist);
            tpStuckToPawn.Mesh.SetRBPosition(NewLoc);
            SetPhysics(0);
            mbDragBody = false;
            mbStickBody = true;
            tpStuckToPawn.mbStuckToWorld = true;
            tpStuckToPawn.mStickingArrow = self;
            tpStuckToPawn.mbDraggedByArrow = false;
            PlayImpactSound(mBodyImpactTreeSndCue);
            // End:0x304
            if(TurokGameInfo(tpStuckToPawn.WorldInfo.Game) != none)
            {
                // End:0x304
                if(TurokGameInfo(tpStuckToPawn.WorldInfo.Game).mStatTracker != none)
                {
                    TurokGameInfo(tpStuckToPawn.WorldInfo.Game).mStatTracker.RecordPinning(self);
                }
            }
            SetTimer(mStickRagdollTimeout, false, 'UnStickPawn');            
        }
        else
        {
            NewLoc = NewLoc + (tpStuckToPawn.Mesh.GetBoneLocation('jt_Cog_C') - tpStuckToPawn.Mesh.GetBoneLocation(mAttachBoneName));
            tpStuckToPawn.Mesh.SetRBPosition(NewLoc);
        }
    }
    //return;    
}

simulated function ActivateArrowPSTimer()
{
    mArrowTrailPS.ActivateSystem();
    mArrowTrailPS3P.ActivateSystem();
    //return;    
}

simulated function @NULL CapImpulse(@NULL vRawImpulse)
{
    local @NULL vImpulse;
    local float fSize;

    vImpulse = vRawImpulse;
    fSize = VSize(vImpulse);
    // End:0x48
    if(fSize > mMaxImpulse)
    {
        vImpulse = Normal(vRawImpulse) * mMaxImpulse;
        fSize = VSize(vImpulse);
    }
    return vImpulse;
    //return ReturnValue;    
}

simulated function RemovePersistentArrowFromPawn(@NULL tPawn)
{
    local @NULL tpStuckToPawn;

    tpStuckToPawn = TurokPawn(mStuckToPawn);
    // End:0x3B
    if(tpStuckToPawn == tPawn)
    {
        tpStuckToPawn = none;
        RemovePersistent();
        bTearOff = true;
        Destroy();
    }
    //return;    
}

simulated function RemovePersistentCheckStuckPawn()
{
    local @NULL tpStuckToPawn;

    tpStuckToPawn = TurokPawn(mStuckToPawn);
    // End:0x2F
    if(tpStuckToPawn != none)
    {
        tpStuckToPawn.RemoveStuckArrow(self);
    }
    RemovePersistent();
    //return;    
}

function UnStickPawn()
{
    local @NULL tpStuckToPawn;

    tpStuckToPawn = TurokPawn(mStuckToPawn);
    // End:0x4D
    if(tpStuckToPawn != none)
    {
        tpStuckToPawn.ReleasePawnFromSticking(mAttachBoneName);
        tpStuckToPawn.mStickingArrow = none;
        RemovePersistentCheckStuckPawn();
    }
    //return;    
}

simulated function SetArrowDamageType(byte arrowDamageType)
{
    mArrowDamageType = arrowDamageType;
    //return;    
}

function RevertCamera()
{
    local @NULL tw, TP, TPC;

    tw = TurokWeapon(Owner);
    // End:0xC1
    if((tw != none) && tw.Owner != none)
    {
        TP = TurokPawnPlayer(tw.Owner);
        // End:0xC1
        if((TP != none) && TP.Controller != none)
        {
            TPC = TurokPlayerController(TP.Controller);
            // End:0xC1
            if((TPC != none) && TPC.PlayerCamera != none)
            {
                TPC.SetCameraMode('FirstPerson');
            }
        }
    }
    //return;    
}

simulated event Landed(@NULL HitNormal, @NULL FloorActor)
{
    super(TurokProjectile).Landed(HitNormal, FloorActor);
    StopAmbience();
    SetPhysics(0);
    SetCollision(false, false);
    //return;    
}

simulated function BlowUp(@NULL HitLocation, @NULL HitNormal)
{
    //return;    
}

simulated function Explode(@NULL HitLocation, @NULL HitNormal)
{
    local @NULL HitInfo, tPawn, stickHit;
    local bool mbApplyDamage;
    local @NULL StartTrace, EndTrace;

    // End:0x0B
    if(mbExploded)
    {
        return;
    }
    mbExploded = true;
    stickHit.Location = HitLocation;
    stickHit.Normal = HitNormal;
    stickHit.Rotation = Rotation;
    StartTrace = HitLocation + (HitNormal * 5.0000000);
    EndTrace = StartTrace + (-HitNormal * 20.0000000);
    Trace(HitLocation, HitNormal, EndTrace, StartTrace, true,, HitInfo);
    stickHit.HitComponent = HitInfo.HitComponent;
    // End:0x15F
    if((ImpactedActor != none) && ImpactedActor != Base)
    {
        tPawn = TurokPawn(ImpactedActor);
        // End:0x12B
        if(tPawn != none)
        {
            tPawn.CheckHitInfo(HitInfo, tPawn.Mesh, Normal(Velocity), HitLocation, true);
        }
        stickHit.Actor = ImpactedActor;
        stickHit.bone = HitInfo.BoneName;
    }
    // End:0x312
    if(int(Role) == int(ROLE_Authority))
    {
        MakeNoise(mImpactNoiseLevel, 'NOISE_ProjectileImpact');
        // End:0x2F8
        if(mbStickDamage)
        {
            tPawn = TurokPawn(ImpactedActor);
            mbApplyDamage = true;
            // End:0x20B
            if(tPawn != none)
            {
                tPawn.CheckHitInfo(HitInfo, tPawn.Mesh, Normal(Velocity), HitLocation);
                // End:0x20B
                if((tPawn.Health < 0) || tPawn.mbStuckToWorld)
                {
                    mbApplyDamage = false;
                }
            }
            stickHit.Actor = ImpactedActor;
            stickHit.bone = HitInfo.BoneName;
            mbApplyDamage = (mbApplyDamage && mbStickDamage) && ImpactedActor != none;
            // End:0x2F8
            if(mbApplyDamage)
            {
                RecordHitStat(stickHit.Location, stickHit.Normal);
                // End:0x2F8
                if(tPawn != none)
                {
                    ImpactedActor.TakeDamage(int(Damage), InstigatorController, HitLocation, CapImpulse(MyDamageType.default.RadialDamageImpulse * Normal(Velocity)), MyDamageType, HitInfo);
                    mbApplyDamage = false;
                }
            }
        }
        SetCollision(false, false);
        OnStickyProjectileHit(stickHit, HitInfo);
    }
    // End:0x36B
    if(mbApplyDamage)
    {
        ImpactedActor.TakeDamage(int(Damage), InstigatorController, HitLocation, CapImpulse(MyDamageType.default.RadialDamageImpulse * Normal(Velocity)), MyDamageType, HitInfo);
    }
    //return;    
}

simulated function OnStickyProjectileHit(@NULL Hit, @NULL HitInfo)
{
    local @NULL tPawn;
    local bool canDrag;
    local @NULL HitActor, hitSurface, HitLocation, HitNormal, arrowDir, surfaceLocation,
	    surfaceNormal, newHitLocation, potentialHitInfo, upVec, downVec;

    local float arrowSurfaceDot, distToGround;
    local @NULL StartTrace, EndTrace, hitReactionImpulse, NewRot, collisionExtents, physProperty,
	    tVehicle;

    canDrag = false;
    // End:0x57
    if(mbIsMultiPlayer && int(Role) < int(ROLE_Authority))
    {
        // End:0x4F
        if(Hit.Rotation == rot(0, 0, 0))
        {
            mArrowDamageType = 0;            
        }
        else
        {
            mArrowDamageType = 3;
        }
    }
    arrowDir = Normal(Velocity);
    tPawn = TurokPawn(Hit.Actor);
    tVehicle = TurokVehicle(Hit.Actor);
    mArrowTrailPS.DeactivateSystem();
    mArrowTrailPS3P.DeactivateSystem();
    // End:0x17D
    if((((((((tPawn != none) && !tPawn.ArrowCanStickInto()) || TurokDoorActor(Hit.Actor) != none) || DynamicSMActor(Hit.Actor) != none) || tVehicle != none) || TurokPawnCinematic(Hit.Actor) != none) || SkeletalMeshActor(Hit.Actor) != none) || mbIsMultiPlayer && TurokPawnHuman(tPawn) != none)
    {
        mArrowDamageType = 0;
    }
    // End:0x1BE
    if(((mbIsMultiPlayer && tPawn != none) && tPawn != none) && tPawn.Health <= 0)
    {
        mArrowDamageType = 0;
    }
    // End:0x21F
    if((Instigator == none) || !Instigator.CanHurt(tPawn))
    {
        mArrowDamageType = 0;
        mArrowTrailPS.DeactivateSystem();
        mArrowTrailPS3P.DeactivateSystem();
        RemovePersistent();
        Destroy();        
    }
    else
    {
        // End:0xC09
        if((tPawn != none) && int(mArrowDamageType) != int(0))
        {
            // End:0xC06
            if(Hit.bone != 'None')
            {
                // End:0x275
                if(tPawn.Health <= 0)
                {
                    canDrag = true;
                }
                // End:0x293
                if(canDrag && !mbStickRagdolls)
                {
                    canDrag = false;
                }
                // End:0x2BE
                if(canDrag && !tPawn.CanBeDraggedByArrow())
                {
                    canDrag = false;
                }
                // End:0x2DA
                if(canDrag && mbIsMultiPlayer)
                {
                    canDrag = false;
                }
                // End:0x37A
                if(int(mArrowDamageType) == int(1))
                {
                    canDrag = false;
                    Hit.bone = 'jt_SpineUpper_C';
                    NewRot = tPawn.Rotation;
                    NewRot.Yaw = -NewRot.Yaw;
                    SetRotation(NewRot);
                    Hit.Location = tPawn.Mesh.GetBoneLocation('jt_SpineUpper_C');
                }
                mAttachBoneName = Hit.bone;
                mAttachLocation = Hit.Location;
                mStuckToPawn = tPawn;
                // End:0x9D6
                if((canDrag && !tPawn.mbStuckToWorld) && !tPawn.mbDraggedByArrow)
                {
                    // End:0x4A8
                    if(((((((mAttachBoneName == 'jt_Wrist_L') || mAttachBoneName == 'jt_Wrist_R') || mAttachBoneName == 'jt_Elbow_L') || mAttachBoneName == 'jt_Elbow_R') || mAttachBoneName == 'jt_Clavicle_L') || mAttachBoneName == 'jt_Clavicle_R') || mAttachBoneName == 'jt_Neck_C')
                    {
                        mAttachBoneName = 'jt_SpineUpper_C';
                        mAttachLocation = tPawn.Mesh.GetBoneLocation(mAttachBoneName);
                    }
                    StartTrace = mAttachLocation;
                    EndTrace = mAttachLocation + (arrowDir * mMaxStickWallDist);
                    HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace, false,, potentialHitInfo);
                    // End:0x8D7
                    if(HitActor != none)
                    {
                        upVec.Z = 1.0000000;
                        arrowSurfaceDot = HitNormal Dot upVec;
                        // End:0x550
                        if((TurokDoorActor(HitActor) != none) || DynamicSMActor(HitActor) != none)
                        {
                            HitActor = none;                            
                        }
                        else
                        {
                            // End:0x56B
                            if(Abs(arrowSurfaceDot) > mVertSurfacePinningTolerance)
                            {
                                HitActor = none;                                
                            }
                            else
                            {
                                // End:0x58D
                                if(Abs(HitNormal Dot arrowDir) < 0.4200000)
                                {
                                    HitActor = none;                                    
                                }
                                else
                                {
                                    downVec.Z = -1.0000000;
                                    // End:0x5F6
                                    if(arrowSurfaceDot > 0.0000000)
                                    {
                                        StartTrace = HitLocation - (arrowDir * mMinStickTargetHeightFromGround);
                                        EndTrace = (HitLocation - (arrowDir * mMinStickTargetHeightFromGround)) + (downVec * float(1600));                                        
                                    }
                                    else
                                    {
                                        StartTrace = HitLocation - (arrowDir * 2.0000000);
                                        EndTrace = (HitLocation - (arrowDir * 2.0000000)) + (downVec * float(1600));
                                    }
                                    hitSurface = Trace(surfaceLocation, surfaceNormal, EndTrace, StartTrace, false);
                                    // End:0x76D
                                    if(hitSurface != none)
                                    {
                                        distToGround = HitLocation.Z - surfaceLocation.Z;
                                        // End:0x757
                                        if((distToGround < mMinStickTargetHeightFromGround) && distToGround > mStickHeightAdjustLowLimit)
                                        {
                                            newHitLocation = mAttachLocation;
                                            newHitLocation.Z = surfaceLocation.Z + mMinStickTargetHeightFromGround;
                                            StartTrace = newHitLocation;
                                            EndTrace = newHitLocation + (arrowDir * mMaxStickWallDist);
                                            hitSurface = Trace(surfaceLocation, surfaceNormal, EndTrace, StartTrace, false);
                                            // End:0x74D
                                            if((hitSurface != none) && TurokPawn(hitSurface) == none)
                                            {
                                                HitLocation = surfaceLocation;                                                
                                            }
                                            else
                                            {
                                                HitActor = none;
                                            }                                            
                                        }
                                        else
                                        {
                                            // End:0x76D
                                            if(distToGround <= mStickHeightAdjustLowLimit)
                                            {
                                                HitActor = none;
                                            }
                                        }
                                    }
                                    // End:0x8D7
                                    if(HitActor != none)
                                    {
                                        EndTrace = HitLocation;
                                        EndTrace.Z = EndTrace.Z + (tPawn.Location.Z - mAttachLocation.Z);
                                        EndTrace = EndTrace + (-arrowDir * tPawn.CylinderComponent.CollisionRadius);
                                        StartTrace = EndTrace + (-arrowDir * 2.0000000);
                                        collisionExtents.X = tPawn.CylinderComponent.CollisionRadius * 0.5000000;
                                        collisionExtents.Y = tPawn.CylinderComponent.CollisionRadius * 0.5000000;
                                        collisionExtents.Z = tPawn.CylinderComponent.CollisionHeight * 0.7500000;
                                        hitSurface = Trace(surfaceLocation, surfaceNormal, EndTrace, StartTrace, false, collisionExtents);
                                        // End:0x8D7
                                        if(hitSurface != none)
                                        {
                                            HitActor = none;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    // End:0x9CE
                    if((HitActor != none) && TurokPawn(HitActor) == none)
                    {
                        SetLocation(Hit.Location);
                        mStickTarget = HitLocation;
                        mDragDir = Normal(HitLocation - Location);
                        mStuckToPawn.Mesh.bUpdateKinematicBonesFromAnimation = false;
                        TurokPawn(mStuckToPawn).InitPawnForDragging(mAttachBoneName);
                        mbDragBody = true;
                        mStickRot = Rotation;
                        TurokPawn(mStuckToPawn).mbDraggedByArrow = true;
                        // End:0x9CB
                        if((TurokDestroyableActor(HitActor) != none) && TurokDestroyableComponent(potentialHitInfo.HitComponent) != none)
                        {
                            mStuckToComponent = TurokDestroyableComponent(potentialHitInfo.HitComponent);
                        }                        
                    }
                    else
                    {
                        canDrag = false;
                    }
                }
                // End:0xACB
                if(int(mArrowDamageType) != int(1))
                {
                    SetBase(none);
                    SetHardAttach(true);
                    SetPhysics(0);
                    bCollideWorld = false;
                    SetLocation(Hit.Location);
                    SetRotation(Hit.Rotation);
                    SetBase(tPawn,, tPawn.Mesh, Hit.bone);
                    SetCollision(false, false, false);
                    TermComponentRBPhys(mArrowMesh);
                    tPawn.AddStuckArrow(self);
                    CollisionComponent = mArrowCollisionCylinder;
                    // End:0xAC8
                    if(tPawn.mbStuckToWorld)
                    {
                        mStuckToPawn.Mesh.bUpdateKinematicBonesFromAnimation = false;
                        TurokPawn(mStuckToPawn).InitPawnForDragging(mAttachBoneName);
                    }                    
                }
                else
                {
                    RemovePersistent();
                    mArrowTrailPS.DeactivateSystem();
                    mArrowTrailPS3P.DeactivateSystem();
                    Destroy();
                }
                // End:0xBE1
                if((mbStickDamage && !canDrag) && !tPawn.mbStuckToWorld)
                {
                    hitReactionImpulse = mBowTensionMomentumTransfer * arrowDir;
                    tPawn.CheckHitInfo(HitInfo, tPawn.Mesh, Normal(Velocity), Hit.Location, true);
                    tPawn.TakeImpact(MyDamageType, Damage, Hit.Location, hitReactionImpulse, HitInfo);
                    // End:0xBE1
                    if(tPawn.Health <= 0)
                    {
                        tPawn.Mesh.AddImpulse(CapImpulse(hitReactionImpulse),,, true);
                    }
                }
                // End:0xC06
                if(mbDragBody)
                {
                    TurokPawn(mStuckToPawn).GotoState('DeadRagDollDragging');
                }
            }            
        }
        else
        {
            // End:0xD55
            if((tPawn != none) && int(mArrowDamageType) == int(0))
            {
                // End:0xD11
                if((mbStickDamage && !canDrag) && !tPawn.mbStuckToWorld)
                {
                    hitReactionImpulse = mBowTensionMomentumTransfer * arrowDir;
                    tPawn.CheckHitInfo(HitInfo, tPawn.Mesh, Normal(Velocity), Hit.Location, true);
                    tPawn.TakeImpact(MyDamageType, Damage, Hit.Location, hitReactionImpulse, HitInfo);
                    // End:0xD11
                    if(tPawn.Health <= 0)
                    {
                        tPawn.Mesh.AddImpulse(CapImpulse(hitReactionImpulse),,, true);
                    }
                }
                mArrowTrailPS.DeactivateSystem();
                mArrowTrailPS3P.DeactivateSystem();
                mArrowMesh.SetHidden(true);
                SetTimer(1.0000000, false, 'DelayedDestroyArrowTimer');                
            }
            else
            {
                // End:0x10DB
                if(tPawn == none)
                {
                    // End:0xD85
                    if(DynamicSMActor(Hit.Actor) != none)
                    {
                        mArrowDamageType = 0;                        
                    }
                    else
                    {
                        // End:0xDC7
                        if(HitInfo.PhysMaterial != none)
                        {
                            physProperty = TurokPhysMatProperty(HitInfo.PhysMaterial.GetPhysicalMaterialProperty(Class'TurokPhysMatProperty'));
                        }
                        // End:0xE8C
                        if((physProperty != none) && physProperty.mPhysMaterialName != 'None')
                        {
                            // End:0xE8C
                            if(((((physProperty.mPhysMaterialName == 'MetalPhysMat') || physProperty.mPhysMaterialName == 'ConcretePhysMat') || physProperty.mPhysMaterialName == 'WaterPhysMat') || physProperty.mPhysMaterialName == 'RockPhysMat') || physProperty.mPhysMaterialName == 'WetConcretePhysMat')
                            {
                                mArrowDamageType = 0;
                            }
                        }
                    }
                    // End:0x1000
                    if(int(mArrowDamageType) == int(3))
                    {
                        // End:0xF29
                        if(TurokDoorActor(Hit.Actor) != none)
                        {
                            mStuckToDoor = TurokDoorActor(Hit.Actor);
                            SetBase(none);
                            SetHardAttach(true);
                            SetPhysics(0);
                            SetLocation(Hit.Location);
                            SetBase(mStuckToDoor,, mStuckToDoor.mPryDoorMesh, Hit.bone);
                            CollisionComponent = mArrowCollisionCylinder;                            
                        }
                        else
                        {
                            // End:0xFC1
                            if((TurokDestroyableActor(Hit.Actor) != none) || TurokDestroyableComponent(Hit.HitComponent) != none)
                            {
                                mStuckToComponent = TurokDestroyableComponent(Hit.HitComponent);
                                SetBase(none);
                                SetHardAttach(true);
                                SetPhysics(0);
                                SetLocation(Hit.Location);
                                SetBase(Hit.Actor);
                                CollisionComponent = mArrowCollisionCylinder;                                
                            }
                            else
                            {
                                SetPhysics(0);
                                bCollideWorld = false;
                                SetLocation(Hit.Location);
                                SetRotation(Hit.Rotation);
                                CollisionComponent = mArrowCollisionCylinder;
                            }
                        }                        
                    }
                    else
                    {
                        mArrowTrailPS.DeactivateSystem();
                        mArrowTrailPS3P.DeactivateSystem();
                        SetBase(none);
                        mArrowMesh.SetHidden(true);
                        SetPhysics(0);
                        bCollideWorld = false;
                        SetLocation(Hit.Location);
                        SetRotation(Hit.Rotation);
                        SetTimer(1.0000000, false, 'DelayedDestroyArrowTimer');
                    }
                    SetCollision(false, false);
                    hitReactionImpulse = mBowTensionMomentumTransfer * arrowDir;
                    Hit.Actor.TakeImpact(MyDamageType, Damage, Hit.Location, CapImpulse(hitReactionImpulse), HitInfo);
                }
            }
        }
    }
    // End:0x1164
    if(int(Role) == int(ROLE_Authority))
    {
        MakeNoise(mImpactNoiseLevel, 'NOISE_ProjectileImpact');
        Hit.Location = Location;
        // End:0x1141
        if(int(mArrowDamageType) == int(0))
        {
            Hit.Rotation = rot(0, 0, 0);            
        }
        else
        {
            Hit.Rotation = Rotation;
        }
        SetReplicatedStickyHit(Hit);        
    }
    else
    {
        // End:0x1193
        if(mStuckToPawn == none)
        {
            SetLocation(Hit.Location);
            SetRotation(Hit.Rotation);
        }
    }
    SpawnExplosionEffects(Hit.Location, Hit.Normal);
    //return;    
}

simulated function bool DoSecondarySpawnExplosionTrace()
{
    return !mbIsMultiPlayer || mbIsMultiPlayer && int(mArrowDamageType) != int(0);
    //return ReturnValue;    
}

simulated function DelayedDestroyArrowTimer()
{
    ClearTimer('DelayedDestroyArrowTimer');
    RemovePersistent();
    Destroy();
    //return;    
}

simulated function bool ShouldPlayExplosionEffect()
{
    return int(mArrowDamageType) == int(0);
    //return ReturnValue;    
}

defaultproperties
{
    mbStickPersistent=true
    // Reference: TurokSoundController'Default__TurokProjArrowNative.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    // Reference: TurokRadialShakeComponent'Default__TurokProjArrowNative.Shakey'
    begin object name=Shakey
    end object
    mExplosionShake=Shakey
    // Reference: CylinderComponent'Default__TurokProjArrowNative.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokProjArrowNative.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    Components[2]=TurokSoundControllerComponent
    CollisionComponent=CollisionCylinder
}