class EvilPlayerController extends UTConsolePlayerController
    native(PC)
    config(Game)
    hidecategories(Navigation);

enum EPOIFocusType
{
    POIFT_None,                     // 0
    POIFT_RecoveryInterp,           // 1
    POIFT_Clamp,                    // 2
    POIFT_Interp,                   // 3
    POIFT_MAX                       // 4
};

enum EAlienFxMode
{
    EAFM_None,                      // 0
    EAFM_Treasure,                  // 1
    EAFM_OnDamage,                  // 2
    EAFM_LowHp,                     // 3
    EAFM_OnKill,                    // 4
    EAFM_EndRound,                  // 5
    EAFM_MAX                        // 6
};

enum EAlienFxLight
{
    EAFL_All,                       // 0
    EAFL_FrontLowerLR,              // 1
    EAFL_MAX                        // 2
};

enum EAlienFxType
{
    EAFT_Normal,                    // 0
    EAFT_Impulse,                   // 1
    EAFT_MAX                        // 2
};

var Guid MyGuid;
var const bool bRenderHighlightMask;
var bool bShowAmmoBoxCaption;
var bool bLookingAtPointOfInterest;
var bool bSetMatineeRotation;
var protected transient bool bCameraLookAtLocked;
var protected bool bCameraLookAtIsFromKismet;
var protected bool bMoveState;
var bool bSlidingDrop;
var bool bFiringOnZipLine;
var bool bProfileSettingsUpdated;
var protected const export editinline EvilSceneCaptureHighlightComponent HighlightSceneCaptureComponent;
var TextureRenderTarget2D HighlightMaskTexture;
var transient float VisualSpread;
var protected EvilMeleeActionsManager MeleeActionsManager;
var protected EvilComboManager ComboManager;
var EvilPawn MyEvilPawn;
var config float InteractAimDotAngle;
var Trigger UsableTrigger;
var private array<EvilPointOfInterest> EnabledPointsOfInterest;
var private array<bool> POILookedAtList;
var EvilPointOfInterest CurrLookedAtPOI;
var EvilPointOfInterest LastBestPOI;
var() float PointOfInterestLookatInterpSpeed;
var() float PointOfInterestLookatInterpExponent;
var Rotator PrePOICamRot;
var protected Actor CameraLookAtFocusActor;
var protected name CameraLookAtFocusBoneName;
var protected Vector CameraLookAtDirection;
var protected float CameraLookAtEpsilon;
var protected float CameraLookAtInterpSpeed;
var protected EvilPlayerController.EPOIFocusType CameraLookAtFocusType;
var EvilTypes.EHandOnLine WhichHandHoldLine;
var protected Rotator CameraLookAtLastDir;
var protected Rotator CameraLookAtInitialDir;
var protected float CameraLookAtInterpAlpha;
var SoundCue LowHealthAmbientCue;
var export editinline AudioComponent LowHealthAmbientComponent;
var Actor ForcedMoveLocationActor;
var float ForcedMoveVelocity;
var protected Pawn BasePawn;
var protected Vector LastPosition;
var protected Vector NewPosition;
var protected Vector MoveUnit;
var float TurnLag;
var protected float OldGroundSpeed;
var Vector SlidingDirection;
var float SlidingVelocity;
var Rotator SlidingRotation;
var float SlidingTurn;
var Vector SlidingMove;
var Vector PawnLastPos;
var transient float LastCheckpointSaveTime;
var transient name LastCheckpointSaveName;
var config float TimeBetweenSaves;
var const localized string CheckpointSavedString;
var const localized string CheckpointLoadedString;
var SeqAct_Checkpoint CheckpointSeqAct;
var Rotator RailCarRotation;
var CanvasIcon IconFriend;
var CanvasIcon IconEnemy;
//var delegate<ContinueCameraRotation> __ContinueCameraRotation__Delegate;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority)
        UsableTrigger;

    // Pos:0x011
    if(bNetDirty
        bShowAmmoBoxCaption;
}

function ApplyInventoryRecords(const out array<InventoryRecord> Records)
{
    local class<Inventory> InvClass;
    local InventoryRecord InvRecord;
    local Inventory InvItem;
    local bool bFoundActiveWeapon, bFoundActiveLeftWeapon;
    local EvilWeap_Base ActiveWeaponToRestore, ActiveLeftWeaponToRestore;

    Pawn.InvManager.DiscardInventory();
    EvilGFxHudWrapper(myHUD).HudMovie.ShowMapHints(false);
    EvilGFxHudWrapper(myHUD).HudMovie.ShowNotepadHints(false, false);
    // End:0x31B
    foreach Records(InvRecord)
    {
        InvClass = class<Inventory>(FindObject(InvRecord.InventoryClassPath, Class'Core.Class'));
        // End:0x11D
        if(InvClass == none)
        {            
        }
        else
        {
            InvItem = Pawn.InvManager.Spawn(InvClass, Pawn);
            // End:0x184
            if(InvItem == none)
            {                
            }
            else
            {
                Pawn.InvManager.AddInventory(InvItem, true);
                // End:0x2AC
                if(EvilWeap_Base(InvItem) != none)
                {
                    EvilWeap_Base(InvItem).ApplyCheckpointRecord(InvRecord);
                    // End:0x247
                    if(InvRecord.bIsActiveWeapon)
                    {
                        ActiveWeaponToRestore = EvilWeap_Base(InvItem);
                    }
                    // End:0x283
                    if(InvRecord.bIsActiveLeftWeapon)
                    {
                        ActiveLeftWeaponToRestore = EvilWeap_Base(InvItem);
                    }
                    // End:0x2AC
                    if(isInventory(InvItem))
                    {
                        RestoreFlashlight(InvItem);
                    }
                }
                bFoundActiveWeapon = bFoundActiveWeapon || InvRecord.bIsActiveWeapon;
                bFoundActiveLeftWeapon = bFoundActiveLeftWeapon || InvRecord.bIsActiveLeftWeapon;
            }
        }        
    }    
    // End:0x416
    if(bFoundActiveLeftWeapon)
    {
        // End:0x416
        if(MyEvilPawn != none)
        {
            // End:0x416
            if(isInventory(ActiveLeftWeaponToRestore))
            {
                MyEvilPawn.SavedWeaponLeft = ActiveWeaponToRestore.OffHandWeaponClass;
                MyEvilPawn.SetBlockingInventoryClass(ActiveLeftWeaponToRestore.Class, true);
                // End:0x416
                if(ActiveWeaponToRestore == none)
                {
                    MyEvilPawn.SetCurrentWeaponLeftClass(ActiveLeftWeaponToRestore.Class, false);
                }
            }
        }
    }
    // End:0x49E
    if(bFoundActiveWeapon)
    {
        // End:0x473
        if(MyEvilPawn != none)
        {
            MyEvilPawn.SetCurrentWeaponClass(ActiveWeaponToRestore.Class, false);            
        }
        else
        {
            Pawn.SetActiveWeapon(ActiveWeaponToRestore);
        }        
    }
    else
    {
        // End:0x502
        if(MyEvilPawn.HandsClass != none)
        {
            MyEvilPawn.SavedWeapon = MyEvilPawn.HandsClass;            
        }
    }
    //return;    
}

function bool isInventory(Inventory Inv)
{
    //return ReturnValue;    
}

function RestoreFlashlight(Inventory Inv)
{
    //return;    
}

function OnCheckPoint(SeqAct_Checkpoint Action)
{
    local bool bTeleportOnly;

    bTeleportOnly = Action.InputLinks[2].bHasImpulse;
    // End:0xEF
    if(Action.InputLinks[0].bHasImpulse || bTeleportOnly)
    {
        // End:0xEF
        if(!bTeleportOnly)
        {
            CheckpointSeqAct = Action;
            SaveCheckpoint(Action.CheckpointName, Action.bIsLevelStart);
        }
    }
    //return;    
}

delegate bool ContinueCameraRotation(float InDiffAngleDeg, float InDirDot)
{
    return InDiffAngleDeg > (Acos(InDirDot) * 57.2957800);
    //return ReturnValue;    
}

function PawnDied(Pawn P)
{
    super(UTPlayerController).PawnDied(P);
    GetMeleeActionsManager().StopHintMessage();
    GetPPManager().Reset();
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x33
    if(VarName == 'Pawn')
    {
        MyEvilPawn = EvilPawn(Pawn);
    }
    super(Controller).ReplicatedEvent(VarName);
    //return;    
}

function EvilLocalPlayer GetELP()
{
    return EvilLocalPlayer(Player);
    //return ReturnValue;    
}

function EvilMeleeActionsManager GetMeleeActionsManager()
{
    // End:0x27
    if(MeleeActionsManager == none)
    {
        MeleeActionsManager = new (self) Class'EvilMeleeActionsManager';
    }
    return MeleeActionsManager;
    //return ReturnValue;    
}

function EvilPostProcessManager GetPPManager()
{
    // End:0x1A
    if(EvilLocalPlayer(Player) == none)
    {
        return none;
    }
    return EvilLocalPlayer(Player).GetPPManager();
    //return ReturnValue;    
}

function EvilPlayerHitEffects GetPlayerHitEffects()
{
    // End:0x1A
    if(EvilLocalPlayer(Player) == none)
    {
        return none;
    }
    return EvilLocalPlayer(Player).GetPlayerHitEffects();
    //return ReturnValue;    
}

function EvilComboManager GetComboManager()
{
    // End:0x27
    if(ComboManager == none)
    {
        ComboManager = new (self) Class'EvilComboManager';
    }
    return ComboManager;
    //return ReturnValue;    
}

exec function SwitchToBestWeaponLeft(optional bool bForceNewWeapon)
{
    // End:0x41
    if((Pawn == none) || EvilInventoryManager(Pawn.InvManager) == none)
    {
        return;
    }
    EvilInventoryManager(Pawn.InvManager).SwitchToBestWeaponLeft(bForceNewWeapon);
    //return;    
}

reliable client simulated function ClientSwitchToBestWeaponLeft(optional bool bForceNewWeapon)
{
    SwitchToBestWeaponLeft(bForceNewWeapon);
    //return;    
}

exec function PrevWeapon()
{
    // End:0x19
    if(!bCinematicMode)
    {
        super.PrevWeapon();
    }
    //return;    
}

exec function NextWeapon()
{
    // End:0x19
    if(!bCinematicMode)
    {
        super.NextWeapon();
    }
    //return;    
}

exec function SetLeanLeft(bool LeanState)
{
    // End:0x49
    if((MyEvilPawn != none) && !bCinematicMode)
    {
        MyEvilPawn.SetLeanLeft(LeanState);
    }
    //return;    
}

exec function SetLeanRight(bool LeanState)
{
    // End:0x49
    if((MyEvilPawn != none) && !bCinematicMode)
    {
        MyEvilPawn.SetLeanRight(LeanState);
    }
    //return;    
}

exec function SetSprint(bool SprintState)
{
    // End:0x29
    if(WorldInfo.TimeSeconds < float(2))
    {
        return;
    }
    ServerSetSprint(SprintState);
    //return;    
}

reliable server function ServerSetSprint(bool SprintState)
{
    // End:0x5A
    if((Pawn != none) && !bCinematicMode || !SprintState)
    {
        MyEvilPawn.SetSprint(SprintState);
    }
    //return;    
}

exec function SetMovingBackward(bool MovingBackward)
{
    // End:0x28
    if(WorldInfo.TimeSeconds < float(1))
    {
        return;
    }
    ServerSetMovingBackward(MovingBackward);
    //return;    
}

reliable server function ServerSetMovingBackward(bool MovingBackward)
{
    // End:0x5A
    if((Pawn != none) && !bCinematicMode || !MovingBackward)
    {
        MyEvilPawn.SetMovingBackward(MovingBackward);
    }
    //return;    
}

exec function SetMovingSideways(byte MovingState)
{
    // End:0x28
    if(WorldInfo.TimeSeconds < float(1))
    {
        return;
    }
    ServerSetMovingSideways(MovingState);
    //return;    
}

reliable server function ServerSetMovingSideways(byte MovingState)
{
    // End:0x5E
    if((Pawn != none) && !bCinematicMode || int(MovingState) == int(0))
    {
        MyEvilPawn.SetMovingSideways(MovingState);
    }
    //return;    
}

exec function MeleeKick()
{
    // End:0x3F
    if((MyEvilPawn != none) && !bCinematicMode)
    {
        MyEvilPawn.DoMeleeKick();
    }
    //return;    
}

exec function Melee()
{
    // End:0x3F
    if((MyEvilPawn != none) && !bCinematicMode)
    {
        MyEvilPawn.DoMelee();
    }
    //return;    
}

exec function DynamiteThrow()
{
    // End:0x3F
    if((MyEvilPawn != none) && !bCinematicMode)
    {
        MyEvilPawn.DoDynamiteThrow();
    }
    //return;    
}

exec function GrenadeThrow()
{
    // End:0x3F
    if((MyEvilPawn != none) && !bCinematicMode)
    {
        MyEvilPawn.DoGrenadeThrow();
    }
    //return;    
}

exec function DynamiteRelease()
{
    // End:0x3F
    if((MyEvilPawn != none) && !bCinematicMode)
    {
        MyEvilPawn.DoDynamiteRelease();
    }
    //return;    
}

exec function GrenadeRelease()
{
    // End:0x3F
    if((MyEvilPawn != none) && !bCinematicMode)
    {
        MyEvilPawn.DoGrenadeRelease();
    }
    //return;    
}

exec function Reload()
{
    // End:0x40
    if((Pawn != none) && !bCinematicMode)
    {
        MyEvilPawn.ClientDoReload(true);
    }
    //return;    
}

function bool CanShowGameplayObject()
{
    return (((((MyEvilPawn != none) && !MyEvilPawn.IsRealSprinting()) && !bCinematicMode) && !(EvilWeap_Base(MyEvilPawn.Weapon) != none) && ((EvilWeap_Base(MyEvilPawn.Weapon).IsReloading() || EvilWeap_Base(MyEvilPawn.Weapon).IsInState('QuickHide')) || EvilWeap_Base(MyEvilPawn.Weapon).IsInState('WeaponPuttingDown')) || EvilWeap_Base(MyEvilPawn.Weapon).IsInState('WeaponAbortEquip')) && !(EvilWeap_Base(MyEvilPawn.WeaponLeft) != none) && (EvilWeap_Base(MyEvilPawn.WeaponLeft).IsReloading() || EvilWeap_Base(MyEvilPawn.WeaponLeft).IsInState('WeaponPuttingDown')) || EvilWeap_Base(MyEvilPawn.WeaponLeft).IsInState('WeaponAbortEquip')) && !(EvilWeap_Base(MyEvilPawn.ThrowWeapon) != none) && !EvilWeap_Base(MyEvilPawn.ThrowWeapon).IsInState('Inactive');
    //return ReturnValue;    
}

function bool CanHideGameplayObject()
{
    return ((((((MyEvilPawn != none) && !MyEvilPawn.IsRealSprinting()) && !bCinematicMode) && MyEvilPawn.WeaponLeft.Class == MyEvilPawn.EvilInvManager.BlockingClassLeft) && !(EvilWeap_Base(MyEvilPawn.Weapon) != none) && (EvilWeap_Base(MyEvilPawn.Weapon).IsReloading() || EvilWeap_Base(MyEvilPawn.Weapon).IsInState('QuickHide')) || EvilWeap_Base(MyEvilPawn.Weapon).IsInState('WeaponAbortEquip')) && !(EvilWeap_Base(MyEvilPawn.WeaponLeft) != none) && (EvilWeap_Base(MyEvilPawn.WeaponLeft).IsReloading() || EvilWeap_Base(MyEvilPawn.WeaponLeft).IsInState('WeaponEquipping')) || EvilWeap_Base(MyEvilPawn.WeaponLeft).IsInState('WeaponAbortEquip')) && !(EvilWeap_Base(MyEvilPawn.ThrowWeapon) != none) && !EvilWeap_Base(MyEvilPawn.ThrowWeapon).IsInState('Inactive');
    //return ReturnValue;    
}

exec function ShowGameplayObject()
{
    // End:0xA6
    if(MyEvilPawn.SavedWeaponLeft == none)
    {
        MyEvilPawn.SavedWeaponLeft = ((MyEvilPawn.WeaponLeft != none) ? class<EvilWeap_Base>(MyEvilPawn.WeaponLeft.Class) : none);
    }
    // End:0x14C
    if(MyEvilPawn.SavedWeapon == none)
    {
        MyEvilPawn.SavedWeapon = ((MyEvilPawn.Weapon != none) ? class<EvilWeap_Base>(MyEvilPawn.Weapon.Class) : none);
    }
    // End:0x2DB
    if(MyEvilPawn.EvilInvManager.BlockingClassLeft != none)
    {
        MyEvilPawn.SetCurrentWeaponLeftClass(class<EvilWeap_Base>(MyEvilPawn.EvilInvManager.BlockingClassLeft), true);
        // End:0x2DB
        if(((EvilWeap_Base(MyEvilPawn.Weapon) != none) && !EvilWeap_Base(MyEvilPawn.Weapon).BothHandWeapon) && int(EvilWeap_Base(MyEvilPawn.Weapon).GetZoomedState()) > int(1))
        {
            EvilWeap_Base(MyEvilPawn.Weapon).EndZoom(self, true);
        }
    }
    // End:0x36D
    if((EvilWeap_Base(MyEvilPawn.Weapon) != none) && ClassIsChildOf(MyEvilPawn.Weapon.Class, Class'EvilWeap_MeleeHands'))
    {
        MyEvilPawn.SetCurrentWeaponClass(none, true);
    }
    //return;    
}

exec function HideGameplayObject()
{
    // End:0x3A9
    if(((EvilWeap_Base(MyEvilPawn.Weapon) != none) && !EvilWeap_Base(MyEvilPawn.Weapon).BothHandWeapon) || (MyEvilPawn.Weapon == none) || MyEvilPawn.Weapon.IsA('EvilWeap_MeleeHands'))
    {
        // End:0x283
        if((MyEvilPawn.SavedWeapon != none) && MyEvilPawn.FindInventoryType(MyEvilPawn.SavedWeapon) != none)
        {
            // End:0x1CA
            if(ClassIsChildOf(MyEvilPawn.SavedWeapon, Class'EvilWeap_MeleeHands'))
            {
                MyEvilPawn.SetCurrentWeaponClass(MyEvilPawn.SavedWeapon);
                MyEvilPawn.SetCurrentWeaponLeftClass(none, true);                
            }
            else
            {
                // End:0x242
                if(MyEvilPawn.SavedWeapon.default.BothHandWeapon)
                {
                    MyEvilPawn.SetCurrentWeaponClass(MyEvilPawn.SavedWeapon, true);                    
                }
                else
                {
                    MyEvilPawn.SetCurrentWeaponLeftClass(MyEvilPawn.SavedWeaponLeft, true);
                }
            }            
        }
        else
        {
            // End:0x342
            if((MyEvilPawn.Weapon != none) && !MyEvilPawn.Weapon.IsA('EvilWeap_MeleeHands'))
            {
                MyEvilPawn.SetCurrentWeaponLeftClass(EvilWeap_Base(MyEvilPawn.Weapon).OffHandWeaponClass);                
            }
            else
            {
                // End:0x385
                if(MyEvilPawn.Weapon == none)
                {
                    MyEvilPawn.EquipHandsWeapon();
                }
                MyEvilPawn.SetCurrentWeaponLeftClass(none, true);
            }
        }        
    }
    else
    {
        MyEvilPawn.SetCurrentWeaponLeftClass(none);
    }
    // End:0x4C4
    if(((EvilWeap_Base(MyEvilPawn.Weapon) != none) && !EvilWeap_Base(MyEvilPawn.Weapon).BothHandWeapon) && int(EvilWeap_Base(MyEvilPawn.Weapon).GetZoomedState()) > int(1))
    {
        EvilWeap_Base(MyEvilPawn.Weapon).EndZoom(self, true);
    }
    MyEvilPawn.SavedWeapon = none;
    MyEvilPawn.SavedWeaponLeft = none;
    //return;    
}

function RetryHideGameplayObject(float retryTime)
{
    SetTimer(retryTime, true, 'TryHideGameplayObject');
    //return;    
}

function TryHideGameplayObject()
{
    // End:0x4F
    if(CanHideGameplayObject())
    {
        HideGameplayObject();
        MyEvilPawn.SetBlockingInventoryClass(none, true);
        ClearTimer('TryHideGameplayObject');        
    }
    //return;    
}

simulated event GetPlayerViewPoint(out Vector POVLocation, out Rotator POVRotation)
{
    local float DeltaTime;
    local UTPawn P;
    local TPOV POV;
    local TViewTarget OutVT;
    local bool bSwitchWithMatineRotation;

    P = ((IsLocalPlayerController()) ? UTPawn(CalcViewActor) : none);
    bSwitchWithMatineRotation = false;
    // End:0x17D
    if(((((LastCameraTimeStamp == WorldInfo.TimeSeconds) && CalcViewActor == ViewTarget) && CalcViewActor != none) && CalcViewActor.Location == CalcViewActorLocation) && CalcViewActor.Rotation == CalcViewActorRotation)
    {
        // End:0x17D
        if((P == none) || (P.EyeHeight == CalcEyeHeight) && P.WalkBob == CalcWalkBob)
        {
            POVLocation = CalcViewLocation;
            POVRotation = CalcViewRotation;
            return;
        }
    }
    DeltaTime = WorldInfo.TimeSeconds - LastCameraTimeStamp;
    LastCameraTimeStamp = WorldInfo.TimeSeconds;
    // End:0x292
    if(CameraActor(ViewTarget) != none)
    {
        // End:0x250
        if((PlayerCamera != none) && PlayerCamera.Class == Class'EvilPlayerCamera')
        {
            PlayerCamera.Destroy();
            PlayerCamera = none;
        }
        // End:0x273
        if(PlayerCamera == none)
        {
            ResetCameraMode();
            SpawnCamera();
        }
        super(PlayerController).GetPlayerViewPoint(POVLocation, POVRotation);        
    }
    else
    {
        // End:0x347
        if((PlayerCamera != none) && PlayerCamera.Class != Class'EvilPlayerCamera')
        {
            // End:0x324
            if(bSetMatineeRotation)
            {
                bSwitchWithMatineRotation = true;
                super(PlayerController).GetPlayerViewPoint(POVLocation, POVRotation);
                SetRotation(POVRotation);
                ClientSetRotation(POVRotation);
            }
            PlayerCamera.Destroy();
            PlayerCamera = none;
        }
        // End:0x440
        if(PlayerCamera == none)
        {
            ResetCameraMode();
            SpawnPlayerCamera();
            // End:0x3D5
            if(EvilWeap_Base(MyEvilPawn.Weapon) != none)
            {
                EvilWeap_Base(MyEvilPawn.Weapon).RestartIdleAnim(true);
            }
            // End:0x440
            if(EvilWeap_Base(MyEvilPawn.WeaponLeft) != none)
            {
                EvilWeap_Base(MyEvilPawn.WeaponLeft).RestartIdleAnim(true);
            }
        }
        // End:0x659
        if(!bSwitchWithMatineRotation)
        {
            // End:0x4B7
            if(PlayerCamera != none)
            {
                PlayerCamera.SetFOV(FOVAngle);
                PlayerCamera.GetCameraViewPoint(POVLocation, POVRotation);
            }
            // End:0x626
            if(ViewTarget != none)
            {
                POVRotation = Rotation;
                // End:0x5C0
                if(((PlayerReplicationInfo != none) && PlayerReplicationInfo.bOnlySpectator) && EvilVehicle_Base(ViewTarget) != none)
                {
                    EvilVehicle_Base(ViewTarget).bSpectatedView = true;
                    ViewTarget.CalcCamera(DeltaTime, POVLocation, POVRotation, FOVAngle);
                    EvilVehicle_Base(ViewTarget).bSpectatedView = false;                    
                }
                else
                {
                    ViewTarget.CalcCamera(DeltaTime, POVLocation, POVRotation, FOVAngle);
                }
                // End:0x623
                if(bFreeCamera)
                {
                    POVRotation = Rotation;
                }                
            }
            else
            {
                CalcCamera(DeltaTime, POVLocation, POVRotation, FOVAngle);
                return;
            }            
        }
        else
        {
            // End:0x672
            if(bSetMatineeRotation)
            {
                bSetMatineeRotation = false;
            }
        }
    }
    POVRotation = Normalize(POVRotation + ShakeRot);
    POVLocation += (ShakeOffset >> Rotation);
    // End:0x705
    if(CameraEffect != none)
    {
        CameraEffect.UpdateLocation(POVLocation, POVRotation, GetFOVAngle());
    }
    // End:0x764
    if(P != none)
    {
        CalcEyeHeight = P.EyeHeight;
        CalcWalkBob = P.WalkBob;
    }
    // End:0x9E1
    if(PlayerCamera != none)
    {
        POV.FOV = FOVAngle;
        POV.Location = POVLocation;
        POV.Rotation = POVRotation;
        PlayerCamera.ApplyCameraModifiers(DeltaTime, POV);
        OutVT.Controller = self;
        OutVT.Target = Pawn;
        OutVT.POV.FOV = FOVAngle;
        OutVT.POV.Location = POVLocation;
        OutVT.POV.Rotation = POVRotation;
        // End:0x94E
        if(GamePlayerCamera(PlayerCamera) != none)
        {
            GamePlayerCamera(PlayerCamera).UpdateCameraLensEffects(OutVT);
        }
        FOVAngle = POV.FOV;
        POVLocation = POV.Location;
        POVRotation = POV.Rotation;
        PlayerCamera.SetLocation(POVLocation);
    }
    CalcViewActor = ViewTarget;
    CalcViewActorLocation = ViewTarget.Location;
    CalcViewActorRotation = ViewTarget.Rotation;
    CalcViewLocation = POVLocation;
    CalcViewRotation = POVRotation;
    //return;    
}

function DamageShake(int Damage, class<DamageType> DamageType)
{
    local float BlendWeight;
    local class<EvilDmgType_Base> UTDamage;
    local CameraAnim AnimToPlay;

    // End:0x2B
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        return;
    }
    UTDamage = class<EvilDmgType_Base>(DamageType);
    // End:0xCA
    if((UTDamage != none) && UTDamage.default.DamageCameraAnim.Length > 0)
    {
        AnimToPlay = UTDamage.default.DamageCameraAnim[Rand(UTDamage.default.DamageCameraAnim.Length)];        
    }
    else
    {
        AnimToPlay = DamageCameraAnim[Rand(DamageCameraAnim.Length)];
    }
    // End:0x1B2
    if(AnimToPlay != none)
    {
        BlendWeight = FClamp(float(Damage) / 50.0000000, 0.2000000, 1.0000000);
        // End:0x1B2
        if((CameraAnimPlayer != none) && CameraAnimPlayer.bFinished || bCurrentCamAnimIsDamageShake && CameraAnimPlayer.CurrentBlendWeight < BlendWeight)
        {
            PlayCameraAnim(AnimToPlay, BlendWeight,,,,, true);
        }
    }
    //return;    
}

function PlayCameraAnim(CameraAnim AnimToPlay, optional float Scale = 1.0000000, optional float Rate = 1.0000000, optional float BlendInTime, optional float BlendOutTime, optional bool bLoop, optional bool bIsDamageShake)
{
    bCurrentCamAnimAffectsFOV = false;
    // End:0xB2
    if(CameraAnimPlayer != none)
    {
        CamOverridePostProcess = Class'Engine.CameraActor'.default.CamOverridePostProcess;
        CameraAnimPlayer.Play(AnimToPlay, self, Rate, Scale, BlendInTime, BlendOutTime, bLoop, false);
    }
    // End:0x14E
    if((!bIsDamageShake && !bLoop) && int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0x13A
        if(AnimToPlay.AnimLength <= float(1))
        {
            ClientPlayForceFeedbackWaveform(CameraShakeShortWaveForm);            
        }
        else
        {
            ClientPlayForceFeedbackWaveform(CameraShakeLongWaveForm);
        }
    }
    bCurrentCamAnimIsDamageShake = bIsDamageShake;
    //return;    
}

event PlayerTick(float DeltaTime)
{
    local float RealSpread;
    local int SeatIndex;
    local Vector Loc;
    local Rotator Rot;

    // End:0x29
    if(bLookingAtPointOfInterest && CameraLookAtFocusActor == none)
    {
        StopForceLookAtPointOfInterest(false);
    }
    super(PlayerController).PlayerTick(DeltaTime);
    // End:0x37B
    if((Pawn != none) && (EvilWeap_Base(Pawn.Weapon) != none) || EvilVehicle_Base(Pawn) != none)
    {
        // End:0x1A1
        if(Vehicle(Pawn) != none)
        {
            SeatIndex = EvilVehicle_Base(Pawn).GetSeatIndexForController(self);
            RealSpread = EvilVehicle_Base(Pawn).Seats[SeatIndex].Gun.Spread[int(EvilVehicle_Base(Pawn).Seats[SeatIndex].Gun.CurrentFireMode)];            
        }
        else
        {
            // End:0x2B6
            if((!Pawn.Weapon.IsFiring() && Pawn.WeaponLeft != none) && Pawn.WeaponLeft.IsFiring())
            {
                RealSpread = EvilWeap_Base(Pawn.WeaponLeft).GetCurrentSpread(Pawn.WeaponLeft.CurrentFireMode);                
            }
            else
            {
                RealSpread = EvilWeap_Base(Pawn.Weapon).GetCurrentSpread(Pawn.Weapon.CurrentFireMode);
            }
        }
        // End:0x37B
        if(RealSpread != VisualSpread)
        {
            VisualSpread = FInterpTo(VisualSpread, RealSpread, DeltaTime, 17.0000000);
        }
    }
    GetPlayerViewPoint(Loc, Rot);
    //return;    
}

simulated function DrawHUD(HUD H)
{
    super(UTPlayerController).DrawHUD(H);
    // End:0x1208
    if((EvilCheatManager(CheatManager) != none) && EvilCheatManager(CheatManager).bWeapSetPosMode)
    {
        // End:0x1208
        if(EvilWeap_Base(MyEvilPawn.Weapon) != none)
        {
            H.Canvas.DrawColor.R = 255;
            H.Canvas.DrawColor.G = 0;
            H.Canvas.DrawColor.B = 0;
            H.Canvas.DrawColor.A = 255;
            H.Canvas.SetPos(10.0000000, 5.0000000);
            H.Canvas.DrawText("INFO");
            H.Canvas.SetPos(10.0000000, 20.0000000);
            H.Canvas.DrawText("[Left Stick] Change Y/Z position");
            H.Canvas.SetPos(10.0000000, 35.0000000);
            H.Canvas.DrawText("[Right Stick] Change Yaw/Pitch rotation");
            H.Canvas.SetPos(10.0000000, 50.0000000);
            H.Canvas.DrawText("[DPAD UP/DOWN] Change X position");
            H.Canvas.SetPos(10.0000000, 65.0000000);
            H.Canvas.DrawText("[DPAD LEFT/RIGHT] Change Roll rotation");
            H.Canvas.SetPos(10.0000000, 80.0000000);
            H.Canvas.DrawText("[L1/R1] Change FOV");
            H.Canvas.SetPos(10.0000000, 95.0000000);
            H.Canvas.DrawText("[Y/B] Change scale");
            H.Canvas.SetPos(10.0000000, 110.0000000);
            H.Canvas.DrawText("[R3] Restore defaults");
            H.Canvas.SetPos(10.0000000, 125.0000000);
            H.Canvas.DrawText("[Start] Pause/replay anim");
            H.Canvas.SetPos(10.0000000, 140.0000000);
            H.Canvas.DrawText("[Back] Copy to clipboard (ATTENTION: FOV and normal scale must be filled in correspodning .uc file)");
            // End:0xC94
            if(int(EvilWeap_Base(MyEvilPawn.Weapon).GetZoomedState()) < int(3))
            {
                H.Canvas.SetPos(10.0000000, 170.0000000);
                H.Canvas.DrawText("CONFIG: NORMAL");
                H.Canvas.SetPos(10.0000000, 185.0000000);
                H.Canvas.DrawText((((("PlayerViewOffset: X=" $ string(EvilWeap_Base(MyEvilPawn.Weapon).PlayerViewOffset.X)) $ " Y=") $ string(EvilWeap_Base(MyEvilPawn.Weapon).PlayerViewOffset.Y)) $ " Z=") $ string(EvilWeap_Base(MyEvilPawn.Weapon).PlayerViewOffset.Z));
                H.Canvas.SetPos(10.0000000, 200.0000000);
                H.Canvas.DrawText((((("PlayerRotationOffset: Yaw=" $ string(EvilWeap_Base(MyEvilPawn.Weapon).PlayerRotationOffset.Yaw)) $ " Pitch=") $ string(EvilWeap_Base(MyEvilPawn.Weapon).PlayerRotationOffset.Pitch)) $ " Roll=") $ string(EvilWeap_Base(MyEvilPawn.Weapon).PlayerRotationOffset.Roll));
                H.Canvas.SetPos(10.0000000, 215.0000000);
                H.Canvas.DrawText("FirstPersonMesh Scale=" $ string(EvilWeap_Base(MyEvilPawn.Weapon).Mesh.Scale));                
            }
            else
            {
                H.Canvas.SetPos(10.0000000, 170.0000000);
                H.Canvas.DrawText("CONFIG: ZOOMING");
                H.Canvas.SetPos(10.0000000, 185.0000000);
                H.Canvas.DrawText((((("ZoomedMeshTranslation: X=" $ string(EvilWeap_Base(MyEvilPawn.Weapon).ZoomedMeshTranslation.X)) $ " Y=") $ string(EvilWeap_Base(MyEvilPawn.Weapon).ZoomedMeshTranslation.Y)) $ " Z=") $ string(EvilWeap_Base(MyEvilPawn.Weapon).ZoomedMeshTranslation.Z));
                H.Canvas.SetPos(10.0000000, 200.0000000);
                H.Canvas.DrawText((((("ZoomedMeshRotation: Yaw=" $ string(EvilWeap_Base(MyEvilPawn.Weapon).ZoomedMeshRotation.Yaw)) $ " Pitch=") $ string(EvilWeap_Base(MyEvilPawn.Weapon).ZoomedMeshRotation.Pitch)) $ " Roll=") $ string(EvilWeap_Base(MyEvilPawn.Weapon).ZoomedMeshRotation.Roll));
                H.Canvas.SetPos(10.0000000, 215.0000000);
                H.Canvas.DrawText("ZoomedMeshScale=" $ string(EvilWeap_Base(MyEvilPawn.Weapon).ZoomedMeshScale));
            }
            H.Canvas.SetPos(10.0000000, 230.0000000);
            H.Canvas.DrawText("FirstPersonMesh FOV=" $ string(UDKSkeletalMeshComponent(EvilWeap_Base(MyEvilPawn.Weapon).Mesh).FOV));
        }
    }
    //return;    
}

function PauseGame(optional delegate<CanUnpause> CanUnpauseDelegate = CanUnpause)
{
    //return;    
}

exec function DEMOToggleHelp()
{
    //return;    
}

function ShowInGameStatsScreen()
{
    //return;    
}

function HideInGameStatsScreen()
{
    //return;    
}

reliable client simulated function ClientSetCinematicMode(bool bInCinematicMode, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsHUD)
{
    local Actor A;
    local editinline EvilCaptionComponent CC;

    super(PlayerController).ClientSetCinematicMode(bInCinematicMode, bAffectsMovement, bAffectsTurning, bAffectsHUD);
    // End:0x5F
    if(bCinematicMode)
    {
        GetPPManager().Reset();
    }
    // End:0x16A
    if(bAffectsHUD)
    {
        // End:0xBB
        if(bCinematicMode)
        {
            LocalPlayer(Player).ViewportClient.SetSplitscreenConfiguration(0);            
        }
        else
        {
            // End:0x12A
            foreach AllActors(Class'Engine.Actor', A)
            {
                // End:0x128
                foreach A.ComponentList(Class'EvilCaptionComponent', CC)
                {
                    CC.OnHUDReset();                    
                }                                
            }            
            LocalPlayer(Player).ViewportClient.SetSplitscreenConfiguration(5);
        }
    }
    // End:0x294
    if(MyEvilPawn != none)
    {
        // End:0x1BE
        if(bCinematicMode)
        {
            CameraAnimPlayer.Stop(true);
            SetSprint(false);
            StopFiring();            
        }
        else
        {
            // End:0x229
            if(EvilWeap_Base(MyEvilPawn.Weapon) != none)
            {
                EvilWeap_Base(MyEvilPawn.Weapon).RestartIdleAnim(true);
            }
            // End:0x294
            if(EvilWeap_Base(MyEvilPawn.WeaponLeft) != none)
            {
                EvilWeap_Base(MyEvilPawn.WeaponLeft).RestartIdleAnim(true);
            }
        }
    }
    bCinemaDisableInputMove = bAffectsMovement && bInCinematicMode;
    bCinemaDisableInputLook = bAffectsTurning && bInCinematicMode;
    //return;    
}

event Jumped()
{
    local EvilWeap_Base Weap, WeapLeft;

    Weap = EvilWeap_Base(Pawn.Weapon);
    WeapLeft = EvilWeap_Base(Pawn.WeaponLeft);
    // End:0x91
    if(Weap != none)
    {
        Weap.SetSpreadJumping(true);
    }
    // End:0xC0
    if(WeapLeft != none)
    {
        WeapLeft.SetSpreadJumping(true);
    }
    //return;    
}

event Landed(Vector HitNormal, Actor FloorActor)
{
    local EvilWeap_Base Weap, WeapLeft;

    super(Actor).Landed(HitNormal, FloorActor);
    Weap = EvilWeap_Base(Pawn.Weapon);
    WeapLeft = EvilWeap_Base(Pawn.WeaponLeft);
    // End:0xD1
    if((Weap != none) && Weap.JumpSpreadState)
    {
        Weap.SetSpreadJumping(false);
    }
    // End:0x124
    if((WeapLeft != none) && WeapLeft.JumpSpreadState)
    {
        WeapLeft.SetSpreadJumping(false);
    }
    //return;    
}

function Possess(Pawn inPawn, bool bVehicleTransition)
{
    SetButtonFilter(false);
    GetMeleeActionsManager().Reset();
    ClientStopLowHealthAmbient();
    // End:0x66
    if((GetPPManager()) != none)
    {
        GetPPManager().Reset();
    }
    super(UTPlayerController).Possess(inPawn, bVehicleTransition);
    MyEvilPawn = EvilPawn(inPawn);
    //return;    
}

function UnPossess()
{
    // End:0x78
    if((MyEvilPawn != none) && MyEvilPawn.CurrentLink != none)
    {
        MyEvilPawn.CurrentLink.UnClaim(MyEvilPawn, -1, true);
    }
    MyEvilPawn = none;
    super(PlayerController).UnPossess();
    //return;    
}

simulated event PostBeginPlay()
{
    super(PlayerController).PostBeginPlay();
    StorePointsOfInterest();
    bProfileSettingsUpdated = true;
    // End:0x47
    if(int(Role) == int(ROLE_Authority))
    {
        SetTimer(0.1000000, true, 'CheckForUsableTrigger');
    }
    //return;    
}

simulated event Destroyed()
{
    // End:0x1A
    if(UsableTrigger != none)
    {
        UsableTrigger = none;
    }
    super(UTPlayerController).Destroyed();
    // End:0x5D
    if(CheckpointSeqAct != none)
    {
        CheckpointSeqAct.MessageFinished();
        CheckpointSeqAct = none;
    }
    //return;    
}

simulated event ReceivedPlayer()
{
    local EvilLocalPlayer LP;
    local Vector2D ViewportSize;

    super(UTPlayerController).ReceivedPlayer();
    LP = GetELP();
    // End:0x1A7
    if(LP != none)
    {
        LP.GetPPManager().Reset();
        // End:0x1A7
        if(false && LP != none)
        {
            HighlightSceneCaptureComponent.Player = LP;
            LP.ViewportClient.GetViewportSize(ViewportSize);
            HighlightMaskTexture = Class'Engine.TextureRenderTarget2D'.static.Create(FCeil(ViewportSize.X), FCeil(ViewportSize.Y), 2, ColorToLinearColor(HighlightSceneCaptureComponent.ClearColor), false);
            HighlightSceneCaptureComponent.SetCaptureParameters(HighlightMaskTexture);
        }
    }
    //return;    
}

function bool IsThereOtherReasonToLetUseHold()
{
    local Vehicle V;

    // End:0x1A
    if(Vehicle(Pawn) != none)
    {
        return true;
    }
    // End:0x94
    if((Vehicle(Pawn.Base) != none) && Vehicle(Pawn.Base).CanEnterVehicle(Pawn))
    {
        return true;
    }
    // End:0xEC
    foreach Pawn.OverlappingActors(Class'Engine.Vehicle', V, Pawn.VehicleCheckRadius)
    {        
        return true;        
    }    
    return false;
    //return ReturnValue;    
}

function CheckForUsableTrigger()
{
    local Trigger T;
    local int Idx;
    local float Weight;
    local bool bInserted;
    local Vector CameraLoc;
    local Rotator CameraRot;
    local array<Trigger> useList, sortedList;
    local array<float> weightList;

    // End:0x2AA
    if(MyEvilPawn != none)
    {
        GetTriggerUseList(InteractDistance, 60.0000000, 0.0000000, true, useList);
        // End:0x2AA
        if(useList.Length > 0)
        {
            GetPlayerViewPoint(CameraLoc, CameraRot);
            J0x62:

            // End:0x289 [Loop If]
            if(useList.Length > 0)
            {
                T = useList[useList.Length - 1];
                useList.Length = useList.Length - 1;
                Weight = Normal(T.Location - CameraLoc) Dot Vector(CameraRot);
                Weight += (1.0000000 - (VSize(T.Location - Pawn.Location) / InteractDistance));
                bInserted = false;
                Idx = 0;
                J0x161:

                // End:0x229 [Loop If]
                if((Idx < sortedList.Length) && !bInserted)
                {
                    // End:0x21B
                    if(weightList[Idx] < Weight)
                    {
                        sortedList.Insert(Idx, 1);                        
                        weightList.Insert(Idx, 1);                        
                        sortedList[Idx] = T;
                        weightList[Idx] = Weight;
                        bInserted = true;
                    }
                    Idx++;
                    // [Loop Continue]
                    goto J0x161;
                }
                // End:0x286
                if(!bInserted)
                {
                    Idx = sortedList.Length;
                    sortedList[Idx] = T;
                    weightList[Idx] = Weight;
                }
                // [Loop Continue]
                goto J0x62;
            }
            UsableTrigger = sortedList[0];
            ForceNetRelevant();
            return;
        }
    }
    UsableTrigger = none;
    ForceNetRelevant();
    //return;    
}

function GetTriggerUseList(float interactDistanceToCheck, float crosshairDist, float minDot, bool bUsuableOnly, out array<Trigger> out_useList)
{
    local int Idx;
    local Vector CameraLoc;
    local Rotator CameraRot;
    local Trigger checkTrigger;
    local SeqEvent_Used UseSeq;

    // End:0x324
    if(Pawn != none)
    {
        GetPlayerViewPoint(CameraLoc, CameraRot);
        // End:0x323
        foreach Pawn.CollidingActors(Class'Engine.Trigger', checkTrigger, interactDistanceToCheck)
        {
            Idx = 0;
            J0x70:

            // End:0x322 [Loop If]
            if(Idx < checkTrigger.GeneratedEvents.Length)
            {
                UseSeq = SeqEvent_Used(checkTrigger.GeneratedEvents[Idx]);
                // End:0x314
                if((((UseSeq != none) && !bUsuableOnly || checkTrigger.GeneratedEvents[Idx].CheckActivate(checkTrigger, Pawn, true)) && (Normal(checkTrigger.Location - CameraLoc) Dot Vector(CameraRot)) >= minDot) && ((UseSeq.bAimToInteract && IsAimingAt(checkTrigger, InteractAimDotAngle)) && VSize(Pawn.Location - checkTrigger.Location) <= UseSeq.InteractDistance) || !UseSeq.bAimToInteract && VSize(Pawn.Location - checkTrigger.Location) <= UseSeq.InteractDistance)
                {
                    out_useList[out_useList.Length] = checkTrigger;
                    Idx = checkTrigger.GeneratedEvents.Length;
                }
                Idx++;
                // [Loop Continue]
                goto J0x70;
            }            
        }        
    }
    //return;    
}

function bool AimingHelp(bool bInstantHit)
{
    // End:0x29
    if(WorldInfo.IsConsoleBuild(0))
    {
        return true;        
    }
    else
    {
        // End:0x83
        if(int(WorldInfo.NetMode) == int(NM_Standalone))
        {
            return (PlayerInput != none) && PlayerInput.bUsingGamepad;
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function bool IsAimingAt(Actor ATarget, float Epsilon)
{
    local Vector Loc;
    local Rotator Rot;

    GetPlayerViewPoint(Loc, Rot);
    return (Normal(ATarget.Location - Loc) Dot Vector(Rot)) >= Epsilon;
    //return ReturnValue;    
}

function bool IsDoingAPawnAction()
{
    return (MyEvilPawn != none) && MyEvilPawn.IsDoingAPawnAction();
    //return ReturnValue;    
}

final function bool CanDoPawnAction(byte AMove, optional bool bForceCheck)
{
    return (int(AMove) == 0) || (MyEvilPawn != none) && MyEvilPawn.super(EvilPlayerController).CanDoPawnAction(AMove, bForceCheck);
    //return ReturnValue;    
}

simulated function bool IsDoingPawnAction(byte AAction)
{
    return (MyEvilPawn != none) && MyEvilPawn.IsDoingPawnAction(AAction);
    //return ReturnValue;    
}

final event DoPawnAction(byte NewAction, optional bool bForceAction = false, optional EvilPawn InInteractionPawn, optional int InPawnActionFlags = 0)
{
    local PAStruct NewActionStruct;

    // End:0x109
    if(bForceAction || CanDoPawnAction(NewAction))
    {
        NewActionStruct = MyEvilPawn.FillPAStructFromParams(NewAction, InInteractionPawn, InPawnActionFlags);
        MyEvilPawn.DoPawnActionFromStruct(NewActionStruct, bForceAction);
        // End:0x109
        if(int(Role) < int(ROLE_Authority))
        {
            ClientToServerDoPawnAction(NewActionStruct, bForceAction, Pawn.Rotation.Yaw);
        }
    }
    //return;    
}

reliable server final function ClientToServerDoPawnAction(PAStruct NewActionStruct, bool bForceAction, int RotYaw)
{
    local Rotator NewRot;

    // End:0xB0
    if(MyEvilPawn != none)
    {
        NewRot = Pawn.Rotation;
        NewRot.Yaw = RotYaw;
        Pawn.SetRotation(NewRot);
        MyEvilPawn.DoPawnActionFromStruct(NewActionStruct, bForceAction);
    }
    //return;    
}

reliable client final simulated function ServerToClientDoPawnAction(PAStruct NewActionStruct, bool bForceAction)
{
    // End:0x41
    if(MyEvilPawn != none)
    {
        MyEvilPawn.DoPawnActionFromStruct(NewActionStruct, bForceAction);
    }
    //return;    
}

final function EndPawnAction()
{
    // End:0x81
    if(IsDoingAPawnAction())
    {
        // End:0x81
        if(MyEvilPawn != none)
        {
            // End:0x61
            if(MyEvilPawn.IsLocallyControlled())
            {
                MyEvilPawn.LocalEndPawnAction();                
            }
            else
            {
                MyEvilPawn.ServerEndPawnAction();
            }
        }
    }
    //return;    
}

final event ServerDictatePawnAction(byte NewAction, optional EvilPawn InInteractionPawn, optional int InPawnActionFlags = 0)
{
    local PAStruct NewActionStruct;

    // End:0x3B
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        ScriptTrace();
        return;
    }
    NewActionStruct = MyEvilPawn.FillPAStructFromParams(NewAction, InInteractionPawn, InPawnActionFlags);
    // End:0xAB
    if(LocalPlayer(Player) == none)
    {
        ServerToClientDoPawnAction(NewActionStruct, true);
    }
    MyEvilPawn.DoPawnActionFromStruct(NewActionStruct, true);
    //return;    
}

function PawnActionStarted(byte NewAction)
{
    //return;    
}

protected simulated function InternalSetFocus(bool bFromKismet, float InterpSpeed, optional float CameraFOV, optional EvilPlayerController.EPOIFocusType FocusType = 3, optional float Epsilon = 0.9990000, optional delegate<ContinueCameraRotation> InDelegate = None)
{
    local Vector LockedViewDir, Loc;
    local Rotator Rot;
    local float F;

    // End:0x45
    if(int(FocusType) <= int(1))
    {
        ScriptTrace();
        return;
    }
    // End:0x74
    if(CameraFOV > 0.0000000)
    {
        StartZoomNonlinear(CameraFOV, CameraLookAtInterpSpeed);
    }
    bCameraLookAtIsFromKismet = bFromKismet;
    __ContinueCameraRotation__Delegate = InDelegate;
    CameraLookAtFocusType = FocusType;
    CameraLookAtEpsilon = Epsilon;
    CameraLookAtInterpSpeed = InterpSpeed;
    GetLockedViewData(false, LockedViewDir, F);
    CameraLookAtLastDir = Rotator(LockedViewDir);
    GetPlayerViewPoint(Loc, Rot);
    CameraLookAtInitialDir = Rot;
    CameraLookAtInterpAlpha = 0.0000000;
    //return;    
}

simulated function SetFocusActor(bool bFromKismet, Actor FocusActor, float InterpSpeed, optional float CameraFOV, optional EvilPlayerController.EPOIFocusType FocusType = 3, optional float Epsilon = 0.9990000, optional name FocusBoneName, optional delegate<ContinueCameraRotation> InDelegate)
{
    CameraLookAtFocusActor = FocusActor;
    CameraLookAtFocusBoneName = FocusBoneName;
    InternalSetFocus(bFromKismet, InterpSpeed, CameraFOV, FocusType, Epsilon, InDelegate);
    //return;    
}

simulated function SetFocusDir(bool bFromKismet, Vector Dir, float InterpSpeed, optional float CameraFOV, optional EvilPlayerController.EPOIFocusType FocusType = 3, optional float Epsilon = 0.9990000, optional delegate<ContinueCameraRotation> InDelegate)
{
    CameraLookAtDirection = Dir;
    InternalSetFocus(bFromKismet, InterpSpeed, CameraFOV, FocusType, Epsilon, InDelegate);
    //return;    
}

reliable client simulated function ClientClearFocus(bool bFromKismet, optional bool bForceLeaveRotation, optional bool bForceClearCameraLookAtFocusType)
{
    ClearFocus(bFromKismet, bForceLeaveRotation, bForceClearCameraLookAtFocusType);
    //return;    
}

simulated function ClearFocus(bool bFromKismet, optional bool bForceLeaveRotation, optional bool bForceClearCameraLookAtFocusType)
{
    local bool bLeaveRotation;
    local Vector Loc;
    local Rotator Rot;

    bLeaveRotation = bForceLeaveRotation || (EvilPointOfInterest(CameraLookAtFocusActor) != none) && EvilPointOfInterest(CameraLookAtFocusActor).bLeavePlayerFacingPOI;
    // End:0x124
    if(!bLeaveRotation)
    {
        // End:0x115
        if(EvilPointOfInterest(CameraLookAtFocusActor) != none)
        {
            CameraLookAtDirection = Vector(PrePOICamRot);
            CameraLookAtFocusType = 1;
            CameraLookAtLastDir = PrePOICamRot;
            __ContinueCameraRotation__Delegate = None;
            GetPlayerViewPoint(Loc, Rot);
            CameraLookAtInitialDir = Rot;
            CameraLookAtInterpAlpha = 0.0000000;            
        }
        else
        {
            CameraLookAtFocusType = 0;
        }        
    }
    else
    {
        // End:0x153
        if((int(CameraLookAtFocusType) != int(3)) || bForceClearCameraLookAtFocusType)
        {
            CameraLookAtFocusType = 0;
        }
    }
    CameraLookAtFocusActor = none;
    CameraLookAtFocusBoneName = 'None';
    StartZoomNonlinear(DefaultFOV, CameraLookAtInterpSpeed);
    //return;    
}

simulated function OnFocusPointReached()
{
    //return;    
}

simulated function Actor GetFocusActor()
{
    return CameraLookAtFocusActor;
    //return ReturnValue;    
}

simulated function Vector GetFocusDir()
{
    return CameraLookAtDirection;
    //return ReturnValue;    
}

simulated function EvilPlayerController.EPOIFocusType GetFocusType()
{
    return CameraLookAtFocusType;
    //return ReturnValue;    
}

protected simulated function GetLockedViewData(bool bRailcarLock, out Vector out_LockedViewDir, out float out_LockedViewEpsilon)
{
    // End:0xD4
    if(bRailcarLock)
    {
        out_LockedViewDir = Normal(EvilRailCar_Base(MyEvilPawn.ClampedBase).AlignViewDir >> MyEvilPawn.ClampedBase.Rotation);
        out_LockedViewEpsilon = EvilRailCar_Base(MyEvilPawn.ClampedBase).AlignViewEpsilon;        
    }
    else
    {
        out_LockedViewEpsilon = CameraLookAtEpsilon;
        // End:0x2CC
        if((CameraLookAtFocusActor != none) && int(CameraLookAtFocusType) != int(1))
        {
            out_LockedViewDir = CameraLookAtFocusActor.Location;
            // End:0x294
            if(CameraLookAtFocusBoneName != 'None')
            {
                // End:0x1F1
                if(CameraLookAtFocusActor.IsA('Pawn') && Pawn(CameraLookAtFocusActor).Mesh != none)
                {
                    out_LockedViewDir = EvilPawn(CameraLookAtFocusActor).Mesh.GetBoneLocation(CameraLookAtFocusBoneName);                    
                }
                else
                {
                    // End:0x294
                    if(CameraLookAtFocusActor.IsA('SkeletalMeshActor') && SkeletalMeshActor(CameraLookAtFocusActor).SkeletalMeshComponent != none)
                    {
                        out_LockedViewDir = SkeletalMeshActor(CameraLookAtFocusActor).SkeletalMeshComponent.GetBoneLocation(CameraLookAtFocusBoneName);
                    }
                }
            }
            out_LockedViewDir = Normal(out_LockedViewDir - Pawn.Location);            
        }
        else
        {
            out_LockedViewDir = CameraLookAtDirection;
        }
    }
    //return;    
}

function Rotator RInterpToEaseInOut(Rotator Current, Rotator Target, Rotator Start, out float Alpha, float DeltaTime, float InterpSpeed, float InterpExponent)
{
    local float InitialDistance, DeltaInterpSpeed;
    local Rotator Result;

    InitialDistance = RDiff(Target, Start);
    // End:0x43
    if(InitialDistance ~= 0.0000000)
    {
        return Target;
    }
    DeltaInterpSpeed = FClamp(DeltaTime * InterpSpeed, 0.0000000, 1.0000000);
    Alpha = FClamp(Alpha + DeltaInterpSpeed, 0.0000000, 1.0000000);
    Start = Normalize(Start);
    Target = Normalize(Target);
    Result.Pitch = FCeil(FInterpEaseInOut(float(Start.Pitch), float(Target.Pitch), Alpha, InterpExponent));
    Result.Yaw = FCeil(FInterpEaseInOut(float(Start.Yaw), float(Target.Yaw), Alpha, InterpExponent));
    Result.Roll = FCeil(FInterpEaseInOut(float(Start.Roll), float(Target.Roll), Alpha, InterpExponent));
    return Result;
    //return ReturnValue;    
}

function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, Rotator DeltaRot)
{
    local bool bRailcar, bRailcarLock;
    local Vector LockedViewDir;
    local float LockedViewEpsilon;
    local Rotator LockedViewRot;
    local int LockedViewAmount;
    local Vector X, Y, Z;

    bRailcar = (MyEvilPawn != none) && EvilRailCar_Base(MyEvilPawn.ClampedBase) != none;
    bRailcarLock = bRailcar && EvilRailCar_Base(MyEvilPawn.ClampedBase).bForceAlignView;
    switch(CameraLookAtFocusType)
    {
        // End:0x25B
        case 0:
            // End:0x25B
            if(!bRailcarLock)
            {
                // End:0x220
                if(bRailcar)
                {
                    super(PlayerController).ProcessViewRotation(DeltaTime, RailCarRotation, DeltaRot);
                    GetAxes(MyEvilPawn.ClampedBase.Rotation, X, Y, Z);
                    out_ViewRotation = QuatToRotator(QuatProduct(QuatProduct(QuatFromAxisAndAngle(Z, float(RailCarRotation.Yaw) * 0.0000959), QuatFromAxisAndAngle(Y, float(-RailCarRotation.Pitch) * 0.0000959)), QuatFromRotator(MyEvilPawn.ClampedBase.Rotation)));                    
                }
                else
                {
                    super(PlayerController).ProcessViewRotation(DeltaTime, out_ViewRotation, DeltaRot);
                }
                PrePOICamRot = out_ViewRotation;
                // End:0x542
                break;
            }
        // End:0x3D0
        case 2:
            super(PlayerController).ProcessViewRotation(DeltaTime, out_ViewRotation, DeltaRot);
            GetLockedViewData(((int(CameraLookAtFocusType) == int(0)) ? bRailcarLock : false), LockedViewDir, LockedViewEpsilon);
            LockedViewRot = Rotator(LockedViewDir);
            LockedViewAmount = Round(Acos(LockedViewEpsilon) * 10430.3800000);
            out_ViewRotation.Yaw = ClampRotAxisFromBase(out_ViewRotation.Yaw, LockedViewRot.Yaw, LockedViewAmount);
            out_ViewRotation.Pitch = ClampRotAxisFromBase(out_ViewRotation.Pitch, LockedViewRot.Pitch, LockedViewAmount);
            // End:0x542
            break;
        // End:0x3D5
        case 3:
        // End:0x53F
        case 1:
            GetLockedViewData(false, LockedViewDir, LockedViewEpsilon);
            LockedViewRot = Rotator(LockedViewDir);
            // End:0x476
            if(int(CameraLookAtFocusType) == int(3))
            {
                // End:0x473
                if(!ContinueCameraRotation(RDiff(out_ViewRotation, LockedViewRot), LockedViewEpsilon))
                {
                    CameraLookAtFocusType = 2;
                    OnFocusPointReached();
                }                
            }
            else
            {
                // End:0x4AB
                if(RDiff(out_ViewRotation, LockedViewRot) < 0.1000000)
                {
                    ClearFocus(false);
                    return;
                }
            }
            out_ViewRotation += Normalize(LockedViewRot - CameraLookAtLastDir);
            CameraLookAtLastDir = LockedViewRot;
            out_ViewRotation = RInterpToEaseInOut(out_ViewRotation, LockedViewRot, CameraLookAtInitialDir, CameraLookAtInterpAlpha, DeltaTime, CameraLookAtInterpSpeed, PointOfInterestLookatInterpExponent);
            // End:0x542
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

simulated function StorePointsOfInterest()
{
    local EvilPointOfInterest POI;

    // End:0x4F
    foreach DynamicActors(Class'EvilPointOfInterest', POI)
    {
        // End:0x4E
        if(POI.bEnabled)
        {
            AddPointOfInterest(POI);
        }        
    }    
    //return;    
}

simulated function bool HasLineOfSightToPOI(EvilPointOfInterest POI)
{
    local Actor HitActor;
    local Vector ActualLookatLoc, HitLoc, HitNormal, StartTrace, StartTraceAdj;

    // End:0x16A
    if(POI.bForceLookCheckLineOfSight)
    {
        ActualLookatLoc = POI.GetActualLookatLocation();
        StartTrace = Pawn.Location + (vect(0.0000000, 0.0000000, 1.0000000) * Pawn.GetCollisionHeight());
        // End:0xF6
        if(MyEvilPawn != none)
        {
            StartTraceAdj = vect(0.0000000, 64.0000000, 0.0000000);
            StartTrace += (StartTraceAdj >> Rotator(ActualLookatLoc - StartTrace));
        }
        HitActor = Trace(HitLoc, HitNormal, ActualLookatLoc, StartTrace);
        // End:0x16A
        if((HitActor != none) && HitActor != POI.AttachedToActor)
        {
            return false;
        }
    }
    return true;
    //return ReturnValue;    
}

simulated function bool ProcessPOI(optional EvilPointOfInterest POI, optional bool bUserInstigated)
{
    local EvilPointOfInterest BestPOI, CurrPOI;

    // End:0x25
    if(HasBestPOIToLookAt())
    {
        BestPOI = LastBestPOI;        
    }
    else
    {
        BestPOI = FindNewBestPOIToLookAt(POI);
    }
    // End:0x7D
    if((BestPOI == none) || (POI != none) && POI != BestPOI)
    {
        return false;
    }
    // End:0xE4
    if((int(BestPOI.ForceLookType) != int(0)) && BestPOI.bForceLookCheckLineOfSight)
    {
        // End:0xE4
        if(!HasLineOfSightToPOI(BestPOI))
        {
            return false;
        }
    }
    // End:0x15A
    if(bLookingAtPointOfInterest && CameraLookAtFocusActor != none)
    {
        CurrPOI = EvilPointOfInterest(CameraLookAtFocusActor);
        // End:0x137
        if(CurrPOI == BestPOI)
        {
            return false;
        }
        // End:0x15A
        if(CurrPOI != none)
        {
            StopForceLookAtPointOfInterest(bUserInstigated);
        }
    }
    return ForceLookAtPointOfInterest(bUserInstigated, BestPOI);
    //return ReturnValue;    
}

simulated function AddPointOfInterest(EvilPointOfInterest POI)
{
    local int Idx, CurrPriority;

    // End:0x226
    if(POI != none)
    {
        POI.bEnabled = true;
        // End:0x84
        if(EnabledPointsOfInterest.Find(POI) == )
        {            
            EnabledPointsOfInterest[EnabledPointsOfInterest.Length] = POI;
            POILookedAtList[POILookedAtList.Length] = false;
        }
        // End:0x1B1
        if(POI.bDisableOtherPOIs)
        {
            Idx = 0;
            J0xB1:

            // End:0x1B1 [Loop If]
            if(Idx < EnabledPointsOfInterest.Length)
            {
                // End:0x1A3
                if((EnabledPointsOfInterest[Idx] != POI) && EnabledPointsOfInterest[Idx].bEnabled)
                {
                    CurrPriority = EnabledPointsOfInterest[Idx].GetLookAtPriority(self);
                    // End:0x1A3
                    if(CurrPriority >= Class'EvilPointOfInterest'.default.POIPriority_ScriptedEvent)
                    {
                        EnabledPointsOfInterest[Idx].bEnabled = false;
                    }
                }
                Idx++;
                // [Loop Continue]
                goto J0xB1;
            }
        }
        // End:0x226
        if((int(POI.ForceLookType) == int(1)) || bLookingAtPointOfInterest && IsHoldingPOIButton())
        {
            ProcessPOI(POI, bLookingAtPointOfInterest && IsHoldingPOIButton());
        }
    }
    //return;    
}

simulated function RemovePointOfInterest(EvilPointOfInterest POI, optional EvilPointOfInterest.EPOIForceLookType ForceLookType)
{
    local int Idx;

    // End:0x8B
    if(POI != none)
    {
        Idx = EnabledPointsOfInterest.Find(POI);        
        // End:0x8B
        if(Idx >= 0)
        {
            EnabledPointsOfInterest.Remove(Idx, 1);            
            POILookedAtList.Remove(Idx, 1);            
            // End:0x8B
            if(CameraLookAtFocusActor == POI)
            {
                StopForceLookAtPointOfInterest();
            }
        }
    }
    //return;    
}

function bool TryPOILookAt()
{
    return ProcessPOI(none, true);
    //return ReturnValue;    
}

function bool TryPOILookAway()
{
    local EvilPointOfInterest CurrPOI;

    // End:0x53
    if(CameraLookAtFocusActor != none)
    {
        CurrPOI = EvilPointOfInterest(CameraLookAtFocusActor);
        // End:0x53
        if(CurrPOI != none)
        {
            // End:0x53
            if(IsTimerActive('ForceLookDurationExpired'))
            {
                return false;
            }
        }
    }
    return StopForceLookAtPointOfInterest(true);
    //return ReturnValue;    
}

final function ForceLookDurationExpired()
{
    // End:0x2C
    if(!bLookingAtPointOfInterest || !IsHoldingPOIButton(true))
    {
        StopForceLookAtPointOfInterest(false);
    }
    //return;    
}

final simulated function EvilPointOfInterest FindBestPOIToLookAt(optional EvilPointOfInterest POIToTest)
{
    local EvilPointOfInterest POI, BestPOI;
    local int POIPriority, CurrPriority;
    local bool bSetBestPOI;
    local Pawn Myself;

    BestPOI = POIToTest;
    POIPriority = ((BestPOI == none) ? -1 : BestPOI.LookAtPriority);
    // End:0x269
    foreach EnabledPointsOfInterest(POI)
    {
        bSetBestPOI = false;
        Myself = Pawn;
        // End:0x268
        if(POI.bEnabled && (POI.AttachedToActor == none) || POI.AttachedToActor != Myself)
        {
            CurrPriority = POI.GetLookAtPriority(self);
            // End:0x268
            if(CurrPriority >= 0)
            {
                // End:0x268
                if(((BestPOI == none) || CurrPriority > POIPriority) || ((CurrPriority == POIPriority) && (POIToTest == none) || BestPOI != POIToTest) && VSizeSq(POI.Location - Pawn.Location) < VSizeSq(BestPOI.Location - Pawn.Location))
                {
                    bSetBestPOI = true;
                    // End:0x268
                    if(bSetBestPOI)
                    {
                        BestPOI = POI;
                        POIPriority = CurrPriority;
                    }
                }
            }
        }        
    }    
    LastBestPOI = BestPOI;
    return BestPOI;
    //return ReturnValue;    
}

final simulated function EvilPointOfInterest FindNewBestPOIToLookAt(optional EvilPointOfInterest POIToTest)
{
    local EvilPointOfInterest BestPOI, OldPOI;

    OldPOI = LastBestPOI;
    BestPOI = FindBestPOIToLookAt(POIToTest);
    // End:0x4A
    if(BestPOI == OldPOI)
    {
        return none;
    }
    LastBestPOI = BestPOI;
    return BestPOI;
    //return ReturnValue;    
}

final simulated function bool HasBestPOIToLookAt()
{
    return LastBestPOI != none;
    //return ReturnValue;    
}

final simulated function bool ForceLookAtPointOfInterest(optional bool bUserInstigated, optional EvilPointOfInterest POIToForce)
{
    local float POICamFOV;
    local int IndexInList;
    local bool bDoForceLookTimer, Temp;
    local Vector POVLoc;
    local Rotator POVRot;
    local MessageInfo MI;

    GetPlayerViewPoint(POVLoc, POVRot);
    // End:0x42
    if(POIToForce == none)
    {
        POIToForce = FindBestPOIToLookAt();
    }
    // End:0x5E
    if(CameraLookAtFocusActor == POIToForce)
    {
        return false;        
    }
    else
    {
        // End:0x76
        if(bLookingAtPointOfInterest)
        {
            StopForceLookAtPointOfInterest(false);
        }
    }
    // End:0x88D
    if(POIToForce != none)
    {
        POICamFOV = (((Vehicle(Pawn) == none) || EvilPawn(Pawn) != none) ? POIToForce.GetDesiredFOV(POVLoc) : 0.0000000);
        SetFocusActor(false, POIToForce, PointOfInterestLookatInterpSpeed, POICamFOV, 3);
        bLookingAtPointOfInterest = true;
        // End:0x134
        if(bUserInstigated)
        {
        }
        EvilPlayerInput(PlayerInput).SetButtonFilter(true, 5);
        // End:0x2B8
        if(EvilGFxHudWrapper(myHUD) != none)
        {
            MI = POIToForce.GetDisplayName();
            EvilGFxHudWrapper(myHUD).HudMovie.SetCenterMessageText(MI.Message, POIToForce.DisplayLong, POIToForce.DisplayParseTags);
            // End:0x2B8
            if(Len(MI.Sound) > 0)
            {
                Pawn.PlaySound(SoundCue(DynamicLoadObject(MI.Sound, Class'Engine.SoundCue')));
            }
        }
        // End:0x3D0
        if((int(POIToForce.ForceLookType) != int(0)) && POIToForce.ForceLookDuration > 0.0000000)
        {
            bDoForceLookTimer = true;
            // End:0x397
            if(int(POIToForce.ForceLookType) != int(0))
            {
                IndexInList = EnabledPointsOfInterest.Find(POIToForce);                
                // End:0x397
                if((IndexInList == -1) || POILookedAtList[IndexInList])
                {
                    bDoForceLookTimer = false;
                }
            }
            // End:0x3D0
            if(bDoForceLookTimer)
            {
                SetTimer(POIToForce.ForceLookDuration, false, 'ForceLookDurationExpired');
            }
        }
        IndexInList = EnabledPointsOfInterest.Find(POIToForce);        
        // End:0x418
        if(IndexInList != -1)
        {
            POILookedAtList[IndexInList] = true;
        }
        ServerFirePOIActionOutputLink(POIToForce, 2);
        // End:0x88B
        if(POIToForce.bHidePlayerWeapon && (EvilWeap_Base(MyEvilPawn.Weapon) != none) || EvilWeap_Base(MyEvilPawn.WeaponLeft) != none)
        {
            // End:0x57B
            if(MyEvilPawn.IsSprinting)
            {
                SetSprint(false);
                EvilWeap_Base(MyEvilPawn.Weapon).StopSprint();
                // End:0x578
                if(MyEvilPawn.WeaponLeft != none)
                {
                    EvilWeap_Base(MyEvilPawn.WeaponLeft).StopSprint();
                }                
            }
            else
            {
                // End:0x847
                if(EvilWeap_Base(MyEvilPawn.Weapon).IsInState('Jumping') || EvilWeap_Base(MyEvilPawn.Weapon).IsInState('MeleeKick'))
                {
                    Temp = EvilWeap_Base(MyEvilPawn.Weapon).JumpSpreadState;
                    EvilWeap_Base(MyEvilPawn.Weapon).JumpSpreadState = false;
                    EvilWeap_Base(MyEvilPawn.Weapon).GotoState('Active');
                    EvilWeap_Base(MyEvilPawn.Weapon).JumpSpreadState = Temp;
                    // End:0x847
                    if(MyEvilPawn.WeaponLeft != none)
                    {
                        Temp = EvilWeap_Base(MyEvilPawn.WeaponLeft).JumpSpreadState;
                        EvilWeap_Base(MyEvilPawn.WeaponLeft).JumpSpreadState = false;
                        EvilWeap_Base(MyEvilPawn.WeaponLeft).GotoState('Active');
                        EvilWeap_Base(MyEvilPawn.WeaponLeft).JumpSpreadState = Temp;
                    }
                }
            }
            MyEvilPawn.QuickHideCurrentWeapon();
            MyEvilPawn.QuickHideCurrentWeapon(,,, true);
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

final function bool StopForceLookAtPointOfInterest(optional bool bUserInstigated)
{
    local EvilPointOfInterest POI;

    ClearTimer('ForceLookDurationExpired');
    // End:0x11D
    if(bLookingAtPointOfInterest)
    {
        POI = EvilPointOfInterest(CameraLookAtFocusActor);
        // End:0x62
        if(POI != none)
        {
            ServerFirePOIActionOutputLink(POI, 3);
        }
        bLookingAtPointOfInterest = false;
        ClearFocus(false);
        // End:0x8B
        if(bUserInstigated == true)
        {
        }
        EvilPlayerInput(PlayerInput).SetButtonFilter(false);
        // End:0x11B
        if(POI.bHidePlayerWeapon)
        {
            MyEvilPawn.EndQuickHideCurrentWeapon();
            MyEvilPawn.EndQuickHideCurrentWeapon(,,, true);
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

reliable server final function ServerFirePOIActionOutputLink(EvilPointOfInterest POI, int POIOutputType)
{
    // End:0xB8
    if((POI != none) && POI.POIAction != none)
    {
        POI.POIAction.ActivateOutputLink(POIOutputType);
        // End:0xB8
        if(POIOutputType == 3)
        {
            POI.POIAction.POI_bEnabled = false;
        }
    }
    //return;    
}

final simulated function bool IsHoldingPOIButton(optional bool bRaw)
{
    return PlayerInput.IsA('EvilPlayerInput') && EvilPlayerInput(PlayerInput).IsButtonActive(9, bRaw);
    //return ReturnValue;    
}

reliable client simulated function ClientShowComboNotification(EvilComboDef CD)
{
    //return;    
}

reliable client singular simulated function ClientSetButtonFilter(bool newEnabled, optional EvilTypes.EGameButtons except = 25)
{
    SetButtonFilter(newEnabled, except);
    //return;    
}

simulated function SetButtonFilter(bool newEnabled, optional EvilTypes.EGameButtons except = 25)
{
    // End:0x5C
    if(EvilPlayerInput(PlayerInput) != none)
    {
        EvilPlayerInput(PlayerInput).super(EvilPlayerController).SetButtonFilter(newEnabled, except);        
    }
    else
    {
        ClientSetButtonFilter(newEnabled, except);
    }
    //return;    
}

function NotifyPossibleInputHijack(EvilTypes.ECombatActionType CAT, EvilPawn Target, float Distance, float TimeOut)
{
    //return;    
}

function InitPlayerReplicationInfo()
{
    super(Controller).InitPlayerReplicationInfo();
    EvilPlayerReplicationInfo(PlayerReplicationInfo).JoinServerTime = WorldInfo.TimeSeconds;
    //return;    
}

simulated event NotifyProjectileFire(Projectile Proj)
{
    //return;    
}

simulated event NotifyProjectileExplode(Projectile Proj)
{
    //return;    
}

simulated event NotifyWeaponZooming(bool ZoomIn)
{
    // End:0x74
    if(EvilSkelControlLimb(MyEvilPawn.LeftHandIK) != none)
    {
        EvilSkelControlLimb(MyEvilPawn.LeftHandIK).OnIKStatusUpdate(ZoomIn);
    }
    // End:0xE8
    if(EvilSkelControlLimb(MyEvilPawn.RightHandIK) != none)
    {
        EvilSkelControlLimb(MyEvilPawn.RightHandIK).OnIKStatusUpdate(ZoomIn);
    }
    //return;    
}

reliable client simulated function ClientPlayLowHealthAmbient()
{
    // End:0x30
    if(LowHealthAmbientComponent == none)
    {
        LowHealthAmbientComponent = GetPooledAudioComponent(LowHealthAmbientCue, self, true, false);
    }
    // End:0x84
    if((LowHealthAmbientComponent != none) && !LowHealthAmbientComponent.IsPlaying())
    {
        LowHealthAmbientComponent.Play();
    }
    //return;    
}

reliable client simulated function ClientStopLowHealthAmbient()
{
    // End:0x43
    if(LowHealthAmbientComponent != none)
    {
        LowHealthAmbientComponent.FadeOut(2.0000000, 0.0000000);
        LowHealthAmbientComponent = none;
    }
    //return;    
}

simulated function bool IsLowHealthAmbientPlaying()
{
    return (LowHealthAmbientComponent != none) && LowHealthAmbientComponent.IsPlaying();
    //return ReturnValue;    
}

event MayFall(bool bFloor, Vector FloorNormal)
{
    local Vector HitLocation, HitNormal;

    // End:0x128
    if(((MyEvilPawn != none) && MyEvilPawn.ClampedBase != none) && !TraceComponent(HitLocation, HitNormal, MyEvilPawn.ClampedBase.CollisionComponent, Pawn.Location - vect(0.0000000, 0.0000000, 1000.0000000), Pawn.Location, Pawn.GetCollisionExtent() * vect(0.5000000, 0.5000000, 1.0000000)))
    {
        Pawn.bCanJump = false;
    }
    //return;    
}

reliable client simulated function SetCaptionComponentVisibility(EvilTouchPickUp_Base Target, bool bHide)
{
    local int I;

    I = EvilGFxHudWrapper(myHUD).PostRenderedComponents.Find(Target.CaptionComponent);    
    // End:0xB5
    if(!bHide)
    {
        EvilCaptionComponent(EvilGFxHudWrapper(myHUD).PostRenderedComponents[I]).Show();        
    }
    else
    {
        EvilCaptionComponent(EvilGFxHudWrapper(myHUD).PostRenderedComponents[I]).Hide();
    }
    //return;    
}

function bool isPlayerSliding()
{
    return false;
    //return ReturnValue;    
}

function StartSliding(Vector Dir, float Vel)
{
    Pawn.SetPhysics(2);
    // End:0x15E
    if(!IsInState('PlayerSliding'))
    {
        GotoState('PlayerSliding');
        Pawn.ZeroMovementVariables();
        Pawn.SetMovementPhysics();
        SlidingDirection = Dir;
        SlidingVelocity = Vel;
        PawnLastPos = Pawn.Location;
        TurnLag = 0.0000000;
        SlidingTurn = 0.0000000;
        SlidingRotation = Rotator(SlidingDirection);
        SetSprint(true);
        bDoubleJump = true;
        ProcessMove(1.0000000, Normal(SlidingDirection), PlayerInput.CheckForDoubleClickMove(0.1000000), rot(0, 0, 0));        
    }
    else
    {
        // End:0x1B4
        if((Dir != SlidingDirection) || Vel != SlidingVelocity)
        {
            SlidingVelocity = Vel;
            SlidingDirection = Dir;
        }
    }
    //return;    
}

function StopSliding()
{
    // End:0x2D
    if(IsInState('PlayerSliding'))
    {
        GotoState('PlayerWalking');
        SlidingVelocity = 0.0000000;
    }
    //return;    
}

function ForcedMoveLocation(Actor InLocationActor, float InVelocity)
{
    // End:0x11
    if(InLocationActor == none)
    {
        return;
    }
    ForcedMoveLocationActor = InLocationActor;
    ForcedMoveVelocity = InVelocity;
    PushState('ForcedMove');
    //return;    
}

exec function StartFire(optional byte FireModeNum)
{
    // End:0x3B
    if(WorldInfo.Pauser == PlayerReplicationInfo)
    {
        SetPause(false);
        return;
    }
    // End:0xB8
    if(((Pawn != none) && !bCinematicMode || bFiringOnZipLine) && !WorldInfo.bPlayersOnly)
    {
        Pawn.StartFire(FireModeNum);
    }
    //return;    
}

function NotifyChangedWeapon(Weapon PrevWeapon, Weapon NewWeapon)
{
    EvilPawn(Pawn).NotifyChangedWeapon(PrevWeapon, NewWeapon);
    //return;    
}

simulated function EvilPawn GetPlayerPawn()
{
    local EvilPlayer_interface EPI;

    EPI = GetPlayer();
    // End:0x55
    if(NotEqual_InterfaceInterface(EPI, EvilPlayer_interface(none)))
    {
        return EPI.GetPlayerPawn();
    }
    return none;
    //return ReturnValue;    
}

simulated function EvilPlayer_interface GetPlayer()
{
    // End:0x3F
    if(NotEqual_InterfaceInterface(EvilPlayer_interface(MyEvilPawn), EvilPlayer_interface(none)))
    {
        return EvilPlayer_interface(MyEvilPawn);        
    }
    else
    {
        // End:0xB7
        if((Vehicle(Pawn) != none) && Vehicle(Pawn).Driver != none)
        {
            return EvilPlayer_interface(Vehicle(Pawn).Driver);
        }
    }
    return none;
    //return ReturnValue;    
}

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
{
    local int iDam;
    local Vector HitDir;

    HitDir = HitLocation - Pawn.Location;
    // End:0x67
    if(int(GetTeamNum()) == int(InstigatedBy.GetTeamNum()))
    {
        return;
    }
    // End:0xE5
    if(EvilAIController(InstigatedBy) != none)
    {
        HitDir = EvilAIController(InstigatedBy).Pawn.Location - Pawn.Location;
    }
    super(PlayerController).NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
    iDam = Clamp(Damage, 0, 250);
    // End:0x18A
    if(((iDam > 0) || bGodMode) && Pawn != none)
    {
        ClientPlayTakeHit(HitDir, byte(iDam), DamageType);
    }
    //return;    
}

exec function ShowPlayer()
{
    local EvilWeap_Base WP;

    WP = EvilWeap_Base(MyEvilPawn.Weapon);
    // End:0xAB
    if(WP != none)
    {
        WP.GetArmMeshComponent().SetOwnerNoSee(false);
        WP.Mesh.SetOwnerNoSee(false);
    }
    WP = EvilWeap_Base(MyEvilPawn.WeaponLeft);
    // End:0x156
    if(WP != none)
    {
        WP.GetArmMeshComponent().SetOwnerNoSee(false);
        WP.Mesh.SetOwnerNoSee(false);
    }
    //return;    
}

exec function HidePlayer()
{
    local EvilWeap_Base WP;

    WP = EvilWeap_Base(MyEvilPawn.Weapon);
    // End:0xAB
    if(WP != none)
    {
        WP.GetArmMeshComponent().SetOwnerNoSee(true);
        WP.Mesh.SetOwnerNoSee(true);
    }
    WP = EvilWeap_Base(MyEvilPawn.WeaponLeft);
    // End:0x156
    if(WP != none)
    {
        WP.GetArmMeshComponent().SetOwnerNoSee(true);
        WP.Mesh.SetOwnerNoSee(true);
    }
    //return;    
}

// Export UEvilPlayerController::execClientUpdateLevelStreamingStatus(FFrame&, void* const)
reliable client native simulated function ClientUpdateLevelStreamingStatus(name PackageName, bool bNewShouldBeLoaded, bool bNewShouldBeVisible, bool bNewShouldBlockOnLoad);

reliable client simulated event ClientLoadCheckpoint(Vector CheckpointLocation)
{
    local EvilEngine Engine;

    Engine = EvilEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0x8A
    if(Engine != none)
    {
        Engine.PendingCheckpointAction = 1;
        Engine.PendingCheckpointLocation = CheckpointLocation;
    }
    //return;    
}

exec function SaveCheckpoint(optional name InCheckpointName, optional bool bIsLevelStart)
{
    local EvilEngine Engine;
    local EvilLocalPlayer LP;

    // End:0x182
    if((((IsPrimaryPlayer() && Pawn != none) && Pawn.Health > 0) && int(Role) == int(ROLE_Authority)) && (WorldInfo.TimeSeconds - LastCheckpointSaveTime) > 0.5000000)
    {
        EvilGame(WorldInfo.Game).DebugMsg(CheckpointSavedString);
        Engine = EvilEngine(Class'Engine.Engine'.static.GetEngine());
        // End:0x182
        if(Engine != none)
        {
            LP = EvilLocalPlayer(Player);
            // End:0x182
            if(LP != none)
            {
                Engine.bShouldWriteCheckpointToDisk = true;
                SaveCheckpointWorker(bIsLevelStart, InCheckpointName);
            }
        }
    }
    //return;    
}

protected final function SaveCheckpointWorker(bool bIsLevelStart, optional name InCheckpointName)
{
    local EvilEngine Engine;
    local EvilPlayerController PC;
    local LocalPlayer LP;

    Engine = EvilEngine(Class'Engine.Engine'.static.GetEngine());
    LastCheckpointSaveTime = WorldInfo.TimeSeconds;
    LastCheckpointSaveName = InCheckpointName;
    Engine.PendingCheckpointAction = 2;
    Engine.PendingCheckpointLocation = ((MyEvilPawn != none) ? MyEvilPawn.Location : Location);
    Engine.bPendingCheckpointIsLevelStart = bIsLevelStart;
    // End:0x31D
    foreach WorldInfo.AllControllers(Class'EvilPlayerController', PC)
    {
        LP = LocalPlayer(PC.Player);
        // End:0x1A6
        if(LP == none)
        {
            PC.ClientNotifySavingCheckpoint();
            // End:0x31C
            continue;
        }
        // End:0x2FD
        if(PC.IsPrimaryPlayer())
        {
            // End:0x2DB
            if(Engine.bShouldWriteCheckpointToDisk)
            {
                // End:0x2D8
                if((((LP != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && int(OnlineSub.PlayerInterface.GetLoginStatus(byte(LP.ControllerId))) > int(0))
                {
                    Engine.CheckpointClass.static.ShowSavingContentWarning();
                }                
            }
            else
            {
                PC.ClientNotifySavingCheckpoint();
            }
            // End:0x31C
            continue;
        }
        PC.ClientNotifySavingCheckpoint();        
    }    
    //return;    
}

reliable client simulated function ClientNotifySavingCheckpoint()
{
    //return;    
}

reliable client simulated function ClosePauseMenu()
{
    //return;    
}

exec function LoadCheckpoint(optional name InCheckpointName)
{
    local EvilEngine Engine;
    local EvilPlayerController PC;
    local Actor A;
    local editinline EvilCaptionComponent CC;

    // End:0x385
    if((int(Role) == int(ROLE_Authority)) && WorldInfo.NextURL == "")
    {
        // End:0xB2
        foreach WorldInfo.AllControllers(Class'EvilPlayerController', PC)
        {
            PC.ClosePauseMenu();
            PC.ClientClearFocus(false, true, true);            
        }        
        // End:0x122
        foreach AllActors(Class'Engine.Actor', A)
        {
            // End:0x120
            foreach A.ComponentList(Class'EvilCaptionComponent', CC)
            {
                CC.OnHUDReset();                
            }                        
        }        
        LastCheckpointSaveName = InCheckpointName;
        Engine = EvilEngine(Class'Engine.Engine'.static.GetEngine());
        // End:0x385
        if(Engine != none)
        {
            // End:0x312
            if((Engine.CurrentCheckpoint != none) && bool(Engine.CurrentCheckpoint.bIsLevelStart))
            {
                ClientShowLevelLoadingMovieByChapter(int(Engine.CurrentCheckpoint.HeaderData.ChapterNum));
                WorldInfo.ServerTravel((((("ADVGame_P?game=ADVGame." $ "ADVGameSP") $ "?loadcheckpoint=0?chapter=") $ string(Engine.CurrentCheckpoint.HeaderData.ChapterNum)) $ "?gamepad=") $ ((PlayerInput.bUsingGamepad) ? "1" : "0"));                
            }
            else
            {
                Engine.PendingCheckpointAction = 1;
                ClientShowLevelLoadingMovieByChapter(int(Engine.CurrentCheckpoint.HeaderData.ChapterNum));
            }
        }
    }
    //return;    
}

reliable client simulated function ClientSaveAllPlayerData(optional bool bShouldForce, optional bool bSkipCacheUpdate)
{
    local EvilLocalPlayer LP;

    LP = EvilLocalPlayer(Player);
    // End:0xDE
    if(((LP != none) && (WorldInfo.RealTimeSeconds - LP.LastSaveTime) >= TimeBetweenSaves) || bShouldForce)
    {
        LP.LastSaveTime = WorldInfo.RealTimeSeconds;
        SaveProfile();
        SavePersistentData();        
    }
    // End:0x103
    if(!bSkipCacheUpdate)
    {
        UpdateLocalCacheOfProfileSettings();
        bProfileSettingsUpdated = false;
    }
    //return;    
}

exec function UpdateLocalCacheOfProfileSettings()
{
    //return;    
}

simulated function SaveProfile()
{
    //return;    
}

function NotifyCheckpointMessageFinished()
{
    // End:0x2E
    if(CheckpointSeqAct != none)
    {
        CheckpointSeqAct.MessageFinished();
    }
    //return;    
}

function NotifyCheckpointSkipped()
{
    // End:0x2E
    if(CheckpointSeqAct != none)
    {
        CheckpointSeqAct.MessageFinished();
    }
    //return;    
}

protected function SavePersistentData()
{
    //return;    
}

function OnDestroyDestructibleObject(EvilDestructibleObject O)
{
    //return;    
}

function OnDestroyDynamicDestructibleObject(EvilDynamicDestructibleObject O)
{
    //return;    
}

function NotifyEnteredRailCar(EvilRailCar_Base Railcar)
{
    RailCarRotation = Rotation;
    //return;    
}

function NotifyLeftRailCar(EvilRailCar_Base Railcar)
{
    RailCarRotation.Yaw = Rotation.Yaw;
    SetRotation(RailCarRotation);
    //return;    
}

reliable client simulated event ClientShowLevelLoadingMovieByChapter(int ChapterNo)
{
    local string MapName;
    local name ChapterName;
    local UTUIDataProvider_MapInfo MapInfo;
    local array<UDKUIResourceDataProvider> ProviderList;
    local int I;

    // End:0x70
    if((Class'EvilTypesNative'.default.ChapterLevelNames.Length > ChapterNo) && ChapterNo >= 0)
    {
        ChapterName = Class'EvilTypesNative'.default.ChapterLevelNames[ChapterNo];
    }
    // End:0x161
    if(ChapterName != name(""))
    {
        Class'UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'UTUIDataProvider_MapInfo', ProviderList);
        I = 0;
        J0xBE:

        // End:0x161 [Loop If]
        if(I < ProviderList.Length)
        {
            MapInfo = UTUIDataProvider_MapInfo(ProviderList[I]);
            // End:0x153
            if(MapInfo.Name == ChapterName)
            {
                MapName = MapInfo.MapName;
                // [Explicit Break]
                goto J0x161;
            }
            I++;
            // [Loop Continue]
            goto J0xBE;
        }
    }
    J0x161:

    ClientShowLevelLoadingMovie(MapName, "");
    //return;    
}

reliable client simulated event ClientShowLevelLoadingMovie(string MapName, string MovieName, optional bool bWaitForInput = false)
{
    Class'Engine.Engine'.static.PlayLoadMapMovie(MapName, MovieName, bWaitForInput);
    //return;    
}

reliable client simulated event ClientStopLevelLoadingMovie()
{
    Class'Engine.Engine'.static.StopMovie(true);
    //return;    
}

reliable client final simulated function ClientResetObjectPool(optional bool bClearActive)
{
    local int I;

    // End:0x63
    if(WorldInfo.MyEmitterPool != none)
    {
        WorldInfo.MyEmitterPool.ClearPoolComponents(bClearActive);
    }
    // End:0x1D2
    if(WorldInfo.MyDecalManager != none)
    {
        I = 0;
        J0x92:

        // End:0x166 [Loop If]
        if(I < WorldInfo.MyDecalManager.ActiveDecals.Length)
        {
            WorldInfo.MyDecalManager.DecalFinished(WorldInfo.MyDecalManager.ActiveDecals[I].Decal);
            I++;
            // [Loop Continue]
            goto J0x92;
        }
        WorldInfo.MyDecalManager.ActiveDecals.Length = 0;
        WorldInfo.MyDecalManager.PoolDecals.Length = 0;
    }
    WorldInfo.ClearObjectPools();
    //return;    
}

reliable client final simulated function ClientCheckpointReset()
{
    local FracturedStaticMeshActor FracActor;
    local EvilPawn P;
    local EvilGFxHudWrapper HUD;

    bCinematicMode = false;
    ClientResetObjectPool(true);
    // End:0x74
    foreach DynamicActors(Class'Engine.FracturedStaticMeshActor', FracActor)
    {
        // End:0x73
        if(!FracActor.bShouldSaveForCheckpoint)
        {
            FracActor.ResetVisibility();
        }        
    }    
    // End:0xCD
    if(WorldInfo.MyFractureManager != none)
    {
        WorldInfo.MyFractureManager.ResetPoolVisibility();
    }
    // End:0x13E
    foreach WorldInfo.AllPawns(Class'EvilPawn', P)
    {
        // End:0x13D
        if(P.bTearOff)
        {
            P.Destroy();
        }        
    }    
    // End:0x17D
    if(Pawn != none)
    {
        // End:0x17D
        if(Pawn.Weapon == none)
        {
            ClientSwitchToBestWeapon();
        }
    }
    ClientStopLevelLoadingMovie();
    ClientFlushLevelStreaming();
    SetTimer(0.5000000, false, 'ServerCheckpointResetComplete');
    HUD = EvilGFxHudWrapper(myHUD);
    // End:0x225
    if(HUD != none)
    {
        HUD.ClearMessages();
        HUD.AddConsoleMessage(CheckpointLoadedString, Class'Engine.LocalMessage', none, 2.0000000);
    }
    //return;    
}

reliable server function ServerCheckpointResetComplete()
{
    local Actor A;
    local Weapon W;

    // End:0x1C4
    if(!IsLocalPlayerController())
    {
        // End:0xDF
        foreach AllActors(Class'Engine.Actor', A)
        {
            // End:0xDE
            if((A.NetUpdateFrequency < 1.0000000) && !A.bOnlyRelevantToOwner)
            {
                A.SetNetUpdateTime(FMin(A.NetUpdateTime, WorldInfo.TimeSeconds + (0.2000000 * FRand())));
            }            
        }        
        // End:0x1C4
        if(Vehicle(Pawn) != none)
        {
            // End:0x155
            if(Pawn.Weapon != none)
            {
                Pawn.Weapon.ClientWeaponSet(false);                
            }
            else
            {
                // End:0x1C3
                foreach Pawn.InvManager.InventoryActors(Class'Engine.Weapon', W)
                {
                    W.ClientWeaponSet(false);
                    // End:0x1C3
                    break;                    
                }                
            }
        }
    }
    //return;    
}

reliable server function ClientToServerSetWeapon3PPReloadRateModifier(float InWeapon3PPReloadRateModifier)
{
    // End:0x58
    if(MyEvilPawn != none)
    {
        MyEvilPawn.Weapon3PPReloadRateModifier = InWeapon3PPReloadRateModifier;
        MyEvilPawn.bForceNetUpdate = true;
    }
    //return;    
}

// Export UEvilPlayerController::execGetCurrentMovieFrame(FFrame&, void* const)
native final function int GetCurrentMovieFrame();

unreliable client simulated function SetAlienFxLight(EvilPlayerController.EAlienFxLight Light, byte R, byte G, byte B, EvilPlayerController.EAlienFxMode Mode, EvilPlayerController.EAlienFxType Type, float Duration, optional int repeatTimes = 1)
{
    //return;    
}

reliable client simulated function ClientPlayOnFacialComponent(EvilPawn EP, SoundCue SoundCue, optional bool TryToUseFaceFX = false)
{
    // End:0x57
    if((EP != none) && SoundCue != none)
    {
        EP.PlayOnFacialComponent(SoundCue, TryToUseFaceFX);
    }
    //return;    
}

exec function ToggleInventoryMap()
{
    //return;    
}

function SetPuzzleDifficultyLevel(EvilTypesNative.EDifficultyLevel DifficultyIdx)
{
    //return;    
}

function SetFightDifficultyLevel(EvilTypesNative.EDifficultyLevel DifficultyIdx)
{
    //return;    
}

function EvilTypesNative.EDifficultyLevel GetPuzzleDifficultyLevel()
{
    return 1;
    //return ReturnValue;    
}

function EvilTypesNative.EDifficultyLevel GetFightDifficultyLevel()
{
    return 1;
    //return ReturnValue;    
}

function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> damageTyp)
{
    super(Controller).NotifyKilled(Killer, Killed, KilledPawn, damageTyp);
    // End:0x61
    if(Killer == self)
    {
        MyEvilPawn.PlayKilledEnemy(1.0000000);
    }
    //return;    
}

exec function DebugShowChapterLevelNames()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x46 [Loop If]
    if(I < Class'EvilTypesNative'.default.ChapterLevelNames.Length)
    {
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

function GetPawnInventoryElements(out array<string> Inventory)
{
    //return;    
}

function bool HasPreorder()
{
    //return ReturnValue;    
}

function bool GetPreorderWeaponSelectedFromProfile()
{
    //return ReturnValue;    
}

reliable client simulated function SetAudioGroupParams(float VolumeMultiplier, optional name NewSoundMode = 'Default')
{
    //return;    
}

function SetUsableTriggerCaptionRefreshing(bool InState)
{
    // End:0x3C
    if(InState)
    {
        // End:0x39
        if(!IsTimerActive('CheckAllWeaponsForAmmo_T'))
        {
            SetTimer(1.0000000, true, 'CheckAllWeaponsForAmmo_T');
        }        
    }
    else
    {
        // End:0x67
        if(IsTimerActive('CheckAllWeaponsForAmmo_T'))
        {
            ClearTimer('CheckAllWeaponsForAmmo_T');
        }
    }
    //return;    
}

function CheckAllWeaponsForAmmo_T()
{
    local array<EvilWeap_Base> Weapons;
    local EvilWeap_Base Weap;

    // End:0xF4
    if((UsableTrigger != none) && ClassIsChildOf(UsableTrigger.Owner.Class, Class'EvilTouchPickUp_AmmoAll'))
    {
        EvilInventoryManager(MyEvilPawn.InvManager).GetWeaponList(Weapons);
        // End:0xF3
        foreach Weapons(Weap)
        {
            // End:0xF2
            if(!Weap.AmmoMaxed(0))
            {
                bShowAmmoBoxCaption = true;
                SetUsableTriggerCaptionRefreshing(false);                
            }
            else
            {                
            }
        }        
    }
    //return;    
}

state WeaponSetPosMode
{
    ignores MeleeKick, Melee, NextWeapon, PrevWeapon, GrenadeThrow, GrenadeRelease, 
	    HideInGameStatsScreen;

    function PlayerMove(float DeltaTime)
    {
        local EvilWeap_Base Weap;
        local bool bZooming;

        Weap = EvilWeap_Base(MyEvilPawn.Weapon);
        // End:0x42
        if(Weap == none)
        {
            return;
        }
        bZooming = int(EvilWeap_Base(MyEvilPawn.Weapon).GetZoomedState()) == int(3);
        // End:0x190
        if(PlayerInput.aBaseY >= 0.3000000)
        {
            // End:0x14E
            if(bZooming)
            {
                Weap.DesiredMeshTranslation.Z += (DeltaTime * float(2));
                Weap.ZoomedMeshTranslation.Z += (DeltaTime * float(2));                
            }
            else
            {
                Weap.PlayerViewOffset.Z += (DeltaTime * float(2));
            }
        }
        // End:0x28E
        if(PlayerInput.aBaseY <= -0.3000000)
        {
            // End:0x24C
            if(bZooming)
            {
                Weap.DesiredMeshTranslation.Z -= (DeltaTime * float(2));
                Weap.ZoomedMeshTranslation.Z -= (DeltaTime * float(2));                
            }
            else
            {
                Weap.PlayerViewOffset.Z -= (DeltaTime * float(2));
            }
        }
        // End:0x38C
        if(PlayerInput.aStrafe <= -0.3000000)
        {
            // End:0x34A
            if(bZooming)
            {
                Weap.DesiredMeshTranslation.Y -= (DeltaTime * float(2));
                Weap.ZoomedMeshTranslation.Y -= (DeltaTime * float(2));                
            }
            else
            {
                Weap.PlayerViewOffset.Y -= (DeltaTime * float(2));
            }
        }
        // End:0x48A
        if(PlayerInput.aStrafe >= 0.3000000)
        {
            // End:0x448
            if(bZooming)
            {
                Weap.DesiredMeshTranslation.Y += (DeltaTime * float(2));
                Weap.ZoomedMeshTranslation.Y += (DeltaTime * float(2));                
            }
            else
            {
                Weap.PlayerViewOffset.Y += (DeltaTime * float(2));
            }
        }
        // End:0x5AF
        if(PlayerInput.aLookUp >= 0.3000000)
        {
            // End:0x560
            if(bZooming)
            {
                Weap.DesiredMeshRotation.Pitch += FCeil(DeltaTime * float(500));
                Weap.ZoomedMeshRotation.Pitch += FCeil(DeltaTime * float(500));                
            }
            else
            {
                Weap.PlayerRotationOffset.Pitch += FCeil(DeltaTime * float(500));
            }
        }
        // End:0x6D4
        if(PlayerInput.aLookUp <= -0.3000000)
        {
            // End:0x685
            if(bZooming)
            {
                Weap.DesiredMeshRotation.Pitch -= FCeil(DeltaTime * float(500));
                Weap.ZoomedMeshRotation.Pitch -= FCeil(DeltaTime * float(500));                
            }
            else
            {
                Weap.PlayerRotationOffset.Pitch -= FCeil(DeltaTime * float(500));
            }
        }
        // End:0x7F9
        if(PlayerInput.aTurn <= -0.3000000)
        {
            // End:0x7AA
            if(bZooming)
            {
                Weap.DesiredMeshRotation.Yaw -= FCeil(DeltaTime * float(500));
                Weap.ZoomedMeshRotation.Yaw -= FCeil(DeltaTime * float(500));                
            }
            else
            {
                Weap.PlayerRotationOffset.Yaw -= FCeil(DeltaTime * float(500));
            }
        }
        // End:0x91E
        if(PlayerInput.aTurn >= 0.3000000)
        {
            // End:0x8CF
            if(bZooming)
            {
                Weap.DesiredMeshRotation.Yaw += FCeil(DeltaTime * float(500));
                Weap.ZoomedMeshRotation.Yaw += FCeil(DeltaTime * float(500));                
            }
            else
            {
                Weap.PlayerRotationOffset.Yaw += FCeil(DeltaTime * float(500));
            }
        }
        //return;        
    }

    exec function DEMOToggleHelp()
    {
        ShowInGameStatsScreen();
        //return;        
    }

    function ToggleInventoryMap()
    {
        local string CpyStr, nl;
        local EvilWeap_Base Weap;

        Weap = EvilWeap_Base(MyEvilPawn.Weapon);
        // End:0x42
        if(Weap == none)
        {
            return;
        }
        nl = Chr(13) $ Chr(10);
        CpyStr = (((((("PlayerViewOffset=(X=" $ string(Weap.PlayerViewOffset.X)) $ ",Y=") $ string(Weap.PlayerViewOffset.Y)) $ ",Z=") $ string(Weap.PlayerViewOffset.Z)) $ ")") $ nl;        
        CpyStr $= ((((((("PlayerRotationOffset=(Yaw=" $ string(Weap.PlayerRotationOffset.Yaw)) $ ",Pitch=") $ string(Weap.PlayerRotationOffset.Pitch)) $ ",Roll=") $ string(Weap.PlayerRotationOffset.Roll)) $ ")") $ nl);        
        CpyStr $= ((((((("ZoomedMeshTranslation=(X=" $ string(Weap.ZoomedMeshTranslation.X)) $ ",Y=") $ string(Weap.ZoomedMeshTranslation.Y)) $ ",Z=") $ string(Weap.ZoomedMeshTranslation.Z)) $ ")") $ nl);        
        CpyStr $= ((((((("ZoomedMeshRotation=(Yaw=" $ string(Weap.ZoomedMeshRotation.Yaw)) $ ",Pitch=") $ string(Weap.ZoomedMeshRotation.Pitch)) $ ",Roll=") $ string(Weap.ZoomedMeshRotation.Roll)) $ ")") $ nl);        
        CpyStr $= (("ZoomedMeshScale=" $ string(Weap.ZoomedMeshScale)) $ nl);        
        CpyStr $= ((nl $ "FOV ") $ string(UDKSkeletalMeshComponent(Weap.Mesh).FOV));        
        CpyStr $= ((nl $ "Scale ") $ string(Weap.Mesh.Scale));
        CopyToClipboard(CpyStr);
        //return;        
    }

    function PauseGame(optional delegate<CanUnpause> CanUnpauseDelegate = CanUnpause)
    {
        local EvilWeap_Base Weap;

        Weap = EvilWeap_Base(MyEvilPawn.Weapon);
        // End:0x7D
        if((Weap == none) || Weap.CustomAnimNode == none)
        {
            return;
        }
        // End:0x135
        if(Weap.CustomAnimNode.GetCustomAnimNodeSeq().bPlaying)
        {
            Weap.CustomAnimNode.StopAnim();
            Weap.CustomArmAnimNode.StopAnim();            
        }
        else
        {
            Weap.CustomAnimNode.ReplayAnim();
            Weap.CustomArmAnimNode.ReplayAnim();
        }
        //return;        
    }

    exec function SetSprint(bool SprintState)
    {
        local EvilWeap_Base Weap;
        local bool bZooming;

        Weap = EvilWeap_Base(MyEvilPawn.Weapon);
        // End:0x42
        if(Weap == none)
        {
            return;
        }
        bZooming = int(EvilWeap_Base(MyEvilPawn.Weapon).GetZoomedState()) == int(3);
        UDKSkeletalMeshComponent(Weap.Mesh).SetFOV(UDKSkeletalMeshComponent(Weap.Mesh).default.FOV);
        MyEvilPawn.ArmsMesh[0].SetFOV(UDKSkeletalMeshComponent(Weap.Mesh).default.FOV);
        Weap.PlayerViewOffset = Weap.default.PlayerViewOffset;
        Weap.PlayerRotationOffset = Weap.default.PlayerRotationOffset;
        Weap.ZoomedMeshTranslation = Weap.default.ZoomedMeshTranslation;
        Weap.ZoomedMeshRotation = Weap.default.ZoomedMeshRotation;
        Weap.ZoomedMeshScale = Weap.default.ZoomedMeshScale;
        // End:0x375
        if(bZooming)
        {
            Weap.DesiredMeshTranslation = Weap.default.ZoomedMeshTranslation;
            Weap.DesiredMeshRotation = Weap.default.ZoomedMeshRotation;
            Weap.DesiredMeshScale = Weap.default.ZoomedMeshScale;            
        }
        else
        {
            Weap.DesiredMeshScale = Weap.Mesh.default.Scale;
        }
        //return;        
    }

    event PlayerTick(float DeltaTime)
    {
        local EvilWeap_Base Weap;
        local bool bZooming;

        global.PlayerTick(DeltaTime);
        Weap = EvilWeap_Base(MyEvilPawn.Weapon);
        // End:0x55
        if(Weap == none)
        {
            return;
        }
        bZooming = int(EvilWeap_Base(MyEvilPawn.Weapon).GetZoomedState()) == int(3);
        // End:0x1FA
        if(int(EvilPlayerInput(PlayerInput).InputButtonDataList[7].RawActive) == int(1))
        {
            UDKSkeletalMeshComponent(Weap.Mesh).SetFOV(UDKSkeletalMeshComponent(Weap.Mesh).FOV - (DeltaTime * float(10)));
            MyEvilPawn.ArmsMesh[0].SetFOV(UDKSkeletalMeshComponent(Weap.Mesh).FOV - (DeltaTime * float(10)));
        }
        // End:0x34F
        if(int(EvilPlayerInput(PlayerInput).InputButtonDataList[9].RawActive) == int(1))
        {
            UDKSkeletalMeshComponent(Weap.Mesh).SetFOV(UDKSkeletalMeshComponent(Weap.Mesh).FOV + (DeltaTime * float(10)));
            MyEvilPawn.ArmsMesh[0].SetFOV(UDKSkeletalMeshComponent(Weap.Mesh).FOV + (DeltaTime * float(10)));
        }
        // End:0x46D
        if(int(EvilPlayerInput(PlayerInput).InputButtonDataList[10].RawActive) == int(1))
        {
            // End:0x42B
            if(bZooming)
            {
                Weap.DesiredMeshTranslation.X += (DeltaTime * float(3));
                Weap.ZoomedMeshTranslation.X += (DeltaTime * float(3));                
            }
            else
            {
                Weap.PlayerViewOffset.X += (DeltaTime * float(3));
            }
        }
        // End:0x58B
        if(int(EvilPlayerInput(PlayerInput).InputButtonDataList[12].RawActive) == int(1))
        {
            // End:0x549
            if(bZooming)
            {
                Weap.DesiredMeshTranslation.X -= (DeltaTime * float(3));
                Weap.ZoomedMeshTranslation.X -= (DeltaTime * float(3));                
            }
            else
            {
                Weap.PlayerViewOffset.X -= (DeltaTime * float(3));
            }
        }
        // End:0x6D0
        if(int(EvilPlayerInput(PlayerInput).InputButtonDataList[11].RawActive) == int(1))
        {
            // End:0x681
            if(bZooming)
            {
                Weap.DesiredMeshRotation.Roll -= FCeil(DeltaTime * float(800));
                Weap.ZoomedMeshRotation.Roll -= FCeil(DeltaTime * float(800));                
            }
            else
            {
                Weap.PlayerRotationOffset.Roll -= FCeil(DeltaTime * float(800));
            }
        }
        // End:0x815
        if(int(EvilPlayerInput(PlayerInput).InputButtonDataList[13].RawActive) == int(1))
        {
            // End:0x7C6
            if(bZooming)
            {
                Weap.DesiredMeshRotation.Roll += FCeil(DeltaTime * float(800));
                Weap.ZoomedMeshRotation.Roll += FCeil(DeltaTime * float(800));                
            }
            else
            {
                Weap.PlayerRotationOffset.Roll += FCeil(DeltaTime * float(800));
            }
        }
        // End:0x8BC
        if(int(EvilPlayerInput(PlayerInput).InputButtonDataList[3].RawActive) == int(1))
        {
            Weap.DesiredMeshScale -= DeltaTime;
            // End:0x8BC
            if(bZooming)
            {
                Weap.ZoomedMeshScale -= DeltaTime;
            }
        }
        // End:0x963
        if(int(EvilPlayerInput(PlayerInput).InputButtonDataList[2].RawActive) == int(1))
        {
            Weap.DesiredMeshScale += DeltaTime;
            // End:0x963
            if(bZooming)
            {
                Weap.ZoomedMeshScale += DeltaTime;
            }
        }
        //return;        
    }
    stop;    
}

state PlayerSliding
{
    ignores Bump;

    function bool isPlayerSliding()
    {
        return true;
        //return ReturnValue;        
    }

    function PlayerMove(float DeltaTime)
    {
        local Vector X, Y, Z, newAccel;
        local float DeltaZ;

        // End:0x20
        if(Pawn == none)
        {
            GotoState('Dead');            
        }
        else
        {
            GetAxes(Rotator(SlidingDirection), X, Y, Z);
            // End:0x14D
            if((PlayerInput.aStrafe != float(0)) && !bSlidingDrop)
            {
                // End:0xCD
                if((PlayerInput.aStrafe > float(0)) && TurnLag < 0.0030000)
                {
                    TurnLag += 0.0000400;                    
                }
                else
                {
                    // End:0x118
                    if((PlayerInput.aStrafe < float(0)) && TurnLag > -0.0030000)
                    {
                        TurnLag -= 0.0000400;
                    }
                }
                SlidingTurn = TurnLag * Abs(PlayerInput.aStrafe);
            }
            // End:0x1FA
            if((PlayerInput.aStrafe == float(0)) && TurnLag != 0.0000000)
            {
                // End:0x1AC
                if(TurnLag > float(0))
                {
                    TurnLag -= 0.0001000;                    
                }
                else
                {
                    TurnLag += 0.0001000;
                }
                // End:0x1E0
                if(Abs(TurnLag) < 0.0010000)
                {
                    TurnLag = 0.0000000;
                }
                SlidingTurn = TurnLag * 1000.0000000;
            }
            DeltaZ = Pawn.Location.Z - PawnLastPos.Z;
            PawnLastPos = Pawn.Location;
            newAccel = (SlidingDirection * 5.0000000) + (Y * SlidingTurn);
            newAccel = Normal(newAccel) * SlidingVelocity;
            // End:0x30B
            if((DeltaZ * 0.5000000) < newAccel.Z)
            {
                bSlidingDrop = true;                
            }
            else
            {
                bSlidingDrop = false;
            }
            UpdateRotation(DeltaTime);
            SetSprint(false);
            bDoubleJump = false;
            SlidingRotation.Pitch += int(PlayerInput.aMouseY);
            SlidingRotation.Yaw += int(PlayerInput.aMouseX);
            ClampRotation(SlidingRotation, Rotator(SlidingDirection), rot(8192, 8192, 0), rot(8192, 8192, 0));
            Pawn.SetViewRotation(SlidingRotation);
            newAccel.Z -= float(10);
            Pawn.MoveSmooth((newAccel * DeltaTime) * float(50));
        }
        //return;        
    }
    stop;    
}

state ForcedMove
{
    function PlayerMove(float DeltaTime)
    {
        UpdateRotation(DeltaTime);
        //return;        
    }

    event PlayerTick(float DeltaTime)
    {
        local Vector realDest, Dist, distXY, Vel;
        local float Epsilon;

        // End:0x11
        if(ForcedMoveLocationActor == none)
        {
            return;
        }
        realDest = ForcedMoveLocationActor.Location + (vect(0.0000000, 0.0000000, 1.0000000) * Pawn.CylinderComponent.CollisionHeight);
        Dist = realDest - Pawn.Location;
        distXY = vect(1.0000000, 1.0000000, 0.0000000) * Dist;
        Epsilon = 5.0000000;
        // End:0x146
        if(VSize(distXY) > Epsilon)
        {
            Vel = Normal(Dist);
            Pawn.Velocity = Vel * ForcedMoveVelocity;            
        }
        else
        {
            Pawn.ZeroMovementVariables();
            Pawn.Move(Dist);
            ForcedMoveLocationActor = none;
            PopState();
        }
        global.PlayerTick(DeltaTime);
        //return;        
    }
    J0x00:
    // End:0x1A [Loop If]
    if(ForcedMoveLocationActor != none)
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x00;
    }
    stop;        
}

state WaitingForPawn
{
    reliable client simulated function ClientRestart(Pawn NewPawn)
    {
        super(UTPlayerController).ClientRestart(NewPawn);
        // End:0x72
        if(bCinematicMode)
        {
            ClientSetCinematicMode(true, bCinemaDisableInputMove, bCinemaDisableInputLook, ((myHUD != none) ? !myHUD.bShowHUD : false));
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    bShowAmmoBoxCaption=true
    // Reference: EvilSceneCaptureHighlightComponent'Default__EvilPlayerController.HighlightComponent'
    begin object name=HighlightComponent class=Class'EvilSceneCaptureHighlightComponent'
    end object
    HighlightSceneCaptureComponent=HighlightComponent
    InteractAimDotAngle=0.9400000
    PointOfInterestLookatInterpSpeed=1.5000000
    PointOfInterestLookatInterpExponent=4.0000000
    bRotateMinimap=true
    // Reference: ForceFeedbackWaveform'Default__EvilPlayerController.ForceFeedbackWaveform7'
    begin object name=ForceFeedbackWaveform7
    end object
    CameraShakeShortWaveForm=ForceFeedbackWaveform7
    // Reference: ForceFeedbackWaveform'Default__EvilPlayerController.ForceFeedbackWaveform8'
    begin object name=ForceFeedbackWaveform8
    end object
    CameraShakeLongWaveForm=ForceFeedbackWaveform8
    DamageCameraAnim[0]=CameraAnim'an_PlayerHit.HitWeapon1'
    DamageCameraAnim[1]=CameraAnim'an_PlayerHit.HitWeapon2'
    bConsolePlayer=false
    CameraClass=Class'EvilPlayerCamera'
    FOVAngle=75.0000000
    DesiredFOV=75.0000000
    DefaultFOV=75.0000000
    InputClass=Class'EvilPlayerInput'
    // Reference: CylinderComponent'Default__EvilPlayerController.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    ForceFeedbackManagerClassName="WinDrv.XnaForceFeedbackManager"
    Components[0]=CollisionCylinder
    Components[1]=HighlightComponent
    CollisionComponent=CollisionCylinder
}