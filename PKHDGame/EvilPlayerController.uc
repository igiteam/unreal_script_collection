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

var Guid MyGuid;
var const bool bRenderHighlightMask;
var bool bLookingAtPointOfInterest;
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
var class<EvilPostProcessManager> PPManagerClass;
var() protected EvilPostProcessManager PPManager;
var class<EvilPlayerHitEffects> HitEffectsClass;
var() protected EvilPlayerHitEffects PlayerHitEffects;
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
var Rotator RailCarRotation;
var CanvasIcon IconFriend;
var CanvasIcon IconEnemy;
//var delegate<ContinueCameraRotation> __ContinueCameraRotation__Delegate;

function ApplyInventoryRecords(const out array<InventoryRecord> Records)
{
    local class<Inventory> InvClass;
    local InventoryRecord InvRecord;
    local Inventory InvItem;
    local bool bFoundActiveWeapon, bFoundActiveLeftWeapon;
    local EvilWeap_Base ActiveWeaponToRestore, ActiveLeftWeaponToRestore;

    Pawn.InvManager.DiscardInventory();
    // End:0x26C
    foreach Records(InvRecord)
    {
        InvClass = class<Inventory>(FindObject(InvRecord.InventoryClassPath, Class'Core.Class'));
        // End:0x9F
        if(InvClass == none)
        {            
        }
        else
        {
            InvItem = Pawn.InvManager.Spawn(InvClass);
            // End:0xFE
            if(InvItem == none)
            {                
            }
            else
            {
                Pawn.InvManager.AddInventory(InvItem, true);
                // End:0x1FD
                if(EvilWeap_Base(InvItem) != none)
                {
                    EvilWeap_Base(InvItem).ApplyCheckpointRecord(InvRecord);
                    // End:0x1C1
                    if(InvRecord.bIsActiveWeapon)
                    {
                        ActiveWeaponToRestore = EvilWeap_Base(InvItem);
                    }
                    // End:0x1FD
                    if(InvRecord.bIsActiveLeftWeapon)
                    {
                        ActiveLeftWeaponToRestore = EvilWeap_Base(InvItem);
                    }
                }
                bFoundActiveWeapon = bFoundActiveWeapon || InvRecord.bIsActiveWeapon;
                bFoundActiveLeftWeapon = bFoundActiveLeftWeapon || InvRecord.bIsActiveLeftWeapon;
            }
        }        
    }    
    // End:0x2F2
    if(bFoundActiveWeapon)
    {
        // End:0x2CA
        if(MyEvilPawn != none)
        {
            MyEvilPawn.SetCurrentWeaponClass(ActiveWeaponToRestore.Class);            
        }
        else
        {
            Pawn.SetActiveWeapon(ActiveWeaponToRestore);
        }
    }
    // End:0x34C
    if(bFoundActiveLeftWeapon)
    {
        // End:0x34C
        if(MyEvilPawn != none)
        {
            MyEvilPawn.SetCurrentWeaponLeftClass(ActiveLeftWeaponToRestore.Class);
        }
    }
    //return;    
}

function OnCheckPoint(SeqAct_Checkpoint Action)
{
    local bool bTeleportOnly;

    bTeleportOnly = Action.InputLinks[2].bHasImpulse;
    // End:0xDC
    if(Action.InputLinks[0].bHasImpulse || bTeleportOnly)
    {
        // End:0xDC
        if(!bTeleportOnly)
        {
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
    GetPPManager().DeactivateAll();
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
    // End:0x11
    if(!IsLocalPlayerController())
    {
        return none;
    }
    // End:0x74
    if(PPManager == none)
    {
        PPManager = Spawn(PPManagerClass, self);
        PPManager.LocalPlayer = LocalPlayer(Player);
    }
    return PPManager;
    //return ReturnValue;    
}

function EvilPlayerHitEffects GetPlayerHitEffects()
{
    // End:0x32
    if(PlayerHitEffects == none)
    {
        PlayerHitEffects = Spawn(HitEffectsClass, self);
    }
    return PlayerHitEffects;
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

exec function PrevWeaponForHand(bool bLeftHand)
{
    // End:0x35
    if((WorldInfo.Pauser != none) || bCinematicMode)
    {
        return;
    }
    // End:0x78
    if(bLeftHand && MyEvilPawn.WeaponLeft == none)
    {
        SwitchToBestWeaponLeft();
        return;        
    }
    else
    {
        // End:0xBA
        if(!bLeftHand && MyEvilPawn.Weapon == none)
        {
            SwitchToBestWeapon();
            return;
        }
    }
    // End:0x12E
    if(EvilInventoryManager(MyEvilPawn.InvManager) != none)
    {
        EvilInventoryManager(MyEvilPawn.InvManager).PrevWeaponForHand(bLeftHand);
    }
    //return;    
}

exec function NextWeaponForHand(bool bLeftHand)
{
    // End:0x35
    if((WorldInfo.Pauser != none) || bCinematicMode)
    {
        return;
    }
    // End:0x78
    if(bLeftHand && MyEvilPawn.WeaponLeft == none)
    {
        SwitchToBestWeaponLeft();
        return;        
    }
    else
    {
        // End:0xBA
        if(!bLeftHand && MyEvilPawn.Weapon == none)
        {
            SwitchToBestWeapon();
            return;
        }
    }
    // End:0x12E
    if(EvilInventoryManager(MyEvilPawn.InvManager) != none)
    {
        EvilInventoryManager(MyEvilPawn.InvManager).NextWeaponForHand(bLeftHand);
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
        MyEvilPawn.DoReload(true);
    }
    //return;    
}

function bool CanShowGameplayObject()
{
    return ((((((MyEvilPawn != none) && !MyEvilPawn.IsRealSprinting()) && !bCinematicMode) && (MyEvilPawn.WeaponLeft != none) || MyEvilPawn.WeaponLeft == none) && !(EvilWeap_Base(MyEvilPawn.Weapon) != none) && EvilWeap_Base(MyEvilPawn.Weapon).IsReloading()) && !(EvilWeap_Base(MyEvilPawn.WeaponLeft) != none) && EvilWeap_Base(MyEvilPawn.WeaponLeft).IsReloading()) && !(EvilWeap_Base(MyEvilPawn.WeaponLeft) != none) && EvilWeap_Base(MyEvilPawn.WeaponLeft).IsInState('WeaponPuttingDown');
    //return ReturnValue;    
}

function bool CanHideGameplayObject()
{
    return (((((((MyEvilPawn != none) && !MyEvilPawn.IsRealSprinting()) && !bCinematicMode) && MyEvilPawn.WeaponLeft != none) && MyEvilPawn.WeaponLeft.Class == MyEvilPawn.EvilInvManager.BlockingClassLeft) && !(EvilWeap_Base(MyEvilPawn.Weapon) != none) && EvilWeap_Base(MyEvilPawn.Weapon).IsReloading()) && !(EvilWeap_Base(MyEvilPawn.WeaponLeft) != none) && EvilWeap_Base(MyEvilPawn.WeaponLeft).IsReloading()) && !(EvilWeap_Base(MyEvilPawn.WeaponLeft) != none) && EvilWeap_Base(MyEvilPawn.WeaponLeft).IsInState('WeaponEquipping');
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
    // End:0x1E1
    if(MyEvilPawn.EvilInvManager.BlockingClassLeft != none)
    {
        MyEvilPawn.SetCurrentWeaponLeftClass(class<EvilWeap_Base>(MyEvilPawn.EvilInvManager.BlockingClassLeft), true);
    }
    // End:0x273
    if((EvilWeap_Base(MyEvilPawn.Weapon) != none) && ClassIsChildOf(MyEvilPawn.Weapon.Class, Class'EvilWeap_MeleeHands'))
    {
        MyEvilPawn.SetCurrentWeaponClass(none, true);
    }
    //return;    
}

exec function HideGameplayObject()
{
    // End:0x3B4
    if(((EvilWeap_Base(MyEvilPawn.Weapon) != none) && !EvilWeap_Base(MyEvilPawn.Weapon).BothHandWeapon) || (MyEvilPawn.Weapon == none) || MyEvilPawn.Weapon.IsA('EvilWeap_MeleeHands'))
    {
        // End:0x28E
        if((MyEvilPawn.SavedWeapon != none) && MyEvilPawn.FindInventoryType(MyEvilPawn.SavedWeapon) != none)
        {
            // End:0x1D5
            if(MyEvilPawn.SavedWeapon.IsA('EvilWeap_MeleeHands'))
            {
                MyEvilPawn.SetCurrentWeaponClass(MyEvilPawn.SavedWeapon);
                MyEvilPawn.SetCurrentWeaponLeftClass(none, true);                
            }
            else
            {
                // End:0x24D
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
            // End:0x34D
            if((MyEvilPawn.Weapon != none) && !MyEvilPawn.Weapon.IsA('EvilWeap_MeleeHands'))
            {
                MyEvilPawn.SetCurrentWeaponLeftClass(EvilWeap_Base(MyEvilPawn.Weapon).OffHandWeaponClass);                
            }
            else
            {
                // End:0x390
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
    MyEvilPawn.SavedWeapon = none;
    MyEvilPawn.SavedWeaponLeft = none;
    //return;    
}

simulated event GetPlayerViewPoint(out Vector POVLocation, out Rotator POVRotation)
{
    local float DeltaTime;
    local UTPawn P;
    local TPOV POV;
    local TViewTarget OutVT;

    P = ((IsLocalPlayerController()) ? UTPawn(CalcViewActor) : none);
    // End:0x171
    if(((((LastCameraTimeStamp == WorldInfo.TimeSeconds) && CalcViewActor == ViewTarget) && CalcViewActor != none) && CalcViewActor.Location == CalcViewActorLocation) && CalcViewActor.Rotation == CalcViewActorRotation)
    {
        // End:0x171
        if((P == none) || (P.EyeHeight == CalcEyeHeight) && P.WalkBob == CalcWalkBob)
        {
            POVLocation = CalcViewLocation;
            POVRotation = CalcViewRotation;
            return;
        }
    }
    DeltaTime = WorldInfo.TimeSeconds - LastCameraTimeStamp;
    LastCameraTimeStamp = WorldInfo.TimeSeconds;
    // End:0x286
    if(CameraActor(ViewTarget) != none)
    {
        // End:0x244
        if((PlayerCamera != none) && PlayerCamera.Class == Class'EvilPlayerCamera')
        {
            PlayerCamera.Destroy();
            PlayerCamera = none;
        }
        // End:0x267
        if(PlayerCamera == none)
        {
            ResetCameraMode();
            SpawnCamera();
        }
        super(PlayerController).GetPlayerViewPoint(POVLocation, POVRotation);        
    }
    else
    {
        // End:0x2E6
        if((PlayerCamera != none) && PlayerCamera.Class != Class'EvilPlayerCamera')
        {
            PlayerCamera.Destroy();
            PlayerCamera = none;
        }
        // End:0x3DF
        if(PlayerCamera == none)
        {
            ResetCameraMode();
            SpawnPlayerCamera();
            // End:0x374
            if(EvilWeap_Base(MyEvilPawn.Weapon) != none)
            {
                EvilWeap_Base(MyEvilPawn.Weapon).RestartIdleAnim(true);
            }
            // End:0x3DF
            if(EvilWeap_Base(MyEvilPawn.WeaponLeft) != none)
            {
                EvilWeap_Base(MyEvilPawn.WeaponLeft).RestartIdleAnim(true);
            }
        }
        // End:0x447
        if(PlayerCamera != none)
        {
            PlayerCamera.SetFOV(FOVAngle);
            PlayerCamera.GetCameraViewPoint(POVLocation, POVRotation);
        }
        // End:0x5B6
        if(ViewTarget != none)
        {
            POVRotation = Rotation;
            // End:0x550
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
            // End:0x5B3
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
    POVRotation = Normalize(POVRotation + ShakeRot);
    POVLocation += (ShakeOffset >> Rotation);
    // End:0x679
    if(CameraEffect != none)
    {
        CameraEffect.UpdateLocation(POVLocation, POVRotation, GetFOVAngle());
    }
    // End:0x6D8
    if(P != none)
    {
        CalcEyeHeight = P.EyeHeight;
        CalcWalkBob = P.WalkBob;
    }
    // End:0x955
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
        // End:0x8C2
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

    UTDamage = class<EvilDmgType_Base>(DamageType);
    // End:0x9F
    if((UTDamage != none) && UTDamage.default.DamageCameraAnim.Length > 0)
    {
        AnimToPlay = UTDamage.default.DamageCameraAnim[Rand(UTDamage.default.DamageCameraAnim.Length)];        
    }
    else
    {
        AnimToPlay = DamageCameraAnim[Rand(DamageCameraAnim.Length)];
    }
    // End:0x187
    if(AnimToPlay != none)
    {
        BlendWeight = FClamp(float(Damage) / 50.0000000, 0.2000000, 1.0000000);
        // End:0x187
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
    //return;    
}

simulated function EvilWeap_Base GetDominantDOFWeapon()
{
    local EvilWeap_Base WP;

    // End:0x11
    if(MyEvilPawn == none)
    {
        return none;
    }
    WP = EvilWeap_Base(MyEvilPawn.WeaponLeft);
    // End:0x7D
    if(WP != none)
    {
        // End:0x7D
        if(WP.ControlDOFWhenOffhand)
        {
            return WP;
        }
    }
    return EvilWeap_Base(MyEvilPawn.Weapon);
    //return ReturnValue;    
}

simulated function DrawHUD(HUD H)
{
    local EvilPawn PP;
    local float XL, YL;
    local Vector WPos;
    local string Key;
    local Vector X, Diff, Loc;
    local Rotator Rot;
    local float FontPosScale;
    local bool bSameTeam;

    super(UTPlayerController).DrawHUD(H);
    // End:0x24
    if(Pawn == none)
    {
        return;
    }
    // End:0x8F9
    if(((WorldInfo.GRI.IsCoopMultiplayerGame() || EvilGameReplicationInfo(WorldInfo.GRI).IsMultiplayerGame()) && int(WorldInfo.NetMode) != int(NM_Standalone)) && int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        GetPlayerViewPoint(Loc, Rot);
        X = Vector(Rot);
        // End:0x8F8
        foreach AllActors(Class'EvilPawn', PP)
        {
            // End:0x16A
            if(EqualEqual_InterfaceInterface(EvilPlayer_interface(PP), EvilPlayer_interface(none)))
            {
                continue;                
            }
            // End:0x1B6
            if(PP.IsLocallyControlled() || PP.PlayerReplicationInfo == none)
            {
                continue;                
            }
            bSameTeam = PP.PlayerReplicationInfo.Team.TeamIndex == PlayerReplicationInfo.Team.TeamIndex;
            Diff = PP.Location - Loc;
            // End:0x297
            if((Normal(X) Dot Normal(Diff)) < 0.7000000)
            {
                continue;                
            }
            H.Canvas.Font = Class'Engine.Engine'.static.GetAdditionalFont(0);
            FontPosScale = ((VSize(Diff) > float(800)) ? 2.3000000 : 1.3000000 + ((VSize(Diff) / float(800)) * float(1)));
            WPos = H.Canvas.Project(PP.Location + ((PP.GetCollisionHeight() * vect(0.0000000, 0.0000000, 1.0000000)) * FontPosScale));
            // End:0x3E8
            if(VSize(Diff) > float(800))
            {
                continue;                                
            }
            else
            {
                Key = PP.PlayerReplicationInfo.PlayerName;
            }
            H.Canvas.StrLen(Key, XL, YL);
            WPos.X = FClamp(WPos.X - (XL / float(2)), 0.0000000, H.Canvas.ClipX - XL);
            WPos.Y = FClamp(WPos.Y, 0.0000000, H.Canvas.ClipY - YL);
            H.Canvas.SetPos(WPos.X, WPos.Y);
            // End:0x763
            if(bSameTeam)
            {
                H.Canvas.DrawColor.R = 100;
                H.Canvas.DrawColor.G = 200;
                H.Canvas.DrawColor.B = 255;
                H.Canvas.DrawColor.A = 255;
                H.Canvas.DrawText(Key);
                // End:0x8F7
                continue;
            }
            // End:0x8F7
            if(FastTrace(PP.Location, Loc))
            {
                H.Canvas.DrawColor.R = 255;
                H.Canvas.DrawColor.G = 150;
                H.Canvas.DrawColor.B = 100;
                H.Canvas.DrawColor.A = 255;
                H.Canvas.DrawText(Key);
            }            
        }        
    }
    //return;    
}

reliable client simulated function ClientSetCinematicMode(bool bInCinematicMode, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsHUD)
{
    local Actor A;
    local editinline EvilCaptionComponent CC;

    super(PlayerController).ClientSetCinematicMode(bInCinematicMode, bAffectsMovement, bAffectsTurning, bAffectsHUD);
    // End:0xAC
    if(bCinematicMode)
    {
        GetPPManager().DeactivateAll();
        LocalPlayer(Player).ClearPostProcessSettingsOverride(0.0000000);
        GetPPManager().Reset();
    }
    // End:0x1B7
    if(bAffectsHUD)
    {
        // End:0x108
        if(bCinematicMode)
        {
            LocalPlayer(Player).ViewportClient.SetSplitscreenConfiguration(0);            
        }
        else
        {
            // End:0x177
            foreach AllActors(Class'Engine.Actor', A)
            {
                // End:0x175
                foreach A.ComponentList(Class'EvilCaptionComponent', CC)
                {
                    CC.OnHUDReset();                    
                }                                
            }            
            LocalPlayer(Player).ViewportClient.SetSplitscreenConfiguration(5);
        }
    }
    // End:0x2E1
    if(MyEvilPawn != none)
    {
        // End:0x20B
        if(bCinematicMode)
        {
            CameraAnimPlayer.Stop(true);
            SetSprint(false);
            StopFiring();            
        }
        else
        {
            // End:0x276
            if(EvilWeap_Base(MyEvilPawn.Weapon) != none)
            {
                EvilWeap_Base(MyEvilPawn.Weapon).RestartIdleAnim(true);
            }
            // End:0x2E1
            if(EvilWeap_Base(MyEvilPawn.WeaponLeft) != none)
            {
                EvilWeap_Base(MyEvilPawn.WeaponLeft).RestartIdleAnim(true);
            }
        }
    }
    bCinemaDisableInputMove = bAffectsMovement;
    bCinemaDisableInputLook = bAffectsTurning;
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
    MyEvilPawn = EvilPawn(inPawn);
    SetButtonFilter(false);
    GetMeleeActionsManager().Reset();
    ClientStopLowHealthAmbient();
    // End:0x81
    if((GetPPManager()) != none)
    {
        PPManager.Reset();
    }
    super(UTPlayerController).Possess(inPawn, bVehicleTransition);
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
    // End:0x72
    if(Player != none)
    {
        EvilPlayerReplicationInfo(PlayerReplicationInfo).SetPlayerPawnClass(EvilLocalPlayer(Player).PlayerPawnClass);
    }
    bProfileSettingsUpdated = true;
    SetTimer(0.1000000, true, 'CheckForUsableTrigger');
    //return;    
}

simulated event ReceivedPlayer()
{
    local LocalPlayer LP;
    local Vector2D ViewportSize;

    super(UTPlayerController).ReceivedPlayer();
    LP = LocalPlayer(Player);
    // End:0x5E
    if((GetPPManager()) != none)
    {
        PPManager.LocalPlayer = LP;
    }
    // End:0x1A3
    if(false && LP != none)
    {
        HighlightSceneCaptureComponent.Player = LP;
        LP.ViewportClient.GetViewportSize(ViewportSize);
        HighlightMaskTexture = Class'Engine.TextureRenderTarget2D'.static.Create(FCeil(ViewportSize.X), FCeil(ViewportSize.Y), 2, ColorToLinearColor(HighlightSceneCaptureComponent.ClearColor), false);
        HighlightSceneCaptureComponent.SetCaptureParameters(HighlightMaskTexture);
    }
    //return;    
}

simulated function CheckForUsableTrigger()
{
    local Trigger T;
    local int Idx;
    local float Weight;
    local bool bInserted;
    local Vector CameraLoc;
    local Rotator CameraRot;
    local array<Trigger> useList, sortedList;
    local array<float> weightList;

    // End:0x2A0
    if(MyEvilPawn != none)
    {
        GetTriggerUseList(InteractDistance, 60.0000000, 0.0000000, true, useList);
        // End:0x2A0
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
            return;
        }
    }
    UsableTrigger = none;
    //return;    
}

simulated function GetTriggerUseList(float interactDistanceToCheck, float crosshairDist, float minDot, bool bUsuableOnly, out array<Trigger> out_useList)
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
    return (PlayerInput != none) && PlayerInput.bUsingGamepad;
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

simulated function ClearFocus(bool bFromKismet, optional bool bForceLeaveRotation)
{
    local bool bLeaveRotation;
    local Vector Loc;
    local Rotator Rot;

    bLeaveRotation = bForceLeaveRotation || (EvilPointOfInterest(CameraLookAtFocusActor) != none) && EvilPointOfInterest(CameraLookAtFocusActor).bLeavePlayerFacingPOI;
    // End:0x123
    if(!bLeaveRotation)
    {
        // End:0x114
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
        // End:0x143
        if(int(CameraLookAtFocusType) != int(3))
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
                // End:0x541
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
            // End:0x541
            break;
        // End:0x3D5
        case 3:
        // End:0x53E
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
                // End:0x4AA
                if(RDiff(out_ViewRotation, LockedViewRot) < 0.1000000)
                {
                    ClearFocus(false);
                    return;
                }
            }
            out_ViewRotation += Normalize(LockedViewRot - CameraLookAtLastDir);
            CameraLookAtLastDir = LockedViewRot;
            out_ViewRotation = RInterpToEaseInOut(out_ViewRotation, LockedViewRot, CameraLookAtInitialDir, CameraLookAtInterpAlpha, DeltaTime, CameraLookAtInterpSpeed, PointOfInterestLookatInterpExponent);
            // End:0x541
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
        if(EnabledPointsOfInterest.Find(POI) == -1)
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

final function bool TryPOILookAt()
{
    return ProcessPOI(none, true);
    //return ReturnValue;    
}

final function bool TryPOILookAway()
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
            EvilGFxHudWrapper(myHUD).HudMovie.SetLocalizedMessageText(MI.Message, POIToForce.DisplayLong, POIToForce.DisplayParseTags);
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
    // End:0x11C
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
        // End:0x8A
        if(bUserInstigated == true)
        {
        }
        EvilPlayerInput(PlayerInput).SetButtonFilter(false);
        // End:0x11A
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

reliable client singular simulated function ClientSetButtonFilter(bool newEnabled, optional EvilTypes.EGameButtons except = 24)
{
    SetButtonFilter(newEnabled, except);
    //return;    
}

simulated function SetButtonFilter(bool newEnabled, optional EvilTypes.EGameButtons except = 24)
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

reliable server function ServerSelectCoopCharacter(int CharNumber, int oldCharNumber, string PlayerName)
{
    EvilGameReplicationInfo(WorldInfo.GRI).UpdateCoopCharacter(CharNumber, oldCharNumber, PlayerName);
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
    // End:0x329
    foreach WorldInfo.AllControllers(Class'EvilPlayerController', PC)
    {
        LP = LocalPlayer(PC.Player);
        // End:0x1A6
        if(LP == none)
        {
            PC.ClientNotifySavingCheckpoint();
            // End:0x328
            continue;
        }
        // End:0x309
        if(PC.IsPrimaryPlayer())
        {
            // End:0x2E7
            if(Engine.bShouldWriteCheckpointToDisk)
            {
                ClientSaveAllPlayerData(,, true);
                // End:0x2E4
                if((((LP != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && int(OnlineSub.PlayerInterface.GetLoginStatus(byte(LP.ControllerId))) > int(0))
                {
                    Engine.CheckpointClass.static.ShowSavingContentWarning();
                }                
            }
            else
            {
                PC.ClientNotifySavingCheckpoint();
            }
            // End:0x328
            continue;
        }
        PC.ClientNotifySavingCheckpoint();        
    }    
    //return;    
}

reliable client simulated function ClientNotifySavingCheckpoint()
{
    ClientSaveAllPlayerData();
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

    // End:0x2D8
    if((int(Role) == int(ROLE_Authority)) && WorldInfo.NextURL == "")
    {
        // End:0x90
        foreach WorldInfo.AllControllers(Class'EvilPlayerController', PC)
        {
            PC.ClosePauseMenu();            
        }        
        LastCheckpointSaveName = InCheckpointName;
        Engine = EvilEngine(Class'Engine.Engine'.static.GetEngine());
        // End:0x2D8
        if(Engine != none)
        {
            // End:0x2B7
            if((Engine.CurrentCheckpoint != none) && bool(Engine.CurrentCheckpoint.bIsLevelStart))
            {
                ClientShowLevelLoadingMovie();
                WorldInfo.ServerTravel((((("PKHDGame_P?game=PKHDGame." $ (((WorldInfo.GRI != none) && WorldInfo.GRI.GameClass.Name == 'PKGameCooperative') ? "PKGameCooperative" : "PKGameSP")) $ "?loadcheckpoint=0?chapter=") $ string(Engine.CurrentCheckpoint.ChapterNum)) $ "?gamepad=") $ ((PlayerInput.bUsingGamepad) ? "1" : "0"));                
            }
            else
            {
                Engine.PendingCheckpointAction = 1;
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

protected function SaveProfile()
{
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

simulated event Destroyed()
{
    // End:0x27
    if(PPManager != none)
    {
        PPManager.Destroy();
    }
    super(UTPlayerController).Destroyed();
    //return;    
}

reliable client simulated event ClientShowLevelLoadingMovie()
{
    Class'Engine.Engine'.static.PlayLoadMapMovie("test");
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

function KilledSomeEnemiesByExplosion(const out array<EvilPawn> KilledPawns, class<DamageType> DamageType)
{
    //return;    
}

// Export UEvilPlayerController::execGetCurrentMovieFrame(FFrame&, void* const)
native final function int GetCurrentMovieFrame();

state PlayerSliding
{
    ignores Bump;

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
    // Reference: EvilSceneCaptureHighlightComponent'Default__EvilPlayerController.HighlightComponent'
    begin object name="HighlightComponent" class=Class'EvilSceneCaptureHighlightComponent'
    end object
    HighlightSceneCaptureComponent=HighlightComponent
    PPManagerClass=Class'EvilPostProcessManager'
    HitEffectsClass=Class'EvilPlayerHitEffects'
    InteractAimDotAngle=0.9400000
    PointOfInterestLookatInterpSpeed=1.5000000
    PointOfInterestLookatInterpExponent=4.0000000
    bRotateMinimap=true
    // Reference: ForceFeedbackWaveform'Default__EvilPlayerController.ForceFeedbackWaveform7'
    // Archetype: ForceFeedbackWaveform'Default__UTConsolePlayerController.ForceFeedbackWaveform7'
    begin object name="ForceFeedbackWaveform7"
    end object
    CameraShakeShortWaveForm=ForceFeedbackWaveform7
    // Reference: ForceFeedbackWaveform'Default__EvilPlayerController.ForceFeedbackWaveform8'
    // Archetype: ForceFeedbackWaveform'Default__UTConsolePlayerController.ForceFeedbackWaveform8'
    begin object name="ForceFeedbackWaveform8"
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
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__UTConsolePlayerController.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    ForceFeedbackManagerClassName="WinDrv.XnaForceFeedbackManager"
    Components[0]=CollisionCylinder
    Components[1]=HighlightComponent
    CollisionComponent=CollisionCylinder
}