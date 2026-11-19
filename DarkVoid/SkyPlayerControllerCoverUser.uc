class SkyPlayerControllerCoverUser extends SkyPlayerControllerBase
    native
    config(Pawn);

var(Cover) config bool bDebugCover;
var(Cover) config bool bRun2CoverAnyDirection;
var bool bServerMoveCoverActive;
var transient bool bIgnoreNextXRelease;
var(Cover) config float DeadZoneThreshold;
var float RemappedJoyRight;
var float RemappedJoyUp;
var Rotator ControlsRemapRotation;

exec function DebugCover()
{
    local SkyPlayerControllerCoverUser PC;

    FlushPersistentDebugLines();
    // End:0xD5
    foreach WorldInfo.AllControllers(Class'SkyPlayerControllerCoverUser', PC)
    {
        // End:0xD4
        if(PC.IsLocalPlayerController())
        {
            PC.bDebugCover = !PC.bDebugCover;
            PC.SetBasicCoverDebug(SkyPawnCoverUser(PC.Pawn), PC.bDebugCover);
            SkyHUD(PC.myHUD).SetDebugDraw(DebugDraw_Cover, PC.bDebugCover);
            // End:0xD5
            break;
        }        
    }    
    //return;    
}

exec function ShowCover()
{
    DebugCover();
    //return;    
}

exec function CoverState()
{
    local SkyPlayerControllerCoverUser PC;
    local int DebugIdx;

    // End:0xB9
    foreach WorldInfo.AllControllers(Class'SkyPlayerControllerCoverUser', PC)
    {
        DebugIdx = SkyHUD(PC.myHUD).DebugDrawList.Find(DebugDraw_Cover);
        // End:0x88
        if(DebugIdx < 0)
        {
            SkyHUD(PC.myHUD).SetDebugDraw(DebugDraw_Cover, true);            
        }
        else
        {
            SkyHUD(PC.myHUD).SetDebugDraw(DebugDraw_Cover, false);
        }
        // End:0xB9
        break;        
    }    
    //return;    
}

function SetBasicCoverDebug(SkyPawnCoverUser P, bool bFlag)
{
    // End:0x7E
    if(P != none)
    {
        P.bCoverDebug_PlayerFOV = bFlag;
        P.bCoverDebug_CoverFOV = bFlag;
        P.bCoverDebug_CoverVolume = bFlag;
        P.bCoverDebug_FoundCover = bFlag;
        P.bCoverDebug_ValidatedCover = bFlag;
    }
    //return;    
}

function DebugDraw_Cover(SkyHUD H)
{
    local SkyPawnCoverUser SP;
    local Vector CamLoc;
    local Rotator CamRot, LSR, RSR, MSR;
    local Canvas Canvas;
    local string Text;
    local CoverReference Info;
    local bool CanSwatTurn;

    Canvas = H.Canvas;
    GetPlayerViewPoint(CamLoc, CamRot);
    // End:0x60
    if(SkyPawnCoverUser(H.DebugTargetActor) != none)
    {
        SP = SkyPawnCoverUser(H.DebugTargetActor);        
    }
    else
    {
        // End:0x11B
        if((PlayerCamera != none) && PlayerCamera.ViewTarget.Target != none)
        {
            SP = SkyPawnCoverUser(PlayerCamera.ViewTarget.Target);
            // End:0x118
            if((SP == none) && Controller(PlayerCamera.ViewTarget.Target) != none)
            {
                SP = SkyPawnCoverUser(Controller(PlayerCamera.ViewTarget.Target).Pawn);
            }            
        }
        else
        {
            SP = SkyPawnCoverUser(Pawn);
        }
    }
    // End:0x72D
    if(SP != none)
    {
        DrawDebugCoordinateSystem(SP.Location + (vect(0.0000000, 40.0000000, 40.0000000) >> SP.Rotation), CamRot, 16.0000000, false);
        DrawDebugCoordinateSystem(SP.Location + (vect(0.0000000, -40.0000000, 40.0000000) >> SP.Rotation), ControlsRemapRotation, 16.0000000, false);
        SetBasicCoverDebug(SP, bDebugCover);
        Canvas.Font = Class'Engine.Engine'.static.GetTinyFont();
        Canvas.SetDrawColor(255, 255, 255, 255);
        Canvas.SetPos(10.0000000, float(Canvas.SizeY) * 0.3300000);
        Text = (((("Link:" $ string(SP.CurrentLink)) @ "CoverState:") $ string(GetEnum(Enum'SkyPawnCoverUser.ECoverState', int(SP.GetCoverState())))) @ "PosInCover:") $ string(GetEnum(Enum'SkyPawnCoverUser.EPositionInCover', int(SP.GetPositionInCover())));
        Canvas.DrawText(Text);
        Text = (((((("CurrentSlotIdx:" $ string(SP.CurrentSlotIdx)) @ "LeftSlotIdx:") $ string(SP.LeftSlotIdx)) @ "RightSlotIdx:") $ string(SP.RightSlotIdx)) @ "CurrentSlotPct:") $ string(SP.CurrentSlotPct);
        Canvas.DrawText(Text);
        CanSwatTurn = SP.CanSwatTurn(Info);
        Text = (((((("CanTargetFromCover?:" $ string(SP.CanTargetFromCover())) @ "CanFireFromCover?") $ string(SP.CanFireFromCover())) @ "CanSwatTurn?") $ string(CanSwatTurn)) @ "IsLeftSwatTurn?") $ string(SP.IsSwatTurningToLeft());
        Canvas.DrawText(Text);
        Text = (("SwatTurnMode:" $ string(GetEnum(Enum'SkyPawnCoverUser.ESwatTurnType', int(SP.GetSwatTurnType())))) @ "PreviousCoverType:") $ string(GetEnum(Enum'Engine.CoverLink.ECoverType', int(SP.GetPreviousCoverType())));
        Canvas.DrawText(Text);
        // End:0x53F
        if(CanSwatTurn)
        {
            DrawDebugLine(SP.Location, CoverLink(Info.Actor).GetSlotLocation(Info.SlotIdx), 255, 255, 0, false);
        }
        LSR = SP.CurrentLink.GetSlotRotation(SP.LeftSlotIdx);
        RSR = SP.CurrentLink.GetSlotRotation(SP.RightSlotIdx);
        MSR = SP.GetInterpCoverNormalRot();
        Canvas.DrawText((((("LeftSlot Rotation = Roll:" @ string(LSR.Roll)) @ "Pitch:") @ string(LSR.Pitch)) @ "Yaw:") @ string(LSR.Yaw));
        Canvas.DrawText((((("RightSlot Rotation = Roll:" @ string(RSR.Roll)) @ "Pitch:") @ string(RSR.Pitch)) @ "Yaw:") @ string(RSR.Yaw));
        Canvas.DrawText((((("My Cover Rotation = Roll:" @ string(MSR.Roll)) @ "Pitch:") @ string(MSR.Pitch)) @ "Yaw:") @ string(MSR.Yaw));
    }
    Text = (((((((("JoyRight(Remapped):" $ string(PlayerInput.RawJoyRight)) $ "(") $ string(RemappedJoyRight)) $ ")") @ "JoyUp(Remapped):") $ string(PlayerInput.RawJoyUp)) $ "(") $ string(RemappedJoyUp)) $ ")";
    Canvas.DrawText(Text);
    Text = (("RawJoyLookRight:" $ string(PlayerInput.RawJoyLookRight)) @ "RawJoyLookUp:") $ string(PlayerInput.RawJoyLookUp);
    Canvas.DrawText(Text);
    // End:0x97A
    if((SP != none) && SP.Mesh != none)
    {
        Canvas.DrawText((((("Root motion mode:" $ string(SP.Mesh.RootMotionMode)) @ "Velocity:") $ string(SP.Velocity)) @ "Acceleration:") $ string(SP.Acceleration));
        Canvas.DrawText((((((("Precise destination?:" $ string(bPreciseDestination)) @ "Physics:") $ string(SP.Physics)) @ "Collide World?:") $ string(SP.bCollideWorld)) @ "InterpolatedMoving?:") $ string(SP.bIsPerformingInterpolatedMove));
    }
    //return;    
}

exec function TryAdeptLedgeJump()
{
    local SkyPawnCoverUser SP;
    local SkyCamera SkyCam;

    SP = SkyPawnCoverUser(Pawn);
    SkyCam = SkyCamera(PlayerCamera);
    // End:0x6E
    if(((SP == none) || (SkyCam != none) && SkyCam.IsFreeCamWithNoPlayerMovement()) || !SP.CanPerformAdeptLedgeJump())
    {
        return;
    }
    SP.StartAdeptLedgeJump();
    //return;    
}

exec function TryVerticalMantleOver(optional bool AllowMantleDown)
{
    local SkyPawnCoverUser SP;
    local SkyCamera SkyCam;

    SkyCam = SkyCamera(PlayerCamera);
    SP = SkyPawnCoverUser(Pawn);
    // End:0xD9
    if((((((SP == none) || (SkyCam != none) && SkyCam.IsFreeCamWithNoPlayerMovement()) || !SP.IsInCover()) || int(SP.GetCoverOrientation()) == int(0)) || !AllowMantleDown && int(SP.GetCoverOrientation()) == int(2)) || !SP.CanMantle())
    {
        return;
    }
    // End:0xF4
    if(int(Role) < int(ROLE_Authority))
    {
        ServerStartVerticalMantle(false);
    }
    SP.StartVerticalMantle(false);
    //return;    
}

exec function TryVerticalMantleSwap()
{
    local SkyPawnCoverUser SP;
    local SkyCamera SkyCam;

    SkyCam = SkyCamera(PlayerCamera);
    SP = SkyPawnCoverUser(Pawn);
    // End:0xAA
    if(((((SP == none) || (SkyCam != none) && SkyCam.IsFreeCamWithNoPlayerMovement()) || !SP.IsInCover()) || int(SP.GetCoverOrientation()) == int(0)) || !SP.CanMantle())
    {
        return;
    }
    // End:0xC5
    if(int(Role) < int(ROLE_Authority))
    {
        ServerStartVerticalMantle(true);
    }
    SP.StartVerticalMantle(true);
    bIgnoreNextXRelease = true;
    //return;    
}

reliable server function ServerStartVerticalMantle(bool ReturnToCover)
{
    // End:0x2F
    if(SkyPawnCoverUser(Pawn) != none)
    {
        SkyPawnCoverUser(Pawn).StartVerticalMantle(ReturnToCover);
    }
    //return;    
}

exec function HandleCoverInput()
{
    local SkyPawnCoverUser SP;
    local CoverReference Info;
    local bool bFinishedHandling;
    local CovPosInfo LeapInfo;
    local SkyCamera SkyCam;
    local CoverLink.ECoverDirection CheckDir;
    local SkyPawnCoverUser.ECoverStepOutType StepoutType;
    local SkyPlayerInput SPI;

    SPI = SkyPlayerInput(PlayerInput);
    // End:0x39
    if((SPI == none) || int(SPI.bCheatButton) == int(1))
    {
        return;
    }
    SkyCam = SkyCamera(PlayerCamera);
    SP = SkyPawnCoverUser(Pawn);
    // End:0x66
    if(SP == none)
    {
        return;
    }
    // End:0x82
    if(SP.IsInWalkVolume() == true)
    {
        return;
    }
    // End:0xA8
    if((SkyCam != none) && SkyCam.IsFreeCamWithNoPlayerMovement())
    {
        return;
    }
    // End:0xC9
    if(SP.HasStartedVerticalMantle())
    {
        bIgnoreNextXRelease = false;
        return;
    }
    // End:0xDA
    if(bIgnoreNextXRelease)
    {
        bIgnoreNextXRelease = false;
    }
    bFinishedHandling = false;
    switch(SP.GetCoverState())
    {
        // End:0x14F
        case 0:
            // End:0x12A
            if(CanLeapToCover(LeapInfo))
            {
                LeapToCover(LeapInfo);
                bFinishedHandling = true;                
            }
            else
            {
                // End:0x14C
                if(CanTryToRunToCover())
                {
                    TryToRunToCover();
                    bFinishedHandling = true;
                }
            }
            // End:0x1B2
            break;
        // End:0x1AC
        case 6:
            // End:0x1A9
            if(SP.CanSwatTurn(Info))
            {
                ServerSwatTurn(Info);
                // End:0x1A1
                if(int(Role) < int(ROLE_Authority))
                {
                    SP.PerformSwatTurn(Info);
                }
                bFinishedHandling = true;
            }
            // End:0x1B2
            break;
        // End:0xFFFF
        default:
            // End:0x1B2
            break;
            break;
    }
    // End:0x296
    if(SP.IsInCover())
    {
        // End:0x279
        if(Abs(RemappedJoyRight) > DeadZoneThreshold)
        {
            // End:0x1F2
            if(RemappedJoyRight > float(0))
            {
                CheckDir = 2;                
            }
            else
            {
                CheckDir = 1;
            }
            // End:0x279
            if(SP.IsNearEdge(CheckDir))
            {
                StepoutType = SP.CanStepout(CheckDir, true, RemappedJoyUp > DeadZoneThreshold, false);
                // End:0x279
                if(int(StepoutType) != int(0))
                {
                    SP.PerformStepout(StepoutType, CheckDir);
                    bFinishedHandling = true;
                }
            }
        }
        // End:0x296
        if(!bFinishedHandling)
        {
            SP.PerformReleaseCover(false, false);
        }
    }
    //return;    
}

exec function TryEnterCover()
{
    local CovPosInfo LeapInfo;
    local SkyPawnCoverUser SP;

    SP = SkyPawnCoverUser(Pawn);
    // End:0x1D
    if(SP == none)
    {
        return;
    }
    // End:0x39
    if(SP.IsInWalkVolume() == true)
    {
        return;
    }
    // End:0x96
    if(int(SP.GetCoverState()) == int(0))
    {
        // End:0x7C
        if(CanLeapToCover(LeapInfo))
        {
            LeapToCover(LeapInfo);            
        }
        else
        {
            // End:0x96
            if(CanTryToRunToCover())
            {
                TryToRunToCover();
            }
        }
    }
    //return;    
}

exec function TrySwatTurn(optional bool bDiveRollOK = true)
{
    local CoverReference Info;
    local SkyPawnCoverUser SP;

    SP = SkyPawnCoverUser(Pawn);
    // End:0x22
    if(SP == none)
    {
        return;
    }
    // End:0x3E
    if(SP.IsInWalkVolume() == true)
    {
        return;
    }
    // End:0xC0
    if(int(SP.GetCoverState()) == int(6))
    {
        // End:0xAD
        if(SP.CanSwatTurn(Info))
        {
            ServerSwatTurn(Info);
            // End:0xAA
            if(int(Role) < int(ROLE_Authority))
            {
                SP.PerformSwatTurn(Info);
            }            
        }
        else
        {
            // End:0xC0
            if(bDiveRollOK)
            {
                TryDiveRoll();
            }
        }
    }
    //return;    
}

exec function TryDiveRoll()
{
    local SkyPawnCoverUser SP;

    SP = SkyPawnCoverUser(Pawn);
    // End:0x1D
    if(SP == none)
    {
        return;
    }
    // End:0x39
    if(SP.IsInWalkVolume() == true)
    {
        return;
    }
    // End:0x83
    if((int(SP.GetCoverOrientation()) == int(0)) && SP.CanDiveRoll())
    {
        SP.PerformReleaseCover(false, true);
    }
    //return;    
}

exec function TrySlip()
{
    local SkyPawnCoverUser SP;

    SP = SkyPawnCoverUser(Pawn);
    // End:0x1D
    if(SP == none)
    {
        return;
    }
    // End:0x39
    if(SP.IsInWalkVolume() == true)
    {
        return;
    }
    // End:0x83
    if((int(SP.GetCoverOrientation()) == int(0)) && SP.CanSlip())
    {
        SP.PerformReleaseCover(false, true);
    }
    //return;    
}

exec function TryHorizontalMantle()
{
    local SkyPawnCoverUser SP;

    SP = SkyPawnCoverUser(Pawn);
    // End:0x1D
    if(SP == none)
    {
        return;
    }
    // End:0x67
    if((int(SP.GetCoverOrientation()) == int(0)) && SP.CanMantle())
    {
        SP.PerformReleaseCover(false, true);
    }
    //return;    
}

exec function ReleaseCover(bool horiz, bool vUp, bool vdown)
{
    local SkyPawnCoverUser SP;
    local CoverLink.ECoverOrientation CO;

    SP = SkyPawnCoverUser(Pawn);
    // End:0x1D
    if(SP == none)
    {
        return;
    }
    // End:0xB5
    if(SP.IsInCover())
    {
        CO = SP.GetCoverOrientation();
        // End:0xB5
        if(((horiz && int(CO) == int(0)) || vUp && int(CO) == int(1)) || vdown && int(CO) == int(2))
        {
            SP.PerformReleaseCover(true, false);
        }
    }
    //return;    
}

reliable server event ServerSwatTurn(CoverReference STInfo)
{
    // End:0x44
    if(SkyPawnCoverUser(Pawn) != none)
    {
        SkyPawnCoverUser(Pawn).RepSwatInfo = STInfo;
        SkyPawnCoverUser(Pawn).PerformSwatTurn(STInfo);
    }
    //return;    
}

function bool CanTryToRunToCover()
{
    local SkyPawnCoverUser SPCU;

    SPCU = SkyPawnCoverUser(Pawn);
    // End:0x3E
    if((Pawn != none) && SkyPawn(Pawn).IsInWalkVolume() == true)
    {
        return false;
    }
    // End:0x96
    if(SPCU != none)
    {
        // End:0x96
        if((SPCU.CommittedToRocketPacking() || SPCU.IsInteracting()) || !SPCU.CanEnterCover())
        {
            return false;
        }
    }
    return SPCU != none;
    //return ReturnValue;    
}

function bool TryToRunToCover(optional float CheckScale, optional bool JustCheck, optional bool VertDownOnly)
{
    local SkyPawnCoverUser P;
    local CovPosInfo FoundCovInfo;
    local Vector CheckDir, CamLoc;
    local Rotator CamRot;
    local bool bNoCameraAutoAlign, bEnteringCoverSideways;
    local float DistanceToCheckToEnterCover;
    local bool bHasInput;

    bNoCameraAutoAlign = false;
    bEnteringCoverSideways = false;
    bHasInput = PlayerInput != none;
    P = SkyPawnCoverUser(Pawn);
    // End:0x355
    if(P != none)
    {
        // End:0x59
        if(P.IsInWalkVolume() == true)
        {
            return false;
        }
        // End:0x73
        if(CheckScale <= 0.0000000)
        {
            CheckScale = 1.0000000;
        }
        // End:0xD1
        if((bHasInput && !bRun2CoverAnyDirection) && (Abs(PlayerInput.RawJoyRight) > Abs(PlayerInput.RawJoyUp)) || PlayerInput.RawJoyUp < -DeadZoneThreshold)
        {
            return false;
        }
        // End:0x125
        if(((int(P.FallState) == int(1)) || int(P.FallState) == int(4)) || int(P.FallState) == int(2))
        {
            return false;
        }
        // End:0x16D
        if((SkyPlayerController(P.Controller) != none) && SkyPlayerController(P.Controller).GetStateName() == 'PlayerGliding')
        {
            return false;
        }
        // End:0x256
        if((bHasInput && bRun2CoverAnyDirection) && Sqrt(Square(PlayerInput.RawJoyRight) + Square(PlayerInput.RawJoyUp)) > DeadZoneThreshold)
        {
            CheckDir.X = PlayerInput.RawJoyUp;
            CheckDir.Y = PlayerInput.RawJoyRight;
            GetPlayerViewPoint(CamLoc, CamRot);
            CheckDir = Normal(CheckDir >> CamRot);
            // End:0x24B
            if(Abs(PlayerInput.RawJoyRight) > Abs(PlayerInput.RawJoyUp))
            {
                bEnteringCoverSideways = true;
            }
            bNoCameraAutoAlign = true;            
        }
        else
        {
            CheckDir = Vector(PlayerCamera.Rotation);
            bNoCameraAutoAlign = false;
        }
        // End:0x29D
        if(bEnteringCoverSideways)
        {
            DistanceToCheckToEnterCover = P.Run2CoverPerpendicularMaxDist * CheckScale;            
        }
        else
        {
            // End:0x2E9
            if(Pawn.GroundSpeed < SkyPawnCoverUser(Pawn).Run2CoverFastDistSpeed)
            {
                DistanceToCheckToEnterCover = SkyPawnCoverUser(Pawn).Run2CoverMaxDist * CheckScale;                
            }
            else
            {
                DistanceToCheckToEnterCover = SkyPawnCoverUser(Pawn).Run2CoverMaxDistFast * CheckScale;
            }
        }
        // End:0x355
        if(P.CanPrepareRun2Cover(DistanceToCheckToEnterCover, FoundCovInfo, CheckDir,, VertDownOnly))
        {
            // End:0x353
            if(!JustCheck)
            {
                AcquireCover(FoundCovInfo, bNoCameraAutoAlign);
            }
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool CanLeapToCover(optional out CovPosInfo OutCovPosInfo)
{
    local SkyPawnCoverUser P;
    local SkyHUD H;

    P = SkyPawnCoverUser(Pawn);
    H = SkyHUD(myHUD);
    // End:0xAB
    if((P != none) && H != none)
    {
        // End:0xAB
        if((P.CommittedToRocketPacking() == false) && P.IsInteracting() == false)
        {
            // End:0xAB
            if(P.CanEnterVerticalCover(H.ReticleHitLocation, H.ReticleHitNormal, OutCovPosInfo))
            {
                return true;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function LeapToCover(CovPosInfo Info)
{
    AcquireCover(Info, false);
    //return;    
}

function AcquireCover(CovPosInfo CovInfo, optional bool bNoCameraAutoAlign)
{
    local SkyPawnCoverUser P;

    // End:0x18
    if(!IsLocalPlayerController())
    {
        ScriptTrace();
        return;
    }
    P = SkyPawnCoverUser(Pawn);
    // End:0x35
    if(P == none)
    {
        return;
    }
    ServerAcquireCover(CovInfo);
    // End:0x6E
    if(int(Role) < int(ROLE_Authority))
    {
        P.PerformAcquireCover(CovInfo);
    }
    //return;    
}

reliable server event ServerAcquireCover(CovPosInfo CovInfo)
{
    // End:0x49
    if(SkyPawnCoverUser(Pawn) != none)
    {
        SkyPawnCoverUser(Pawn).RepCovInfo = CovInfo;
        SkyPawnCoverUser(Pawn).PerformAcquireCover(CovInfo);
    }
    //return;    
}

exec function StartAltFire(optional byte FireModeNum)
{
    local SkyCamera SkyCam;

    SkyCam = SkyCamera(PlayerCamera);
    // End:0x37
    if((SkyCam != none) && SkyCam.IsFreeCamWithNoPlayerMovement())
    {
        return;
    }
    // End:0x56
    if(Vehicle(Pawn) != none)
    {
        StartFire(1);        
    }
    else
    {
        // End:0xF4
        if((Pawn.Weapon != none) && Pawn.Weapon.bAllowZoom == true)
        {
            // End:0xD4
            if(int(Pawn.Weapon.CurrentFireMode) != int(2))
            {
                Pawn.Weapon.SetCurrentFireMode(2);                
            }
            else
            {
                Pawn.Weapon.SetCurrentFireMode(0);
            }
        }
    }
    //return;    
}

exec function StopAltFire(optional byte FireModeNum)
{
    local SkyCamera SkyCam;

    SkyCam = SkyCamera(PlayerCamera);
    // End:0x37
    if((SkyCam != none) && SkyCam.IsFreeCamWithNoPlayerMovement())
    {
        return;
    }
    // End:0x53
    if(Vehicle(Pawn) != none)
    {
        StopFire(1);
    }
    //return;    
}

simulated event SendRemappedInput()
{
    // End:0x24
    if(int(Role) < int(ROLE_Authority))
    {
        ServerReceiveRemappedInput(RemappedJoyRight, RemappedJoyUp);
    }
    //return;    
}

unreliable server function ServerReceiveRemappedInput(float Right, float Up)
{
    // End:0x26
    if(int(Role) == int(ROLE_Authority))
    {
        RemappedJoyRight = Right;
        RemappedJoyUp = Up;
    }
    //return;    
}

function ClientUpdatePosition()
{
    local name CurrentStateName;

    CurrentStateName = GetStateName();
    super(PlayerController).ClientUpdatePosition();
    // End:0x26
    if(CurrentStateName != GetStateName())
    {
        GotoState(CurrentStateName);
    }
    //return;    
}

function CallServerMove(SavedMove NewMove, Vector ClientLoc, byte ClientRoll, int View, SavedMove OldMove)
{
    local SkySavedMove PendingSkyMove;

    // End:0x45
    if(OldMove != none)
    {
        PendingSkyMove = SkySavedMove(OldMove);
        OldMove = none;
        SendServerMove(PendingSkyMove, vect(1.0000000, 2.0000000, 3.0000000), ClientRoll, View, none);
    }
    // End:0x8A
    if(PendingMove != none)
    {
        PendingSkyMove = SkySavedMove(PendingMove);
        PendingMove = none;
        SendServerMove(PendingSkyMove, vect(1.0000000, 2.0000000, 3.0000000), ClientRoll, View, none);
    }
    SendServerMove(NewMove, ClientLoc, ClientRoll, View, OldMove);
    //return;    
}

final function SendServerMove(SavedMove NewMove, Vector ClientLoc, byte ClientRoll, int View, SavedMove OldMove)
{
    local SkySavedMove NewSkyMove;
    local SkyPawnCoverUser MySkyPawnCoverUser;

    MySkyPawnCoverUser = SkyPawnCoverUser(Pawn);
    NewSkyMove = SkySavedMove(NewMove);
    // End:0x1C7
    if(MySkyPawnCoverUser != none)
    {
        // End:0xA9
        if(NewMove.bForceRMVelocity)
        {
            RMServerMove(NewMove.TimeStamp, NewMove.RMVelocity * float(10), ClientLoc, NewMove.CompressedFlags(), ClientRoll, View, int(NewSkyMove.CoverType) != int(0));            
        }
        else
        {
            // End:0x173
            if(int(NewSkyMove.CoverType) != int(0))
            {
                CoverServerMove(NewMove.TimeStamp, NewMove.Acceleration * float(10), ClientLoc, NewMove.CompressedFlags(), ClientRoll, View, NewSkyMove.CoverType, NewSkyMove.CoverAction, NewSkyMove.CoverDirection, NewSkyMove.bWantsToBeMirrored, NewSkyMove.CurrentSlotDirection, NewSkyMove.bIsInStationaryCover);                
            }
            else
            {
                ServerMove(NewMove.TimeStamp, NewMove.Acceleration * float(10), ClientLoc, NewMove.CompressedFlags(), ClientRoll, View);
            }
        }        
    }
    else
    {
        ServerMove(NewMove.TimeStamp, NewMove.Acceleration * float(10), ClientLoc, NewMove.CompressedFlags(), ClientRoll, View);
    }
    //return;    
}

unreliable server event ServerVerifyState(name ClientState)
{
    //return;    
}

unreliable client simulated event ClientVerifyState(name ServerState)
{
    UpdateStateFromAdjustment(ServerState);
    //return;    
}

function UpdateStateFromAdjustment(name NewState)
{
    local SkyPawnCoverUser MySkyPawnCoverUser;

    // End:0x99
    if(GetStateName() != NewState)
    {
        MySkyPawnCoverUser = SkyPawnCoverUser(Pawn);
        // End:0x54
        if(int(MySkyPawnCoverUser.GetCoverState()) != int(0))
        {
            // End:0x51
            if(NewState == 'PlayerWalking')
            {
                return;
            }            
        }
        else
        {
            // End:0x8F
            if(GetStateName() == 'PlayerWalking')
            {
                // End:0x8F
                if((NewState == 'PlayerTakingCover') || NewState == 'PlayerTakingCover_Stationary')
                {
                    return;
                }
            }
        }
        GotoState(NewState);
    }
    //return;    
}

unreliable server function CoverServerMove(float TimeStamp, Vector InAccel, Vector ClientLoc, byte MoveFlags, byte ClientRoll, int View, CoverLink.ECoverType InCoverType, CoverLink.ECoverAction InCoverAction, CoverLink.ECoverDirection InCoverDirection, bool InbWantsToBeMirrored, CoverLink.ECoverDirection InCurrentSlotDirection, bool InbIsInStationaryCover)
{
    // End:0x11
    if(CurrentTimeStamp >= TimeStamp)
    {
        return;
    }
    bServerMoveCoverActive = true;
    ServerMove(TimeStamp, InAccel, ClientLoc, MoveFlags, ClientRoll, View);
    bServerMoveCoverActive = false;
    //return;    
}

unreliable server function RMServerMove(float TimeStamp, Vector InAccel, Vector ClientLoc, byte MoveFlags, byte ClientRoll, int View, bool bIsInCover)
{
    local SkyPawnCoverUser WP;

    // End:0x11
    if(CurrentTimeStamp >= TimeStamp)
    {
        return;
    }
    WP = SkyPawnCoverUser(Pawn);
    WP.bForceRMVelocity = true;
    WP.RMVelocity = InAccel * 0.1000000;
    InAccel = WP.AccelRate * Normal(InAccel);
    bServerMoveCoverActive = bIsInCover;
    ServerMove(TimeStamp, InAccel, ClientLoc, MoveFlags, ClientRoll, View);
    bServerMoveCoverActive = false;
    WP.bForceRMVelocity = false;
    //return;    
}

unreliable server function MantleServerMove(float TimeStamp, Vector InAccel, Vector ClientLoc, byte MoveFlags, byte ClientRoll, int View, bool bIsInCover)
{
    local SkyPawnCoverUser WP;
    local Rotator ViewRot, Rot;
    local float DeltaTime;

    // End:0x11
    if(CurrentTimeStamp >= TimeStamp)
    {
        return;
    }
    // End:0x67
    if(!IsInState('PlayerWalking') && !IsInState('PlayerTakingCover'))
    {
        RMServerMove(TimeStamp, InAccel, ClientLoc, MoveFlags, ClientRoll, View, bIsInCover);
        return;
    }
    WP = SkyPawnCoverUser(Pawn);
    // End:0xAE
    if(WP == none)
    {
        ServerMove(TimeStamp, Normal(InAccel), ClientLoc, MoveFlags, ClientRoll, View);
        return;
    }
    WP.SetLocation(ClientLoc);
    WP.Velocity = InAccel * 0.1000000;
    bWasSpeedHack = false;
    DeltaTime = FMin(MaxResponseTime, TimeStamp - CurrentTimeStamp);
    CurrentTimeStamp = TimeStamp;
    ServerTimeStamp = WorldInfo.TimeSeconds;
    ViewRot.Pitch = View & 65535;
    ViewRot.Yaw = View >> 16;
    ViewRot.Roll = 0;
    LastActiveTime = WorldInfo.TimeSeconds;
    SetRotation(ViewRot);
    // End:0x194
    if(AcknowledgedPawn != Pawn)
    {
        return;
    }
    // End:0x1E7
    if(Pawn != none)
    {
        Rot = Rotation;
        Rot.Roll = 256 * int(ClientRoll);
        Pawn.FaceRotation(Rot, DeltaTime);
    }
    PendingAdjustment.TimeStamp = TimeStamp;
    PendingAdjustment.bAckGoodMove = 1;
    //return;    
}

unreliable server function ServerMove(float TimeStamp, Vector InAccel, Vector ClientLoc, byte MoveFlags, byte ClientRoll, int View)
{
    // End:0x11
    if(CurrentTimeStamp >= TimeStamp)
    {
        return;
    }
    // End:0xAE
    if((Pawn != none) && !Pawn.bForceRMVelocity)
    {
        // End:0xA6
        if((Pawn.Mesh != none) && (int(Pawn.Mesh.RootMotionMode) == int(3)) || int(Pawn.Mesh.RootMotionMode) == int(1))
        {
            Pawn.bForceRegularVelocity = true;
        }
        bPreciseDestination = false;
    }
    super(PlayerController).ServerMove(TimeStamp, InAccel, ClientLoc, MoveFlags, ClientRoll, View);
    // End:0xEF
    if(Pawn != none)
    {
        Pawn.bForceRegularVelocity = false;
    }
    //return;    
}
