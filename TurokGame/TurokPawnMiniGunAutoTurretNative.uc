class TurokPawnMiniGunAutoTurretNative extends TurokPawnHumanNpcNative
    native
    config(Pawn)
    hidecategories(Navigation);

enum EAutoTurretType
{
    EATT_Player,                    // 0
    EATT_Wc,                        // 1
    EATT_Mg,                        // 2
    EATT_None,                      // 3
    EATT_MAX                        // 4
};

var @NULL mSkelAimController;
var export editinline @NULL mTripodMesh;
var @NULL mAimDirection;
var @NULL mInitSetupDirection;
var byte mScanOffsetIndex;
var byte mTurretType;
var(Reclaiming) array mScanOffsets;
var(Reclaiming) float mScanDepth;
var(Reclaiming) bool mbDrawReclaimingRays;
var private bool mBaseIsNone;
var @NULL mPrevViewRotation;
var @NULL mDeployCtrl;
var int mDeployedBy;
var float mLastScanTime;
var int mLastScanDir;
var @NULL mStartTrackingSndCue;
var private @NULL mPosOnDynamicSMActor;

simulated event bool CanAutoAimTo()
{
    return false;
    //return ReturnValue;    
}

event PostSaveGameRestore()
{
    local @NULL TPC;

    // End:0x72
    if(mDeployedBy != -1)
    {
        // End:0x71
        foreach WorldInfo.AllControllers(Class'TurokPlayerController', TPC)
        {
            // End:0x70
            if((TPC.PlayerReplicationInfo != none) && TPC.PlayerReplicationInfo.PlayerID == mDeployedBy)
            {
                mDeployCtrl = TPC;
                // End:0x71
                break;
            }            
        }        
    }
    // End:0x8B
    if(mDeployCtrl != none)
    {
        GotoState('Pickup');
    }
    //return;    
}

simulated event Tick(float DeltaTime)
{
    // End:0x1F
    if(mSkelAimController != none)
    {
        mSkelAimController.TargetLocation = mSpatialTarget;
    }
    super(TurokPawnHuman).Tick(DeltaTime);
    // End:0xE6
    if(((int(Role) == int(ROLE_Authority)) && mDeployedBy != -1) && !bPendingDelete)
    {
        // End:0xE6
        if(((mBaseIsNone || mDeployCtrl == none) || mDeployCtrl.IsDead()) || ((Base != none) && Base.IsA('DynamicSMActor')) && Location != mPosOnDynamicSMActor)
        {
            TakeDamage(Health, none, Location, vect(0.0000000, 0.0000000, 9.0000000), Class'Engine.DmgType_Suicided');
        }
    }
    //return;    
}

singular event BaseChange()
{
    // End:0x21
    if(Base == none)
    {
        // End:0x1E
        if(!bPendingDelete)
        {
            mBaseIsNone = true;
        }        
    }
    else
    {
        // End:0x43
        if(Base.IsA('DynamicSMActor'))
        {
            mPosOnDynamicSMActor = Location;
        }
        mBaseIsNone = false;
    }
    //return;    
}

// Export UTurokPawnMiniGunAutoTurretNative::execGetPawnViewLocation(FFrame&, void* const)
native simulated function @NULL GetPawnViewLocation();

// Export UTurokPawnMiniGunAutoTurretNative::execGetViewRotation(FFrame&, void* const)
native simulated function @NULL GetViewRotation();

function bool NeedToTurn(@NULL targ)
{
    local @NULL LookDir, AimDir;

    AimDir = targ - Location;
    AimDir.Z = 0.0000000;
    AimDir = Normal(AimDir);
    LookDir = Vector(GetViewRotation());
    LookDir.Z = 0.0000000;
    LookDir = Normal(LookDir);
    // End:0x80
    if((LookDir Dot AimDir) > 0.9300000)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated function PostBeginPlay()
{
    local @NULL turokInv;

    super.PostBeginPlay();
    mSkelAimController = SkelControlLookAt(mTripodMesh.FindSkelControl('AutoTurretSkelControl'));
    turokInv = TurokInventoryManager(InvManager);
    // End:0x59
    if(turokInv != none)
    {
        turokInv.SetMaxWeaponLimits(0, 1);
    }
    //return;    
}

simulated function bool CanBeDraggedByArrow()
{
    return false;
    //return ReturnValue;    
}

function TakeDamage(int Damage, @NULL InstigatedBy, @NULL HitLocation, @NULL Momentum, class<Class> DamageType, optional @NULL HitInfo, optional @NULL DamageCauser)
{
    super(TurokPawnHuman).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo);
    // End:0x3E
    if(Health <= 0)
    {
        TearOffMomentum *= 0.1000000;
    }
    //return;    
}

function bool Died(@NULL Killer, class<Class> DamageType, @NULL HitLocation)
{
    return super(TurokPawnHuman).Died(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}

function GiveTo(@NULL pwn)
{
    local @NULL gun, mgr, tpp;

    tpp = TurokPawnPlayer(pwn);
    // End:0x261
    if(((tpp != none) && tpp.Health > 0) && Health > 0)
    {
        gun = TurokWeapChaingunNative(GetPrimaryWeapon());
        // End:0x261
        if((gun != none) && IsInState('Pickup'))
        {
            gun.GetAttachment().StopThirdPersonFireEffects();
            SetHidden(true);
            GotoState('None');
            StopFiring();
            gun.mCurrentSpinPer = 0.0000000;
            gun.StopFire(0);
            gun.ClearFlashLocation();
            gun.DetachWeapon();
            gun.DetachWeaponAttachment();
            gun.GotoState('Inactive');
            gun.mTurretLightState = 0;
            // End:0x15F
            if(TurokAIControllerMinigunAutoTurret(Owner) != none)
            {
                TurokAIControllerMinigunAutoTurret(Owner).Destroy();
            }
            mgr = TurokInventoryManager(InvManager);
            mgr.DropFromInventory(gun);
            // DebugMode: 0
            assert(tpp.mMiniGunSentryGraph == none);
            tpp.mMiniGunSentryGraph = gun.mChaingunTripodGraphSet.FindGraph('unequip');
            // DebugMode: 0
            assert(tpp.mMiniGunSentryGraph != none);
            tpp.GotoState('PickupMiniGunSentry');
            gun.mAmmoPoolPickupCount = mgr.GetAmmoPoolCount(gun.mAmmoPoolClass);
            mgr = TurokInventoryManager(tpp.InvManager);
            mgr.AddInventory(gun);
            Destroy();
        }
    }
    //return;    
}

state Pickup
{
    function EndState(name NextStateName)
    {
        local @NULL TPC, mgr, tpp;

        // End:0x7D
        foreach TouchingActors(Class'TurokPawnPlayer', tpp)
        {
            TPC = TurokPlayerController(tpp.Controller);
            mgr = TurokInventoryManager(tpp.InvManager);
            // End:0x5D
            if(TPC != none)
            {
                TPC.mPickupMiniGunSentry = none;
            }
            // End:0x7C
            if(mgr != none)
            {
                mgr.EndPromptToDropItem(self);
            }            
        }        
        //return;        
    }

    event Touch(@NULL P, @NULL HitLocation, @NULL HitNormal)
    {
        local @NULL TPC, mgr, tpp, minigun;

        tpp = TurokPawnPlayer(P);
        // End:0x183
        if((((tpp != none) && tpp.mWeaponMediator != none) && tpp.Health > 0) && tpp.mWeaponMediator.CanUseAction())
        {
            mgr = TurokInventoryManager(tpp.InvManager);
            // End:0x183
            if((mgr != none) && !mgr.IsSwappingWeapons())
            {
                TPC = TurokPlayerController(tpp.Controller);
                // End:0x183
                if((TPC != none) && TPC.GetStateName() == 'PlayerWalking')
                {
                    minigun = GetPrimaryWeapon();
                    // End:0x12D
                    if(mgr.ShouldPickupWeapon(minigun.Class))
                    {
                        TPC.mPickupMiniGunSentry = self;                        
                    }
                    else
                    {
                        // End:0x183
                        if(mgr.ShouldPromptToDropItem(minigun.Class))
                        {
                            TPC.mPickupMiniGunSentry = none;
                            mgr.StartPromptToDropItem(self, minigun.Class);
                        }
                    }
                }
            }
        }
        //return;        
    }

    event UnTouch(@NULL P)
    {
        local @NULL TPC, mgr, tpp;

        tpp = TurokPawnPlayer(P);
        // End:0x87
        if(tpp != none)
        {
            TPC = TurokPlayerController(tpp.Controller);
            mgr = TurokInventoryManager(tpp.InvManager);
            // End:0x68
            if(TPC != none)
            {
                TPC.mPickupMiniGunSentry = none;
            }
            // End:0x87
            if(mgr != none)
            {
                mgr.EndPromptToDropItem(self);
            }
        }
        //return;        
    }
Begin:

    stop;                
}

state Dying
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        Destroy();
        //return;        
    }
    stop;    
}

defaultproperties
{
    mTurretType=3
    mScanOffsets=/* Array type was not detected. */
    mScanDepth=90.0000000
    mDeployedBy=-1
    // Reference: TurokWeaponMediator'Default__TurokPawnMiniGunAutoTurretNative.TurokWeaponMediatorComponent'
    begin object name=TurokWeaponMediatorComponent
    end object
    mWeaponMediator=TurokWeaponMediatorComponent
    // Reference: TurokMeleeMaulMeter'Default__TurokPawnMiniGunAutoTurretNative.MeterComponent'
    begin object name=MeterComponent
    end object
    mMeleeMaulMeter=MeterComponent
    // Reference: TurokAnimKnockdownController'Default__TurokPawnMiniGunAutoTurretNative.KnockdownComponent'
    begin object name=KnockdownComponent
    end object
    mKnockdownController=KnockdownComponent
    // Reference: TurokAISteer'Default__TurokPawnMiniGunAutoTurretNative.TurokAISteerComponent'
    begin object name=TurokAISteerComponent
    end object
    mSteer=TurokAISteerComponent
    // Reference: TurokAIPlanner'Default__TurokPawnMiniGunAutoTurretNative.TurokAIPlannerComponent'
    begin object name=TurokAIPlannerComponent
    end object
    mPlanner=TurokAIPlannerComponent
    // Reference: DynamicLightEnvironmentComponent'Default__TurokPawnMiniGunAutoTurretNative.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    mbEnableImpactAnims=false
    mbAllowDinoMelee=false
    mbUsePoweredRagdoll=false
    // Reference: TurokPathController'Default__TurokPawnMiniGunAutoTurretNative.TurokPathControllerComponent'
    begin object name=TurokPathControllerComponent
    end object
    mPathController=TurokPathControllerComponent
    // Reference: TurokTargetingSystem'Default__TurokPawnMiniGunAutoTurretNative.TurokTargetingSystemComponent'
    begin object name=TurokTargetingSystemComponent
    end object
    mTargetingSystem=TurokTargetingSystemComponent
    // Reference: TurokSoundController'Default__TurokPawnMiniGunAutoTurretNative.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    mTerrainSampleRadius=1.0000000
    mTerrainSinkHeight=4.5000000
    mTerrainFollowRayLengthMultiplier=2.0000000
    // Reference: TurokAnimLadderController'Default__TurokPawnMiniGunAutoTurretNative.ladderController'
    begin object name=ladderController
    end object
    mLadderController=ladderController
    HearingThreshold=0.0000000
    SightRadius=8000.0000000
    PeripheralVision=0.5700000
    BaseEyeHeight=7.5000000
    // Reference: SkeletalMeshComponent'Default__TurokPawnMiniGunAutoTurretNative.TurokSkeletalMeshComponent'
    begin object name=TurokSkeletalMeshComponent
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawnMiniGunAutoTurretNative.MyLightEnvironment'
    end object
    Mesh=TurokSkeletalMeshComponent
    // Reference: CylinderComponent'Default__TurokPawnMiniGunAutoTurretNative.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=25.0000000
        CollisionRadius=42.0000000
        BlockActors=false
    end object
    CylinderComponent=CollisionCylinder
    mDefaultTraceTypeFlags=65536
    mDefaultTraceSourceFlags=2052
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__TurokPawnMiniGunAutoTurretNative.Arrow'
    begin object name=Arrow
    end object
    Components[1]=Arrow
    Components[2]=TurokAISteerComponent
    Components[3]=TurokAIPlannerComponent
    Components[4]=TurokPathControllerComponent
    Components[5]=TurokTargetingSystemComponent
    Components[6]=MyLightEnvironment
    Components[7]=TurokSkeletalMeshComponent
    Components[8]=TurokSoundControllerComponent
    Components[9]=ladderController
    Components[10]=TurokWeaponMediatorComponent
    // Reference: SkeletalMeshComponent'Default__TurokPawnMiniGunAutoTurretNative.TurokHeadSkeletalMeshComponent'
    begin object name=TurokHeadSkeletalMeshComponent
        ParentAnimComponent=SkeletalMeshComponent'Default__TurokPawnMiniGunAutoTurretNative.TurokSkeletalMeshComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawnMiniGunAutoTurretNative.MyLightEnvironment'
    end object
    Components[11]=TurokHeadSkeletalMeshComponent
    Components[12]=MeterComponent
    Components[13]=KnockdownComponent
    Physics=1
    CollisionComponent=CollisionCylinder
}