//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDPawn extends TMPawn
    native(HDGame)
    config(TGPawn)
    dependson(HDWeapon, HDInventoryManager);

// move speed properties
var(Move) float         AimWalkingPct;
var(Move) float         BackWalkingPct;
var(Move) float         StrafeWalkingPct;
var(Move) float         SprintPct;

var bool                bIsAimWalking, bIsBackWalking, bIsStrafeWalking, bIsProneStop, bIsSprint;
var bool                bProneZoomStop;

// sprint logic
var bool                bCanSprint;
var bool                bSprintTag;
var float               CurrentSprintValue;
var float               SprintConsumeSpeed;
var float               SprintRecoverSpeed;
var bool                bCanStandUp;
var bool                bGearNoiseFlag;

// P1 Tree Node
var transient TMAnimNodeSequence  BaseNode, AddNode;
var transient AnimNodeAdditiveBlending  AdditiveBlendingNode;
var transient SkelControlSingleBone     PoseBlendNode;
var transient SkelControlSingleBone     AimTagAdsNode;
var transient SkelControlSingleBone     AimTagWeaponNode;
var transient GameSkelCtrl_Recoil       RecoilNode, AimHRecoilNode, AimWeaponRecoilNode, AimCamRecoilNode, HitRecoil;


// Night Vision
var bool                bCanNightVision;
var bool                bNVEquip;
var MaterialEffect                      NVEffect;
var transient MaterialInstanceConstant  NVEffectInstance;
var(Attach) editinline MeshComponent NightVision;
var name NVSocketName;

// falling logic
var float           FallingTime;
var bool            bFallingStand;

var HDDroppedPickup best_pickup;

// Telescope
var MaterialEffect  TelescopeEffect;
var transient MaterialInstanceConstant  TelescopeInstance;

// Gas Mask
var bool            bCanGasMask;
var bool            bGMEquip;
var MaterialEffect  GMEffect;
var transient MaterialInstanceConstant  GMEffectInstance;
var (Attach) editinline MeshComponent   GasMask;
var name            GMSocketName;

// Melee Weapon Attach
var (Attach) editinline MeshComponent   MeleeWeapon;
var name    MWSocketName;
var HDAttachment_Knife          MeleeAttachment;

var() transient protected SoundCue  PlayerHeartRateCue;
var AudioComponent                  PlayerHeartRateAudio;

// postprocess
var PostProcessSettings         CachedSetting;

// flash value
var MaterialEffect FlashEffect;
var transient MaterialInstanceConstant FlashEffectInstance;
var transient float FlashWeight;
var transient float FlashStep1Time, FlashStep2Time;
var transient bool  FlashUp, FlashDown;
var const HDSceneCapture2DComponentOnce     SceneCapture;
var float FlashDefaultStep1Time, FlashDefaultStep2Time;

// camera effect
var array<CameraAnim>            ShakeCameraAnim;
var HodPlayer hod;

// telescope
var bool                         bCanUsingTelescope;
var transient bool               bTSEquip;
var MaterialEffect               TSEffect;
var transient MaterialInstanceConstant  TSEffectInstance;
var float                        TelescopeFOV;

// explode effect
var MaterialEffect                      ExplodeEffect;
var transient MaterialInstanceConstant  ExplodeEffectInstance;
var class <RadialBlurActor>             ExplodeEffectClass;
var RadialBlurActor                     ExplodeActors[3];

// volume temp value
var transient bool                      bOldCrouch, bOldProne;

// tarce
// fire flag
var() float                     FirendlyFireDistance;
var transient byte              bFireState;    // 0  normal, 1 enemy, 2 firendly
var transient HDBaseGame        HDGameInfo;

/** Last time custom animation was played. */
var float   LastCustomAnimTime;
/** Controls how often you can send an custom animation. */
var float   MinTimeBetweenCustomAnims;


var bool    bShowDebugBox;

/** Holds the class type of the current weapon attachment.  Replicated to all clients. */
var repnotify   class<HDWeaponAttachment>   BackWeaponAttachmentClass[3];
/** This holds the local copy of the current attachment.  This "attachment" actor will exist independantly on all clients */
var             HDWeaponAttachment          BackWeaponAttachment[3];
// back weapon socket
var             name                        BackWeaponSocket[3];

//
var transient   bool                        bNextPutdownFront, bNextEquipFront;

//
var(Move)       float                       StandMoveSoundSeed,SprintSoundSeed;

// P3 Mesh Skeletal Controller Node
var SkelControlSingleBone                   LeftHandIKRot, RightHandIKRot, ZoomControlNode, UnZoomControlNode, WeaponRotControlNode, HighProneControlNode;
var SkelControlSingleBone                   LeftHandIKController, RightHandIKController;
var SkelControlSingleBone                   DeathRightHandIndex1, DeathRightHandIndex2;
var SkelControlSingleBone                   NeckController;
var AnimNodeBlendList                       ZoomBlend;
var AnimNodeBlendList                       StateBlend;
var GameSkelCtrl_Recoil                     FireNode, HitRecoilNode;
var repnotify   int                         HitCount;

struct native ClientDrawTips
{
    var bool    bDraw;
    var bool    bDrawIcon;
    var string  Command;
    var string  Tip;
    var TextureCoordinates Coordinates;
};

var ClientDrawTips                          ClientHudDrawTips;

// DamageCoefficient: For Gameplay, scale pawns damage cofficient, max 1 and min 0
var float                                   DamageCoefficient <UIMin=0.0 | UIMax=1.0 | ClampMin=0.0 | ClampMax=1.0>;

// IK Flag
var bool                                    bGlobalStopIKFlag, bActionStopIKFlag;

// Walking collide
var()   float                               WalkingCollisionOffset;


// prone pitch scale
var const   float                           ProneViewPitchScale;

// fire flag
var bool                                    bIsFiring;

// call support
var     HDWeaponAttachment                  CSTurretAttachment;

//current turret
var HDTurret_Base                           CurrentTurret;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

native function ResetMaxStepHeight( float value );
native function bool IsValidEnemyTargetFor(const PlayerReplicationInfo PRI, bool bNoPRIisEnemy);
native simulated function bool IsProne();
native simulated function bool IsCrouch();
native simulated function bool IsStand();

replication
{
    if (bNetDirty)
        BackWeaponAttachmentClass,
        bIsAimWalking, bIsBackWalking, bIsStrafeWalking, bIsProneStop, bIsSprint, bProneZoomStop,
        bFireState, best_pickup, bIsFiring,HitCount;
}

// set firing flag
simulated function SetFiringFlag( bool value )
{
    if ( ROLE == ROLE_Authority )
    {
        bIsFiring = value;
        bNetDirty = True;
    }
}

simulated event ReplicatedEvent(name VarName)
{
    if (VarName == 'BackWeaponAttachmentClass')
    {
        WeaponBackAttachmentChanged(0);
        WeaponBackAttachmentChanged(1);
        WeaponBackAttachmentChanged(2);
    }
    else if ( VarName == 'HitCount' )
    {
        PlayTakeDamageEffect();
    }
    else
    {
        super.ReplicatedEvent(VarName);
    }
}

/** Change the type of weapon animation we are playing. */
simulated function SetWeapAnimType(TMWeaponAttachment.EWeapAnimType AnimType)
{
    if (AimNode != None)
    {
        switch(AnimType)
        {
            case EWAT_Default:
                AimNode.SetActiveProfileByName('Rifle');
                break;
            case EWAT_Pistol:
                AimNode.SetActiveProfileByName('Pistol');
                break;
            case EWAT_Launcher:
                AimNode.SetActiveProfileByName('Launcher');
                break;
            case EWAT_Grenade:
                AimNode.SetActiveProfileByName('Grenade');
                break;
        }
    }
}

simulated event PostCrouch()
{
    if ( Abs(MaxStepHeight-default.MaxStepHeight) > 0.1f )
        ResetMaxStepHeight(default.MaxStepHeight);
}

simulated function InitHod()
{
    if( hod != none )
    {
        hod.team = 'allies';
        hod.type = 'human';
        //hod.accuracy = 0.3;
        hod.health = 100;
        //hod.weapon = 'mp5';
    }
}

reliable client function ClientInitializeLocalPostProcess( Controller C )
{
    // create NV effect material instance
    local LocalPlayer LPlayer;

    if ( C == None ) return;

    LPlayer = LocalPlayer(PlayerController(C).Player);

    if ( LPlayer == None ) return;


    if ( NVEffect == None )
    {
        NVEffect = MaterialEffect(LPlayer.PlayerPostProcess.FindPostProcessEffect('NVEffect'));
        if ( NVEffect != none )
        {
            if (MaterialInstanceConstant(NVEffect.Material) != None && NVEffect.Material.GetPackageName() == 'Transient')
            {
                // the runtime material already exists; grab it
                NVEffectInstance = MaterialInstanceConstant(NVEffect.Material);
            }
            else
            {
                NVEffectInstance = new(NVEffect) class'MaterialInstanceConstant';
                NVEffectInstance.SetParent(NVEffect.Material);
                NVEffect.Material = NVEffectInstance;
            }
            NVEffect.bShowInGame = false;
        }
    }
    // create GasMask effect material instance
    if ( GMEffect == None )
    {
        GMEffect = MaterialEffect(LPlayer.PlayerPostProcess.FindPostProcessEffect('GMEffect'));
        if ( GMEffect != none )
        {
            if (MaterialInstanceConstant(GMEffect.Material) != None && GMEffect.Material.GetPackageName() == 'Transient')
            {
                // the runtime material already exists; grab it
                GMEffectInstance = MaterialInstanceConstant(GMEffect.Material);
            }
            else
            {
                GMEffectInstance = new(GMEffect) class'MaterialInstanceConstant';
                GMEffectInstance.SetParent(GMEffect.Material);
                GMEffect.Material = GMEffectInstance;
            }
            GMEffect.bShowInGame = false;
        }
    }
    // create FlashGrenade effect material instance
    if ( FlashEffect == None )
    {
        FlashEffect = MaterialEffect(LPlayer.PlayerPostProcess.FindPostProcessEffect('FlashEffect'));
        if ( FlashEffect != none )
        {
            if (MaterialInstanceConstant(FlashEffect.Material) != None && FlashEffect.Material.GetPackageName() == 'Transient')
            {
                // the runtime material already exists; grab it
                FlashEffectInstance = MaterialInstanceConstant(FlashEffect.Material);
            }
            else
            {
                FlashEffectInstance = new(FlashEffect) class'MaterialInstanceConstant';
                FlashEffectInstance.SetParent(FlashEffect.Material);
                FlashEffect.Material = FlashEffectInstance;
            }
            FlashEffect.bShowInGame = false;
            FlashWeight = 0;
            FlashStep1Time = 0;
            FlashStep2Time = 0;
        }
    }
    // create GasMask effect material instance
    if ( ExplodeEffect == None )
    {
        ExplodeEffect = MaterialEffect(LPlayer.PlayerPostProcess.FindPostProcessEffect('Explode'));
        if ( ExplodeEffect != none )
        {
            if (MaterialInstanceConstant(ExplodeEffect.Material) != None && ExplodeEffect.Material.GetPackageName() == 'Transient')
            {
                // the runtime material already exists; grab it
                ExplodeEffectInstance = MaterialInstanceConstant(ExplodeEffect.Material);
            }
            else
            {
                ExplodeEffectInstance = new(ExplodeEffect) class'MaterialInstanceConstant';
                ExplodeEffectInstance.SetParent(ExplodeEffect.Material);
                ExplodeEffect.Material = ExplodeEffectInstance;
            }
            ExplodeEffect.bShowInGame = false;
        }
    }

        // create GasMask effect material instance
    if ( TelescopeEffect == None )
    {
        TelescopeEffect = MaterialEffect(LPlayer.PlayerPostProcess.FindPostProcessEffect('TelescopeHUD'));
        if ( TelescopeEffect != none )
        {
            if (MaterialInstanceConstant(TelescopeEffect.Material) != None && TelescopeEffect.Material.GetPackageName() == 'Transient')
            {
                // the runtime material already exists; grab it
                TelescopeInstance = MaterialInstanceConstant(TelescopeEffect.Material);
            }
            else
            {
                TelescopeInstance = new(TelescopeEffect) class'MaterialInstanceConstant';
                TelescopeInstance.SetParent(TelescopeEffect.Material);
                TelescopeEffect.Material = TelescopeInstance;
            }
            TelescopeEffect.bShowInGame = false;
        }
    }
}


simulated function PostBeginPlay()
{
    local int index;

	//CylinderComponent.SetTranslation(vect(5, 0, 0));
    super.PostBeginPlay();
    if ( ROLE == ROLE_Authority && TGGame(WorldInfo.Game) != none )
    {
        hod = HodPlayer( TGGame(WorldInfo.Game).system.NewObject(class'HodPlayer') );
        if( hod != none )
		{
	        InitHod();
	        health = hod.health;
	        hod.maxhealth = hod.health;
	        hod.Initialize(self);
    	}
    }

    PhysicsVolume.GroundFriction = 3.0;
    PlayerHeartRateAudio =CreateAndAttachAudioComponent(PlayerHeartRateCue,false);
    CachedSetting = WorldInfo.DefaultPostProcessSettings;

    //
    for ( index = 0; index < 3; ++index )
    {
        ExplodeActors[index] = Spawn(ExplodeEffectClass, self,, Location);
        if ( ExplodeActors[index] != None )
           ExplodeActors[index].RadialBlur.SetEnabled(False);
    }

    // initialize Game Info only for sp game
    if ( Role == Role_Authority )
        HDGameInfo = HDBaseGame(WorldInfo.Game);

    SetTimer( 0.1, true, 'TracePawnTarget' );
    //SetCollisionType(COLLIDE_BlockAllButWeapons);
}


function PossessedBy(Controller C, bool bVehicleTransition)
{
    ClientSetPRI(C);
    Super.PossessedBy( C, bVehicleTransition );

    ClientInitializeLocalPostProcess( C );
}

reliable client function ClientSetPRI( Controller C )
{
    if ( C.PlayerReplicationInfo != None )
	{
		PlayerReplicationInfo = C.PlayerReplicationInfo;
	}
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    local TMSkeletalMeshComponent TMSkelComp;
    TMSkelComp = TMSkeletalMeshComponent(SkelComp);
    if ( TMSkelComp == ArmsMesh[0] )
    {
       BaseNode = TMAnimNodeSequence(ArmsMesh[0].FindAnimNode('BaseNode'));
       AddNode = TMAnimNodeSequence(ArmsMesh[0].FindAnimNode('AddNode'));
       AdditiveBlendingNode = AnimNodeAdditiveBlending(ArmsMesh[0].FindAnimNode('AdditiveBlending'));
       PoseBlendNode = SkelControlSingleBone(ArmsMesh[0].FindSkelControl('PoseBlendNode'));
       RecoilNode = GameSkelCtrl_Recoil(ArmsMesh[0].FindSkelControl('Recoil'));
       AimHRecoilNode = GameSkelCtrl_Recoil(ArmsMesh[0].FindSkelControl('AimRecoil'));
       AimWeaponRecoilNode = GameSkelCtrl_Recoil(ArmsMesh[0].FindSkelControl('AimWeaponRecoil'));
       AimCamRecoilNode = GameSkelCtrl_Recoil(ArmsMesh[0].FindSkelControl('AimCamRecoil'));
       AimTagAdsNode = SkelControlSingleBone(ArmsMesh[0].FindSkelControl('AimAdsNode'));
       AimTagWeaponNode = SkelControlSingleBone(ArmsMesh[0].FindSkelControl('AimWeapon'));
       AimTagAdsNode.SetSkelControlStrength( 0, 0 );
       AimTagWeaponNode.SetSkelControlStrength( 0, 0 );
       HitRecoil = GameSkelCtrl_Recoil(ArmsMesh[0].FindSkelControl('HitRecoil'));
    }
    if (SkelComp == Mesh)
    {
        LeftLegControl = SkelControlFootPlacement(Mesh.FindSkelControl(LeftFootControlName));
        RightLegControl = SkelControlFootPlacement(Mesh.FindSkelControl(RightFootControlName));
        //FeignDeathBlend = AnimNodeBlend(Mesh.FindAnimNode('FeignDeathBlend'));
        FullBodyAnimSlot = AnimNodeSlot(Mesh.FindAnimNode('FullBodySlot'));
        TopHalfAnimSlot = AnimNodeSlot(Mesh.FindAnimNode('TopHalfSlot'));

        LeftHandIK = SkelControlLimb( mesh.FindSkelControl('LeftHandIK') );
        RightHandIK = SkelControlLimb( mesh.FindSkelControl('RightHandIK') );

        RootRotControl = SkelControlSingleBone( mesh.FindSkelControl('RootRot') );
        AimNode = AnimNodeAimOffset( mesh.FindAnimNode('AimNode') );
        ZoomBlend = AnimNodeBlendList( mesh.FindAnimNode('ZoomBlend') );
        StateBlend = AnimNodeBlendList( mesh.FindAnimNode('StateBlend') );
        GunRecoilNode = GameSkelCtrl_Recoil( mesh.FindSkelControl('GunRecoilNode') );
        UpperRecoilNode = GameSkelCtrl_Recoil( mesh.FindSkelControl('UpperRecoilNode') );
        FireNode = GameSkelCtrl_Recoil( mesh.FindSkelControl('FireNode') );
        HitRecoilNode = GameSkelCtrl_Recoil( mesh.FindSkelControl('HitRecoilNode') );

        //LeftRecoilNode = GameSkelCtrl_Recoil( mesh.FindSkelControl('LeftRecoilNode') );
        //RightRecoilNode = GameSkelCtrl_Recoil( mesh.FindSkelControl('RightRecoilNode') );

        LeftHandIKRot = SkelControlSingleBone( Mesh.FindSkelControl('LeftHandIKRot') );
        RightHandIKRot = SkelControlSingleBone( Mesh.FindSkelControl('RightHandIKRot') );
        ZoomControlNode = SkelControlSingleBone( Mesh.FindSkelControl('ZoomControlNode') );
        UnZoomControlNode = SkelControlSingleBone( Mesh.FindSkelControl('UnZoomControlNode') );
        WeaponRotControlNode = SkelControlSingleBone( Mesh.FindSkelControl('WeaponRotControlNode') );
        HighProneControlNode = SkelControlSingleBone( Mesh.FindSkelControl('HighProneControlNode') );

        LeftHandIKController = SkelControlSingleBone( Mesh.FindSkelControl('LeftHandIKController') );
        RightHandIKController = SkelControlSingleBone( Mesh.FindSkelControl('RightHandIKController') );

        DeathRightHandIndex1 =  SkelControlSingleBone( Mesh.FindSkelControl('DeathRightHandIndex1') );
        DeathRightHandIndex2 =  SkelControlSingleBone( Mesh.FindSkelControl('DeathRightHandIndex2') );
        NeckController =  SkelControlSingleBone( Mesh.FindSkelControl('NeckControl') );
    }
}

function TossInventory(Inventory Inv, optional vector ForceVelocity)
{
/*  local vector    POVLoc, TossVel;
    local rotator   POVRot;
    local Vector    X,Y,Z;

    if ( ForceVelocity != vect(0,0,0) )
    {
        TossVel = ForceVelocity;
    }
    else
    {
        GetActorEyesViewPoint(POVLoc, POVRot);
        TossVel = Vector(POVRot);
        TossVel = TossVel * ((Velocity Dot TossVel) + 50) + Vect(0,0,20);
    }

    GetAxes(Rotation, X, Y, Z);
    Inv.DropFrom(Location + 0.8 * CylinderComponent.CollisionRadius * X - 0.5 * CylinderComponent.CollisionRadius * Y, TossVel);
*/
    Inv.DropFrom(Location, Vect(0,0,-10));
}

simulated function SyncWeaponAttachmentChanged()
{
    local HDWeaponAttachment wa;

    if ((CurrentWeaponAttachment == None || CurrentWeaponAttachment.Class != CurrentWeaponAttachmentClass) && Mesh.SkeletalMesh != None)
    {
        wa = HDWeaponAttachment(CurrentWeaponAttachment);

        if (wa != none)
        {
            CurrentWeaponAttachment.DetachFrom(ArmsMesh[0]);
            CurrentWeaponAttachment.Destroy();
        }
        // Detach/Destroy the current attachment if we have one
        else if (CurrentWeaponAttachment!=None)
        {
            CurrentWeaponAttachment.DetachFrom(Mesh);
            CurrentWeaponAttachment.Destroy();
        }

        // Create the new Attachment.
        if (CurrentWeaponAttachmentClass!=None)
        {
            CurrentWeaponAttachment = Spawn(CurrentWeaponAttachmentClass,self);
            CurrentWeaponAttachment.Instigator = self;
            UpdatePawnAnimSets();
        }
        else
            CurrentWeaponAttachment = none;

        // if all is good, attach it to the Pawn's Mesh.
        if (CurrentWeaponAttachment != None)
        {
            CurrentWeaponAttachment.AttachTo(self);
            CurrentWeaponAttachment.SetSkin(ReplicatedBodyMaterial);
            CurrentWeaponAttachment.ChangeVisibility(bWeaponAttachmentVisible);
        }
    }
}
simulated function WeaponAttachmentChanged()
{
    SyncWeaponAttachmentChanged();
}

//---------------------------------------------------------
// switch weapon
//---------------------------------------------------------
simulated function SwitchGrenadeWeapon( byte Type )
{
    if (HDInventoryManager(InvManager) != None)
    {
        ;
        if ( Physics != PHYS_Ladder )
           HDInventoryManager(InvManager).SwitchGrenadeWeapon( Type );
    }
}
simulated function ThrowGrenade( byte Type )
{
    if (HDInventoryManager(InvManager) != none)
    {
        HDInventoryManager(InvManager).ThrowGrenade( Type );
    }
}

simulated function SwitchConventionalWeaponSroll( byte Value )
{
    if (HDInventoryManager(InvManager) != None)
    {
        ;
        if ( Physics != PHYS_Ladder )
           HDInventoryManager(InvManager).SwitchConventionalWeaponSroll( Value );
    }
}

simulated function SwitchConventionalWeapon( byte Type )
{
    if (HDInventoryManager(InvManager) != None)
    {
        ;
        if ( Physics != PHYS_Ladder )
           HDInventoryManager(InvManager).SwitchConventionalWeapon( Type );
    }
}

simulated function SwitchSpecialWeapon( byte Type )
{
    if (HDInventoryManager(InvManager) != None)
    {
        ;
        if ( Physics != PHYS_Ladder )
           HDInventoryManager(InvManager).SwitchSpecialWeapon( Type );
    }
}

simulated function SwitchWeaponFireMode( byte Type )
{
    if (HDInventoryManager(InvManager) != None)
    {
        ;
        if ( Physics != PHYS_Ladder )
           HDInventoryManager(InvManager).SwitchWeaponFireMode( Type );
    }
}


simulated function SwitchToLastConventionalWeapon()
{
    if (HDInventoryManager(InvManager) != None)
    {
        ;
        if ( Physics != PHYS_Ladder )
           HDInventoryManager(InvManager).SwitchToLastConventionalWeapon();
    }
}



simulated function SwitchWeapon(byte NewGroup)
{
    if (TMInventoryManager(InvManager) != None)
    {
        ;
        if ( Physics != PHYS_Ladder )
           TMInventoryManager(InvManager).SwitchWeapon(NewGroup);
    }
}


// Reload Action
function ReloadWeapon()
{
    local HDWeapon HDW;
    HDW = HDWeapon(Weapon);

    if (HDW == none)
        return;

    HDW.Reload();
}

unreliable sync function SyncHandleRelaodInterupt()
{
    local HDWeapon HDW;
    HDW = HDWeapon(Weapon);
    if ( HDW == None || !HDW.IsInState('WeaponReload') ) return;
    DoPlayCustomAnim('Reload', 1.0f);
}
simulated function PlayReloadAnim()
{
    //bActionStopIKFlag = True;
    //SetHandIKEnabled(False);
    DoPlayCustomAnim('Reload');
}
simulated function EndReloadAnim()
{
    ClearTimer('SyncHandleRelaodInterupt');
    DoStopCustomAnim( True, 0.1f );
}

// Melee Action
simulated function PlayMeleeAction()
{
    local HDWeapon HDW;
    if ( Role == ROLE_Authority )
    {
        HDW = HDWeapon(Weapon);
        if ( HDW == None ) return;
    }
    //bActionStopIKFlag = True;
    //SetHandIKEnabled(False);
    DoPlayCustomAnim('Melee');
    SetTimer(0.1f, false, 'AddMeleeAttachment');
    SetTimer(0.7f, false, 'RemoveMeleeAttachment');
    //SetTimer( HDW.MeleeTime + 0.35, false, 'ServerEndMeleeAction' );
}

simulated function AddMeleeAttachment()
{
    // 3rd person...
    if ( Role >= ROLE_SimulatedProxy )
    {
        //if (WorldInfo.NetMode == NM_ListenServer || WorldInfo.NetMode == NM_Standalone || (WorldInfo.NetMode == NM_Client && IsLocallyControlled()))
        //{
            if ( MeleeAttachment == none )
            {
                MeleeAttachment = Spawn(class'HDAttachment_Knife', self);
                MeleeAttachment.Instigator = self;
            }
            if ( MeleeAttachment != none )
                MeleeAttachment.AttachTo(self);
        //}
    }
}

simulated function RemoveMeleeAttachment()
{
    // 3rd person...
    if ( Role >= ROLE_SimulatedProxy )
    {
        //if (WorldInfo.NetMode == NM_ListenServer || WorldInfo.NetMode == NM_Standalone || (WorldInfo.NetMode == NM_Client && IsLocallyControlled()))
        //{
            if ( MeleeAttachment != none )
                MeleeAttachment.DetachFrom(Mesh);
        //}
    }
}

simulated function EndMeleeAction()
{
    DoStopCustomAnim( True, 0.1f );
}

// Weapon Change Action
simulated function InitializeWeaponEquip()
{
    local HDWeaponAttachment HDWA;
    HDWA = HDWeaponAttachment(CurrentWeaponAttachment);
    if ( HDWA == None ) return;

    //LeftHandIK.EffectorLocation = HDWA.LeftHandIKEffector;

    if( LeftHandIK != none )
		LeftHandIK.JointTargetLocation = HDWA.LeftHandIKJoint;

	if( LeftHandIKRot != none )
		LeftHandIKRot.BoneRotation = HDWA.LeftHandRot;

	if( LeftHandIKController != none )
		LeftHandIKController.BoneTranslation = HDWA.LeftHandIKEffector;

	if( RightHandIK != none )
		RightHandIK.JointTargetLocation = HDWA.RightHandIKJoint;

	if( RightHandIKRot != none )
        RightHandIKRot.BoneRotation = HDWA.RightHandRot;

	if( RightHandIKController != none )
	    RightHandIKController.BoneTranslation = HDWA.RightHandIKEffector;

	//RightHandIK.EffectorLocation = HDWA.RightHandIKEffector;

	if( ZoomControlNode != none )
	{
		ZoomControlNode.BoneTranslation = HDWA.ZoomTranslation;
	    ZoomControlNode.BoneRotation = HDWA.ZoomRotation;
	}

    if( UnZoomControlNode != none )
	{
		UnZoomControlNode.BoneTranslation = HDWA.UnZoomTranslation;
	    UnZoomControlNode.BoneRotation = HDWA.UnZoomRotation;
	}

    if( WeaponRotControlNode != none )
		WeaponRotControlNode.BoneRotation = HDWA.WeaponRot;

	bGlobalStopIKFlag = HDWA.bStopHumanIK;

    if( HighProneControlNode != none )
	{
		HighProneControlNode.BoneTranslation = HDWA.HighProneWeaponOffset;
    	HighProneControlNode.BoneRotation = HDWA.HighProneWeaponRotOffset;
    }

    if( NeckController != none )
		NeckController.BoneRotation = HDWA.NeckZoomAimRot;
}

// Equip
reliable sync function SyncPawnEquipWeapon()
{
    if ( ROLE >= ROLE_AutonomousProxy && IsLocallyControlled() )
        EquipWeaponAction();
    if ( ROLE == ROLE_SimulatedProxy || !IsLocallyControlled() )
    {
        // defer play animation while update animation set list
        ;
    }
}

simulated function PawnEquipWeapon()
{
    LeaveSprint();
    SyncPawnEquipWeapon();
}

simulated function EquipWeaponAction()
{
    //bActionStopIKFlag = True;
    //SetHandIKEnabled(False);

    if ( bNextEquipFront )
    {
        DoPlayCustomAnim('EquipFront');
    }
    else
    {
       DoPlayCustomAnim('Equip');
    }
    bNextEquipFront = False;
}

reliable sync function SyncPawnEquipWeaponEnd()
{
    EquipWeaponEndAction();
}
simulated function PawnEquipWeaponEnd()
{
    SyncPawnEquipWeaponEnd();
}

simulated function EquipWeaponEndAction()
{
    InitializeWeaponEquip();
    DoStopCustomAnim( True, 0.1f );
//    if( HDGameInfo != none && HDGameInfo.bMatchingWeaponSwitch )
//    {
//        // while in DroppedPickup Volume, check weapon matching when weapon switching
//        ServerBestPickup();
//    }
}

// Putdown
unreliable sync function SyncPawnPutdownWeapon()
{
    PutdownWeaponAction();
}
reliable sync function SyncPawnPutdownFunction( bool value )
{
    bNextPutdownFront = value;
}
reliable sync function SyncPawnEquipFunction( bool value )
{
    bNextEquipFront = value;
}

simulated function PawnPutdownWeapon()
{
    local HDWeap_Grenade PendingGrenade, CurrentGrenade;
    PendingGrenade = HDWeap_Grenade(InvManager.PendingWeapon);
    CurrentGrenade = HDWeap_Grenade(Weapon);

    bNextPutdownFront = false;
    bNextEquipFront = false;

    if ( PendingGrenade != None )
        bNextPutdownFront = True;
    if ( CurrentGrenade != None )
        bNextEquipFront = True;
    SyncPawnPutdownFunction(bNextPutdownFront);
    SyncPawnEquipFunction(bNextEquipFront);
    SyncPawnPutdownWeapon();
}

unreliable sync function SyncPawnPutdownWeaponEnd()
{
    PutdownWeaponEndAction();
}
simulated function PawnPutdownWeaponEnd()
{
    SyncPawnPutdownWeaponEnd();
}

simulated function PutdownWeaponAction()
{
    //bActionStopIKFlag = True;
    //SetHandIKEnabled(False);
    if ( bNextPutdownFront )
    {
        DoPlayCustomAnim('PutdownFront');
    }
    else
    {
        DoPlayCustomAnim('Putdown');
    }
    bNextPutdownFront = False;
    //SyncPawnPutdownFunction(False);
}

simulated function PutdownWeaponEndAction()
{
    local HDInventoryManager HDIM;
    local int index;
    local HDWeap_Grenade Grenade;

    if( InvManager == none )		return;

    Grenade = HDWeap_Grenade(InvManager.PendingWeapon);

    DoStopCustomAnim( True, 0.1f );
    HDIM = HDInventoryManager(InvManager);
    if ( HDIM != None && HDIM.PendingWeapon != None && Grenade == None )
    {
       for ( index = 0; index < 3; ++index )
       {
            //if ( HDWeapon(HDIM.PendingWeapon).AttachmentClass == BackWeaponAttachmentClass[index] )
            if ( BackWeaponAttachmentClass[index] == None ) continue;

            if ( class<HDWeaponAttachment>(HDWeapon(HDIM.PendingWeapon).AttachmentClass).default.AttachType ==
                 BackWeaponAttachmentClass[index].default.AttachType )
            {
                BackWeaponAttachmentClass[index] = None;
                WeaponBackAttachmentChanged(index);
                break;
            }
       }
    }
}

// zoom
unreliable sync function SyncSetPawnZoomState( float weight )
{
    ZoomBlend.SetActiveChild(weight, 0.1);
}

simulated function EnablePawnZoom( vector AdsLocation, rotator AdsRotation, float time )
{
    if ( IsLocallyControlled() )
    {
        if ( bIsProne && VSizeSq(Velocity) > 0.01f )
            SetProneZoomStopFlag(True);

        AimTagAdsNode.BoneTranslation = AdsLocation;
	    AimTagAdsNode.BoneRotation = AdsRotation;
	    AimTagAdsNode.SetSkelControlStrength ( 1.0, time );
	    AdditiveBlendingNode.SetBlendTarget( 0.0f, 0.0f );
        SyncSetPawnZoomState(1.0);
    }
}

simulated function DisablePawnZoom( float time )
{
    if ( IsLocallyControlled() || CurrentTurret != None )
    {
        AimTagAdsNode.SetSkelControlStrength ( 0.0, time );
        AimTagWeaponNode.SetSkelControlStrength ( 0.0, time );
        AdditiveBlendingNode.SetBlendTarget( 0.0f, 0.0f );
        if ( bProneZoomStop == True )
            SetProneZoomStopFlag(False);
        SyncSetPawnZoomState(0.0);
    }
}

// Update eye height
event UpdateEyeHeight( float DeltaTime )
{
    local HDWeapon HDW;

    local float smooth, MaxEyeHeight, OldEyeHeight, Speed2D, OldBobTime;
    local Actor HitActor;
    local vector HitLocation,HitNormal, X, Y, Z;
    local int m,n;
    local float tmp;
    if ( bTearOff )
    {
        // no eyeheight updates if dead
        EyeHeight = Default.BaseEyeheight;
        bUpdateEyeHeight = false;
        return;
    }

    if ( abs(Location.Z - OldZ) > 15 )
    {
        // if position difference too great, don't do smooth land recovery
        bJustLanded = false;
        bLandRecovery = false;
    }

    if ( !bJustLanded )
    {
        // normal walking around
        // smooth eye position changes while going up/down stairs
        smooth = FMin(0.9, 10.0 * DeltaTime/CustomTimeDilation);
        LandBob *= (1 - smooth);
        if( Physics == PHYS_Walking || Physics==PHYS_Spider || Controller.IsInState('PlayerSwimming') )
        {
            OldEyeHeight = EyeHeight;
            EyeHeight = FMax((EyeHeight - Location.Z + OldZ) * (1 - smooth) + BaseEyeHeight * smooth,
                                -0.5 * CylinderComponent.CollisionHeight);
        }
        else
        {
            EyeHeight = EyeHeight * ( 1 - smooth) + BaseEyeHeight * smooth;
        }
    }
    else if ( bLandRecovery )
    {
        // return eyeheight back up to full height
        smooth = FMin(0.9, 9.0 * DeltaTime);
        OldEyeHeight = EyeHeight;
        LandBob *= (1 - smooth);
        // linear interpolation at end
        if ( Eyeheight > 0.9 * BaseEyeHeight )
        {
            Eyeheight = Eyeheight + 0.15*BaseEyeheight*Smooth;  // 0.15 = (1-0.75)*0.6
        }
        else
            EyeHeight = EyeHeight * (1 - 0.6*smooth) + BaseEyeHeight*0.6*smooth;
        if ( Eyeheight >= BaseEyeheight)
        {
            bJustLanded = false;
            bLandRecovery = false;
            Eyeheight = BaseEyeheight;
        }
    }
    else
    {
        // drop eyeheight a bit on landing
        smooth = FMin(0.65, 8.0 * DeltaTime);
        OldEyeHeight = EyeHeight;
        EyeHeight = EyeHeight * (1 - 1.5*smooth);
        LandBob += 0.1 * (Eyeheight - OldEyeHeight );//0.08 * (OldEyeHeight - Eyeheight);
        if ( (Eyeheight < 0.25 * BaseEyeheight + 1) || (LandBob > 2.4)  )
        {
            bLandRecovery = true;
            Eyeheight = 0.25 * BaseEyeheight + 1;
        }
    }

    // don't bob if disabled, or just landed
    if( bJustLanded || !bUpdateEyeheight )
    {
        BobTime = 0;
        WalkBob = Vect(0,0,0);
    }
    else
    {
        // add some weapon bob based on jumping
        if ( Velocity.Z > 0 )
        {
          JumpBob = 0; // when up no bob here--wk//FMax(-1.5, JumpBob - 0.03 * DeltaTime * FMin(Velocity.Z,300));
        }
        else
        {
          JumpBob *= (1 -  FMin(1.0, 8.0 * DeltaTime));
        }

        // Add walk bob to movement
        OldBobTime = BobTime;
        Bob = FClamp(Bob, -0.05, 0.05);

        if (Physics == PHYS_Walking )
        {
          GetAxes(Rotation,X,Y,Z);
          Speed2D = VSize(Velocity);
          if ( Speed2D < 10 )
              BobTime += 0.2 * DeltaTime;
          else
              BobTime += DeltaTime * (0.3 + 0.7 * Speed2D/GroundSpeed);
          WalkBob = Y * Bob * Speed2D * sin(8 * BobTime);
          AppliedBob = AppliedBob * (1 - FMin(1, 16 * deltatime));
          WalkBob.Z = AppliedBob;
          if ( Speed2D > 10 )
              WalkBob.Z = WalkBob.Z + 0.9 * Bob * Speed2D * sin(16 * BobTime);
        }
        else if ( Physics == PHYS_Swimming )
        {
          GetAxes(Rotation,X,Y,Z);
          BobTime += DeltaTime;
          Speed2D = Sqrt(Velocity.X * Velocity.X + Velocity.Y * Velocity.Y);
          WalkBob = Y * Bob *  0.5 * Speed2D * sin(4.0 * BobTime);
          WalkBob.Z = Bob * 1.5 * Speed2D * sin(8.0 * BobTime);
        }
        else
        {
          BobTime = 0;
          WalkBob = WalkBob * (1 - FMin(1, 8 * deltatime));
        }

        if ( (Physics == PHYS_Walking) && (VSizeSq(Velocity) > 100) && IsFirstPerson() )
        {
            tmp = (VSizeSq(Velocity)>300*300)? SprintSoundSeed : StandMoveSoundSeed;
            m = int(0.5 * Pi + tmp * OldBobTime/Pi);
            n = int(0.5 * Pi + tmp * BobTime/Pi);

            if ( (m != n) && !bIsWalking && !bIsCrouched )
            {
              bGearNoiseFlag = true;
              PlayFootStepSound(0);
              //`log("footsetp sound play!");
            }
            else if( (m != n) && !bIsWalking && bIsCrouched )
            {
              bGearNoiseFlag = true;
              PlayCrouchedFootStepSound(0);
            }

            m = 2 * int(0.5 * Pi + tmp * BobTime/Pi);
            n = int(2* (0.5 * Pi + tmp * BobTime/Pi));
            if(bGearNoiseFlag)
            {
              if(m != n)
              {
                   bGearNoiseFlag = false;
                   ActuallyPlayGearsNoiseSound();
              }
            }
        }
        if ( !bWeaponBob )
        {
            WalkBob *= 0.1;
        }
    }
    if ( (CylinderComponent.CollisionHeight - Eyeheight < 12) && IsFirstPerson() )
    {
      // desired eye position is above collision box
      // check to make sure that viewpoint doesn't penetrate another actor
        // min clip distance 12
        if (bCollideWorld && Physics != PHYS_Ladder)
        {
            HitActor = trace(HitLocation,HitNormal, Location + WalkBob + (MaxStepHeight + CylinderComponent.CollisionHeight) * vect(0,0,1),
                          Location + WalkBob, true, vect(9,9,12),, TRACEFLAG_Blocking);
            MaxEyeHeight = (HitActor == None) ? CylinderComponent.CollisionHeight + MaxStepHeight : HitLocation.Z - Location.Z;
            Eyeheight = FMin(Eyeheight, MaxEyeHeight);
        }
    }

    HDW = HDWeapon(Weapon);
    if ( HDW != none )
    {
        WalkBob = WalkBob * 0.5;
        if ( HDW.GetZoomedState() == ZST_Zoomed )
        {
            WalkBob = WalkBob * AimWalkingPct * 0.2;
        }
    }
}

simulated function ProcessViewRange()
{
    ViewPitchMin = default.ViewPitchMin;
    ViewPitchMax = default.ViewPitchMax;

    if ( ( bIsProne ) )
    {
        ViewPitchMin = default.ViewPitchMin * ProneViewPitchScale;
        ViewPitchMax = default.ViewPitchMax * ProneViewPitchScale;
    }
}


simulated function CalcWalkingSpeedTick()
{
    local float GroupMoveScale, GroupLadderScale;
    local AnimTree     BaseTree;

    CrouchedPct = default.CrouchedPct;
    PronedPct = default.PronedPct;
    WalkingPct = default.WalkingPct;
    GroupMoveScale = 1.0f;
    GroupLadderScale = 0.0f;

    if ( bIsSprint )
    {
        WalkingPct *= SprintPct;
        PronedPct *= SprintPct;
    }
    else
    {
        if ( bIsBackWalking )
        {
            WalkingPct *= BackWalkingPct;
            CrouchedPct *= BackWalkingPct;
            PronedPct *= BackWalkingPct;
            GroupMoveScale *= BackWalkingPct;
        }
        else if ( bIsStrafeWalking )
        {
            WalkingPct *= StrafeWalkingPct;
            CrouchedPct *= StrafeWalkingPct;
            PronedPct *= StrafeWalkingPct;
            GroupMoveScale *= StrafeWalkingPct;
        }
        if ( bIsAimWalking )
        {
            WalkingPct *= AimWalkingPct;
            CrouchedPct *= AimWalkingPct;
            GroupMoveScale *= AimWalkingPct;
        }
    }
    if ( bIsProneStop || bProneZoomStop )
    {
        PronedPct = 0;
    }
    // for 3p anim tree setting
    BaseTree = (Mesh!=None)?AnimTree(Mesh.Animations) : None;
    if ( BaseTree != None )
    {
        BaseTree.SetGroupRateScale('Move', GroupMoveScale);
        if ( Physics == PHYS_Ladder && VSize(Velocity) > 0.001f )
        {
            GroupLadderScale = (Velocity.Z >= 0) ? 1.f : -1.f;
        }
        BaseTree.SetGroupRateScale('Ladder', GroupLadderScale);
    }
}

simulated function HandlePawnMove( float DeltaTime, bool bIsMoveBackward, bool bIsMoveStrafe )
{
    CalcPawnMoving( DeltaTime, bisMoveBackward, bIsMoveStrafe );
    HandlePawnSprint( DeltaTime );
    HandlePawnProneJumpLogic();
}

simulated function HandlePawnProneJumpLogic()
{
    local HDPlayerController HDPC;
    HDPC = HDPlayerController(Controller);
    if ( HDPC == None ) return;

    if ( Physics == PHYS_Walking )
    {
        FallingTime = WorldInfo.TimeSeconds;
    }
    else if ( Physics == PHYS_Falling && bFallingStand )
    {
        if ( WorldInfo.TimeSeconds - FallingTime > 0.2 )
        {
            HDPC.bDuck = (HDPC.bProne == 0)? HDPC.bDuck : 255;
            HDPC.bProne = 0;
            ShouldCrouchOrProne( HDPC.bDuck != 0, false );
            FallingTime = WorldInfo.TimeSeconds;
        }
    }
}
simulated function HandlePawnSprint( float DeltaTime )
{
    local HDPlayerController HDPC;
    HDPC = HDPlayerController(Controller);
    if ( HDPC == None ) return;

    // calc sprint time
    if ( bSprintTag || HDPC.bJumpSprint )
    {
        CurrentSprintValue = FMax( 0, CurrentSprintValue - DeltaTime * SprintConsumeSpeed );
        if (CurrentSprintValue == 0)
        {
            LeaveSprint();
            SetTimer( 0.001, false, 'EndSprint' );
            HDPC.bRecoverSprint = 1;
            HDPC.LastSprintRecoverTime = WorldInfo.TimeSeconds;
            HDPC.bJumpSprint = False;
        }
    }
    else
    {
        CurrentSprintValue = FClamp( CurrentSprintValue + DeltaTime * SprintRecoverSpeed, 0, default.CurrentSprintValue );
        if ( HDPC.bRecoverSprint == 1 )
        {
           if ( WorldInfo.TimeSeconds - HDPC.LastSprintRecoverTime > HDPC.SprintRecoverTime )
           {
               HDPC.bRecoverSprint = 0;
           }
        }
    }
}

simulated function SetPawnMovingFlag( bool bIsMoveSprint, bool bIsBackMove, bool bIsStrafe, bool bIsAim, bool bIsProneStopMoving , bool bIsProneZoomStop )
{
    bIsSprint = bIsMoveSprint;
    bIsBackWalking = bIsBackMove;
    bIsStrafeWalking = bIsStrafe;
    bIsAimWalking = bIsAim;
    bIsProneStop = bIsProneStopMoving;
}

simulated function SetPawnMoving( bool bIsMoveSprint, bool bIsBackMove, bool bIsStrafe, bool bIsAim, bool bIsProneStopMoving, bool bIsProneZoomStop )
{
    if ( ROLE >= ROLE_AutonomousProxy )
    {
        if ( bIsSprint != bIsMoveSprint || bIsBackWalking != bIsBackMove
        || bIsStrafeWalking != bIsStrafe || bIsAimWalking != bIsAim
        || bIsProneStop != bIsProneStopMoving)
        {
            ServerSetPawnMovingFlag( bIsMoveSprint, bIsBackMove, bIsStrafe, bIsAim, bIsProneStopMoving, bIsProneZoomStop );
        }
    }

    //ServerSetPawnMovingFlag( bIsMoveSprint, bIsBackMove, bIsStrafe, bIsAim, bIsProneStopMoving );
}


reliable server function ServerSetPawnMovingFlag( bool bIsMoveSprint, bool bIsBackMove, bool bIsStrafe, bool bIsAim, bool bIsProneStopMoving, bool bIsProneZoomStop )
{
    SetPawnMovingFlag( bIsMoveSprint, bIsBackMove, bIsStrafe, bIsAim, bIsProneStopMoving, bIsProneZoomStop );
    bNetDirty = TRUE;
}

simulated function SetProneZoomStopFlag( bool Flag )
{
    if( Role < Role_Authority )
    {
        ServerSetProneZoomStopFlag( Flag );
    }
    bProneZoomStop = flag;
}

reliable server function ServerSetProneZoomStopFlag( bool flag )
{
    bProneZoomStop = flag;
}


simulated function CalcPawnMoving( float DeltaTime, bool bIsMoveBackward, bool bIsMoveStrafe )
{
    local HDWeapon HDW;
    local HDPlayerController HDPC;
    local bool bSprint, bBackWalking, bStrafeWalking, bAimWalking, bProneStop;

    HDPC = HDPlayerController(Controller);
    HDW = HDWeapon(Weapon);

    if ( HDPC == None || HDW == None ) return;

    if ( !bCanStandUp )
    {
        bSprintTag = false;
    }


    if ( HDPC !=none && HDPC.IsInState('PlayerWalking') )
    {
        bSprint = bSprintTag;
        bBackWalking =  bIsMoveBackward;
        bStrafeWalking = bIsMoveStrafe;
        bAimWalking = (HDW != None && HDW.GetZoomedState() == ZST_Zoomed);
    }

    // prone: not moving while firing, reloading
    bProneStop = false;
    if ( bIsProne || bWantsToProne )
    {
        if ( !HDW.IsInState('Active') && !HDW.IsInState('WeaponHidden') )
        {
            bProneStop = true;
        }
        if ( !HDW.IsInState('Active') && !HDW.IsInState('WeaponHidden') && !HDW.IsInState('WeaponFiring') )
        {
            SetProneZoomStopFlag(False);
        }
    }

    SetPawnMoving( bSprint, bBackWalking, bStrafeWalking, bAimWalking, bProneStop, bProneZoomStop );
}


function PickupItem()
{
    ServerPickupItem();
}

reliable server function ServerClearBestPickup()
{
    ClearBestPickup();
}
simulated function ClearBestPickup()
{
    best_pickup = None;
    ClientDisableDynamicTip();
}
simulated function ClearBestPickupObject()
{
    if ( ROLE < ROLE_Authority )
    {
        ServerClearBestPickup();
    }
    ClearBestPickup();
}
reliable server function ServerPickupItem()
{
    local HDInventoryManager HDIM;

    if (best_pickup == none)
        return;

    HDIM = HDInventoryManager(InvManager);
    if ( HDIM != none && !HDIM.bStopPickUp )
    {
        if (HDIM.PickupItem(best_pickup))
        {
            best_pickup.PickedUpBy(self);
        }
        ServerBestPickup(best_pickup);
        LeaveSprint();
        //[ Comment WK: disable find pickup item
//        // find new weapon can be picked up
//        if ( !IsLocallyControlled() )
//        {
//            // if client, set pending time for finding pickup item
//            SetTimer( 0.35, false, 'ServerBestPickup' );
//        }
//        else
//            ServerBestPickup();
        // WK]
    }
}

reliable server function ServerBestPickup(optional HDDroppedPickup skiped)
{
    local HDDroppedPickup dp;
    local HDWeapon HDW;
    ClearTimer('ServerBestPickup');
    if ( best_pickup != None )
        best_pickup.UnPossessed();
    best_pickup = none;
    // if living
    if ( Health > 0 )
    {
        foreach TouchingActors(class'HDDroppedPickup', dp)
        {
            if (skiped != dp && dp.IsValidTouch(self))
            {
                best_pickup = dp;
                best_pickup.PossessedByPawn(self);
                break;
            }
        }
    }

    if ( best_pickup != None  )
    {
       HDW = HDWeapon(best_pickup.Inventory);
       if ( HDW != None )
       {
            ClientDrawDynamicTip( "GBA_PickupItem", HDW.PickupMessage, HDW.IconTexCoord[0], True );
            return;
       }
    }
    ClientDisableDynamicTip();
}


function TouchDroppedPickup(HDDroppedPickup Item)
{
    if (Role < ROLE_AutonomousProxy)
        return;

    ;
    ServerBestPickup();
}

function UntouchDroppedPickup(HDDroppedPickup Item)
{
    if (Role < ROLE_AutonomousProxy)
        return;

    ;
    ServerBestPickup();
}


function InitializeEquipment(SHDEquipment equip)
{
    local HDInventoryManager InvMgr;
    InvMgr = HDInventoryManager(InvManager);
    if (InvMgr != none)
    {
        InvMgr.InitializeEquipment(equip);
    }
}

//---------------------------------------------------------
// Sprint Section
//---------------------------------------------------------
function DoSprintCheck( bool sprint, bool moveforward )
{
    // firing  return
    if ( Weapon!=none && (Weapon.GetStateName() == 'WeaponFiring' || Weapon.PendingFire(0) ) )
    {
        bSprintTag = false;
        return;
    }

    if ( sprint && moveforward )
    {
        if ( bSprintTag == false ) // do sprint
        {
            SetTimer( 0.01, false, 'GotoSprint' );
        }
        // do calu sprint energy
        bSprintTag = true;
    }
    else
    {
        if ( bSprintTag == true ) // do unsprint
        {
            if (IsTimerActive('GotoSprint'))
            {
                ClearTimer('GotoSprint');
            }
            SetTimer( 0.001, false, 'EndSprint' );
        }
        bSprintTag = false;
    }
}

// cancel sprint
simulated function LeaveSprint()
{
    // not sprint
    local HDPlayerController HDPC;
    HDPC = HDPlayerController(Controller);
    if(HDPC != none)
    {
        HDPC.bSprint = 0;
        bSprintTag = false;
        ClearTimer('GotoSprint');
    }
}

// goto sprint
simulated function GotoSprint()
{
        local HDWeapon HDW;
        local HDPlayerController    HDPC;

        // 1 if not crouch, goto sprint
        if ( !bIsCrouched && !bWantsToCrouch )
        {
         HDW = HDWeapon(Weapon);
         if ( HDW != none )
            HDW.WeaponSprintIn();
        }
        else if (bSprintTag || !bCanStandUp)
        {
         HDPC = HDPlayerController  (Controller);
         HDPC.bDuck = 0;
         //HDPC.bProne = 0;
         ShouldCrouchOrProne( false, HDPC.bProne != 0 );
         //SetTimer(0.02,false,'GotoSprint');
         bSprintTag = false;
        }
}

simulated function EndSprint()
{
        local HDWeapon HDW;

        HDW = HDWeapon(Weapon);
        if ( HDW != none )
            HDW.WeaponSprintOut();
}


// global OnAnimEnd
simulated event OnAnimEnd(optional AnimNodeSequence SeqNode, optional float PlayedTime, optional float ExcessTime)
{
  local HDWeapon HDW;

  HDW=HDWeapon(Weapon);

  if ( HDW != none )
  {
    HDW.OnAnimEnd( SeqNode, PlayedTime, ExcessTime );
  }
}

// Start Fire
simulated function StartFire(byte FireModeNum)
{
    LeaveSprint();
    OnAnimEnd(none, 0.f, 0.f);
    if ( !TMGameReplicationInfo(WorldInfo.GRI).bFirendlyFire && bFireState == 2 )
       return;
    Super.StartFire(FireModeNum);
}

// zoom fire mode
simulated function ZoomFireMode()
{
    local HDWeapon HDW;
    //if ( bIsProne && VSizeSq(Velocity) > 0.001f ) return;
    LeaveSprint();
    OnAnimEnd(none, 0.f, 0.f);
    HDW = HDWeapon(Weapon);
    if ( HDW != None )
        HDW.ZoomFireMode();
}

// ChangeZoomFunction
simulated function ChangeZoomFunction( bool bUp )
{
   local HDWeapon HDW;
   HDW = HDWeapon(Weapon);
   if ( HDW != none )
   {
      HDW.ChangeZoomFunction( bUp );
   }
}


unreliable server function ServerTerminateMoving()
{
    // setting velocity VZero directly
    Velocity.X = 0;
    Velocity.Y = 0;
}


simulated function bool TestWalkingForwardCollide( float Yaw )
{
    local vector  StartPos2,  EndPos2;
    local rotator AimRot;
    local bool  Pos2Test;
    local float Distance;
    local HDWeapon HDW;
    HDW = HDWeapon(Weapon);
    StartPos2 = Location + vect(0,0,10);
    AimRot = GetBaseAimRotation();
    AimRot.Pitch = 0;
    AimRot.Yaw += Yaw;
    Distance = WalkingCollisionOffset * HDW.WeaponOffsetScale;
    if ( Yaw != 0 ) Distance *= 0.6;
    EndPos2 = StartPos2 + (vector(AimRot) * Distance );
    Pos2Test = FastTrace( StartPos2 , EndPos2, , true );
//    DrawDebugLine( StartPos2, EndPos2, 255,0,0, false );
    return !Pos2Test;
}
//---------------------------------------------------------
// Pose Section
//---------------------------------------------------------
// Prone
simulated function bool TestProneCollision( float Yaw )
{
    local vector StartPos1, StartPos2, EndPos1, EndPos2;
    local rotator AimRot;
    local bool Pos1Test, Pos2Test;
    local float Distance;

    if ( CylinderComponent.CollisionHeight != ProneHeight ) return false;
     StartPos1 = Location;
     StartPos2 = Location + vect(0,0,-5);
     AimRot = GetBaseAimRotation();
     AimRot.Pitch = 0;
     AimRot.Yaw += Yaw;
     Distance = 80;
     if ( Yaw != 0 ) Distance *= 0.8;
     EndPos1 = StartPos1 - (vector(AimRot) * Distance );
     EndPos2 = StartPos2 - (vector(AimRot) * Distance );

     Pos1Test = FastTrace( StartPos1 , EndPos1, , true );
     Pos2Test = FastTrace( StartPos2 , EndPos2, , true );

     return !Pos1Test && !Pos2Test;

}


simulated function ShouldCrouchOrProne( bool bCrouch, bool bProne )
{
    local HDPlayerController HDPC;
    local vector StartPos1, StartPos2, EndPos1, EndPos2;
    local rotator AimRot;
    local bool Pos1Test, Pos2Test;
    local vector offset;

    HDPC = HDPlayerController(Controller);
    if ( HDPC == none ) return;

    if ( bCrouch && bProne )
    {
        ;
        return;
    }
    if ( !bCanCrouch )
    {
       bCrouch = false;
       HDPC.bDuck = 0;
    }
    if ( !bCanProne )
    {
       bProne = false;
       HDPC.bProne = 0;
    }

    // test prone
    if ( bProne )
    {
        // test prone
        if ( CylinderComponent.CollisionHeight != ProneHeight )
        {
            StartPos1 = Location;
            offset = bIsCrouched? vect(0,0,-6) : vect(0,0,-30);
            StartPos2 = Location + offset;
            AimRot = GetBaseAimRotation();
            AimRot.Pitch = 0;
            EndPos1 = StartPos1 - (vector(AimRot) * 40 );
            EndPos2 = StartPos2 - (vector(AimRot) * 40 );
            Pos1Test = FastTrace( StartPos1 , EndPos1, , true );
            Pos2Test = FastTrace( StartPos2 , EndPos2, , true );
            if ( !Pos1Test || !Pos2Test )
            {
                bProne = false;
                HDPC.bProne = 0;
            }
        }
    }

    // set flag
    if ( bWantsToCrouch != bCrouch || bWantsToProne != bProne )
       SyncSetWantsToPosture( bCrouch, bProne );

    if ( (!bIsCrouched && bWantsToCrouch) || (!bIsProne && bWantsToProne) )
    {
        bFallingStand = false;
        SetTimer( 0.3, false, 'FallingStand' );
    }
}

reliable sync function SyncSetWantsToPosture( bool bWantsCrouch, bool bWantsProne )
{
    bWantsToCrouch = bWantsCrouch;
    bWantsToProne = bWantsProne;
}
simulated function ProneTransition( bool bToProne )
{
    local name TransitionName;
    if ( bToProne )
    {
        TransitionName = bIsCrouched? 'Crouch2Prone' : 'Stand2Prone';
        SyncPlayTransitionAnimation( TransitionName );
    }
    else
    {
        if ( VSize(Velocity) < 10 )
        {
            TransitionName = bWantsToCrouch? 'Prone2Crouch' : 'Prone2Stand';
            SyncPlayTransitionAnimation( TransitionName );
        }
    }
}

unreliable sync function SyncPlayTransitionAnimation( name TagName )
{
    // take special for Reload
    SyncStopCustomAnim();
    SetTimer( 1.1f, false, 'SyncHandleRelaodInterupt' );
    SyncPlayCustomAnim( TagName );
}

simulated function FallingStand()
{
    bFallingStand = true;
}


simulated event StartCrouch(float HeightAdjust)
{
    Super.StartCrouch(HeightAdjust);
    if ( bIsProne && ROLE >= ROLE_AutonomousProxy )
    {
        ProneTransition( TRUE );
    }
}

simulated event EndCrouch(float HeightAdjust)
{
  local HDPlayerController HDPC;
  HDPC = HDPlayerController(Controller);

  if ( HeightAdjust == 0 && HDPC != none )
  {
     if ( bIsCrouched )
     {
        HDPC.bDuck = 255;
        HDPC.bProne = 0;
     }
     else if ( bIsProne )
     {
        HDPC.bDuck = 0;
        HDPC.bProne = 255;
     }
     bSprintTag = false;
     bCanStandUp = false;
  }
  else
  {
     bCanStandUp = true;
     Super.EndCrouch(HeightAdjust);

  }
}

simulated event EndProne()
{
    if ( ROLE >= ROLE_AutonomousProxy )
    {
        ProneTransition( FALSE );
    }
}

//---------------------------------------------------------
// Night Vision
//---------------------------------------------------------
simulated  function CloseNightVision()
{
    NVEffect.bShowInGame = false;
    bNVEquip = false;
    ClientResetBloom();
}

simulated  function bool ToggleNightVision()
{
    local HDWeapon HDWeap;
    local HDWeap_Grenade HDGrenade;

    HDWeap = HDWeapon(Weapon);
    HDGrenade = HDWeap_Grenade(Weapon);

    if ( HDWeap == none || HDGrenade!= none || Physics == PHYS_Ladder || bGMEquip )
        return false;

    if ( bCanNightVision )
    {
        LeaveSprint();
        if (HDWeap.ToggleNightVision(!bNVEquip))
            bNVEquip = !bNVEquip;
        else
            return false;
    }

    return true;
}


//---------------------------------------------------------
// Gas Mask
//---------------------------------------------------------
simulated  function CloseGasMask()
{
    GMEffect.bShowInGame = false;
    bGMEquip = false;
}
simulated  function bool ToggleGasMask()
{
    local HDWeapon HDWeap;
    local HDWeap_Grenade HDGrenade;

    HDWeap = HDWeapon(Weapon);
    HDGrenade = HDWeap_Grenade(Weapon);

    if ( HDWeap == none || HDGrenade!= none || Physics == PHYS_Ladder || bNVEquip )
        return false;

    if ( bCanGasMask )
    {
        LeaveSprint();
        if (HDWeap.ToggleGasMask(!bGMEquip))
            bGMEquip = !bGMEquip;
        else
            return false;
    }

    return true;
}


//---------------------------------------------------------
// Melee Attack
//---------------------------------------------------------
simulated function ToggleMelee()
{
    local HDWeapon HDW;
    HDW = HDWeapon(Weapon);
    LeaveSprint();
    if ( HDW != none )
    {
        HDW.ToggleMelee();
    }

}

//---------------------------------------------------------
// Toggle Telescope
//---------------------------------------------------------
simulated function bool ToggleTelescope()
{
    local HDWeapon HDW;
    HDW = HDWeapon(Weapon);
    LeaveSprint();
    if ( HDW == none || Physics == PHYS_Ladder || bNVEquip || bGMEquip )
        return false;
    if (HDW.IsInState('Active'))
    {
        GotoState('Telescope');
    }
    return TRUE;
}

state Telescope
{
    ignores StartFire, ToggleGasMask, ToggleMelee, ToggleNightVision,ZoomFireMode,
    DoSprintCheck, GotoSprint, ThrowGrenade, PickupItem,SwitchGrenadeWeapon,SwitchToLastConventionalWeapon,
    SwitchWeaponFireMode,SwitchSpecialWeapon,SwitchConventionalWeapon;

    simulated event BeginState( name PrevStateName)
    {
        local HDWeapon HDW;
        local TMPlayerController PC;
        HDW = HDWeapon(Weapon);
        HDW.GotoState('WeaponHidden');
        SetTimer( 0.1, false, 'CloseEye' );
        SetTimer( 0.3, false, 'OpenEye' );

        PC = TMPlayerController(Controller);
        if (PC != none)
        {
           PC.StartZoomNonlinear(50, 10);
        }
    }

    function CloseEye()
    {
        TelescopeInstance.SetScalarParameterValue('Brintness', 0.0 );
        TelescopeEffect.bShowInGame = true;
    }

    function OpenEye()
    {
        TelescopeInstance.SetScalarParameterValue('Brintness', 1.0 );
    }

    simulated function bool ToggleTelescope()
    {
        local HDWeapon HDW;
        HDW = HDWeapon(Weapon);

        if ( IsTimerActive('CloseEye') || IsTimerActive('OpenEye') )
        {
            return FALSE;
        }

        //if (HDW.IsInState('WeaponHidden'))
        //{
            TelescopeInstance.SetScalarParameterValue('Brintness', 0.0 );
            SetTimer( 0.2, false, 'ExitTelescope');
            HDW.GotoState('Active');
        //}
        return TRUE;
    }

    simulated function ChangeZoomFunction( bool bUp )
    {
        local TMPlayerController PC;

        PC = TMPlayerController(Controller);
        if ( PC != None )
        {
            if ( bUp )
                TelescopeFOV -= 10;
            else
                TelescopeFOV += 10;

            TelescopeFOV = FClamp( TelescopeFOV, 15, 50 );
            PC.StartZoomNonlinear( TelescopeFOV, 30 );
        }
    }

    function ExitTelescope()
    {
        local TMPlayerController PC;
        GotoState('Active');
        TelescopeEffect.bShowInGame = False;

        PC = TMPlayerController(Controller);
        if (PC != none)
        {
           PC.EndZoom();
        }

    }
}

/** Assign an arm mesh and material to this pawn */
simulated function SetFirstPersonArmsInfo(SkeletalMesh FirstPersonArmMesh, MaterialInterface ArmMaterial)
{
    // Arms
    ArmsMesh[0].SetSkeletalMesh(FirstPersonArmMesh);
    ArmsMesh[1].SetSkeletalMesh(FirstPersonArmMesh);
    AttachEquipment();
}


/** Kismet Action to possess a Pawn or a vehicle */
//function OnHDPossess(HDSeqAct_HDPossess inAction)
//{
//  local Pawn      OldPawn;
//  local Vehicle   V;
//  local HDPlatform_Derrick Derrick;
//
//  // if we're driving a vehicle, and we should try to get out first.
//
//    if( !inAction.bTryToLeaveVehicle
//        && inAction.ActorToPossess != none )
//  {
//      V = Vehicle(inAction.ActorToPossess);
//      Derrick = HDPlatform_Derrick(inAction.ActorToPossess);
//      if( self!= none && V != none )
//      {
//          V.TryToDrive( self );
//      }
//      else if(self!= none && Derrick != none )
//      {
//          if(Derrick.TurretActor != none)
//          {
//            Derrick.TurretActor.TryToDrive(self);
//          }
//        }
////        else
////        {
////
////            OldPawn = self;
////            Controller.UnPossess();
////            Controller.Possess( inAction.ActorToPossess, false );
////
////            if( inAction.bKillOldPawn && OldPawn != none )
////            {
////                OldPawn.Destroy();
////            }
////        }
//  }
//}

simulated function TickFlashGrenadeEffect( float DeltaTime )
{
    local float currentFlashValue, currentBrintness;

    if( FlashEffect != none )
    {
        if ( FlashEffect.bShowInGame )
        {
            if ( FlashUp )
            {
                FlashEffectInstance.GetScalarParameterValue('Step1Value', currentFlashValue);
                currentFlashValue = FInterpTo( currentFlashValue, FlashWeight, DeltaTime, 1/DeltaTime );
                FlashEffectInstance.SetScalarParameterValue('Step1Value', currentFlashValue );
                FlashEffectInstance.SetScalarParameterValue('Brintness', 30.0f );
            }
            if ( !FlashDown && Abs(currentFlashValue - FlashWeight) < 0.0001f )
            {
                FlashUp = FALSE;
                FlashDown = TRUE;
            }

            if ( FlashDown )
            {
                // step1
                FlashStep1Time -= DeltaTime;
                // goto step2
                if ( FlashStep1Time <= 0.f )
                {
                    FlashEffectInstance.GetScalarParameterValue('Step1Value', currentFlashValue);
                    currentFlashValue = FInterpTo( currentFlashValue, 0, DeltaTime, FlashWeight/FlashStep2Time );
                    FlashEffectInstance.SetScalarParameterValue('Step1Value', currentFlashValue );

                    FlashEffectInstance.GetScalarParameterValue('Brintness', currentBrintness);
                    currentBrintness = FInterpTo( currentBrintness, 1, DeltaTime, 1 );
                    FlashEffectInstance.SetScalarParameterValue('Brintness', currentBrintness );


                    FlashStep2Time -= DeltaTime;
                    if ( Abs(currentFlashValue) < 0.0001f || FlashStep2Time <= 0.f )
                    {
                        FlashEffect.bShowInGame = FALSE;
                    }
                }
            }
        }
    }
}

reliable client function ClientHandleFlashGrenade( float flashValue )
{
    //
    local vector out_loc;
    local rotator out_rot;
    local HDPlayerController PC;
    PC = HDPlayerController(Controller);

    if ( flashValue > 0.33f )
    {
        FlashStep2Time = FlashDefaultStep2Time;
        FlashStep1Time = FlashDefaultStep1Time * flashValue - FlashDefaultStep2Time;
    }
    else
    {
        FlashStep1Time = 0;
        FlashStep2Time = FlashDefaultStep2Time * flashValue/(FlashDefaultStep2Time/(FlashDefaultStep1Time+FlashDefaultStep2Time));
    }

    FlashEffect.bShowInGame = TRUE;
    FlashUp = TRUE;
    FlashDown = FALSE;
    FlashWeight = (FlashStep1Time > 0.f )? 1.0f : FlashStep2Time / FlashDefaultStep2Time;
    if ( Controller != none )
    {
       Controller.GetPlayerViewPoint( out_loc, out_rot );
    }
   else
    {
        out_loc = Location;
        out_rot = Rotation;
    }

 /*   if ( ArmsMesh[0] != None && PC != None && PC.WeaponHand == HAND_Right )
    {
        ArmsMesh[0].GetSocketWorldLocationAndRotation('Camera', out_loc, out_rot, 0);
    }
    else
    {
        out_loc = Location;
        out_rot = Rotation;
    } */
    SceneCapture.SetView(out_loc, out_rot);
    SceneCapture.SetCaptureParameters(,(PC!=none)? PC.FOVAngle : 90.0 );
    SceneCapture.SetEnabled(TRUE);
}

simulated function OnHDPawnDamageControl( HDSeqAct_HDPawnDamageControl seq )
{
    DamageCoefficient = seq.DamageCoefficient;
    DamageCoefficient = FClamp( DamageCoefficient, 0.0, 1.0 );
}

/* AdjustDamage()
adjust damage based on inventory, other attributes
*/
function AdjustDamage( out int inDamage, out Vector momentum, Controller instigatedBy, Vector hitlocation, class<DamageType> damageType, TraceHitInfo HitInfo, Actor DamageCauser)
{
    Super.AdjustDamage( inDamage, momentum, instigatedBy, hitlocation, damageType, HitInfo, DamageCauser );
    inDamage *= DamageCoefficient;
    inDamage *= HDGameInfo.GameDifficulty;
}


// handle momentum
function HandleMomentum( vector Momentum, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo )
{
    // do not jump
    Momentum.Z = 0;
	Super.HandleMomentum( Momentum, HitLocation, DamageType, HitInfo );
}

event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local class<HDDmgType_FlashGrenade> FlashDmgType;
    local class<HDDamageType_PoisonGas> GasDmgType;
    local bool  bHitHeadShot, bPlayTakeDamageEffect;
    bHitHeadShot = False;
    bPlayTakeDamageEffect = False;

    FlashDmgType = class<HDDmgType_FlashGrenade>(DamageType);
    if ( FlashDmgType != none )
    {
        ClientHandleFlashGrenade(Damage/1000.0f);
        return;
    }

    GasDmgType = class<HDDamageType_PoisonGas>(DamageType);
    if ( GasDmgType != None && bGMEquip )
    {
        return;
    }
    if( Damage != 0 )
    {
        if ( AIController(EventInstigator) == None )
        {
            switch (HitInfo.BoneName)
            {
            case 'Spine2':
            case 'Spine3':
            case 'LeftShoulder':
            case 'RightShoulder':
                    Damage *= 1.5;
                    bPlayTakeDamageEffect = True;
                break;

            case 'Hips':
            case 'Spine':
            case 'Spine1':
                    Damage *= 1.0;
                    bPlayTakeDamageEffect = True;
                break;

            case 'neck':
                    Damage *= 1.5;
                    bPlayTakeDamageEffect = True;
                break;

            case 'head':
                    Damage *= 2.0;
                    bPlayTakeDamageEffect = True;
                    bHitHeadShot = True;
                break;

            case 'LeftArm':
            case 'LeftArmRoll':
            case 'LeftForeArm':
            case 'LeftForeArmRoll':
            case 'LeftHand':
            case 'RightArm':
            case 'RightArmRoll':
            case 'RightForeArm':
            case 'RightForeArmRoll':
            case 'RightHand':
                    Damage *= 0.8;
                    bPlayTakeDamageEffect = True;
                break;

            case 'LeftUpLeg':
            case 'LeftUpLegRoll':
            case 'LeftLeg':
            case 'LeftFoot1':
            case 'LeftToeBase':
            case 'RightUpLeg':
            case 'RightUpLegRoll':
            case 'RightLeg':
            case 'RightFoot':
            case 'RightToeBase':
                Damage *= 0.5;
                break;

            default:
                Damage *= 1.0;
            }
        }
        // stop any health recharge
        ResetHealthRecharge();
        //Momentum.Z = 0; // do not jump
        // call Actor's version to handle any SeqEvent_TakeDamage for scripting
        Super.TakeDamage( Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser );
        if ( Health <= 0 && bHitHeadShot )
        {
            // notify  EventInstigator HeadShot
            HDPlayerController(EventInstigator).ClientDrawHeadShot();
        }
        if ( Damage > 0 && bPlayTakeDamageEffect )
        {
            HitCount++;
            PlayTakeDamageEffect();
            //ClientPlayFPTakeDamageEffect();
        }
    }
}

simulated function PlayTakeDamageEffect()
{
    if ( HitRecoilNode != None )
	{
		// Use recoil node to move arms when we fire
		HitRecoilNode.bPlayRecoil = true;
	}
}

unreliable client function ClientPlayFPTakeDamageEffect()
{
    if ( HitRecoil != None )
        HitRecoil.bPlayRecoil = True;
}

simulated function TickHod()
{
    if( hod != none )
    {
        hod.origin = location;
        hod.origin.z -= CylinderComponent.CollisionHeight;
        hod.angles.pitch = rotation.pitch / 182.04;
        hod.angles.yaw = rotation.yaw / 182.04;
        hod.angles.roll = rotation.roll / 182.04;
    }
}

exec function ShowPawn()
{
    bShowDebugBox = !bShowDebugBox;
}

simulated function  CalculatePawnMeshProneRotation()
{
    local Actor HitActor;
    local vector HitLocation, HitNormal, StartPos, EndPos, AimRotVect, TAxis, TargetRotVect;
    local rotator AimRot, TargetRot;
    if ( Mesh == None ) return;

    if ( bIsProne )
    {
        StartPos = Location + 6*vect(0,0,-1);
        EndPos = StartPos + 50*vect(0,0,-1);
        HitActor = Trace( HitLocation, HitNormal, EndPos, StartPos, True );
//        DrawDebugLine(StartPos, EndPos, 0,255,0, false );
        if ( HitActor != None )
        {
//            DrawDebugLine( HitLocation, HitLocation + 50*HitNormal, 0,0,255, false );
            AimRot = GetBaseAimRotation();
            AimRot.Pitch = 0;
            AimRotVect = Vector(AimRot);
            TAxis =  AimRotVect Cross HitNormal;
//            DrawDebugLine( Location, Location + 100 * TAxis, 255,0,255, false);
            TargetRotVect = HitNormal Cross TAxis;
//            DrawDebugLine( Location, Location + 100 * TargetRotVect, 128,0,255, false);
            TargetRot = rotator(TargetRotVect);
            TargetRot.Yaw = 0;
            TargetRot.Roll = 0;
            Mesh.SetRotation(TargetRot);
        }

    }
    else
        Mesh.SetRotation(rot(0,0,0));
}
simulated event Tick(float DeltaTime)
{
    if(ROLE == ROLE_Authority)
    {
        // don't do this if dead!
        if( bHealthIsRecharging && Health < DefaultHealth && Health > 0 )
        {
            RechargingHealthAmount = FMin(RechargingHealthAmount + (DeltaTime * (HealthRechargePercentPerSecond * 0.01f) * DefaultHealth), DefaultHealth);
            Health = int(RechargingHealthAmount);
        }
    }

    if( Role >= ROLE_AutonomousProxy  )
    {
        TickFlashGrenadeEffect(DeltaTime);
        //TracePawnTarget();
    }

    TickHod();
    CalcWalkingSpeedTick();

    // prone move disable hand ik
    if ( bGlobalStopIKFlag || (bIsProne && VSizeSq(Velocity) > 10) || VSizeSq(Velocity) > 24025 || Physics == PHYS_Ladder )
    {
        if ( LeftHandIK.StrengthTarget >= 0.1f )
            SetHandIKEnabled(False);
    }
    else if ( !bActionStopIKFlag )
    {
        if ( LeftHandIK.StrengthTarget == 0.f && !IsTimerActive('RecoverHandIK') )
        {
            SetTimer( 0.2, false, 'RecoverHandIK');
        }
    }
    if ( bActionStopIKFlag )
    {
        bActionStopIKFlag = IsPlayCustomAnim();
    }
    if ( bShowDebugBox )
        DrawDebugBox(Location, vect(5,5,5), 255, 0,0, False );

    if ( ROLE == ROLE_Authority || ROLE == ROLE_SimulatedProxy )
    {
        CalculatePawnMeshProneRotation();
    }

    if ( ROLE == ROLE_SimulatedProxy )
    {
        // reset max step height localy
        if ( (MaxStepHeight - default.MaxStepHeight) > 0.01f )
            ResetMaxStepHeight(default.MaxStepHeight);
    }
}

// Attachment object equip
simulated function AttachEquipment()
{
    // attach Gas Mask to fist person mesh
    if ( ArmsMesh[0] != none )
    {
        if ( GasMask != none )
        {
            ArmsMesh[0].AttachComponentToSocket(GasMask, GMSocketName);
            GasMask.SetLightEnvironment(LightEnvironment);
            SetGMVisibility(False);
        }

        if ( NightVision != none )
        {
            ArmsMesh[0].AttachComponentToSocket(NightVision, NVSocketName);
            NightVision.SetLightEnvironment(LightEnvironment);
            SetNVVisibility(False);
        }

        if ( MeleeWeapon != none )
        {
            ArmsMesh[0].AttachComponentToSocket(MeleeWeapon, MWSocketName);
            MeleeWeapon.SetLightEnvironment(LightEnvironment);
            SetKnifeVisibility(False);
        }
    }
}


// notification
simulated function Notify_ThrowGrenade()
{
    local HDWeap_Grenade Grenade;
    Grenade = HDWeap_Grenade(Weapon);
    if ( Grenade != none )
        Grenade.Notify_ThrowGrenade();
}

//Notify_ReloadSound
simulated function Notify_ReloadSound()
{
    local HDWeapon HDW;
    HDW = HDWeapon(Weapon);
    if ( HDW != none )
        HDW.Notify_ReloadSound();
}

simulated function Notify_ClipEffect()
{
  local HDWeapon HDW;
  HDW = HDWeapon(Weapon);
  if ( HDW != none )
     HDW.Notify_ClipEffect();
}


// Weapon Stable
simulated function WeaponStable( bool flag )
{
    local HDWeapon HDW;
    HDW = HDWeapon(Weapon);
    if ( HDW != None )
        HDW.WeaponStable(flag);
}

/** plays clientside hit effects using the data in LastTakeHitInfo */
simulated function PlayTakeHitEffects()
{
    local class<TMDamageType> TMDamage;
    local vector BloodMomentum;
    local TMEmit_HitEffect HitEffect;
    local ParticleSystem BloodTemplate;

    // set if you want to be able to test in a level and not be tossed around nor have damage effects on screen making it impossible to see what is going on
    if( !AffectedByHitEffects() )
    {
        return;
    }

    if (EffectIsRelevant(Location, false))
    {
        TMDamage = class<TMDamageType>(LastTakeHitInfo.DamageType);

        if (TMDamage != None &&  TMDamage.default.bCausesBlood )
        {
            BloodTemplate = class'TMEmitter'.static.GetTemplateForDistance(GetFamilyInfo().default.BloodEffects, LastTakeHitInfo.HitLocation, WorldInfo);
            if (BloodTemplate != None)
            {
                BloodMomentum = Normal(-1.0 * LastTakeHitInfo.Momentum) + (0.5 * VRand());
                HitEffect = Spawn(GetFamilyInfo().default.BloodEmitterClass, self,, LastTakeHitInfo.HitLocation, rotator(BloodMomentum));
                HitEffect.SetTemplate(BloodTemplate, true);
                HitEffect.AttachTo(self, LastTakeHitInfo.HitBone);
            }
        }

        if (!IsFirstPerson())
        {
            if ( !Mesh.bNotUpdatingKinematicDueToDistance )
            {
                // physics based takehit animations
                if (TMDamage != None)
                {
                    //@todo: apply impulse when in full ragdoll too (that also needs to happen on the server)
                    if ( Health > 0 && DrivenVehicle == None && Physics != PHYS_RigidBody &&
                        VSize(LastTakeHitInfo.Momentum) > TMDamage.default.PhysicsTakeHitMomentumThreshold )
                    {
                        if (Mesh.PhysicsAssetInstance != None)
                        {
                            // just add an impulse to the asset that's already there
                            Mesh.AddImpulse(LastTakeHitInfo.Momentum, LastTakeHitInfo.HitLocation);
                            // if we were already playing a take hit effect, restart it
                            if (bBlendOutTakeHitPhysics)
                            {
                                Mesh.PhysicsWeight = 0.5;
                            }
                        }
                        else if (Mesh.PhysicsAsset != None)
                        {
                            Mesh.PhysicsWeight = 0.5;
                            Mesh.PhysicsAssetInstance.SetNamedBodiesFixed(true, TakeHitPhysicsFixedBones, Mesh, true);
                            Mesh.AddImpulse(LastTakeHitInfo.Momentum, LastTakeHitInfo.HitLocation);
                            bBlendOutTakeHitPhysics = true;
                        }
                    }
                    TMDamage.static.SpawnHitEffect(self, LastTakeHitInfo.Damage, LastTakeHitInfo.Momentum, LastTakeHitInfo.HitBone, LastTakeHitInfo.HitLocation);
                }
            }
        }

        if ( IsFirstPerson() )
        {
            if (TMDamage != none)
                TMDamage.static.SpawnFPHitEffect(self, LastTakeHitInfo.Damage, LastTakeHitInfo.Momentum, LastTakeHitInfo.HitBone, LastTakeHitInfo.HitLocation);
        }
    }
}

/** Internal.  Sets up an audiocomponent. */
simulated protected function AudioComponent CreateAndAttachAudioComponent(SoundCue Cue,bool bSpatialization)
{
    local AudioComponent AC;

    AC = CreateAudioComponent(Cue, FALSE, TRUE);
    if (AC != None)
    {
        AC.bUseOwnerLocation = TRUE;
        AC.bAllowSpatialization = bSpatialization;
        AC.bAutoDestroy = FALSE;
        AC.bShouldRemainActiveIfDropped = TRUE;
    }

    return AC;
}

reliable client function ClientCacheDefaultDOF()
{
    if ( ROLE >= ROLE_AutonomousProxy && IsLocallyControlled() )
    {
        CachedSetting.bEnableDOF = WorldInfo.DefaultPostProcessSettings.bEnableDOF;
        CachedSetting.DOF_BlurKernelSize = WorldInfo.DefaultPostProcessSettings.DOF_BlurKernelSize;
        CachedSetting.DOF_FalloffExponent = WorldInfo.DefaultPostProcessSettings.DOF_FalloffExponent;
        CachedSetting.DOF_FocusDistance = WorldInfo.DefaultPostProcessSettings.DOF_FocusDistance;
        CachedSetting.DOF_FocusInnerRadius = WorldInfo.DefaultPostProcessSettings.DOF_FocusInnerRadius;
        CachedSetting.DOF_MaxFarBlurAmount = WorldInfo.DefaultPostProcessSettings.DOF_MaxFarBlurAmount;
        CachedSetting.DOF_MaxNearBlurAmount = WorldInfo.DefaultPostProcessSettings.DOF_MaxNearBlurAmount;
    }
}

reliable client function ClientSetDOFPostProcess( PostProcessSettings DOFSetting )
{
    if ( ROLE >= ROLE_AutonomousProxy && IsLocallyControlled() )
    {
        WorldInfo.DefaultPostProcessSettings.bEnableDOF = DOFSetting.bEnableDOF;
        WorldInfo.DefaultPostProcessSettings.DOF_BlurKernelSize = DOFSetting.DOF_BlurKernelSize;
        WorldInfo.DefaultPostProcessSettings.DOF_FalloffExponent = DOFSetting.DOF_FalloffExponent;
        WorldInfo.DefaultPostProcessSettings.DOF_FocusDistance = DOFSetting.DOF_FocusDistance;
        WorldInfo.DefaultPostProcessSettings.DOF_FocusInnerRadius = DOFSetting.DOF_FocusInnerRadius;
        WorldInfo.DefaultPostProcessSettings.DOF_MaxFarBlurAmount = DOFSetting.DOF_MaxFarBlurAmount;
        WorldInfo.DefaultPostProcessSettings.DOF_MaxNearBlurAmount = DOFSetting.DOF_MaxNearBlurAmount;

        WorldInfo.GlobalPPSetting.bOverride_EnableDOF = True;
        WorldInfo.GlobalPPSetting.bOverride_DOF_BlurKernelSize = True;
        WorldInfo.GlobalPPSetting.bOverride_DOF_FalloffExponent = True;
        WorldInfo.GlobalPPSetting.bOverride_DOF_FocusDistance = True;
        WorldInfo.GlobalPPSetting.bOverride_DOF_FocusInnerRadius = True;
        WorldInfo.GlobalPPSetting.bOverride_DOF_MaxFarBlurAmount = True;
        WorldInfo.GlobalPPSetting.bOverride_DOF_MaxNearBlurAmount = True;
    }
}

reliable client function ClientResetDOF()
{
    if ( ROLE >= ROLE_AutonomousProxy && IsLocallyControlled() )
    {
        WorldInfo.DefaultPostProcessSettings.bEnableDOF = CachedSetting.bEnableDOF;
        WorldInfo.DefaultPostProcessSettings.DOF_BlurKernelSize = CachedSetting.DOF_BlurKernelSize;
        WorldInfo.DefaultPostProcessSettings.DOF_FalloffExponent = CachedSetting.DOF_FalloffExponent;
        WorldInfo.DefaultPostProcessSettings.DOF_FocusDistance = CachedSetting.DOF_FocusDistance;
        WorldInfo.DefaultPostProcessSettings.DOF_FocusInnerRadius = CachedSetting.DOF_FocusInnerRadius;
        WorldInfo.DefaultPostProcessSettings.DOF_MaxFarBlurAmount = CachedSetting.DOF_MaxFarBlurAmount;
        WorldInfo.DefaultPostProcessSettings.DOF_MaxNearBlurAmount = CachedSetting.DOF_MaxNearBlurAmount;

        WorldInfo.GlobalPPSetting.bOverride_EnableDOF = False;
        WorldInfo.GlobalPPSetting.bOverride_DOF_BlurKernelSize = False;
        WorldInfo.GlobalPPSetting.bOverride_DOF_FalloffExponent = False;
        WorldInfo.GlobalPPSetting.bOverride_DOF_FocusDistance = False;
        WorldInfo.GlobalPPSetting.bOverride_DOF_FocusInnerRadius = False;
        WorldInfo.GlobalPPSetting.bOverride_DOF_MaxFarBlurAmount = False;
        WorldInfo.GlobalPPSetting.bOverride_DOF_MaxNearBlurAmount = False;
    }
}

reliable client function ClientResetBloom()
{
    if ( ROLE >= ROLE_AutonomousProxy && IsLocallyControlled() )
    {
        WorldInfo.DefaultPostProcessSettings.Bloom_Scale = CachedSetting.Bloom_Scale;
        WorldInfo.DefaultPostProcessSettings.WKShader_GlobalMeshEmissive = CachedSetting.WKShader_GlobalMeshEmissive;
        //WorldInfo.DefaultPostProcessSettings.Scene_HighLights = CachedSetting.Scene_HighLights;
   	   WorldInfo.GlobalPPSetting.bOverride_EnableBloom = False;
       WorldInfo.GlobalPPSetting.bOverride_Bloom_Scale = False;
       WorldInfo.GlobalPPSetting.bOverride_WKShader_GlobalMeshEmissive = False;
    }
}
reliable client function ClientClosePostEffect()
{
    bNVEquip = false;
    NVEffect.bShowInGame = false;
    bGMEquip = false;
    GMEffect.bShowInGame = false;
    FlashEffect.bShowInGame = false;
    TelescopeEffect.bShowInGame = false;
    DisableExplodeEffect();
}


function UnPossessed()
{
    ClientResetDOF();
    ClientResetBloom();
    ClientClosePostEffect();
    Super.UnPossessed();
}

simulated State Dying
{
    simulated function SetDyingSkeletalBoneController()
    {
        if ( DeathRightHandIndex1 != None ) DeathRightHandIndex1.SetSkelControlActive(True);
        if ( DeathRightHandIndex2 != None ) DeathRightHandIndex2.SetSkelControlActive(True);
    }
    simulated function BeginState(Name PreviousStateName)
    {
        ClientHiddenArmMesh();
        SetDyingSkeletalBoneController();
        Super.BeginState(PreviousStateName);
    }

    simulated event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
    {
        local Vector shotDir, ApplyImpulse,BloodMomentum;
        local class<TMDamageType> TMDamage;
        local TMEmit_HitEffect HitEffect;
        local ParticleSystem BloodTemplate;

        // When playing death anim, we keep track of how long since we took that kind of damage.
        if(DeathAnimDamageType != None)
        {
            if(DamageType == DeathAnimDamageType)
            {
                TimeLastTookDeathAnimDamage = WorldInfo.TimeSeconds;
            }
        }

        if ((InstigatedBy != None || EffectIsRelevant(Location, true, 0)))
        {
            TMDamage = class<TMDamageType>(DamageType);

            // accumulate damage taken in a single tick
            if ( AccumulationTime != WorldInfo.TimeSeconds )
            {
                AccumulateDamage = 0;
                AccumulationTime = WorldInfo.TimeSeconds;
            }
            AccumulateDamage += Damage;

            if ( !bHideOnListenServer && (WorldInfo.NetMode != NM_DedicatedServer) )
            {
                CheckHitInfo( HitInfo, Mesh, Normal(Momentum), HitLocation );
                if ( TMDamage != None )
                {
                    TMDamage.Static.SpawnHitEffect(self, Damage, Momentum, HitInfo.BoneName, HitLocation);
                }
                if ( TMDamage.default.bCausesBlood
                    && ((PlayerController(Controller) == None) || (WorldInfo.NetMode != NM_Standalone)) )
                {
                    BloodMomentum = Momentum;
                    if ( BloodMomentum.Z > 0 )
                        BloodMomentum.Z *= 0.5;
                    BloodTemplate = class'TMEmitter'.static.GetTemplateForDistance(GetFamilyInfo().default.BloodEffects, LastTakeHitInfo.HitLocation, WorldInfo);
                    if (BloodTemplate != None)
                    {
                        HitEffect = Spawn(GetFamilyInfo().default.BloodEmitterClass,self,, HitLocation, rotator(BloodMomentum));
                        HitEffect.SetTemplate(BloodTemplate, true);
                        HitEffect.AttachTo(Self,HitInfo.BoneName);
                    }
                }

                if( (Physics != PHYS_RigidBody) || (Momentum == vect(0,0,0)) || (HitInfo.BoneName == '') )
                    return;

                shotDir = Normal(Momentum);
                ApplyImpulse = (DamageType.Default.KDamageImpulse * shotDir);

                if( (TMDamage != None) && TMDamage.Default.bThrowRagdoll && (Velocity.Z > -10) )
                {
                    ApplyImpulse += Vect(0,0,1)*DamageType.default.KDeathUpKick;
                }
                // AddImpulse() will only wake up the body for the bone we hit, so force the others to wake up
                ApplyImpulse *= 0.15f;
                Mesh.WakeRigidBody();
                Mesh.AddImpulse(ApplyImpulse, HitLocation, HitInfo.BoneName, true);
            }
        }
    }
}


reliable client function ClientHiddenArmMesh()
{
    if(ArmsMesh[0] != none)
    {
        ArmsMesh[0].SetHidden(true);
    }
    if(ArmsMesh[1] != none)
    {
        ArmsMesh[1].SetHidden(true);
    }
}

function bool Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
    ClientHiddenArmMesh();
    DestoryAllAttachment();

    HDHUD(HDPlayerController(Controller).myHUD).ClearHitEffect();

    return Super.Died(Killer, damageType, HitLocation );
}

/** @return whether or not we should gib due to damage from the passed in damagetype */
// do not gibs
simulated function bool ShouldGib(class<TMDamageType> TMDamageType)
{
    return False;
}

/**
 * Iterates through the list of item classes specified in the action
 * and creates instances that are addeed to this Pawn's inventory.
 *
 * @param       inAction - scripted action that was activated
 */
simulated function OnGiveInventory(SeqAct_GiveInventory InAction)
{
    Super.OnGiveInventory(InAction);

    HDInventoryManager(InvManager).GetEquipment();
}

simulated function OnTogglePosture(HDSeqAct_TogglePosture Action)
{
    if(Action.InputLinks[0].bHasImpulse)
    {
        bCanCrouch =  Action.bCanCrouch;
        bCanProne = Action.bCanProne;
        bCanSprint = Action.bCanSprint;
        GroundSpeed = Action.GroundSpeed;
        bJumpCapable = Action.bCanJump;
    }
    else
    {
        bCanCrouch = default.bCanCrouch;
        bCanProne = default.bCanProne;
        bCanSprint = default.bCanSprint;
        GroundSpeed = default.GroundSpeed;
        bJumpCapable = default.bJumpCapable;
    }
}

// camera effect
simulated function OnShakeCameraEffect(vector expLocation, optional bool alldir = false, optional float Radius, optional float Rate=1.f)
{
    local int index, yawdiff;
    local rotator expdir, aimdir;
    local HDPlayerController PC;
    local float Dist, BlendWeight;
    local RadialBlurActor tempActor;

    PC = HDPlayerController(Controller);
    if ( PC.ViewTarget != self ) return;

    if ( alldir == true )
    {
        aimdir = GetBaseAimRotation();
        expdir = rotator(expLocation-Location);
        yawdiff = expdir.Yaw - aimdir.Yaw;
        yawdiff = yawdiff & 65535;
        yawdiff -= 16384;

        if ( yawdiff <= 0 )
        {
            index = 0;
        }
        else if ( yawdiff <= 16384 )
        {
            index = 1;
        }
        else if ( yawdiff <= 32768 )
        {
            index = 2;
        }
        else if ( yawdiff <= 49152 )
        {
            index = 3;
        }
    }
    else
    {
        index = 0;
    }

    if ( PC != none && LocalPlayer(PC.Player) != None && index < ShakeCameraAnim.Length && ShakeCameraAnim[index] != none )
    {
        PC.StopCameraAnim(true);

        if(Radius > 1.0)
        {
           Dist = VSize(Location - expLocation);
           BlendWeight = FClamp(1.0 - Dist / Radius, 0.0, 1.0);
        }
        else
        {
           BlendWeight = 0.3;
        }

        PC.PlayCameraAnim(ShakeCameraAnim[index], BlendWeight, Rate,,,, false);
    }

    if ( IsFirstPerson() )
    {
        EnableExplodeEffect();
        TimeSwitchOffExplodeEffect();
        tempActor = None;
        for ( index = 0; index < 3; ++index )
        {
            if ( !ExplodeActors[index].RadialBlur.bEnabled  )
            {
                tempActor = ExplodeActors[index];
                break;
            }
        }
        if ( tempActor != None )
        {
            tempActor.SetLocation(expLocation);
            tempActor.RadialBlur.SetEnabled(True);
        }
    }
}

//simulated function OnCinematicModeEnd( bool bInCinematicMode, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsHUD )
//{
//}

simulated function DirectorControl( bool bNowControlling )
{
   ResetPawn();
}

simulated function ResetPawn()
{
    local HDWeapon HDW;
    LeaveSprint();
    if ( IsInState('TeleScope') )
    {
       ToggleTelescope();
    }
    if ( bNVEquip )
    {
        CloseNightVision();
    }
    if ( bGMEquip )
    {
        CloseGasMask();
    }
    DisableExplodeEffect();
    HDW = HDWeapon(weapon);
    if ( HDW != None )
    {
        HDW.ResetWeapon();
    }
}

//---------------------------------------------------------
// Draw HUD
//---------------------------------------------------------
/**
 * PostRenderFor() Hook to allow pawns to render HUD overlays for themselves.
 * Assumes that appropriate font has already been set
 *
 * @param   PC      The Player Controller who is rendering this pawn
 * @param   Canvas  The canvas to draw on
 */
simulated native function NativePostRenderFor(PlayerController PC, Canvas Canvas, vector CameraPosition, vector CameraDir);

unreliable client function ClientDisableDynamicTip()
{
    ClientHudDrawTips.bDraw = False;
}

unreliable client function  ClientDrawDynamicTip( string Command, string PickupMessage,  TextureCoordinates iconTexcoord, bool DrawIcon )
{
    ClientHudDrawTips.bDraw = True;
    ClientHudDrawTips.Command = Command;
    ClientHudDrawTips.Tip = PickupMessage;
    ClientHudDrawTips.Coordinates = iconTexcoord;
    ClientHudDrawTips.bDrawIcon = True;
}

simulated event PostRenderFor(PlayerController PC, Canvas Canvas, vector CameraPosition, vector CameraDir)
{
    local HDHUD     HUD;
    local HDWeapon  HDW;
    local HDTurret_Base HDT;
    local HDPlayerController HPC;

    local Trigger checkTrigger;
    local vector cameraLoc;
    local rotator cameraRot;
    local SeqEvent_Used UseSeq;

    super.PostRenderFor(PC,Canvas,CameraPosition,CameraDir);
    HUD = HDHUD(PC.MyHUD);

    // Draw pickup
    if ( ClientHudDrawTips.bDraw )
    {
        HUD.DrawDynamicTip( Canvas, PC, ClientHudDrawTips.Command, ClientHudDrawTips.Tip, ClientHudDrawTips.bDrawIcon, Canvas.ClipX * 0.5, Canvas.ClipY * 0.25, ClientHudDrawTips.Coordinates, Canvas.ClipY/720 );
    }
/*  if ( best_pickup != none )
    {
        HDW = HDWeapon(best_pickup.Inventory);
        if ( HDW != none )
        {
            //ClientDrawDynamicTip( "GBA_PickupItem", HDW.PickupMessage, HDW.IconTexCoord[0]);
            HUD.DrawDynamicTip( Canvas, PC, "GBA_PickupItem", HDW.PickupMessage, TRUE, Canvas.ClipX * 0.5, Canvas.ClipY * 0.6, HDW.IconTexCoord[0], Canvas.ClipY/720 );
        }
    }
*/
    //Draw UseTurret
    HPC = HDPlayerController(PC);
    HDT = HDTurret_Base(HPC.GetCurrentTurret());
    if(HDT != none)
    {
        HDW = HDWeapon(HDT.MyWeapon);
        HUD.DrawDynamicTip( Canvas, PC, "GBA_Use", HDW.PickupMessage, FALSE, Canvas.ClipX * 0.5, Canvas.ClipY * 0.25, HDW.IconTexCoord[0], Canvas.ClipY/720 );
    }

    //Draw Trigger Used
    PC.GetPlayerViewPoint(cameraLoc, cameraRot);
    ForEach TouchingActors(class'Trigger', checkTrigger)
    {
        UseSeq = HPC.CanUseTrigger(checkTrigger, cameraLoc, cameraRot, 0.f, true);
        if(UseSeq != none && UseSeq.InteractText != "")
        {
            HUD.DrawDynamicTip( Canvas, PC, "GBA_Use", UseSeq.InteractText, FALSE, Canvas.ClipX * 0.5, Canvas.ClipY * 0.6, HDW.IconTexCoord[0], Canvas.ClipY/720, ,, "?");
            break; //just once
        }
    }

}

// explode effect
simulated function EnableExplodeEffect()
{
    if (IsTimerActive('DisableExplodeEffect'))
    {
        ClearTimer('DisableExplodeEffect');
    }
    ExplodeEffect.bShowInGame = TRUE;
}


simulated function TimeSwitchOffExplodeEffect()
{
    SetTimer( 0.2, false, nameof(DisableExplodeEffect) );
}

simulated function DisableExplodeEffect()
{
    ExplodeEffect.bShowInGame = FALSE;
}


//---------------------------------------------------------
// volume
//---------------------------------------------------------
simulated function EnteredPostureVolume( HDPawnPostureVolume volume )
{
   bCanCrouch =  volume.bCanCrouch;
   bCanProne = volume.bCanProne;
   bCanSprint = volume.bCanSprint;
   GroundSpeed = volume.GroundSpeed;
   bJumpCapable = volume.bCanJump;
}


simulated function LeavingPostureVolume()
{
    bCanCrouch = default.bCanCrouch;
    bCanProne = default.bCanProne;
    bCanSprint = default.bCanSprint;
    GroundSpeed = default.GroundSpeed;
    bJumpCapable = default.bJumpCapable;
}


// Visibility setting
simulated function SetWeaponVisibility(bool bWeaponVisible)
{
    local TMWeapon Weap;
    Weap = TMWeapon(Weapon);
    if (Weap != None)
    {
        Weap.ChangeVisibility(bWeaponVisible);
        Weap.OnAnimEnd( None, 0, 0 );
    }
}

//
simulated function SetKnifeVisibility(bool bVisible)
{
    if ( MeleeWeapon != None )
        MeleeWeapon.SetHidden( !(bVisible && IsFirstPerson()) );
}
simulated function SetGMVisibility(bool bVisible)
{
    if ( GasMask != None )
        GasMask.SetHidden( !(bVisible && IsFirstPerson()) );
}
simulated function SetNVVisibility(bool bVisible)
{
    if ( NightVision != None )
        NightVision.SetHidden( !(bVisible && IsFirstPerson()) );
}


// aim enemy or friendly
simulated function float GetTraceRange()
{
    return ((Weapon != None)? Weapon.GetTraceRange() : 0.f);
}
simulated function TracePawnTarget()
{
    local vector StartTrace, EndTrace, Extent, HitNormal, HitLoc;
    local Actor HitActor;
    local HDBasePawn           HitPawn;
    local TraceHitInfo         HitInfo;

    // define range to use for CalcWeaponFire()
    StartTrace = GetPawnViewLocation();
    EndTrace = StartTrace + vector(GetBaseAimRotation()) * GetTraceRange();
    Extent = vect(0,0,0);
    //DrawDebugLine(StartTrace, EndTrace, 255,0,0, true );
    // Perform shot
    bFireState = 0;
    foreach TraceActors(class'Actor', HitActor, HitLoc, HitNormal , EndTrace, StartTrace, Extent, HitInfo, TRACEFLAG_Bullet)
    {
        HitPawn = HDBasePawn(HitActor);
        if( HitPawn == none || HitPawn.IsInState('Dying') )
        {
            return;
        }
        else if ( HitPawn.GetTeamNum() == GetTeamNum() )
        {
            if ( VSizeSq(HitPawn.Location - Location) <  FirendlyFireDistance )
            {
                 bFireState = 2;
            }
            return;
        }
        else if ( HitPawn.GetTeamNum() != GetTeamNum() )
        {
            bFireState = 1;
            return;
        }
    }
    return;
}

//---------------------------------------------------------
// Custom Animaion Interface
//---------------------------------------------------------
/** Play an emote given a category and index within that category. */
simulated function DoPlayCustomAnim(name TagName, optional float StartTime = 0.f )
{
    local TMPlayerReplicationInfo TMPRI;
    local class<HDFamilyInfo> FamilyInfo;
    local int AnimIndex;
    local CustomAnimInfo CAInfo;
    local name CustomAnimName;

    TMPRI = TMPlayerReplicationInfo(PlayerReplicationInfo);
    if (TMPRI == None && DrivenVehicle != None)
    {
        TMPRI = TMPlayerReplicationInfo(DrivenVehicle.PlayerReplicationInfo);
    }
    if(TMPRI != None)
    {
        // Find the family we belong to (if we need to)
        FamilyInfo = class<HDFamilyInfo>(GetFamilyInfo());
        if ( FamilyInfo == None ) return;

        AnimIndex = FamilyInfo.static.GetCustomAnimIndex(TagName);

        if (AnimIndex != INDEX_None)
        {

            CAInfo = FamilyInfo.default.CustomAnimInfos[AnimIndex];

            // If this isn't a dedicated server, perform the emote
            // [TJJ MODIFY: on client side, the health of other pawn is always zero, so remove the condition(Health > 0).
            //if(Health > 0 && WorldInfo.NetMode != NM_DedicatedServer && TMPRI != None && !IsInState('FeigningDeath'))
            if( WorldInfo.NetMode != NM_DedicatedServer && TMPRI != None && !IsInState('FeigningDeath') )
            // TJJ MODIFY]
            {
                CustomAnimName = CAInfo.AnimNames[0];

                if ( CAInfo.AnimNames.Length == 3 )
                {
                    CustomAnimName = bIsCrouched ? CAInfo.AnimNames[1] : CAInfo.AnimNames[0];
                    CustomAnimName = bIsProne ? CAInfo.AnimNames[2] : CustomAnimName;
                }
                // Play the anim in correct slot
                if(CustomAnimName != '')
                {
                    if(CAInfo.bTopHalf || DrivenVehicle != None)
                    {
                        if(TopHalfAnimSlot != None)
                        {
                            TopHalfAnimSlot.PlayCustomAnim(CustomAnimName, CAInfo.RateScale, CAInfo.BlendInTime, CAInfo.BlendOutTime, CAInfo.bLoopFlag, CAInfo.bOverrideFlag, StartTime );
                        }
                    }
                    else
                    {
                        if(FullBodyAnimSlot != None)
                        {
                            FullBodyAnimSlot.PlayCustomAnim(CustomAnimName, CAInfo.RateScale, CAInfo.BlendInTime, CAInfo.BlendOutTime, CAInfo.bLoopFlag, CAInfo.bOverrideFlag, StartTime );
                        }
                    }
                    bActionStopIKFlag = CAInfo.bStopIKFlag;
                    SetHandIKEnabled(!bActionStopIKFlag);
                }
            }
        }
    }
}

unreliable sync function SyncPlayCustomAnim(name TagName)
{
    //bActionStopIKFlag = True;
    //SetHandIKEnabled(false);
    DoPlayCustomAnim(TagName);
    LastCustomAnimTime = WorldInfo.TimeSeconds;
}

exec simulated function PlayCustomAnim( name TagName )
{
    // If it has been long enough since the last emote, play one now
    if(WorldInfo.TimeSeconds - LastCustomAnimTime > MinTimeBetweenCustomAnims)
    {
        SyncPlayCustomAnim(TagName);
        LastCustomAnimTime = WorldInfo.TimeSeconds;
    }
}

/** Play an emote given a category and index within that category. */
simulated function DoPlayCustomAnimByDuration(name TagName, float Duration )
{
    local TMPlayerReplicationInfo TMPRI;
    local class<HDFamilyInfo> FamilyInfo;
    local int AnimIndex;
    local CustomAnimInfo CAInfo;
    local name CustomAnimName;

    TMPRI = TMPlayerReplicationInfo(PlayerReplicationInfo);
    if (TMPRI == None && DrivenVehicle != None)
    {
        TMPRI = TMPlayerReplicationInfo(DrivenVehicle.PlayerReplicationInfo);
    }
    if(TMPRI != None)
    {
        // Find the family we belong to (if we need to)
        FamilyInfo = class<HDFamilyInfo>(GetFamilyInfo());
        if ( FamilyInfo == None ) return;

        AnimIndex = FamilyInfo.static.GetCustomAnimIndex(TagName);

        if (AnimIndex != INDEX_None)
        {

            CAInfo = FamilyInfo.default.CustomAnimInfos[AnimIndex];

            // If this isn't a dedicated server, perform the emote
            // [TJJ MODIFY: on client side, the health of other pawn is always zero, so remove the condition(Health > 0).
            //if(Health > 0 && WorldInfo.NetMode != NM_DedicatedServer && TMPRI != None && !IsInState('FeigningDeath'))
            if( WorldInfo.NetMode != NM_DedicatedServer && TMPRI != None && !IsInState('FeigningDeath') )
            // TJJ MODIFY]
            {
                CustomAnimName = CAInfo.AnimNames[0];

                if ( CAInfo.AnimNames.Length == 3 )
                {
                    CustomAnimName = bIsCrouched ? CAInfo.AnimNames[1] : CAInfo.AnimNames[0];
                    CustomAnimName = bIsProne ? CAInfo.AnimNames[2] : CustomAnimName;
                }
                // Play the anim in correct slot
                if(CustomAnimName != '')
                {
                    if(CAInfo.bTopHalf || DrivenVehicle != None)
                    {
                        if(TopHalfAnimSlot != None)
                        {
                            TopHalfAnimSlot.PlayCustomAnimByDuration(CustomAnimName, Duration, CAInfo.BlendInTime, CAInfo.BlendOutTime, CAInfo.bLoopFlag, CAInfo.bOverrideFlag );
                        }
                    }
                    else
                    {
                        if(FullBodyAnimSlot != None)
                        {
                            FullBodyAnimSlot.PlayCustomAnimByDuration(CustomAnimName, Duration, CAInfo.BlendInTime, CAInfo.BlendOutTime, CAInfo.bLoopFlag, CAInfo.bOverrideFlag );
                        }
                    }
                    bActionStopIKFlag = CAInfo.bStopIKFlag;
                    SetHandIKEnabled(!bActionStopIKFlag);
                }
            }
        }
    }
}

unreliable sync function SyncPlayCustomAnimByDuration(name TagName)
{
    DoPlayCustomAnim(TagName);

    LastCustomAnimTime = WorldInfo.TimeSeconds;
}

exec simulated function PlayCustomAnimByDuration( name TagName )
{
    // If it has been long enough since the last emote, play one now
    if(WorldInfo.TimeSeconds - LastCustomAnimTime > MinTimeBetweenCustomAnims)
    {
        SyncPlayCustomAnim(TagName);
        LastCustomAnimTime = WorldInfo.TimeSeconds;
    }
}

simulated function RecoverHandIK()
{
    ClearTimer('RecoverHandIK');
    bActionStopIKFlag = False;
    SetHandIKEnabled( true, 0.1f );
}
simulated function DoStopCustomAnim( optional bool bTopHalf = true, optional float BlendOutTime = 0.1f )
{
    if( TopHalfAnimSlot != None && bTopHalf )
    {
        TopHalfAnimSlot.StopCustomAnim(BlendOutTime);
    }
    if( FullBodyAnimSlot != None && !bTopHalf )
    {
       FullBodyAnimSlot.StopCustomAnim(BlendOutTime);
    }

    SetTimer( 0.15, false, 'RecoverHandIK');
}

reliable sync function SyncStopCustomAnim()
{
    DoStopCustomAnim();
}
exec simulated function StopCustomAnim()
{
    SyncStopCustomAnim();
}

simulated function bool IsPlayCustomAnim()
{
    local bool ret;
    ret = False;
    if ( TopHalfAnimSlot != None )
    {
        ret = TopHalfAnimSlot.bIsPlayingCustomAnim;
    }
    if(FullBodyAnimSlot != None)
    {
        ret = (ret || FullBodyAnimSlot.bIsPlayingCustomAnim);
    }
    return ret;
}

//---------------------------------------------------------
// Back Attachment Weapon
//---------------------------------------------------------
simulated function int SetBackAttachmentWeapon( class<TMWeaponAttachment> WeaponClass, EAttachPawnType Type )
{
    if ( Type == EATTACH_RIFLE )
    {
        BackWeaponAttachmentClass[0] = class<HDWeaponAttachment>(WeaponClass);
        return 0;
    }
    if ( Type == EATTACH_LAUNCHER )
    {
        BackWeaponAttachmentClass[1] = class<HDWeaponAttachment>(WeaponClass);
        return 1;
    }
    if ( Type == EATTACH_PISTOL )
    {
        BackWeaponAttachmentClass[2] = class<HDWeaponAttachment>(WeaponClass);
        return 2;
    }
    return -1;
}


simulated function DestoryAllAttachment()
{
    local int index;
    for ( index = 0; index < 3; ++index )
    {
        if ( BackWeaponAttachment[index] != None )
        {
            BackWeaponAttachment[index].Destroy();
            BackWeaponAttachmentClass[index] = None;
        }
    }
    if ( MeleeAttachment != None )
        MeleeAttachment.Destroy();
}


simulated function WeaponBackAttachmentChanged( int type )
{
    if ((BackWeaponAttachment[type] == None || BackWeaponAttachment[type].Class != BackWeaponAttachmentClass[type]) && Mesh.SkeletalMesh != None)
    {
        if (BackWeaponAttachment[type]!=None)
        {
            BackWeaponAttachment[type].DetachFromBack(Mesh, BackWeaponSocket[Type]);
            BackWeaponAttachment[type].Destroy();
        }

        // Create the new Attachment.
        if (BackWeaponAttachmentClass[type]!=None)
        {
            BackWeaponAttachment[type] = Spawn(BackWeaponAttachmentClass[type],self);
            BackWeaponAttachment[type].Instigator = self;
        }
        else
            BackWeaponAttachment[type] = none;

        // if all is good, attach it to the Pawn's Mesh.
        if (BackWeaponAttachment[type] != None)
        {
            BackWeaponAttachment[type].AttachToBack(self, BackWeaponSocket[Type]);
            if ( CurrentWeaponAttachment != None )
                CurrentWeaponAttachment.ChangeVisibility(True);
        }
    }
}


// Add Current Weapon AnimSets to Lists on Weapon Switching
//
simulated event bool RestoreAnimSetsToDefault()
{
    local class<TMFamilyInfo>  Info;
    Info = GetFamilyInfo();
    Mesh.AnimSets = Info.default.AnimSets;
    return True;
}


simulated function UpdateAnimSetLists()
{
    local HDWeaponAttachment HDWA;
    HDWA = HDWeaponAttachment(CurrentWeaponAttachment);
    if ( HDWA == None ) return;
    InitializeWeaponEquip();
    // Restore
    RestoreAnimSetsToDefault();

    // Add weapon list
    if ( HDWA.CustomAnimSets.Length > 0 )
    {
        AddAnimSets(HDWA.CustomAnimSets);
    }

    // Force AnimTree to be updated with new AnimSets array
    Mesh.bDisableWarningWhenAnimNotFound = TRUE;
    Mesh.UpdateAnimations();
    Mesh.bDisableWarningWhenAnimNotFound = FALSE;
}


simulated function UpdatePawnAnimSets()
{
    UpdateAnimSetLists();
    Mesh.ForceSkelUpdate();
    //SetTimer( 0.01f, FALSE, 'UpdateAnimations' );

    // defer Play Equip Weapon Animation
    if ( ROLE == ROLE_SimulatedProxy || !IsLocallyControlled() )
    {
        EquipWeaponAction();
    }
}

simulated exec function UpdateAnimations()
{
    UpdateAnimSetLists();
}





//[TJJ ADD: Let pawn can get default inventories from its family info.
//[WK ADD: AddDefaultInventory Logic.
/* AddDefaultInventory:
    Add Pawn default Inventory.
    Called from GameInfo.AddDefaultInventory()
*/
function AddDefaultInventory()
{
    local array< class<Inventory> > DefaultInv;
    local int j, conventionalLength, specialLength, grenadeLength;
    local SHDEquipment equip;
    local class<HDConventionalWeapon> ConventionalClass;
    local class<HDSpecialWeapon> SpecialClass;
    local class<HDWeap_Grenade> GrenadeClass;

    if( TMPlayerReplicationInfo(PlayerReplicationInfo) != none &&
        TMPlayerReplicationInfo(PlayerReplicationInfo).CharClassInfo != none &&
        TMPlayerReplicationInfo(PlayerReplicationInfo).CharClassInfo.default.DefaultInventory.Length > 0 )
    {
        equip.ConventionalWeaponClass.Length = HDBaseGame(WorldInfo.Game).ConventionalWeaponCount;
        equip.SpecialWeaponClass.Length = HDBaseGame(WorldInfo.Game).SpecialWeaponCount;
        equip.GrenadeClass.Length = HDBaseGame(WorldInfo.Game).GrenadeTypeCount;
        conventionalLength = 0;
        specialLength = 0;
        grenadelength = 0;
        DefaultInv = TMPlayerReplicationInfo(PlayerReplicationInfo).CharClassInfo.default.DefaultInventory;
        for ( j = 0; j < DefaultInv.Length; ++j )
        {
            // conventional
            ConventionalClass = class<HDConventionalWeapon>(DefaultInv[j]);
            if ( ConventionalClass != None && conventionalLength < HDBaseGame(WorldInfo.Game).ConventionalWeaponCount )
            {
                equip.ConventionalWeaponClass[conventionalLength++]=ConventionalClass;
                continue;
            }

            // special
            SpecialClass = class<HDSpecialWeapon>(DefaultInv[j]);
            if ( SpecialClass != None && specialLength < HDBaseGame(WorldInfo.Game).SpecialWeaponCount )
            {
                equip.SpecialWeaponClass[specialLength++]=SpecialClass;
                continue;
            }

            // grenade
            GrenadeClass = class<HDWeap_Grenade>(DefaultInv[j]);
            if ( GrenadeClass != None && grenadelength < HDBaseGame(WorldInfo.Game).GrenadeTypeCount )
            {
                equip.GrenadeClass[grenadeLength++]=GrenadeClass;
                continue;
            }
        }
        InitializeEquipment(equip);
    }

    Controller.ClientSwitchToBestWeapon();
}
// WK]
//TJJ]

/** Enable or disable IK that keeps hands on IK bones. */
simulated function SetHandIKEnabled(bool bEnabled, optional float Time = 0.f )
{
    if ( IsTimerActive('RecoverHandIK') )
        ClearTimer('RecoverHandIK');

    if (WorldInfo.NetMode != NM_DedicatedServer && Mesh.Animations != None)
    {
        if (bEnabled)
        {
            LeftHandIKRot.SetSkelControlStrength(1.0, Time);
            RightHandIKRot.SetSkelControlStrength(1.0, Time);
        }
        else
        {
            LeftHandIKRot.SetSkelControlStrength(0.0, Time);
            RightHandIKRot.SetSkelControlStrength(0.0, Time);
        }
    }
    Super.SetHandIKEnabled(bEnabled, Time);
}


/**
 * This function sets up the Location of a hit to be replicated to all remote clients.
 * It is also responsible for fudging a shot at (0,0,0).
 *
 * Network: Server only (unless using client-side hit detection)
 */
// Sync function: Play Impacts decal and particle
unreliable client function ClientSetFlashLocation(Weapon InWeapon, byte InFiringMode, vector NewLoc)
{
    SyncSetFlashLocation( InWeapon, InFiringMode, NewLoc );
}

unreliable sync function SyncSetFlashLocation(Weapon InWeapon, byte InFiringMode, vector NewLoc)
{
    if( !IsZero(NewLoc) )
    {
        WeaponFired(InWeapon, True, NewLoc);
    }
}


// on end fire kismet
simulated function OnForceEndFire(HDSeqAct_ForceEndFire Action)
{
    if ( Action.Targets[0] == Controller && Weapon != None )
    {
        Weapon.ForceEndFire();
    }
}

// patch for call support weapon
// Call Support
reliable sync function SyncInitCSTurretAttachment( class<HDWeaponAttachment> TurretAttachmentClass )
{
    if ( CSTurretAttachment != None )
    {
        CSTurretAttachment.Destroy();
        CSTurretAttachment = None;
    }
    if ( CSTurretAttachment == None )
    {
        CSTurretAttachment = Spawn(TurretAttachmentClass, Self);
        CSTurretAttachment.Instigator = Self;
    }
}

unreliable sync function SyncPlayCSTurretAttachment( vector HitLocation )
{
    if ( CSTurretAttachment != None )
        CSTurretAttachment.PlayImpactEffects(HitLocation);
}

simulated function PlayCSTurretAttachment( vector HitLocation )
{
    if ( ROLE == ROLE_Authority )
        SyncPlayCSTurretAttachment(HitLocation);
}

// current weapon empty
event   CurrentWeaponEmptyNotify()
{
    TriggerEventClass(class'HDSeqEvent_WeaponEmpty', Self);
}

function bool CanDoubleJump()
{
    return False;
}


// query ConstHold Weapon
simulated function HDWeapon GetConstHoldWeapon()
{
    return HDInventoryManager(InvManager).GetConstHoldWeapon();
}

/**
 * Called when a weapon is changed and is responsible for making sure
 * the new weapon respects the current pawn's states/etc.
 */

simulated function WeaponChanged(TMWeapon NewWeapon)
{
    local TMSkeletalMeshComponent TMSkel;
    local HDWeapon HDW;
    HDW = HDWeapon(NewWeapon);
    // Make sure the new weapon respects behindview
    if (NewWeapon.Mesh != None)
    {
        NewWeapon.Mesh.SetHidden(!IsFirstPerson());
        TMSkel = TMSkeletalMeshComponent(NewWeapon.Mesh);
        if (TMSkel != none)
        {
            TMSkel.SetFOV(HDW.UnZoomObjectFOV);
            ArmsMesh[0].SetFOV(TMSkel.FOV);
            //ArmsMesh[1].SetFOV(TMSkel.FOV);
            ArmsMesh[0].SetScale(TMSkel.Scale);
            //ArmsMesh[1].SetScale(TMSkel.Scale);
        }
    }
}


