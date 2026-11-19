class AdvTurret_Mirror_Base extends AdvTurret_Base
    abstract
    config(Game)
    hidecategories(Navigation)
    implements(AdvLightAffection_interface);

struct CheckpointRecord
{
    var Rotator WeaponRotation;
    var bool bBlocked;
    var bool bIsDisabled;
    var Vector Location;
    var Vector CameraTargetLocation;
    var Vector PreviousLocation;
    var Rotator Rotation;
    var Rotator PreviousViewRotation;
    var Rotator RotationViewDiff;
    var int Purpose;
    var bool bIsLit;
    var bool bWasLit;
    var float LightPower;
    var float tmpState;
    var bool bIsUnderFocusedBeamEffect;
    var string SavedBase;
    var bool bHidden;

    structdefaultproperties
    {
        WeaponRotation=(Pitch=0,Yaw=0,Roll=0)
        bBlocked=false
        bIsDisabled=false
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        CameraTargetLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        PreviousLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(Pitch=0,Yaw=0,Roll=0)
        PreviousViewRotation=(Pitch=0,Yaw=0,Roll=0)
        RotationViewDiff=(Pitch=0,Yaw=0,Roll=0)
        Purpose=0
        bIsLit=false
        bWasLit=false
        LightPower=0.0000000
        tmpState=0.0000000
        bIsUnderFocusedBeamEffect=false
        SavedBase=""
        bHidden=false
    }
};

var() export editinline AdvMirrorComponent MirrorComponent;
var() Actor TargetActor;
var() bool bBlocked;
var bool bDriverJustEntered;
var() bool bIgnoreObstruction;
var bool bLastUsingGamepad;
var() bool bShowDebugInfo;
var Rotator OldRotation;
var Rotator RotationDiff;
var Rotator PreviousViewRotation;
var Rotator RotationViewDiff;
var Vector PreviousLocation;
var() float Friction;
var() Rotator InitialViewRotation;
var GFxObject TextField;
var GFxObject TextFieldBG;
var AdvPlayerPawn tmpAPP_T;
var string HintString;
var() export editinline AudioComponent RotatingAudio;
var Vector CameraTargetLocation;
var Vector PivotLatLoc;

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.WeaponRotation = SeatWeaponRotation(0,, true);
    Record.bBlocked = bBlocked;
    Record.bIsDisabled = bIsDisabled;
    MirrorComponent.MirrorReflectingMaterial.GetScalarParameterValue('LightPower', Record.tmpState);
    Record.bIsUnderFocusedBeamEffect = MirrorComponent.bIsUnderFocusedBeamEffect;
    Record.bIsLit = MirrorComponent.bIsLit;
    Record.bWasLit = MirrorComponent.bWasLit;
    Record.LightPower = MirrorComponent.LightPower;
    Record.Purpose = int(MirrorComponent.Purpose);
    Record.Location = self.Location;
    Record.Rotation = self.Rotation;
    Record.PreviousViewRotation = self.PreviousViewRotation;
    Record.RotationViewDiff = self.RotationViewDiff;
    Record.SavedBase = PathName(Base);
    Record.bHidden = self.bHidden;
    Record.CameraTargetLocation = self.CameraTargetLocation;
    Record.PreviousLocation = self.PreviousLocation;
    //return;    
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    local Actor SavedBaseActor;

    // End:0x407
    if(!bDeleteMe)
    {
        AuxiliarySetLocation(Record.Location);
        self.SetRotation(Record.Rotation);
        WeaponRotation = Record.WeaponRotation;
        SeatWeaponRotation(0, Record.WeaponRotation, false);
        self.PreviousLocation = Record.PreviousLocation;
        self.CameraTargetLocation = Record.CameraTargetLocation;
        bBlocked = Record.bBlocked;
        bIsDisabled = Record.bIsDisabled;
        self.PreviousViewRotation = Record.PreviousViewRotation;
        self.RotationViewDiff = Record.RotationViewDiff;
        MirrorComponent.MirrorReflectingMaterial.SetScalarParameterValue('LightPower', Record.tmpState);
        MirrorComponent.bIsUnderFocusedBeamEffect = Record.bIsUnderFocusedBeamEffect;
        MirrorComponent.bIsLit = Record.bIsLit;
        MirrorComponent.bWasLit = Record.bWasLit;
        MirrorComponent.LightPower = Record.LightPower;
        MirrorComponent.UpdatePurpose(Record.Purpose);
        Team = 128;
        // End:0x3E0
        if(Record.SavedBase != "")
        {
            SavedBaseActor = Actor(FindObject(Record.SavedBase, Class'Engine.Actor'));
            // End:0x3E0
            if(SavedBaseActor != none)
            {
                SetBase(SavedBaseActor);
            }
        }
        SetHidden(Record.bHidden);
    }
    //return;    
}

function AuxiliarySetLocation(Vector Destination)
{
    self.SetLocation(Destination);
    // End:0xAB
    if(self.Location != Destination)
    {
        // End:0x74
        if(self.MoveSmooth(Destination - self.Location))
        {            
        }
        else
        {
            // End:0xAB
            if(self.Move(Destination - self.Location))
            {                
            }
        }
    }
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    MirrorComponent.Init();
    // End:0x90
    if((InitialViewRotation.Pitch != 0) || InitialViewRotation.Yaw != 0)
    {
        SeatWeaponRotation(0, Rotation + InitialViewRotation, false);
    }
    PreviousViewRotation = SeatWeaponRotation(0,, true);
    PivotLatLoc = Mesh.GetBoneLocation(Seats[0].GunPivotPoints[0]);
    CameraTargetLocation = PivotLatLoc + (Vector(PreviousViewRotation) * 100.0000000);
    OldRotation = Rotation;
    PreviousLocation = Location;
    //return;    
}

simulated event Destroyed()
{
    MirrorComponent.DestroyDecals();
    super(EvilVehicle_Base).Destroyed();
    //return;    
}

function SetLightAffectionFromFlashLight(bool bInLightCone, optional bool bBeamActive, optional Vector FlashSourceLocation)
{
    MirrorComponent.SetLightAffectionFromFlashLight(bInLightCone, bBeamActive);
    //return;    
}

function SetLightAffectionFromVolume(bool bInLightVolume)
{
    MirrorComponent.SetLightAffectionFromVolume(bInLightVolume);
    //return;    
}

function UpdateLightInfluence_T()
{
    MirrorComponent.UpdateLightInfluence_T();
    //return;    
}

function StartInLightEffects()
{
    MirrorComponent.StartInLightEffects();
    //return;    
}

function StopInLightEffects()
{
    MirrorComponent.StopInLightEffects();
    //return;    
}

function SetTraceParameters(Actor HitActor, Vector HitLocation, Vector HitNormal, Vector SourceLocation)
{
    local Vector SocLoc;
    local Rotator SocRot;

    // End:0x76
    if(HitActor == self)
    {
        Mesh.GetSocketWorldLocationAndRotation(Seats[0].GunSocket[0], SocLoc, SocRot);
        HitNormal = Vector(SocRot);
    }
    MirrorComponent.SetTraceParameters(HitActor, HitLocation, HitNormal, SourceLocation);
    //return;    
}

function Vector GetTraceStartLocation()
{
    local Vector SocLoc;
    local Rotator SocRot;

    Mesh.GetSocketWorldLocationAndRotation(Seats[0].GunSocket[0], SocLoc, SocRot);
    return SocLoc;
    //return ReturnValue;    
}

function KickPlayerOutAndLock()
{
    // End:0x26
    if(Driver != none)
    {
        DriverLeave(true);
        bBlocked = true;
    }
    //return;    
}

function bool AnySeatAvailable()
{
    return super(EvilVehicle_Base).AnySeatAvailable() && !bBlocked;
    //return ReturnValue;    
}

function bool DriverEnter(Pawn P)
{
    HideWeapons(AdvPlayerPawn(P));
    // End:0x293
    if(super.DriverEnter(P))
    {
        CaptionComponent.Hide();
        // End:0x24B
        if(TextField != AdvGFxHud(AdvGFxHudWrapper(AdvPlayerController(self.Controller).myHUD).HudMovie).GetVariableObject("_root.HUD.TreasureTipMC.TreasureTipMC_g.textField"))
        {
            TextField = AdvGFxHud(AdvGFxHudWrapper(AdvPlayerController(self.Controller).myHUD).HudMovie).GetVariableObject("_root.HUD.TreasureTipMC.TreasureTipMC_g.textField");
            TextFieldBG = AdvGFxHud(AdvGFxHudWrapper(AdvPlayerController(self.Controller).myHUD).HudMovie).GetVariableObject("_root.HUD.TreasureTipMC.bg");
        }
        TextFieldBG.GotoAndStop("show");
        SetTextfield();
        bDriverJustEntered = true;
        FireIOevent(true);
        return true;
    }
    RestoreWeapons(AdvPlayerPawn(P));
    return false;
    //return ReturnValue;    
}

function SetTextfield()
{
    // End:0x13B
    if(bLastUsingGamepad)
    {
        HintString = "\n";        
        HintString @= "\n";        
        HintString @= ("\n" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "MirrorRotate", "EvilGame"), PlayerController(self.Controller)));        
        HintString @= ("\n" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "MirrorExit", "EvilGame"), PlayerController(self.Controller)));        
    }
    else
    {
        HintString = "\n";        
        HintString @= "\n";        
        HintString @= ("\n" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "MirrorRotate", "EvilGame"), PlayerController(self.Controller)));        
        HintString @= ("\n" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "MirrorExit_PC", "EvilGame"), PlayerController(self.Controller)));
    }
    TextField.SetBool("html", true);
    TextField.SetString("htmlText", HintString);
    //return;    
}

simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);
    // End:0x234
    if((AdvPlayerController(self.Controller) != none) && TextField != AdvGFxHud(AdvGFxHudWrapper(AdvPlayerController(self.Controller).myHUD).HudMovie).GetVariableObject("_root.HUD.TreasureTipMC.TreasureTipMC_g.textField"))
    {
        TextField = AdvGFxHud(AdvGFxHudWrapper(AdvPlayerController(self.Controller).myHUD).HudMovie).GetVariableObject("_root.HUD.TreasureTipMC.TreasureTipMC_g.textField");
        TextFieldBG = AdvGFxHud(AdvGFxHudWrapper(AdvPlayerController(self.Controller).myHUD).HudMovie).GetVariableObject("_root.HUD.TreasureTipMC.bg");
    }
    // End:0x31B
    if(((Driver != none) && self.Controller != none) && bLastUsingGamepad != AdvPlayerController(self.Controller).PlayerInput.bUsingGamepad)
    {
        bLastUsingGamepad = AdvPlayerController(self.Controller).PlayerInput.bUsingGamepad;
        SetTextfield();
    }
    //return;    
}

function DriverLeft()
{
    RestoreWeapons(AdvPlayerPawn(Driver));
    CaptionComponent.SetCaptionLoc("EnterMirror");
    TextFieldBG.GotoAndStop("hide");
    TextField.SetString("htmlText", "");
    CaptionComponent.Use3DCaption = true;
    FireIOevent(false);
    Team = 128;
    super.DriverLeft();
    //return;    
}

event bool DriverLeave(bool bForceLeave)
{
    local bool bResult;

    Driver.Mesh.SetHidden(false);
    bResult = super.DriverLeave(bForceLeave);
    // End:0x98
    if(!bResult)
    {
        Driver.Mesh.SetHidden(true);
    }
    return bResult;
    //return ReturnValue;    
}

simulated function UpdateTurret(float DeltaTime)
{
    local Rotator AimDir;
    local Vector AimTargetWorld, AimTargetLoc;

    // End:0x36
    if(PreviousLocation != Location)
    {
        CameraTargetLocation += (Location - PreviousLocation);
    }
    RotationDiff = Rotation - OldRotation;
    RotationViewDiff += RotationDiff;
    // End:0xF9
    if(((RotationDiff.Yaw != 0) || RotationDiff.Pitch != 0) || RotationDiff.Roll != 0)
    {
        SeatWeaponRotation(0, (SeatWeaponRotation(0,, true)) + RotationDiff, false);
    }
    OldRotation = Rotation;
    AimDir = SeatWeaponRotation(0,, true);
    PivotLatLoc = Mesh.GetBoneLocation(Seats[0].GunPivotPoints[0]);
    AimTargetWorld = PivotLatLoc + (Vector(AimDir) * float(16384));
    AimTargetLoc = (CameraTargetLocation - Location) << Rotation;
    AimTargetLoc = TransformVectorByRotation(RotationViewDiff, AimTargetLoc);
    // End:0x21E
    if(Pivot_Latitude != none)
    {
        Pivot_Latitude.TargetLocation = AimTargetLoc;
    }
    // End:0x255
    if(Pivot_Longitude != none)
    {
        Pivot_Longitude.TargetLocation = AimTargetLoc;
    }
    // End:0x2AC
    if(bShowDebugInfo)
    {
        DrawDebugLine(PivotLatLoc, AimTargetWorld, 0, 255, 0, false);
        DrawDebugBox(AimTargetWorld, vect(5.0000000, 5.0000000, 5.0000000), 0, 255, 0, false);
    }
    PreviousLocation = Location;
    //return;    
}

function FadeRotationSound_T()
{
    RotatingAudio.FadeOut(0.5000000, 0.0000000);
    //return;    
}

simulated function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
{
    // End:0x95
    if(bDriverJustEntered)
    {
        out_ViewRotation = PreviousViewRotation + RotationViewDiff;
        bDriverJustEntered = false;
        RotationViewDiff.Yaw = 0;
        RotationViewDiff.Pitch = 0;
        RotationViewDiff.Roll = 0;        
    }
    else
    {
        PreviousViewRotation = out_ViewRotation;
    }
    out_DeltaRot *= Friction;
    out_DeltaRot += RotationViewDiff;
    RotationViewDiff.Yaw = 0;
    RotationViewDiff.Pitch = 0;
    RotationViewDiff.Roll = 0;
    // End:0x1D2
    if((RotatingAudio != none) && out_DeltaRot.Yaw != 0)
    {
        SetTimer(0.0000000, false, 'FadeRotationSound_T');
        // End:0x1BF
        if(!RotatingAudio.IsPlaying())
        {
            RotatingAudio.FadeIn(0.2000000, 1.0000000);
        }
        SetTimer(0.1000000, false, 'FadeRotationSound_T');
    }
    super(Pawn).ProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRot);
    out_ViewRotation.Yaw = ClampRotAxisFromBase(out_ViewRotation.Yaw, Rotation.Yaw, ViewYawLimit);
    CameraTargetLocation = PivotLatLoc + (Vector(out_ViewRotation) * MirrorComponent.Range);
    //return;    
}

simulated function bool CalcCamera(float DeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    local Vector pos;
    local float tmpOffsetFromPitch;

    // End:0x227
    if(bIgnoreObstruction)
    {
        GetActorEyesViewPoint(out_CamLoc, out_CamRot);
        // End:0x4C
        if(!bShowDebugInfo)
        {
            out_CamLoc += BaseOffset;
        }
        // End:0x113
        if((out_CamRot.Pitch >= 0) && out_CamRot.Pitch <= 10000)
        {
            tmpOffsetFromPitch = float(out_CamRot.Pitch) / 500.0000000;
            out_CamLoc.X -= tmpOffsetFromPitch;
            out_CamLoc.Z += tmpOffsetFromPitch;
        }
        pos = (out_CamLoc - (Vector(out_CamRot) * CamDist)) + ((bShowDebugInfo) ? TransformVectorByRotation(rot(0, 16380, 0), vect(0.0000000, 1.0000000, 0.0000000)) * CamDist : vect(0.0000000, 0.0000000, 0.0000000));
        out_CamLoc = pos;
        // End:0x222
        if(bShowDebugInfo)
        {
            DrawDebugLine(out_CamLoc, out_CamLoc + (Vector(out_CamRot) * float(500)), 255, 0, 0, false);
            DrawDebugBox(out_CamLoc + (Vector(out_CamRot) * float(500)), vect(5.0000000, 5.0000000, 5.0000000), 255, 0, 0, false);
        }
        return true;        
    }
    else
    {
        super(EvilVehicle_Base).CalcCamera(DeltaTime, out_CamLoc, out_CamRot, out_FOV);
    }
    return true;
    //return ReturnValue;    
}

simulated function bool ShouldShowUseable(PlayerController PC, float Dist)
{
    return !(bIsDisabled || bBlocked) || Driver != none;
    //return ReturnValue;    
}

simulated function bool IsUsable()
{
    return true;
    //return ReturnValue;    
}

simulated function bool IsUsableAndActive()
{
    return !(bIsDisabled || bBlocked) || Driver != none;
    //return ReturnValue;    
}

simulated function bool CanBeUsedNow(PlayerController PC)
{
    return !(bIsDisabled || bBlocked) || Driver != none;
    //return ReturnValue;    
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0x1D9
    if((int(MirrorComponent.Purpose) == int(0)) || int(MirrorComponent.Purpose) == int(1))
    {
        // End:0xAF
        if(Action.InputLinks[0].bHasImpulse)
        {
            MirrorComponent.Purpose = 1;            
        }
        else
        {
            // End:0x10A
            if(Action.InputLinks[1].bHasImpulse)
            {
                MirrorComponent.Purpose = 0;                
            }
            else
            {
                // End:0x1D9
                if(Action.InputLinks[2].bHasImpulse)
                {
                    // End:0x18F
                    if(int(MirrorComponent.Purpose) == int(1))
                    {
                        MirrorComponent.Purpose = 0;                        
                    }
                    else
                    {
                        // End:0x1D9
                        if(int(MirrorComponent.Purpose) == int(0))
                        {
                            MirrorComponent.Purpose = 1;
                        }
                    }
                }
            }
        }
    }
    // End:0x314
    if((int(MirrorComponent.Purpose) == int(2)) && MirrorComponent.ToggleMode)
    {
        // End:0x260
        if(Action.InputLinks[0].bHasImpulse)
        {            
        }
        else
        {
            // End:0x2DC
            if(Action.InputLinks[1].bHasImpulse)
            {
                MirrorComponent.bIsLit = false;
                MirrorComponent.bIsUnderFocusedBeamEffect = false;                
            }
            else
            {
                // End:0x314
                if(Action.InputLinks[2].bHasImpulse)
                {
                }
            }
        }
    }
    //return;    
}

function FireIOevent(bool entered)
{
    local Sequence GameSeq;
    local array<SequenceObject> ExecutionEvents;
    local SequenceObject ExecutionEvent;
    local SeqEvent_IOpuzzle FireEvent;
    local array<int> ActivateIndices;

    GameSeq = WorldInfo.GetGameSequence();
    // End:0x119
    if(GameSeq != none)
    {
        // End:0x55
        if(entered)
        {
            ActivateIndices[0] = 0;            
        }
        else
        {
            ActivateIndices[0] = 1;
        }
        GameSeq.FindSeqObjectsByClass(Class'SeqEvent_IOpuzzle', true, ExecutionEvents);
        // End:0x118
        foreach ExecutionEvents(ExecutionEvent)
        {
            FireEvent = SeqEvent_IOpuzzle(ExecutionEvent);
            // End:0x117
            if(FireEvent.Originator == self)
            {
                FireEvent.CheckActivate(self, none, false, ActivateIndices);
            }            
        }        
    }
    //return;    
}

function bool PlaceExitingDriver(optional Pawn ExitingDriver)
{
    local int I;
    local Vector tryPlace, Extent, HitLocation, HitNormal, ZOffset;

    // End:0x23
    if(ExitingDriver == none)
    {
        ExitingDriver = Driver;
    }
    // End:0x34
    if(ExitingDriver == none)
    {
        return false;
    }
    Extent = ExitingDriver.GetCollisionRadius() * vect(1.0000000, 1.0000000, 0.0000000);
    Extent.Z = ExitingDriver.GetCollisionHeight();
    ZOffset = Extent.Z * vect(0.0000000, 0.0000000, 1.0000000);
    // End:0x2A8
    if(ExitPositions.Length > 0)
    {
        I = 0;
        J0xF8:

        // End:0x2A8 [Loop If]
        if(I < ExitPositions.Length)
        {
            // End:0x170
            if(ExitPositions[0].Z != float(0))
            {
                ZOffset = vect(0.0000000, 0.0000000, 1.0000000) * ExitPositions[0].Z;                
            }
            else
            {
                ZOffset = ExitingDriver.CylinderComponent.default.CollisionHeight * vect(0.0000000, 0.0000000, 2.0000000);
            }
            tryPlace = (Location + ((ExitPositions[I] - ZOffset) >> Rotation)) + ZOffset;
            // End:0x24D
            if(Trace(HitLocation, HitNormal, tryPlace, Location + ZOffset, false, Extent) != none)
            {                
            }
            else
            {
                // End:0x298
                if(!TryExitPos(ExitingDriver, tryPlace, false))
                {
                    // End:0x298
                    if(!ExitingDriver.SetLocation(tryPlace))
                    {
                        // [Explicit Continue]
                        goto J0x29A;
                    }
                }
                return true;
            }
            J0x29A:

            I++;
            // [Loop Continue]
            goto J0xF8;
        }
    }
    return FindAutoExit(ExitingDriver);
    //return ReturnValue;    
}

function HideWeapons(AdvPlayerPawn APP)
{
    // End:0x53
    if(APP != none)
    {
        APP.QuickHideCurrentWeapon(true,, true);
        APP.QuickHideCurrentWeapon(true,, false);
    }
    //return;    
}

function HideGamePlayObject_T()
{
    AdvPlayerController(tmpAPP_T.Controller).HideGameplayObject();
    tmpAPP_T = none;
    //return;    
}

function RestoreWeapons(AdvPlayerPawn APP)
{
    // End:0x79
    if(APP != none)
    {
        APP.EndQuickHideCurrentWeapon(true,, true);
        APP.EndQuickHideCurrentWeapon(true,, false);
        tmpAPP_T = APP;
        SetTimer(0.2000000, false, 'HideGamePlayObject_T');
    }
    //return;    
}

function bool AddFlashlight(AdvInventoryItem_Torch addTorch)
{
    //return ReturnValue;    
}

function RemoveFlashlight(AdvInventoryItem_Torch removeTorch)
{
    //return;    
}

function bool IsUnderBeamEffect()
{
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: AdvMirrorComponent'Default__AdvTurret_Mirror_Base.MirrorComponent0'
    begin object name=MirrorComponent0 class=Class'AdvMirrorComponent'
        LightMesh=StaticMeshComponent'Default__AdvTurret_Mirror_Base.StaticMeshLight'
        // Reference: LensFlareComponent'Default__AdvTurret_Mirror_Base.MirrorComponent0.LensFlare0'
        begin object name=LensFlare0
            NextTraceTime=-0.3593860
            ReplacementPrimitive=none
        end object
        MirrorLensFlare=LensFlare0
        // Reference: AudioComponent'Default__AdvTurret_Mirror_Base.MirrorComponent0.ChargeAudioComponent0'
        begin object name=ChargeAudioComponent0
        end object
        ChargeSound=ChargeAudioComponent0
        // Reference: SpotLightComponent'Default__AdvTurret_Mirror_Base.MirrorComponent0.SpotLightComponent0'
        begin object name=SpotLightComponent0
        end object
        SLC=SpotLightComponent0
    end object
    MirrorComponent=MirrorComponent0
    bIgnoreObstruction=true
    Friction=0.3000000
    // Reference: AudioComponent'Default__AdvTurret_Mirror_Base.RotatingAudioComponent0'
    begin object name=RotatingAudioComponent0 class=Class'Engine.AudioComponent'
    end object
    RotatingAudio=RotatingAudioComponent0
    // Reference: EvilCaptionComponent'Default__AdvTurret_Mirror_Base.CaptionComp'
    begin object name=CaptionComp
        LocString="EnterMirror"
        bAimToFullySee=true
        ReferenceDistance=120.0000000
        FarDistance=180.0000000
    end object
    CaptionComponent=CaptionComp
    bInvincible=true
    bEnableIK=true
    // Reference: DynamicLightEnvironmentComponent'Default__AdvTurret_Mirror_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: SVehicleSimBase'Default__AdvTurret_Mirror_Base.SimObject'
    begin object name=SimObject
    end object
    SimObj=SimObject
    // Reference: RB_StayUprightSetup'Default__AdvTurret_Mirror_Base.MyStayUprightSetup'
    begin object name=MyStayUprightSetup
    end object
    StayUprightConstraintSetup=MyStayUprightSetup
    // Reference: RB_ConstraintInstance'Default__AdvTurret_Mirror_Base.MyStayUprightConstraintInstance'
    begin object name=MyStayUprightConstraintInstance
    end object
    StayUprightConstraintInstance=MyStayUprightConstraintInstance
    BaseOffset=(X=0.0000000,Y=0.0000000,Z=95.0000000)
    CamDist=50.0000000
    WalkingPhysics=EPhysics.PHYS_Flying
    // Reference: SkeletalMeshComponent'Default__AdvTurret_Mirror_Base.SVehicleMesh'
    begin object name=SVehicleMesh
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvTurret_Mirror_Base.MyLightEnvironment'
        bAcceptsStaticDecals=true
        bAcceptsDynamicDecals=true
    end object
    Mesh=SVehicleMesh
    // Reference: CylinderComponent'Default__AdvTurret_Mirror_Base.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=148.0000000
        CollisionRadius=40.0000000
        ReplacementPrimitive=none
        CollideActors=true
        BlockActors=true
        BlockNonZeroExtent=true
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=SVehicleMesh
    Components[2]=MyLightEnvironment
    Components[3]=CaptionComp
    Components[4]=SimObject
    Components[5]=RotatingAudioComponent0
    // Reference: StaticMeshComponent'Default__AdvTurret_Mirror_Base.StaticMeshLight'
    begin object name=StaticMeshLight class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        bUsePrecomputedShadows=true
        Rotation=(Pitch=32760,Yaw=0,Roll=0)
    end object
    Components[6]=StaticMeshLight
    Components[7]=MirrorComponent0
    Components[8]=none
    Components[9]=CollisionCylinder
    Physics=EPhysics.PHYS_Interpolating
    CollisionComponent=SVehicleMesh
    SupportedEvents=/* Array type was not detected. */
}