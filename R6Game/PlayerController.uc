class PlayerController extends Controller
    native
    nativereplication
    config(Game)
    notplaceable
    hidecategories(lighting);

enum EInputTypes
{
    IT_XAxis,                       // 0
    IT_YAxis,                       // 1
    IT_MAX                          // 2
};

enum EInputMatchAction
{
    IMA_GreaterThan,                // 0
    IMA_LessThan,                   // 1
    IMA_MAX                         // 2
};

enum EOverrideBehavior
{
    OB_Additive,                    // 0
    OB_Override,                    // 1
    OB_Lerp,                        // 2
    OB_MAX                          // 3
};

struct ClientAdjustment
{
    var float TimeStamp;
    var name NewState;
    var Actor.EPhysics newPhysics;
    var Vector NewLoc;
    var Vector NewVel;
    var Actor NewBase;
    var Vector NewFloor;
    var byte bAckGoodMove;

    structdefaultproperties
    {
        TimeStamp=0.0000000
        NewState="None"
        newPhysics=0
        NewLoc=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        NewVel=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        NewBase=none
        NewFloor=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        bAckGoodMove=0
    }
};

struct InputEntry
{
    var PlayerController.EInputTypes Type;
    var float Value;
    var float TimeDelta;
    var PlayerController.EInputMatchAction Action;

    structdefaultproperties
    {
        Type=0
        Value=0.0000000
        TimeDelta=0.0000000
        Action=0
    }
};

struct InputMatchRequest
{
    var array<InputEntry> Inputs;
    var Actor MatchActor;
    var name MatchFuncName;
    var name FailedFuncName;
    var name RequestName;
    var transient int MatchIdx;
    var transient float LastMatchTime;

    structdefaultproperties
    {
        Inputs=none
        MatchActor=none
        MatchFuncName="None"
        FailedFuncName="None"
        RequestName="None"
        MatchIdx=0
        LastMatchTime=0.0000000
    }
};

struct R6PostProcessParamOverrides
{
    var PlayerController.EOverrideBehavior m_eDistortion;
    var PlayerController.EOverrideBehavior m_eBloom;
    var PlayerController.EOverrideBehavior m_eBlurCommon;
    var PlayerController.EOverrideBehavior m_eBlurGaussian;
    var PlayerController.EOverrideBehavior m_eBlurRadial;
    var PlayerController.EOverrideBehavior m_eEdgeBlur;
    var PlayerController.EOverrideBehavior m_eMotionBlur;
    var PlayerController.EOverrideBehavior m_eDOF;
    var PlayerController.EOverrideBehavior m_eNightVision;
    var PlayerController.EOverrideBehavior m_eHeatVision;
    var PlayerController.EOverrideBehavior m_eColorGel;
    var PlayerController.EOverrideBehavior m_eSceneAdjustment;
    var PlayerController.EOverrideBehavior m_eNoise;
    var PlayerController.EOverrideBehavior m_eRetinaImprint;
    var float m_fDistortionLerpFactor;
    var float m_fBloomLerpFactor;
    var float m_fBlurCommonLerpFactor;
    var float m_fBlurGaussianLerpFactor;
    var float m_fBlurRadialLerpFactor;
    var float m_fEdgeBlurLerpFactor;
    var float m_fMotionBlurLerpFactor;
    var float m_fDOFLerpFactor;
    var float m_fNightVisionLerpFactor;
    var float m_fHeatVisionLerpFactor;
    var float m_fColorGelLerpFactor;
    var float m_fSceneAdjustmentLerpFactor;
    var float m_fNoiseLerpFactor;
    var float m_fRetinaImprintLerpFactor;
    var R6PostProcessParam m_Value;

    structdefaultproperties
    {
        m_eDistortion=0
        m_eBloom=0
        m_eBlurCommon=0
        m_eBlurGaussian=0
        m_eBlurRadial=0
        m_eEdgeBlur=0
        m_eMotionBlur=0
        m_eDOF=0
        m_eNightVision=0
        m_eHeatVision=0
        m_eColorGel=0
        m_eSceneAdjustment=0
        m_eNoise=0
        m_eRetinaImprint=0
        m_fDistortionLerpFactor=0.0000000
        m_fBloomLerpFactor=0.0000000
        m_fBlurCommonLerpFactor=0.0000000
        m_fBlurGaussianLerpFactor=0.0000000
        m_fBlurRadialLerpFactor=0.0000000
        m_fEdgeBlurLerpFactor=0.0000000
        m_fMotionBlurLerpFactor=0.0000000
        m_fDOFLerpFactor=0.0000000
        m_fNightVisionLerpFactor=0.0000000
        m_fHeatVisionLerpFactor=0.0000000
        m_fColorGelLerpFactor=0.0000000
        m_fSceneAdjustmentLerpFactor=0.0000000
        m_fNoiseLerpFactor=0.0000000
        m_fRetinaImprintLerpFactor=0.0000000
        m_Value=none
    }
};

var const Player Player;
var Camera PlayerCamera;
var const class<Camera> CameraClass;
var bool bFrozen;
var bool bPressedJump;
var bool bDoubleJump;
var bool bUpdatePosition;
var bool bJumpStatus;
var bool bUpdating;
var globalconfig bool bNeverSwitchOnPickup;
var bool bSetTurnRot;
var bool bCheatFlying;
var bool bCameraPositionLocked;
var bool bShortConnectTimeOut;
var const bool bPendingDestroy;
var bool bWasSpeedHack;
var const bool bWasSaturated;
var globalconfig bool bDynamicNetSpeed;
var globalconfig bool bAimingHelp;
var globalconfig bool bLandingShake;
var bool usePreferredTeamIndex;
var bool bCinematicMode;
var bool m_bDrawDebug;
var bool bReplicateAllPawns;
var float MaxResponseTime;
var float WaitDelay;
var Pawn AcknowledgedPawn;
var Actor.EDoubleClickDir DoubleClickDir;
var byte bIgnoreMoveInput;
var byte bIgnoreLookInput;
var input byte bRun;
var input byte bDuck;
var const Actor ViewTarget;
var const PlayerReplicationInfo RealViewTarget;
var globalconfig float DesiredFOV;
var globalconfig float DefaultFOV;
var transient float m_fFOVBias;
var Rotator TargetViewRotation;
var float TargetEyeHeight;
var HUD myHUD;
var class<SavedMove> SavedMoveClass;
var SavedMove SavedMoves;
var SavedMove FreeMoves;
var SavedMove PendingMove;
var Vector LastAckedAccel;
var float CurrentTimeStamp;
var float LastUpdateTime;
var float ServerTimeStamp;
var float TimeMargin;
var float ClientUpdateTime;
var float MaxTimeMargin;
var float LastActiveTime;
var int ClientCap;
var globalconfig float DynamicPingThreshold;
var float LastPingUpdate;
var float OldPing;
var float LastSpeedHackLog;
var int preferredTeamIndex;
var ClientAdjustment PendingAdjustment;
var string ProgressMessage[4];
var Color ProgressColor[4];
var float ProgressTimeOut;
var const localized string QuickSaveString;
var const localized string NoPauseMessage;
var const localized string ViewingFrom;
var const localized string OwnCamera;
var int GroundPitch;
var Rotator TurnRot180;
var Vector OldFloor;
var transient CheatManager CheatManager;
var class<CheatManager> CheatClass;
var() editinline transient PlayerInput PlayerInput;
var class<PlayerInput> InputClass;
var const Vector FailedPathStart;
var config string ForceFeedbackManagerClassName;
var transient ForceFeedbackManager ForceFeedbackManager;
var transient array<Interaction> Interactions;
var config float InteractDistance;
var array<InputMatchRequest> InputRequests;
var float LastBroadcastTime;
var string LastBroadcastString[4];
var int m_iMovableInteractionStartIndex;
var transient R6PostProcessParamOverrides m_PostProcessEffects;
var R6PlayerOptions m_PlayerOptions;
var float m_fRepMoveVelocity;
var Vector m_vNetOptOldAcceleration;
var Vector m_vNetOptOldLoc;
var int m_iNetOptOldView;
var float m_fNetOptOldMoveVelocity;

replication
{
    // Pos:0x000
    if(((bNetOwner && int(Role) == int(ROLE_Authority)) && ViewTarget != Pawn) && Pawn(ViewTarget) != none)
        TargetEyeHeight, TargetViewRotation;
}

reliable client simulated function ClientDrawCoordinateSystem(Vector AxisLoc, Rotator AxisRot, float Scale, optional bool bPersistentLines)
{
    LogInternal("ClientDrawCoordinateSystem");
    DrawCoordinateSystem(AxisLoc, AxisRot, Scale, bPersistentLines);
    return;
}

// Export UPlayerController::execSetNetSpeed(FFrame&, void* const)
native final function SetNetSpeed(int NewSpeed);

// Export UPlayerController::execGetPlayerNetworkAddress(FFrame&, void* const)
native final function string GetPlayerNetworkAddress();

// Export UPlayerController::execGetServerNetworkAddress(FFrame&, void* const)
native final function string GetServerNetworkAddress();

// Export UPlayerController::execConsoleCommand(FFrame&, void* const)
native function string ConsoleCommand(string Command, optional bool bWriteToLog);

// Export UPlayerController::execClientTravel(FFrame&, void* const)
reliable client native simulated event ClientTravel(string URL, Actor.ETravelType TravelType);

// Export UPlayerController::execUpdateURL(FFrame&, void* const)
native(546) final function UpdateURL(string NewOption, string NewValue, bool bSaveDefault);

// Export UPlayerController::execGetDefaultURL(FFrame&, void* const)
native final function string GetDefaultURL(string Option);

// Export UPlayerController::execCopyToClipboard(FFrame&, void* const)
native function CopyToClipboard(string Text);

// Export UPlayerController::execPasteFromClipboard(FFrame&, void* const)
native function string PasteFromClipboard();

// Export UPlayerController::execClientValidate(FFrame&, void* const)
private reliable client native simulated event ClientValidate(string C);

// Export UPlayerController::execServerValidationResponse(FFrame&, void* const)
private reliable server native event ServerValidationResponse(string Response);

// Export UPlayerController::execCheckSpeedHack(FFrame&, void* const)
native final function bool CheckSpeedHack(float DeltaTime);

// Export UPlayerController::execFindStairRotation(FFrame&, void* const)
native(524) final function int FindStairRotation(float DeltaTime);

// Export UPlayerController::execRetinaImprintActivate(FFrame&, void* const)
native final exec function RetinaImprintActivate();

// Export UPlayerController::execRetinaImprintDeActivate(FFrame&, void* const)
native final exec function RetinaImprintDeActivate();

// Export UPlayerController::execRetinaImprintGrabFrame(FFrame&, void* const)
native final exec function RetinaImprintGrabFrame();

// Export UPlayerController::execRetinaImprintSetOpacity(FFrame&, void* const)
native final exec function RetinaImprintSetOpacity(float fOpacity);

// Export UPlayerController::execMotionBlurActivate(FFrame&, void* const)
native final exec function MotionBlurActivate(float Amount);

// Export UPlayerController::execMotionBlurDeActivate(FFrame&, void* const)
native final exec function MotionBlurDeActivate();

// Export UPlayerController::execBlurActivate(FFrame&, void* const)
native final exec function BlurActivate(float fFactor);

// Export UPlayerController::execBlurDeActivate(FFrame&, void* const)
native final exec function BlurDeActivate();

// Export UPlayerController::execDistortionActivate(FFrame&, void* const)
native final function DistortionActivate(float fStrength, float fScale);

// Export UPlayerController::execDistortionDeActivate(FFrame&, void* const)
native final function DistortionDeActivate();

simulated event PostBeginPlay()
{
    local R6PostProcessParam PrivateParam;

    PostBeginPlay();
    ResetCameraMode();
    // End:0x7D
    if(CameraClass != none)
    {
        PlayerCamera = __NFUN_278__(CameraClass, self);
        // End:0x4C
        if(PlayerCamera != none)
        {
            PlayerCamera.InitializeFor(self);            
        }
        else
        {
            LogInternal("Couldn't Spawn Camera Actor for Player!!");
        }        
    }
    MaxTimeMargin = Class'GameInfo'.default.MaxTimeMargin;
    MaxResponseTime = default.MaxResponseTime * WorldInfo.TimeDilation;
    // End:0xCF
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        SpawnDefaultHUD();        
    }
    else
    {
        // End:0xF3
        if(WorldInfo.Game.AllowCheats(self))
        {
            AddCheats();
        }
    }
    DesiredFOV = DefaultFOV;
    SetViewTarget(self);
    LastActiveTime = WorldInfo.TimeSeconds;
    m_iShowSelfLastTick = GetGTicksGame();
    PrivateParam = new Class'R6PostProcessParam';    
    PrivateParam.m_fDistortionScale = 0.0000000;
    PrivateParam.m_bDistortionAllowInEditor = false;
    PrivateParam.m_bBlurRed = false;
    PrivateParam.m_bBlurGreen = false;
    PrivateParam.m_bBlurBlue = false;
    PrivateParam.m_fGlowAmount = 0.0000000;
    PrivateParam.m_fBlurScreenAmount = 0.0000000;
    PrivateParam.m_bBlurAllowInEditor = false;
    PrivateParam.m_iBlurRadialNbIteration = 0;
    PrivateParam.m_fBlurRadialStrength = 0.0000000;
    PrivateParam.m_fEdgeBlurStrength = 0.0000000;
    PrivateParam.m_bEdgeBlurAllowInEditor = false;
    PrivateParam.m_vEdgeBlurScale.X = 0.0000000;
    PrivateParam.m_vEdgeBlurScale.Y = 0.0000000;
    PrivateParam.m_fMotionBlurBlurAmount = 0.0000000;
    PrivateParam.m_fMotionBlurMaxVelocity = 0.0000000;
    PrivateParam.m_fDOFStrength = 0.0000000;
    PrivateParam.m_fDOFFalloffDistance = 0.0000000;
    PrivateParam.m_fDOFFalloffStrength = 0.0000000;
    PrivateParam.m_bDOFAllowInEditor = false;
    PrivateParam.m_DOFColor.R = 0;
    PrivateParam.m_DOFColor.G = 0;
    PrivateParam.m_DOFColor.B = 0;
    PrivateParam.m_DOFColor.A = 0;
    PrivateParam.m_fDOFTensor = 0.0000000;
    PrivateParam.m_bColorGelAllowInEditor = false;
    PrivateParam.m_vSceneBrightness.X = 0.0000000;
    PrivateParam.m_vSceneBrightness.Y = 0.0000000;
    PrivateParam.m_vSceneBrightness.Z = 0.0000000;
    PrivateParam.m_vSceneContrast.X = 0.0000000;
    PrivateParam.m_vSceneContrast.Y = 0.0000000;
    PrivateParam.m_vSceneContrast.Z = 0.0000000;
    PrivateParam.m_vSceneSaturation.X = 0.0000000;
    PrivateParam.m_vSceneSaturation.Y = 0.0000000;
    PrivateParam.m_vSceneSaturation.Z = 0.0000000;
    PrivateParam.m_bSceneAllowInEditor = false;
    PrivateParam.m_fNoiseScale = 0.0000000;
    PrivateParam.m_fNoiseSpeed = 0.0000000;
    PrivateParam.m_bNoiseAllowInEditor = false;
    m_PostProcessEffects.m_Value = PrivateParam;
    return;
}

// Export UPlayerController::execPreRender(FFrame&, void* const)
native function PreRender(Canvas Canvas);

// Export UPlayerController::execLoadPlayerProfile(FFrame&, void* const)
native function LoadPlayerProfile();

// Export UPlayerController::execSetPlayerInput(FFrame&, void* const)
native function SetPlayerInput();

// Export UPlayerController::execResetTimeMargin(FFrame&, void* const)
native final function ResetTimeMargin();

reliable server function ServerShortTimeout()
{
    local Actor A;

    bShortConnectTimeOut = true;
    ResetTimeMargin();
    // End:0xA5
    if(WorldInfo.Game.NumPlayers < 8)
    {
        // End:0xA1
        foreach AllActors(Class'Actor', A)
        {
            // End:0xA0
            if((A.NetUpdateFrequency < float(1)) && !A.bOnlyRelevantToOwner)
            {
                A.NetUpdateTime = FMin(A.NetUpdateTime, WorldInfo.TimeSeconds + (0.2000000 * FRand()));
            }            
        }                
    }
    else
    {
        // End:0x11A
        foreach AllActors(Class'Actor', A)
        {
            // End:0x119
            if((A.NetUpdateFrequency < float(1)) && !A.bOnlyRelevantToOwner)
            {
                A.NetUpdateTime = FMin(A.NetUpdateTime, WorldInfo.TimeSeconds + (0.5000000 * FRand()));
            }            
        }        
    }
    ClientSetRemainingTime(WorldInfo.GRI, WorldInfo.GRI.RemainingTime);
    return;
}

reliable client simulated function ClientSetRemainingTime(GameReplicationInfo GRI, int RemainingTime)
{
    // End:0x1F
    if(GRI != none)
    {
        GRI.RemainingTime = RemainingTime;
    }
    return;
}

function ServerGivePawn()
{
    GivePawn(Pawn);
    return;
}

event KickWarning()
{
    ReceiveLocalizedMessage(Class'GameMessage', 15);
    return;
}

// Export UPlayerController::execRoFChanged(FFrame&, void* const)
native simulated function RoFChanged();

// Export UPlayerController::execGetViewPointForNetRelevancy(FFrame&, void* const)
native function GetViewPointForNetRelevancy(out Vector vLocation, out Rotator rRotation);

// Export UPlayerController::execAddCheats(FFrame&, void* const)
native function AddCheats();

function SpawnDefaultHUD()
{
    // End:0x12
    if(LocalPlayer(Player) == none)
    {
        return;
    }
    myHUD = __NFUN_278__(Class'HUD', self);
    return;
}

function CleanOutSavedMoves()
{
    local SavedMove Next;

    J0x00:
    // End:0x39 [Loop If]
    if(SavedMoves != none)
    {
        Next = SavedMoves.NextMove;
        SavedMoves.Destroy();
        SavedMoves = Next;
        // [Loop Continue]
        goto J0x00;
    }
    // End:0x57
    if(PendingMove != none)
    {
        PendingMove.Destroy();
        PendingMove = none;
    }
    return;
}

// Export UPlayerController::execInitInputSystem(FFrame&, void* const)
native function InitInputSystem();

final function SetRumbleScale(float ScaleBy)
{
    // End:0x1F
    if(ForceFeedbackManager != none)
    {
        ForceFeedbackManager.ScaleAllWaveformsBy = ScaleBy;
    }
    return;
}

final function float GetRumbleScale()
{
    local float retval;

    retval = 1.0000000;
    // End:0x2A
    if(ForceFeedbackManager != none)
    {
        retval = ForceFeedbackManager.ScaleAllWaveformsBy;
    }
    return retval;
    return;
}

reliable client simulated function ClientGotoState(name NewState, optional name NewLabel)
{
    local bool bIsInState;

    bIsInState = IsInState(NewState);
    // End:0x30
    if((NewLabel == 'None') && bIsInState)
    {
        return;        
    }
    else
    {
        // End:0x59
        if((NewLabel == 'Begin') && !bIsInState)
        {
            GotoState(NewState);            
        }
        else
        {
            GotoState(NewState, NewLabel);
        }
    }
    return;
}

reliable server event AskForPawn()
{
    // End:0x1B
    if(GamePlayEndedState())
    {
        ClientGotoState(GetStateName(), 'Begin');        
    }
    else
    {
        // End:0x35
        if(Pawn != none)
        {
            GivePawn(Pawn);            
        }
        else
        {
            bFrozen = false;
            ServerRestartPlayer();
        }
    }
    return;
}

reliable client simulated event GivePawn(Pawn NewPawn)
{
    // End:0x1E
    if((NewPawn == none) || Pawn == NewPawn)
    {
        return;
    }
    Pawn = NewPawn;
    NewPawn.Controller = self;
    ClientRestart(Pawn);
    return;
}

function Possess(Pawn aPawn, bool bVehicleTransition)
{
    local Rotator PawnRot;

    // End:0x14
    if(PlayerReplicationInfo.bOnlySpectator)
    {
        return;
    }
    PawnRot = aPawn.Rotation;
    PawnRot.Roll = 0;
    SetRotation(PawnRot);
    aPawn.PossessedBy(self, bVehicleTransition);
    Pawn = aPawn;
    Pawn.bStasis = false;
    ResetTimeMargin();
    CleanOutSavedMoves();
    // End:0xD8
    if((Vehicle(Pawn) != none) && Vehicle(Pawn).Driver != none)
    {
        PlayerReplicationInfo.bIsFemale = Vehicle(Pawn).Driver.bIsFemale;        
    }
    else
    {
        PlayerReplicationInfo.bIsFemale = Pawn.bIsFemale;
    }
    Restart(bVehicleTransition);
    return;
}

function AcknowledgePossession(Pawn P)
{
    // End:0x5F
    if(LocalPlayer(Player) != none)
    {
        AcknowledgedPawn = P;
        // End:0x53
        if(P != none)
        {
            P.SetBaseEyeheight();
            P.EyeHeight = P.BaseEyeHeight;
        }
        ServerAcknowledgePossession(P);
    }
    return;
}

reliable server function ServerAcknowledgePossession(Pawn P)
{
    ResetTimeMargin();
    AcknowledgedPawn = P;
    return;
}

function UnPossess()
{
    // End:0x60
    if(Pawn != none)
    {
        SetLocation(Pawn.Location);
        Pawn.RemoteRole = ROLE_SimulatedProxy;
        Pawn.UnPossessed();
        CleanOutSavedMoves();
        // End:0x60
        if((GetViewTarget()) == Pawn)
        {
            SetViewTarget(self);
        }
    }
    Pawn = none;
    return;
}

function PawnDied(Pawn P)
{
    // End:0x11
    if(P != Pawn)
    {
        return;
    }
    // End:0x2D
    if(Pawn != none)
    {
        Pawn.RemoteRole = ROLE_SimulatedProxy;
    }
    PawnDied(P);
    return;
}

reliable client simulated function ClientSetHUD(class<HUD> newHUDType, class<ScoreBoard> newScoringType)
{
    // End:0x17
    if(myHUD != none)
    {
        myHUD.Destroy();
    }
    // End:0x2C
    if(newHUDType == none)
    {
        myHUD = none;        
    }
    else
    {
        myHUD = __NFUN_278__(newHUDType, self);
        // End:0x6D
        if((myHUD != none) && newScoringType != none)
        {
            myHUD.SpawnScoreBoard(newScoringType);
        }
    }
    return;
}

function HandlePickup(Inventory Inv)
{
    ReceiveLocalizedMessage(Inv.MessageClass,,,, Inv.Class);
    return;
}

reliable client simulated event ReceiveLocalizedMessage(class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    // End:0x35
    if((int(WorldInfo.NetMode) == int(NM_DedicatedServer)) || WorldInfo.GRI == none)
    {
        return;
    }
    Message.static.ClientReceive(self, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    return;
}

unreliable client simulated event ClientPlaySound(SoundCue ASound, R6EngineEnums.ESoundSlot eSlot, optional bool bDontUseOwnerLocation, optional bool bStopWhenOwnerDestroyed, optional Vector SoundLocation)
{
    PlaySound(ASound, eSlot, !bDontUseOwnerLocation,,, bStopWhenOwnerDestroyed, SoundLocation);
    return;
}

// Export UPlayerController::execClientHearSound(FFrame&, void* const)
unreliable client native simulated function AudioComponent ClientHearSound(SoundCue pSound, R6EngineEnums.ESoundSlot eSlot, Actor pSourceActor, Vector vSourceLocation, bool bStopWhenOwnerDestroyed, bool bUseOwnerLocation, int iSourceTriangle, int iZoneIndex);

unreliable client simulated event AudioComponent ReplicatedHearSound(SoundCue pSound, R6EngineEnums.ESoundSlot eSlot, Actor pSourceActor, Vector vSourceLocation, bool bStopWhenOwnerDestroyed, bool bUseOwnerLocation, int iSourceTriangle, int iZoneIndex)
{
    return ClientHearSound(pSound, eSlot, pSourceActor, vSourceLocation, bStopWhenOwnerDestroyed, bUseOwnerLocation, iSourceTriangle, iZoneIndex);
    return;
}

reliable client simulated event ClientMessage(coerce string S, optional name Type, optional float MsgLifeTime)
{
    // End:0x33
    if((int(WorldInfo.NetMode) == int(NM_DedicatedServer)) || WorldInfo.GRI == none)
    {
        return;
    }
    // End:0x4D
    if(Type == 'None')
    {
        Type = 'Event';
    }
    TeamMessage(PlayerReplicationInfo, S, Type, MsgLifeTime);
    return;
}

reliable client simulated event TeamMessage(PlayerReplicationInfo PRI, coerce string S, name Type, optional float MsgLifeTime)
{
    // End:0x30
    if(myHUD != none)
    {
        myHUD.Message(PRI, S, Type, MsgLifeTime);
    }
    // End:0x7E
    if(((Type == 'Say') || Type == 'TeamSay') && PRI != none)
    {
        S = (PRI.PlayerName $ ": ") $ S;
    }
    // End:0xB5
    if(Player != none)
    {
        LocalPlayer(Player).ViewportClient.ViewportConsole.OutputText(S);
    }
    return;
}

simulated function PlayBeepSound()
{
    return;
}

simulated event Destroyed()
{
    local SavedMove Next;
    local Vehicle DrivenVehicle;
    local Pawn Driver;

    // End:0xC1
    if(Pawn != none)
    {
        DrivenVehicle = Vehicle(Pawn);
        // End:0x8D
        if(DrivenVehicle != none)
        {
            Driver = DrivenVehicle.Driver;
            DrivenVehicle.DriverLeave(true);
            // End:0x8A
            if(Driver != none)
            {
                Driver.Health = 0;
                Driver.Died(self, Class'DmgType_Suicided', Driver.Location);
            }            
        }
        else
        {
            Pawn.Health = 0;
            Pawn.Died(self, Class'DmgType_Suicided', Pawn.Location);
        }
    }
    // End:0xD8
    if(myHUD != none)
    {
        myHUD.Destroy();
    }
    J0xD8:

    // End:0x111 [Loop If]
    if(FreeMoves != none)
    {
        Next = FreeMoves.NextMove;
        FreeMoves.Destroy();
        FreeMoves = Next;
        // [Loop Continue]
        goto J0xD8;
    }
    J0x111:

    // End:0x14A [Loop If]
    if(SavedMoves != none)
    {
        Next = SavedMoves.NextMove;
        SavedMoves.Destroy();
        SavedMoves = Next;
        // [Loop Continue]
        goto J0x111;
    }
    // End:0x168
    if(PlayerCamera != none)
    {
        PlayerCamera.Destroy();
        PlayerCamera = none;
    }
    Destroyed();
    return;
}

function FixFOV()
{
    FOVAngle = default.DefaultFOV;
    DesiredFOV = default.DefaultFOV;
    DefaultFOV = default.DefaultFOV;
    return;
}

function SetFOV(float NewFOV)
{
    DesiredFOV = NewFOV;
    FOVAngle = NewFOV;
    return;
}

function ResetFOV()
{
    DesiredFOV = DefaultFOV;
    FOVAngle = DefaultFOV;
    return;
}

exec function FOV(float F)
{
    ClientFOV(F);
    return;
}

unreliable client simulated function ClientFOV(float F)
{
    // End:0x22
    if(PlayerCamera != none)
    {
        PlayerCamera.SetFOV(F);
        return;
    }
    // End:0x85
    if(((F >= 80.0000000) || int(WorldInfo.NetMode) == int(NM_Standalone)) || PlayerReplicationInfo.bOnlySpectator)
    {
        DefaultFOV = FClamp(F, 1.0000000, 170.0000000);
        DesiredFOV = DefaultFOV;
        SaveConfig();
    }
    return;
}

exec function Mutate(string MutateString)
{
    ServerMutate(MutateString);
    return;
}

reliable server function ServerMutate(string MutateString)
{
    // End:0x1B
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        return;
    }
    WorldInfo.Game.Mutate(MutateString, self);
    return;
}

function bool AllowTextMessage(string Msg)
{
    local int I;

    // End:0x2F
    if((int(WorldInfo.NetMode) == int(NM_Standalone)) || PlayerReplicationInfo.bAdmin)
    {
        return true;
    }
    // End:0x64
    if((WorldInfo.Pauser == none) && (WorldInfo.TimeSeconds - LastBroadcastTime) < float(1))
    {
        return false;
    }
    // End:0xD3
    if((WorldInfo.TimeSeconds - LastBroadcastTime) < float(1))
    {
        Msg = Left(Msg, Clamp(Len(Msg) - 4, 8, 64));
        I = 0;
        J0xA6:

        // End:0xD3 [Loop If]
        if(I < 4)
        {
            // End:0xC9
            if(LastBroadcastString[I] ~= Msg)
            {
                return false;
            }
            I++;
            // [Loop Continue]
            goto J0xA6;
        }
    }
    I = 3;
    J0xDB:

    // End:0x10A [Loop If]
    if(I > 0)
    {
        LastBroadcastString[I] = LastBroadcastString[I - 1];
        I--;
        // [Loop Continue]
        goto J0xDB;
    }
    LastBroadcastTime = WorldInfo.TimeSeconds;
    return true;
    return;
}

exec function Say(string Msg)
{
    Msg = Left(Msg, 128);
    // End:0x2A
    if(AllowTextMessage(Msg))
    {
        ServerSay(Msg);
    }
    return;
}

unreliable server function ServerSay(string Msg)
{
    local PlayerController PC;

    Msg = WorldInfo.Game.StripColor(Msg);
    // End:0xD0
    if(PlayerReplicationInfo.bAdmin && Left(Msg, 1) == "#")
    {
        Msg = Right(Msg, Len(Msg) - 1);
        // End:0xCD
        foreach WorldInfo.AllControllers(Class'PlayerController', PC)
        {
            PC.ClearProgressMessages();
            PC.SetProgressTime(6.0000000);
            PC.SetProgressMessage(0, Msg, MakeColor(byte(255), byte(255), byte(255), byte(255)));            
        }        
        return;
    }
    WorldInfo.Game.Broadcast(self, Msg, 'Say');
    return;
}

exec function TeamSay(string Msg)
{
    Msg = Left(Msg, 128);
    // End:0x2A
    if(AllowTextMessage(Msg))
    {
        ServerTeamSay(Msg);
    }
    return;
}

unreliable server function ServerTeamSay(string Msg)
{
    LastActiveTime = WorldInfo.TimeSeconds;    
    WorldInfo.Game.StripColor(Msg);
    // End:0x6B
    if(!WorldInfo.GRI.GameClass.default.bTeamGame)
    {
        Say(Msg);
        return;
    }
    WorldInfo.Game.BroadcastTeam(self, WorldInfo.Game.ParseMessageString(self, Msg), 'TeamSay');
    return;
}

event bool IsDead()
{
    return false;
    return;
}

event PreClientTravel()
{
    return;
}

exec function Camera(name NewMode)
{
    ServerCamera(NewMode);
    return;
}

reliable server function ServerCamera(name NewMode)
{
    // End:0x1D
    if(NewMode == '1st')
    {
        NewMode = 'FirstPerson';        
    }
    else
    {
        // End:0x37
        if(NewMode == '3rd')
        {
            NewMode = 'ThirdPerson';
        }
    }
    SetCameraMode(NewMode);
    // End:0x6B
    if(PlayerCamera != none)
    {
        LogInternal("#### " $ string(PlayerCamera.CameraStyle));
    }
    return;
}

reliable client simulated function ClientSetCameraMode(name NewCamMode)
{
    // End:0x1F
    if(PlayerCamera != none)
    {
        PlayerCamera.CameraStyle = NewCamMode;
    }
    return;
}

function SetCameraMode(name NewCamMode)
{
    // End:0x44
    if(PlayerCamera != none)
    {
        PlayerCamera.CameraStyle = NewCamMode;
        // End:0x44
        if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
        {
            ClientSetCameraMode(NewCamMode);
        }
    }
    return;
}

event ResetCameraMode()
{
    // End:0x26
    if(Pawn != none)
    {
        SetCameraMode(Pawn.GetDefaultCameraMode(self));        
    }
    else
    {
        SetCameraMode('FirstPerson');
    }
    return;
}

function bool UsingFirstPersonCamera()
{
    return ((PlayerCamera == none) || PlayerCamera.CameraStyle == 'FirstPerson') && LocalPlayer(Player) != none;
    return;
}

function ClientVoiceMessage(PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name messagetype, byte messageID)
{
    return;
}

// Export UPlayerController::execForceDeathUpdate(FFrame&, void* const)
native final function ForceDeathUpdate();

// Export UPlayerController::execNativeDualServerMove(FFrame&, void* const)
native final function NativeDualServerMove(float TimeStamp0, Vector InAccel0, int View0, float TimeStamp, Vector InAccel, Vector ClientLoc, int View, float fVel);

unreliable server event DualServerMove(float TimeStamp0, Vector InAccel0, int View0, float TimeStamp, Vector InAccel, Vector ClientLoc, int View, float fVel)
{
    NativeDualServerMove(TimeStamp0, InAccel0, View0, TimeStamp, InAccel, ClientLoc, View, fVel);
    return;
}

// Export UPlayerController::execNativeOldServerMove(FFrame&, void* const)
native final function NativeOldServerMove(float OldTimeStamp, byte OldAccelX, byte OldAccelY, byte OldAccelZ);

unreliable server event OldServerMove(float OldTimeStamp, byte OldAccelX, byte OldAccelY, byte OldAccelZ)
{
    NativeOldServerMove(OldTimeStamp, OldAccelX, OldAccelY, OldAccelZ);
    return;
}

// Export UPlayerController::execSetPawnRotation(FFrame&, void* const)
native final function SetPawnRotation(Rotator rViewRot, float fDeltaTime);

function InitPlayerLocAndRot()
{
    return;
}

// Export UPlayerController::execNativeServerMove(FFrame&, void* const)
native final function NativeServerMove(float TimeStamp, Vector InAccel, Vector ClientLoc, int View, float fMoveVel);

// Export UPlayerController::execUpdateMoveVelocity(FFrame&, void* const)
native function UpdateMoveVelocity(float fMoveVel);

unreliable server event ServerMoveNothing(float fTimeStamp)
{
    NativeServerMove(fTimeStamp, m_vNetOptOldAcceleration, m_vNetOptOldLoc, m_iNetOptOldView, m_fNetOptOldMoveVelocity);
    return;
}

unreliable server event ServerMoveAccel(float fTimeStamp, Vector vAccel)
{
    NativeServerMove(fTimeStamp, vAccel, m_vNetOptOldLoc, m_iNetOptOldView, m_fNetOptOldMoveVelocity);
    return;
}

unreliable server event ServerMoveAccelLoc(float fTimeStamp, Vector vAccel, Vector vLoc)
{
    NativeServerMove(fTimeStamp, vAccel, vLoc, m_iNetOptOldView, m_fNetOptOldMoveVelocity);
    return;
}

unreliable server event ServerMoveAccelLocView(float fTimeStamp, Vector vAccel, Vector vLoc, int iView)
{
    NativeServerMove(fTimeStamp, vAccel, vLoc, iView, m_fNetOptOldMoveVelocity);
    return;
}

unreliable server event ServerMoveAccelLocVel(float fTimeStamp, Vector vAccel, Vector vLoc, float fVel)
{
    NativeServerMove(fTimeStamp, vAccel, vLoc, m_iNetOptOldView, fVel);
    return;
}

unreliable server event ServerMoveAccelView(float fTimeStamp, Vector vAccel, int iView)
{
    NativeServerMove(fTimeStamp, vAccel, m_vNetOptOldLoc, iView, m_fNetOptOldMoveVelocity);
    return;
}

unreliable server event ServerMoveAccelViewVel(float fTimeStamp, Vector vAccel, int iView, float fVel)
{
    NativeServerMove(fTimeStamp, vAccel, m_vNetOptOldLoc, iView, fVel);
    return;
}

unreliable server event ServerMoveAccelVel(float fTimeStamp, Vector vAccel, float fVel)
{
    NativeServerMove(fTimeStamp, vAccel, m_vNetOptOldLoc, m_iNetOptOldView, fVel);
    return;
}

unreliable server event ServerMoveLoc(float fTimeStamp, Vector vLoc)
{
    NativeServerMove(fTimeStamp, m_vNetOptOldAcceleration, vLoc, m_iNetOptOldView, m_fNetOptOldMoveVelocity);
    return;
}

unreliable server event ServerMoveLocViewVel(float fTimeStamp, Vector vLoc, int iView, float fVel)
{
    NativeServerMove(fTimeStamp, m_vNetOptOldAcceleration, vLoc, iView, fVel);
    return;
}

unreliable server event ServerMoveLocView(float fTimeStamp, Vector vLoc, int iView)
{
    NativeServerMove(fTimeStamp, m_vNetOptOldAcceleration, vLoc, iView, m_fNetOptOldMoveVelocity);
    return;
}

unreliable server event ServerMoveLocVel(float fTimeStamp, Vector vLoc, float fVel)
{
    NativeServerMove(fTimeStamp, m_vNetOptOldAcceleration, vLoc, m_iNetOptOldView, fVel);
    return;
}

unreliable server event ServerMoveView(float fTimeStamp, int iView)
{
    NativeServerMove(fTimeStamp, m_vNetOptOldAcceleration, m_vNetOptOldLoc, iView, m_fNetOptOldMoveVelocity);
    return;
}

unreliable server event ServerMoveViewVel(float fTimeStamp, int iView, float fVel)
{
    NativeServerMove(fTimeStamp, m_vNetOptOldAcceleration, m_vNetOptOldLoc, iView, fVel);
    return;
}

unreliable server event ServerMoveVel(float fTimeStamp, float fVel)
{
    NativeServerMove(fTimeStamp, m_vNetOptOldAcceleration, m_vNetOptOldLoc, m_iNetOptOldView, fVel);
    return;
}

unreliable server event ServerMove(float TimeStamp, Vector InAccel, Vector ClientLoc, int View, float fVel)
{
    NativeServerMove(TimeStamp, InAccel, ClientLoc, View, fVel);
    return;
}

// Export UPlayerController::execSendClientAdjustment(FFrame&, void* const)
native final function SendClientAdjustment();

unreliable server function ServerDrive(float InForward, float InStrafe, float aUp, bool InJump, int View)
{
    local Rotator ViewRotation;

    ViewRotation.Pitch = View / 32768;
    ViewRotation.Yaw = 2 * (View - (32768 * ViewRotation.Pitch));
    ViewRotation.Pitch *= float(2);
    ViewRotation.Roll = 0;
    SetRotation(ViewRotation);
    ProcessDrive(InForward, InStrafe, aUp, InJump);
    return;
}

function ProcessDrive(float InForward, float InStrafe, float InUp, bool InJump)
{
    ClientGotoState(GetStateName(), 'Begin');
    return;
}

// Export UPlayerController::execProcessMove(FFrame&, void* const)
native final function ProcessMove(float DeltaTime, Vector newAccel, Rotator DeltaRot);

// Export UPlayerController::execMoveAutonomous(FFrame&, void* const)
native final function MoveAutonomous(float DeltaTime, Vector newAccel, Rotator DeltaRot);

unreliable client simulated event ShortClientAdjustPosition(float TimeStamp, name NewState, Actor.EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, Actor NewBase)
{
    local Vector Floor;

    // End:0x1F
    if(Pawn != none)
    {
        Floor = Pawn.Floor;
    }
    NativeLongClientAdjustPosition(TimeStamp, NewState, newPhysics, NewLocX, NewLocY, NewLocZ, 0.0000000, 0.0000000, 0.0000000, NewBase, Floor.X, Floor.Y, Floor.Z);
    return;
}

reliable client simulated function ClientCapBandwidth(int Cap)
{
    ClientCap = Cap;
    // End:0x3B
    if((Player != none) && Player.CurrentNetSpeed > Cap)
    {
        SetNetSpeed(Cap);
    }
    return;
}

unreliable client simulated event ClientAckGoodMove(float TimeStamp)
{
    UpdatePing(TimeStamp);
    CurrentTimeStamp = TimeStamp;
    ClearAckedMoves();
    return;
}

unreliable client simulated event ClientAdjustPosition(float TimeStamp, name NewState, Actor.EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase)
{
    local Vector Floor;

    // End:0x1F
    if(Pawn != none)
    {
        Floor = Pawn.Floor;
    }
    NativeLongClientAdjustPosition(TimeStamp, NewState, newPhysics, NewLocX, NewLocY, NewLocZ, NewVelX, NewVelY, NewVelZ, NewBase, Floor.X, Floor.Y, Floor.Z);
    return;
}

// Export UPlayerController::execUpdatePing(FFrame&, void* const)
native final function UpdatePing(float TimeStamp);

// Export UPlayerController::execNativeLongClientAdjustPosition(FFrame&, void* const)
native final function NativeLongClientAdjustPosition(float TimeStamp, name NewState, Actor.EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase, float NewFloorX, float NewFloorY, float NewFloorZ);

unreliable client simulated event LongClientAdjustPosition(float TimeStamp, name NewState, Actor.EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase, float NewFloorX, float NewFloorY, float NewFloorZ)
{
    NativeLongClientAdjustPosition(TimeStamp, NewState, newPhysics, NewLocX, NewLocY, NewLocZ, NewVelX, NewVelY, NewVelZ, NewBase, NewFloorX, NewFloorY, NewFloorZ);
    return;
}

unreliable server event ServerUpdatePing(int NewPing)
{
    PlayerReplicationInfo.Ping = byte(Min(int(0.2500000 * float(NewPing)), 250));
    return;
}

// Export UPlayerController::execClearAckedMoves(FFrame&, void* const)
native final function ClearAckedMoves();

// Export UPlayerController::execClientUpdatePosition(FFrame&, void* const)
native final function ClientUpdatePosition();

// Export UPlayerController::execGetFreeMove(FFrame&, void* const)
native final function SavedMove GetFreeMove();

// Export UPlayerController::execCompressAccel(FFrame&, void* const)
native final function int CompressAccel(int C);

// Export UPlayerController::execReplicateMove(FFrame&, void* const)
native final function ReplicateMove(float DeltaTime, Vector newAccel, Rotator DeltaRot);

// Export UPlayerController::execCallServerMove(FFrame&, void* const)
native final function CallServerMove(SavedMove NewMove, Vector ClientLoc, int View, SavedMove OldMove);

// Export UPlayerController::execHandleWalking(FFrame&, void* const)
native function HandleWalking();

reliable server event ServerRestartGame()
{
    return;
}

unreliable client simulated function SetFOVAngle(float NewFOV)
{
    FOVAngle = NewFOV;
    return;
}

exec function Speech(name Type, int Index, string Callsign)
{
    ServerSpeech(Type, Index, Callsign);
    return;
}

reliable server function ServerSpeech(name Type, int Index, string Callsign)
{
    return;
}

exec event RestartLevel()
{
    // End:0x2C
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        ClientTravel("?restart", NM_ListenServer);
    }
    return;
}

exec function LocalTravel(string URL)
{
    // End:0x27
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        ClientTravel(URL, 2);
    }
    return;
}

exec function QuickSave()
{
    // End:0x75
    if(((Pawn != none) && Pawn.Health > 0) && int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        ClientMessage(QuickSaveString);        
        ConsoleCommand("DEFER SAVEGAME QUICKSAVE.SAV");
    }
    return;
}

exec function QuickLoad()
{
    // End:0x44
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {        
        ConsoleCommand("DEFER LOADGAME QUICKSAVE.SAV");
    }
    return;
}

reliable server event bool SetPause(bool bPause)
{
    local bool bResult;

    bFire = 0;
    bResult = WorldInfo.Game.SetPause(bPause, self);
    // End:0x5A
    if(bResult)
    {
        // End:0x5A
        if(ForceFeedbackManager != none)
        {
            ForceFeedbackManager.PauseWaveform(bPause);
        }
    }
    return bResult;
    return;
}

exec event Pause()
{
    ServerPause();
    return;
}

reliable server function ServerPause()
{
    // End:0x1F
    if(WorldInfo.Pauser == none)
    {
        SetPause(true);        
    }
    else
    {
        SetPause(false);
    }
    return;
}

exec function ShowMenu()
{
    // End:0x1C
    if(WorldInfo.Pauser == none)
    {
        SetPause(true);
    }
    return;
}

exec function ThrowWeapon()
{
    // End:0x23
    if((Pawn == none) || Pawn.Weapon == none)
    {
        return;
    }
    ServerThrowWeapon();
    return;
}

reliable server function ServerThrowWeapon()
{
    return;
}

exec function PrevWeapon()
{
    // End:0x16
    if(WorldInfo.Pauser != none)
    {
        return;
    }
    // End:0x33
    if(Pawn.Weapon == none)
    {
        SwitchToBestWeapon();
        return;
    }
    // End:0x60
    if(Pawn.InvManager != none)
    {
        Pawn.InvManager.PrevWeapon();
    }
    return;
}

exec function NextWeapon()
{
    // End:0x16
    if(WorldInfo.Pauser != none)
    {
        return;
    }
    // End:0x33
    if(Pawn.Weapon == none)
    {
        SwitchToBestWeapon();
        return;
    }
    // End:0x60
    if(Pawn.InvManager != none)
    {
        Pawn.InvManager.NextWeapon();
    }
    return;
}

// Export UPlayerController::execStartFire(FFrame&, void* const)
native exec function StartFire(optional byte FireModeNum);

// Export UPlayerController::execStopFire(FFrame&, void* const)
native exec function StopFire(optional byte FireModeNum);

exec function StartAltFire(optional byte FireModeNum)
{
    StartFire(1);
    return;
}

exec function StopAltFire(optional byte FireModeNum)
{
    StopFire(1);
    return;
}

simulated function GetTriggerUseList(float interactDistanceToCheck, float crosshairDist, float minDot, bool bUsuableOnly, out array<Trigger> out_useList)
{
    local int idx;
    local Vector cameraLoc;
    local Rotator cameraRot;
    local Trigger checkTrigger;
    local SeqEvent_Used UseSeq;

    // End:0x1D3
    if(Pawn != none)
    {
        GetPlayerViewPoint(cameraLoc, cameraRot);
        // End:0x1D2
        foreach Pawn.CollidingActors(Class'Trigger', checkTrigger, interactDistanceToCheck)
        {
            idx = 0;
            J0x42:

            // End:0x1D1 [Loop If]
            if(idx < checkTrigger.GeneratedEvents.Length)
            {
                UseSeq = SeqEvent_Used(checkTrigger.GeneratedEvents[idx]);
                // End:0x1C7
                if((((UseSeq != none) && (bUsuableOnly == false) || checkTrigger.GeneratedEvents[idx].CheckActivate(checkTrigger, Pawn, true)) && (Normal(checkTrigger.Location - cameraLoc) Dot Vector(cameraRot)) >= minDot) && (((UseSeq.bAimToInteract == true) && self.IsAimingAt(checkTrigger) == true) && VSize(Pawn.Location - checkTrigger.Location) <= UseSeq.InteractDistance) || (UseSeq.bAimToInteract == false) && VSize(Pawn.Location - checkTrigger.Location) <= UseSeq.InteractDistance)
                {
                    out_useList[out_useList.Length] = checkTrigger;
                    idx = checkTrigger.GeneratedEvents.Length;
                }
                idx++;
                // [Loop Continue]
                goto J0x42;
            }            
        }        
    }
    return;
}

exec function Use()
{
    // End:0x17
    if(int(Role) < int(ROLE_Authority))
    {
        PerformedUseAction();
    }
    ServerUse();
    return;
}

unreliable server function ServerUse()
{
    PerformedUseAction();
    return;
}

simulated function bool PerformedUseAction()
{
    // End:0x32
    if(WorldInfo.Pauser == PlayerReplicationInfo)
    {
        // End:0x30
        if(int(Role) == int(ROLE_Authority))
        {
            SetPause(false);
        }
        return true;
    }
    // End:0x55
    if((Pawn == none) || !Pawn.bCanUse)
    {
        return true;
    }
    // End:0x67
    if(int(Role) < int(ROLE_Authority))
    {
        return false;
    }
    // End:0x8E
    if(Vehicle(Pawn) != none)
    {
        return Vehicle(Pawn).DriverLeave(false);
    }
    // End:0x9A
    if(FindVehicleToDrive())
    {
        return true;
    }
    return TriggerInteracted();
    return;
}

function bool FindVehicleToDrive()
{
    local Vehicle V, Best;
    local Vector ViewDir, PawnLoc2D, VLoc2D;
    local float NewDot, BestDot;

    // End:0x43
    if((Vehicle(Pawn.Base) != none) && Vehicle(Pawn.Base).TryToDrive(Pawn))
    {
        return true;
    }
    PawnLoc2D = Pawn.Location;
    PawnLoc2D.Z = 0.0000000;
    ViewDir = Vector(Pawn.Rotation);
    // End:0x13D
    foreach Pawn.OverlappingActors(Class'Vehicle', V, Pawn.VehicleCheckRadius)
    {
        VLoc2D = V.Location;
        VLoc2D.Z = 0.0000000;
        NewDot = Normal(VLoc2D - PawnLoc2D) Dot ViewDir;
        // End:0x13C
        if((Best == none) || NewDot > BestDot)
        {
            // End:0x13C
            if(FastTrace(V.Location, Pawn.Location))
            {
                Best = V;
                BestDot = NewDot;
            }
        }        
    }    
    return (Best != none) && Best.TryToDrive(Pawn);
    return;
}

simulated function bool TriggerInteracted()
{
    local Actor A;
    local int idx;
    local float Weight;
    local bool bInserted;
    local Vector cameraLoc;
    local Rotator cameraRot;
    local array<Trigger> useList;
    local array<Actor> sortedList;
    local array<float> weightList;

    // End:0x1DA
    if(Pawn != none)
    {
        GetTriggerUseList(InteractDistance, 60.0000000, 0.0000000, true, useList);
        // End:0x1DA
        if(useList.Length > 0)
        {
            GetPlayerViewPoint(cameraLoc, cameraRot);
            J0x44:

            // End:0x199 [Loop If]
            if(useList.Length > 0)
            {
                A = useList[useList.Length - 1];
                useList.Length = useList.Length - 1;
                Weight = Normal(A.Location - cameraLoc) Dot Vector(cameraRot);
                Weight += (1.0000000 - (VSize(A.Location - Pawn.Location) / InteractDistance));
                bInserted = false;
                idx = 0;
                J0xDF:

                // End:0x15D [Loop If]
                if((idx < sortedList.Length) && !bInserted)
                {
                    // End:0x153
                    if(weightList[idx] < Weight)
                    {
                        sortedList.Insert(idx, 1);
                        weightList.Insert(idx, 1);
                        sortedList[idx] = A;
                        weightList[idx] = Weight;
                        bInserted = true;
                    }
                    idx++;
                    // [Loop Continue]
                    goto J0xDF;
                }
                // End:0x196
                if(!bInserted)
                {
                    idx = sortedList.Length;
                    sortedList[idx] = A;
                    weightList[idx] = Weight;
                }
                // [Loop Continue]
                goto J0x44;
            }
            idx = 0;
            J0x1A0:

            // End:0x1DA [Loop If]
            if(idx < sortedList.Length)
            {
                // End:0x1D0
                if(sortedList[idx].UsedBy(Pawn))
                {
                    return true;
                }
                idx++;
                // [Loop Continue]
                goto J0x1A0;
            }
        }
    }
    return false;
    return;
}

exec function Suicide()
{
    ServerSuicide();
    return;
}

reliable server function ServerSuicide()
{
    // End:0x5F
    if((Pawn != none) && ((WorldInfo.TimeSeconds - Pawn.LastStartTime) > float(10)) || int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        Pawn.Suicide();
    }
    return;
}

exec function SetName(coerce string S)
{
    ChangeName(S);
    UpdateURL("Name", S, true);
    SaveConfig();
    return;
}

reliable server function ChangeName(coerce string S)
{
    // End:0x1D
    if(Len(S) > 20)
    {
        S = Left(S, 20);
    }
    ReplaceText(S, " ", "_");
    ReplaceText(S, "\"", "");
    WorldInfo.Game.ChangeName(self, S, true);
    return;
}

exec function SwitchTeam()
{
    local int teamIdx;

    teamIdx = 0;
    // End:0x38
    if(PlayerReplicationInfo.Team != none)
    {
        teamIdx = PlayerReplicationInfo.Team.TeamIndex;
    }
    // End:0x4D
    if(teamIdx != 0)
    {
        teamIdx = 0;        
    }
    else
    {
        teamIdx = 1;
    }
    ServerChangeTeam(teamIdx);
    return;
}

exec function ChangeTeam(string TeamName)
{
    local int N;

    // End:0x1A
    if(TeamName ~= "blue")
    {
        N = 1;        
    }
    else
    {
        // End:0x33
        if(TeamName ~= "red")
        {
            N = 0;            
        }
        else
        {
            // End:0x7D
            if(((PlayerReplicationInfo == none) || PlayerReplicationInfo.Team == none) || PlayerReplicationInfo.Team.TeamIndex > 1)
            {
                N = 0;                
            }
            else
            {
                N = 1 - PlayerReplicationInfo.Team.TeamIndex;
            }
        }
    }
    ServerChangeTeam(N);
    return;
}

reliable server function ServerChangeTeam(int N)
{
    local int newTeam;
    local TeamInfo OldTeam;

    newTeam = N;
    // End:0x27
    if(usePreferredTeamIndex)
    {
        newTeam = preferredTeamIndex;
        usePreferredTeamIndex = false;
    }
    OldTeam = PlayerReplicationInfo.Team;
    WorldInfo.Game.ChangeTeam(self, newTeam, true);
    // End:0xAB
    if(WorldInfo.Game.bTeamGame && PlayerReplicationInfo.Team != OldTeam)
    {
        // End:0xAB
        if(Pawn != none)
        {
            Pawn.PlayerChangedTeam();
        }
    }
    UpdatePreferredTeamChoice();
    return;
}

exec function SwitchLevel(string URL)
{
    // End:0x65
    if(((int(WorldInfo.NetMode) == int(NM_Standalone)) || int(WorldInfo.NetMode) == int(NM_ListenServer)) || int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        WorldInfo.ServerTravel(URL, false);
    }
    return;
}

exec function ClearProgressMessages()
{
    ClientClearProgressMessages();
    return;
}

reliable client simulated function ClientClearProgressMessages()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x4D [Loop If]
    if(I < 4)
    {
        ProgressMessage[I] = "";
        ProgressColor[I] = MakeColor(byte(255), byte(255), byte(255), byte(255));
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

exec event SetProgressMessage(int Index, string S, Color C)
{
    ClientSetProgressMessage(Index, S, C);
    return;
}

reliable client simulated event ClientSetProgressMessage(int Index, string S, Color C)
{
    // End:0x2E
    if(Index < 4)
    {
        ProgressMessage[Index] = S;
        ProgressColor[Index] = C;
    }
    return;
}

exec event SetProgressTime(float T)
{
    ClientSetProgressTime(T);
    return;
}

exec event ApplyPreferredTeamChoice()
{
    // End:0x2B
    if((preferredTeamIndex == 1) || preferredTeamIndex == 0)
    {
        ServerChangeTeam(preferredTeamIndex);
        UpdatePreferredTeamChoice();
    }
    return;
}

function UpdatePreferredTeamChoice()
{
    // End:0x28
    if(PlayerReplicationInfo != none)
    {
        preferredTeamIndex = PlayerReplicationInfo.Team.TeamIndex;
    }
    return;
}

exec event OnMapReload()
{
    UpdatePreferredTeamChoice();
    usePreferredTeamIndex = preferredTeamIndex != -1;
    return;
}

reliable client simulated event ClientSetProgressTime(float T)
{
    ProgressTimeOut = T + WorldInfo.TimeSeconds;
    return;
}

function Restart(bool bVehicleTransition)
{
    Restart(bVehicleTransition);
    ServerTimeStamp = 0.0000000;
    ResetTimeMargin();
    SetViewTarget(Pawn);
    EnterStartState();
    ClientRestart(Pawn);
    ResetCameraMode();
    ClientStopForceFeedbackWaveform();
    return;
}

function EnterStartState()
{
    local name NewState;

    // End:0x6A
    if(Pawn.PhysicsVolume.bWaterVolume)
    {
        // End:0x53
        if(Pawn.HeadVolume.bWaterVolume)
        {
            Pawn.BreathTime = Pawn.UnderWaterTime;
        }
        NewState = Pawn.WaterMovementState;        
    }
    else
    {
        NewState = Pawn.LandMovementState;
    }
    // End:0x99
    if(IsInState(NewState))
    {
        BeginState(NewState);        
    }
    else
    {
        GotoState(NewState);
    }
    return;
}

reliable client simulated event ClientRestart(Pawn NewPawn)
{
    ResetPlayerMovementInput();
    Pawn = NewPawn;
    // End:0x3F
    if((Pawn != none) && Pawn.bTearOff)
    {
        UnPossess();
        Pawn = none;
    }
    AcknowledgePossession(Pawn);
    // End:0x62
    if(Pawn == none)
    {
        GotoState('WaitingForPawn');
        return;
    }
    Pawn.ClientRestart();
    // End:0x97
    if(int(Role) < int(ROLE_Authority))
    {
        SetViewTarget(Pawn);
        EnterStartState();
    }
    CleanOutSavedMoves();
    // End:0xB5
    if(int(Role) < int(ROLE_Authority))
    {
        ResetCameraMode();
    }
    return;
}

function GameHasEnded(optional Actor EndGameFocus, optional bool bIsWinner)
{
    SetViewTarget(EndGameFocus);
    GotoState('RoundEnded');
    ClientGameEnded(EndGameFocus, bIsWinner);
    return;
}

reliable client simulated function ClientGameEnded(Actor EndGameFocus, bool bIsWinner)
{
    SetViewTarget(EndGameFocus);
    GotoState('RoundEnded');
    return;
}

function NotifyChangedWeapon(Weapon PreviousWeapon, Weapon NewWeapon)
{
    return;
}

event PlayerTick(float DeltaTime)
{
    local PlayerController PC;

    // End:0x33
    if(!bShortConnectTimeOut)
    {
        // End:0x2B
        foreach LocalPlayerControllers(PC)
        {
            PC.bShortConnectTimeOut = true;            
        }        
        ServerShortTimeout();
    }
    // End:0x8F
    if(Pawn != AcknowledgedPawn)
    {
        // End:0x83
        if(int(Role) < int(ROLE_Authority))
        {
            // End:0x83
            if((AcknowledgedPawn != none) && AcknowledgedPawn.Controller == self)
            {
                AcknowledgedPawn.Controller = none;
            }
        }
        AcknowledgePossession(Pawn);
    }
    PlayerInput.PlayerInput(DeltaTime);
    // End:0xB3
    if(bUpdatePosition)
    {
        ClientUpdatePosition();
    }
    PlayerUpdate(DeltaTime);
    PlayerMove(DeltaTime);
    return;
}

function PlayerMove(float DeltaTime)
{
    return;
}

function PlayerUpdate(float fDeltaTime)
{
    return;
}

function bool AimingHelp()
{
    return (int(WorldInfo.NetMode) == int(NM_Standalone)) && bAimingHelp;
    return;
}

function Rotator GetAdjustedAimFor(Inventory W, Vector StartFireLoc)
{
    local Vector FireDir, AimSpot, OldAim, AimOffset, HitLocation, HitNormal;

    local Actor HitActor, BestTarget;
    local float bestAim, bestDist, projSpeed;
    local bool bNoZAdjust, bLeading, bInstantHit;
    local Rotator BaseAimRot, AimRot;

    // End:0x41
    if((W == none) || W.IsA('Weapon') && Weapon(W).bInstantHit)
    {
        bInstantHit = true;
    }
    // End:0x65
    if(Pawn != none)
    {
        BaseAimRot = Pawn.GetBaseAimRotation();        
    }
    else
    {
        BaseAimRot = Rotation;
    }
    FireDir = Vector(BaseAimRot);
    HitActor = Trace(HitLocation, HitNormal, StartFireLoc, StartFireLoc, true);
    // End:0x104
    if((HitActor != none) && HitActor.bProjTarget)
    {
        BestTarget = HitActor;
        bNoZAdjust = true;
        OldAim = HitLocation;
        bestDist = VSize(BestTarget.Location - Pawn.Location);        
    }
    else
    {
        bestAim = 0.9000000;
        // End:0x15B
        if(AimingHelp())
        {
            bestAim = 0.9300000;
            // End:0x138
            if(bInstantHit)
            {
                bestAim = 0.9700000;
            }
            // End:0x158
            if(FOVAngle < (DefaultFOV - float(8)))
            {
                bestAim = 0.9900000;
            }            
        }
        else
        {
            // End:0x16F
            if(bInstantHit)
            {
                bestAim = 1.0000000;
            }
        }
        BestTarget = PickTarget(Class'Pawn', bestAim, bestDist, FireDir, StartFireLoc, Weapon(W).WeaponRange);
        // End:0x1B5
        if(BestTarget == none)
        {
            return BaseAimRot;
        }
        OldAim = StartFireLoc + (FireDir * bestDist);
    }
    // End:0x1F2
    if(bInstantHit)
    {
        InstantWarnTarget(BestTarget, Weapon(W), FireDir);
    }
    ShotTarget = Pawn(BestTarget);
    // End:0x22E
    if(!bAimingHelp || int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        return BaseAimRot;
    }
    // End:0x310
    if(!bInstantHit)
    {
        // End:0x25A
        if(W != none)
        {
            projSpeed = W.GetTossInitialSpeed();
        }
        bestDist = VSize((BestTarget.Location + (BestTarget.Velocity * FMin(1.0000000, 0.0200000 + (bestDist / projSpeed)))) - StartFireLoc);
        bLeading = true;
        FireDir = (BestTarget.Location + (BestTarget.Velocity * FMin(1.0000000, 0.0200000 + (bestDist / projSpeed)))) - StartFireLoc;
        AimSpot = StartFireLoc + (bestDist * Normal(FireDir));        
    }
    else
    {
        FireDir = BestTarget.Location - StartFireLoc;
        AimSpot = StartFireLoc + (bestDist * Normal(FireDir));
    }
    AimOffset = AimSpot - OldAim;
    // End:0x44D
    if(ShotTarget != none)
    {
        // End:0x3B9
        if(bNoZAdjust || bLeading && Abs(AimOffset.Z) < ShotTarget.CylinderComponent.CollisionHeight)
        {
            AimSpot.Z = OldAim.Z;            
        }
        else
        {
            // End:0x40C
            if(AimOffset.Z < float(0))
            {
                AimSpot.Z = ShotTarget.Location.Z + (0.4000000 * ShotTarget.CylinderComponent.CollisionHeight);                
            }
            else
            {
                AimSpot.Z = ShotTarget.Location.Z - (0.7000000 * ShotTarget.CylinderComponent.CollisionHeight);
            }
        }        
    }
    else
    {
        AimSpot.Z = OldAim.Z;
    }
    // End:0x4F4
    if(!bLeading)
    {
        // End:0x4F1
        if(!bNoZAdjust)
        {
            AimRot = Rotator(AimSpot - StartFireLoc);
            // End:0x4C6
            if(FOVAngle < (DefaultFOV - float(8)))
            {
                AimRot.Yaw = (AimRot.Yaw + 200) - Rand(400);                
            }
            else
            {
                AimRot.Yaw = (AimRot.Yaw + 375) - Rand(750);
            }
            return AimRot;
        }        
    }
    else
    {
        // End:0x553
        if(!FastTrace(StartFireLoc + ((0.9000000 * bestDist) * Normal(FireDir)), StartFireLoc))
        {
            FireDir = BestTarget.Location - StartFireLoc;
            AimSpot = StartFireLoc + (bestDist * Normal(FireDir));
        }
    }
    return Rotator(AimSpot - StartFireLoc);
    return;
}

function bool NotifyLanded(Vector HitNormal)
{
    return bUpdating;
    return;
}

function AdjustView(float DeltaTime)
{
    // End:0x9F
    if(FOVAngle != DesiredFOV)
    {
        // End:0x4F
        if(FOVAngle > DesiredFOV)
        {
            FOVAngle = FOVAngle - FMax(7.0000000, (0.9000000 * DeltaTime) * (FOVAngle - DesiredFOV));            
        }
        else
        {
            FOVAngle = FOVAngle - FMin(-7.0000000, (0.9000000 * DeltaTime) * (FOVAngle - DesiredFOV));
        }
        // End:0x9F
        if(Abs(FOVAngle - DesiredFOV) <= float(10))
        {
            FOVAngle = DesiredFOV;
        }
    }
    return;
}

// Export UPlayerController::execSetViewTarget(FFrame&, void* const)
native function SetViewTarget(Actor NewViewTarget, optional float TransitionTime, optional bool bWaitRender);

reliable client simulated event ClientSetViewTarget(Actor A, optional float TransitionTime, optional bool bWaitRender)
{
    // End:0x1A
    if(A == none)
    {
        ServerVerifyViewTarget(bWaitRender);
    }
    SetViewTarget(A, TransitionTime, bWaitRender);
    return;
}

// Export UPlayerController::execGetViewTarget(FFrame&, void* const)
native function Actor GetViewTarget();

reliable server function ServerVerifyViewTarget(bool bWaitRender)
{
    local Actor TheViewTarget;

    TheViewTarget = GetViewTarget();
    // End:0x1A
    if(TheViewTarget == self)
    {
        return;
    }
    ClientSetViewTarget(TheViewTarget, 0.0000000, bWaitRender);
    return;
}

function ViewShake(float DeltaTime)
{
    return;
}

function TurnAround()
{
    // End:0x2F
    if(!bSetTurnRot)
    {
        TurnRot180 = Rotation;
        TurnRot180.Yaw += 32768;
        bSetTurnRot = true;
    }
    DesiredRotation = TurnRot180;
    return;
}

function UpdateRotation(float DeltaTime)
{
    local Rotator DeltaRot, NewRotation, ViewRotation;

    ViewRotation = Rotation;
    DesiredRotation = ViewRotation;
    // End:0x36
    if(int(PlayerInput.bTurn180) != 0)
    {
        TurnAround();        
    }
    else
    {
        bSetTurnRot = false;
        DeltaRot.Yaw = int(PlayerInput.aTurn);
        DeltaRot.Pitch = int(PlayerInput.aLookUp);
    }
    ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
    SetRotation(ViewRotation);
    ViewShake(DeltaTime);
    NewRotation = ViewRotation;
    NewRotation.Roll = Rotation.Roll;
    // End:0xE4
    if(Pawn != none)
    {
        Pawn.FaceRotation(NewRotation, DeltaTime);
    }
    return;
}

// Export UPlayerController::execProcessViewRotation(FFrame&, void* const)
native simulated function ProcessViewRotation(float DeltaTime, out Rotator rViewRotation, Rotator rDeltaRot);

// Export UPlayerController::execLimitViewRotation(FFrame&, void* const)
native function Rotator LimitViewRotation(Rotator ViewRotation, float ViewPitchMin, float ViewPitchMax);

function ClearDoubleClick()
{
    // End:0x1F
    if(PlayerInput != none)
    {
        PlayerInput.DoubleClickTimer = 0.0000000;
    }
    return;
}

function CheckJumpOrDuck()
{
    // End:0x2C
    if(bPressedJump && Pawn != none)
    {
        Pawn.DoJump(bUpdating);
    }
    return;
}

event bool IsSpectating()
{
    return false;
    return;
}

unreliable server event ServerViewNextPlayer()
{
    local Controller C, Pick;
    local bool bFound, bRealSpec;
    local Actor TheViewTarget;

    bRealSpec = PlayerReplicationInfo.bOnlySpectator;
    PlayerReplicationInfo.bOnlySpectator = true;
    // End:0xEC
    foreach WorldInfo.AllControllers(Class'Controller', C)
    {
        // End:0xEB
        if((C.Pawn != none) && WorldInfo.Game.CanSpectate(self, bRealSpec, C))
        {
            // End:0x97
            if(Pick == none)
            {
                Pick = C;
            }
            // End:0xB1
            if(bFound)
            {
                Pick = C;
                // End:0xEC
                break;
                // End:0xEB
                continue;
            }
            TheViewTarget = GetViewTarget();
            bFound = (TheViewTarget == C) || TheViewTarget == C.Pawn;
        }        
    }    
    SetViewTarget(Pick);
    ClientSetViewTarget(Pick);
    PlayerReplicationInfo.bOnlySpectator = bRealSpec;
    return;
}

unreliable server function ServerViewSelf()
{
    ResetCameraMode();
    SetViewTarget(self);
    ClientSetViewTarget(self);
    ClientMessage(OwnCamera, 'Event');
    return;
}

function bool CanRestartPlayer()
{
    return !PlayerReplicationInfo.bOnlySpectator;
    return;
}

exec function NoGun()
{
    // End:0x23
    if((Pawn == none) || Pawn.Weapon == none)
    {
        return;
    }
    Pawn.Weapon.Destroy();
    return;
}

exec function SetX(int newx)
{
    local Vector V;

    V.X = float(newx);
    Pawn.Mesh.SetTranslation(V);
    return;
}

exec function Sety(int newy)
{
    local Vector V;

    V.Y = float(newy);
    Pawn.Mesh.SetTranslation(V);
    return;
}

exec function Setz(int newz)
{
    local Vector V;

    V.Z = float(newz);
    Pawn.Mesh.SetTranslation(V);
    return;
}

exec function showpp()
{
    LogInternal(("### Pawn.PrePivot" $ string(Pawn.PrePivot)) @ string(Pawn.CylinderComponent.CollisionHeight));
    return;
}

function DrawHUD(HUD H)
{
    // End:0x20
    if(Pawn != none)
    {
        Pawn.DrawHUD(H);
    }
    PlayerInput.DrawHUD(H);
    return;
}

simulated function OnToggleInput(SeqAct_ToggleInput inAction)
{
    // End:0x50
    if(inAction.InputLinks[0].bHasImpulse)
    {
        // End:0x33
        if(inAction.bToggleMovement)
        {
            IgnoreMoveInput(false);
        }
        // End:0x4D
        if(inAction.bToggleTurning)
        {
            IgnoreLookInput(false);
        }        
    }
    else
    {
        // End:0xA0
        if(inAction.InputLinks[1].bHasImpulse)
        {
            // End:0x83
            if(inAction.bToggleMovement)
            {
                IgnoreMoveInput(true);
            }
            // End:0x9D
            if(inAction.bToggleTurning)
            {
                IgnoreLookInput(true);
            }            
        }
        else
        {
            // End:0xFE
            if(inAction.InputLinks[2].bHasImpulse)
            {
                // End:0xDC
                if(inAction.bToggleMovement)
                {
                    IgnoreMoveInput(!IsMoveInputIgnored());
                }
                // End:0xFE
                if(inAction.bToggleTurning)
                {
                    IgnoreLookInput(!IsLookInputIgnored());
                }
            }
        }
    }
    return;
}

function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    DisplayDebug(HUD, out_YL, out_YPos);
    // End:0xCE
    if(HUD.ShouldDisplayDebug("camera"))
    {
        // End:0x5E
        if(PlayerCamera != none)
        {
            PlayerCamera.DisplayDebug(HUD, out_YL, out_YPos);            
        }
        else
        {
            HUD.Canvas.SetDrawColor(byte(255), 0, 0);
            HUD.Canvas.__NFUN_465__("NO CAMERA");
            out_YPos += out_YL;
            HUD.Canvas.SetPos(4.0000000, out_YPos);
        }
    }
    return;
}

simulated function OnSetCameraTarget(SeqAct_SetCameraTarget inAction)
{
    local Actor RealCameraTarget;

    RealCameraTarget = inAction.CameraTarget;
    // End:0x3D
    if(Controller(RealCameraTarget) != none)
    {
        RealCameraTarget = Controller(RealCameraTarget).Pawn;
    }
    SetViewTarget(RealCameraTarget);
    return;
}

simulated function OnToggleHUD(SeqAct_ToggleHUD inAction)
{
    // End:0xA0
    if(myHUD != none)
    {
        // End:0x38
        if(inAction.InputLinks[0].bHasImpulse)
        {
            myHUD.bShowHUD = true;            
        }
        else
        {
            // End:0x65
            if(inAction.InputLinks[1].bHasImpulse)
            {
                myHUD.bShowHUD = false;                
            }
            else
            {
                // End:0xA0
                if(inAction.InputLinks[2].bHasImpulse)
                {
                    myHUD.bShowHUD = !myHUD.bShowHUD;
                }
            }
        }
    }
    return;
}

exec function CauseEvent(name EventName)
{
    local array<SequenceObject> AllConsoleEvents;
    local SeqEvent_Console ConsoleEvt;
    local Sequence GameSeq;
    local int idx;

    GameSeq = WorldInfo.GetGameSequence();
    // End:0xA7
    if(GameSeq != none)
    {
        GameSeq.FindSeqObjectsByClass(Class'SeqEvent_Console', true, AllConsoleEvents);
        idx = 0;
        J0x42:

        // End:0xA7 [Loop If]
        if(idx < AllConsoleEvents.Length)
        {
            ConsoleEvt = SeqEvent_Console(AllConsoleEvents[idx]);
            // End:0x9D
            if((ConsoleEvt != none) && EventName == ConsoleEvt.ConsoleEventName)
            {
                ActivateEvent(ConsoleEvt, Pawn);
            }
            idx++;
            // [Loop Continue]
            goto J0x42;
        }
    }
    return;
}

exec function CE(name inEventName)
{
    CauseEvent(inEventName);
    return;
}

exec function ListConsoleEvents()
{
    local array<SequenceObject> ConsoleEvents;
    local SeqEvent_Console ConsoleEvt;
    local Sequence GameSeq;
    local int idx;

    GameSeq = WorldInfo.GetGameSequence();
    // End:0x11F
    if(GameSeq != none)
    {
        LogInternal("Console events:");
        ClientMessage("Console events:",, 15.0000000);
        GameSeq.FindSeqObjectsByClass(Class'SeqEvent_Console', true, ConsoleEvents);
        idx = 0;
        J0x75:

        // End:0x11F [Loop If]
        if(idx < ConsoleEvents.Length)
        {
            ConsoleEvt = SeqEvent_Console(ConsoleEvents[idx]);
            // End:0x115
            if((ConsoleEvt != none) && ConsoleEvt.bEnabled)
            {
                LogInternal(("-" @ string(ConsoleEvt.ConsoleEventName)) @ ConsoleEvt.EventDesc);
                ClientMessage(("-" @ string(ConsoleEvt.ConsoleEventName)) @ ConsoleEvt.EventDesc,, 15.0000000);
            }
            idx++;
            // [Loop Continue]
            goto J0x75;
        }
    }
    return;
}

function OnForceFeedback(SeqAct_ForceFeedback Action)
{
    // End:0x30
    if(Action.InputLinks[0].bHasImpulse)
    {
        ClientPlayForceFeedbackWaveform(Action.FFWaveform);        
    }
    else
    {
        // End:0x5D
        if(Action.InputLinks[1].bHasImpulse)
        {
            ClientStopForceFeedbackWaveform(Action.FFWaveform);
        }
    }
    return;
}

unreliable client final simulated event ClientPlayForceFeedbackWaveform(ForceFeedbackWaveform FFWaveform)
{
    // End:0x20
    if(ForceFeedbackManager != none)
    {
        ForceFeedbackManager.PlayForceFeedbackWaveform(FFWaveform);
    }
    return;
}

unreliable client final simulated event ClientPlayForceFeedbackWaveformId(DamageType.EForceFeedbackWaveform eWaveform)
{
    ClientPlayForceFeedbackWaveform(GetControlsConfig().GetWaveform(eWaveform));
    return;
}

unreliable client final simulated event ClientStopForceFeedbackWaveform(optional ForceFeedbackWaveform FFWaveform)
{
    // End:0x21
    if(ForceFeedbackManager != none)
    {
        ForceFeedbackManager.StopForceFeedbackWaveform(FFWaveform);
    }
    return;
}

unreliable client final simulated event ClientStopForceFeedbackWaveformId(optional DamageType.EForceFeedbackWaveform eWaveform)
{
    ClientStopForceFeedbackWaveform(GetControlsConfig().GetWaveform(eWaveform));
    return;
}

function CameraShake(float Duration, Vector newRotAmplitude, Vector newRotFrequency, Vector newLocAmplitude, Vector newLocFrequency, float newFOVAmplitude, float newFOVFrequency)
{
    return;
}

// Export UPlayerController::execAddInteraction(FFrame&, void* const)
native final function AddInteraction(Interaction InterToAdd);

// Export UPlayerController::execRemoveInteraction(FFrame&, void* const)
native final function RemoveInteraction(Interaction InteractionToRemove);

// Export UPlayerController::execPushUpInteraction(FFrame&, void* const)
native final function PushUpInteraction(Interaction InteractionToPushUp);

event PostLoadGame()
{
    ClientSetHUD(WorldInfo.Game.HUDType, WorldInfo.Game.ScoreBoardType);
    return;
}

// Export UPlayerController::execUpdateDesiredPrePivot(FFrame&, void* const)
native final function UpdateDesiredPrePivot(Vector NewLocation, Vector OldLocation);

simulated function OnToggleCinematicMode(SeqAct_ToggleCinematicMode Action)
{
    // End:0x24
    if(Action.InputLinks[0].bHasImpulse)
    {
        bCinematicMode = true;        
    }
    else
    {
        // End:0x48
        if(Action.InputLinks[1].bHasImpulse)
        {
            bCinematicMode = false;            
        }
        else
        {
            // End:0x71
            if(Action.InputLinks[2].bHasImpulse)
            {
                bCinematicMode = !bCinematicMode;
            }
        }
    }
    // End:0xE1
    if(bCinematicMode)
    {
        // End:0xAA
        if((Pawn != none) && Action.bHidePlayer)
        {
            Pawn.bHidden = true;
        }
        // End:0xC4
        if(Action.bDisableMovement)
        {
            IgnoreMoveInput(true);
        }
        // End:0xDE
        if(Action.bDisableTurning)
        {
            IgnoreLookInput(true);
        }        
    }
    else
    {
        // End:0xFD
        if(Pawn != none)
        {
            Pawn.bHidden = false;
        }
        IgnoreMoveInput(false);
        IgnoreLookInput(false);
    }
    return;
}

function IgnoreMoveInput(bool bNewMoveInput)
{
    bIgnoreMoveInput = byte(Max(int(bIgnoreMoveInput) + ((bNewMoveInput) ? 1 : -1), 0));
    return;
}

function bool IsMoveInputIgnored()
{
    return int(bIgnoreMoveInput) > 0;
    return;
}

function IgnoreLookInput(bool bNewLookInput)
{
    bIgnoreLookInput = byte(Max(int(bIgnoreLookInput) + ((bNewLookInput) ? 1 : -1), 0));
    return;
}

function bool IsLookInputIgnored()
{
    return int(bIgnoreLookInput) > 0;
    return;
}

function ResetPlayerMovementInput()
{
    bIgnoreMoveInput = default.bIgnoreMoveInput;
    bIgnoreLookInput = default.bIgnoreLookInput;
    return;
}

function OnConsoleCommand(SeqAct_ConsoleCommand inAction)
{
    ConsoleCommand(inAction.Command);
    return;
}

function OnForceGarbageCollection(SeqAct_ForceGarbageCollection inAction)
{
    WorldInfo.ForceGarbageCollection();
    return;
}

simulated function bool IsAimingAt(Actor ATarget)
{
    local Vector cameraLoc;
    local Rotator cameraRot;

    GetPlayerViewPoint(cameraLoc, cameraRot);
    return (Normal(ATarget.Location - cameraLoc) Dot Vector(cameraRot)) >= 0.9800000;
    return;
}

exec function LogExTest()
{
    __NFUN_900__(3, 'testCategory', "test logex");
    return;
}

exec function LogInfoTest()
{
    __NFUN_904__('RandomCategory', "LogInfo test");
    return;
}

event LevelStreamingStatusChanged(LevelStreaming LevelObject, bool bNewShouldBeLoaded, bool bNewShouldBeVisible)
{
    ClientUpdateLevelStreamingStatus(LevelObject.PackageName, bNewShouldBeLoaded, bNewShouldBeVisible);
    return;
}

// Export UPlayerController::execClientUpdateLevelStreamingStatus(FFrame&, void* const)
reliable client native simulated function ClientUpdateLevelStreamingStatus(name PackageName, bool bNewShouldBeLoaded, bool bNewShouldBeVisible);

reliable server event ServerFullAmmoCheat()
{
    return;
}

// Export UPlayerController::execIsSnakeCam(FFrame&, void* const)
native function bool IsSnakeCam();

state PlayerWalking
{
    function NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
    {
        // End:0x25
        if(NewVolume.bWaterVolume)
        {
            GotoState(Pawn.WaterMovementState);
        }
        return;
    }

    function PlayerMove(float DeltaTime)
    {
        local Vector X, Y, Z, newAccel;
        local Rotator OldRotation;
        local bool bSaveJump;

        // End:0x18
        if(Pawn == none)
        {
            GotoState('Dead');            
        }
        else
        {
            GetAxes(Pawn.Rotation, X, Y, Z);
            newAccel = (PlayerInput.aForward * X) + (PlayerInput.aStrafe * Y);
            newAccel.Z = 0.0000000;
            // End:0x9D
            if(VSize(newAccel) < 1.0000000)
            {
                newAccel = vect(0.0000000, 0.0000000, 0.0000000);
            }
            Pawn.CheckBob(DeltaTime, Y);
            OldRotation = Rotation;
            UpdateRotation(DeltaTime);
            bDoubleJump = false;
            // End:0x107
            if(bPressedJump && Pawn.CannotJumpNow())
            {
                bSaveJump = true;
                bPressedJump = false;                
            }
            else
            {
                bSaveJump = false;
            }
            // End:0x13F
            if(int(Role) < int(ROLE_Authority))
            {
                ReplicateMove(DeltaTime, newAccel, OldRotation - Rotation);                
            }
            else
            {
                ProcessMove(DeltaTime, newAccel, OldRotation - Rotation);
            }
            bPressedJump = bSaveJump;
        }
        return;
    }

    function BeginState(name PreviousStateName)
    {
        DoubleClickDir = 0;
        bPressedJump = false;
        GroundPitch = 0;
        // End:0x75
        if(Pawn != none)
        {
            Pawn.ShouldCrouch(false);
            // End:0x75
            if((int(Pawn.Physics) != int(2)) && int(Pawn.Physics) != int(10))
            {
                Pawn.SetPhysics(1);
            }
        }
        return;
    }

    function EndState(name NextStateName)
    {
        GroundPitch = 0;
        // End:0x30
        if(Pawn != none)
        {
            // End:0x30
            if(int(bDuck) == 0)
            {
                Pawn.ShouldCrouch(false);
            }
        }
        return;
    }
Begin:

    stop;            
}

state PlayerClimbing
{
    function NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
    {
        // End:0x28
        if(NewVolume.bWaterVolume)
        {
            GotoState(Pawn.WaterMovementState);            
        }
        else
        {
            GotoState(Pawn.LandMovementState);
        }
        return;
    }

    function PlayerMove(float DeltaTime)
    {
        local Vector X, Y, Z, newAccel;
        local Rotator OldRotation, ViewRotation;

        GetAxes(Rotation, X, Y, Z);
        // End:0x91
        if(Pawn.OnLadder != none)
        {
            newAccel = PlayerInput.aForward * Pawn.OnLadder.ClimbDir;
            // End:0x8E
            if(Pawn.OnLadder.bAllowLadderStrafing)
            {
                newAccel += (PlayerInput.aStrafe * Y);
            }            
        }
        else
        {
            newAccel = (PlayerInput.aForward * X) + (PlayerInput.aStrafe * Y);
        }
        // End:0xE7
        if(VSize(newAccel) < 1.0000000)
        {
            newAccel = vect(0.0000000, 0.0000000, 0.0000000);
        }
        ViewRotation = Rotation;
        SetRotation(ViewRotation);
        OldRotation = Rotation;
        UpdateRotation(DeltaTime);
        // End:0x142
        if(int(Role) < int(ROLE_Authority))
        {
            ReplicateMove(DeltaTime, newAccel, OldRotation - Rotation);            
        }
        else
        {
            ProcessMove(DeltaTime, newAccel, OldRotation - Rotation);
        }
        bPressedJump = false;
        return;
    }

    function BeginState(name PreviousStateName)
    {
        Pawn.ShouldCrouch(false);
        bPressedJump = false;
        return;
    }

    function EndState(name NextStateName)
    {
        // End:0x1C
        if(Pawn != none)
        {
            Pawn.ShouldCrouch(false);
        }
        return;
    }
    stop;
}

state PlayerDriving
{
    function ProcessDrive(float InForward, float InStrafe, float InUp, bool InJump)
    {
        local Vehicle CurrentVehicle;

        CurrentVehicle = Vehicle(Pawn);
        // End:0x1D
        if(CurrentVehicle == none)
        {
            return;
        }
        CurrentVehicle.SetInputs(InForward, -InStrafe, InUp);
        return;
    }

    function PlayerMove(float DeltaTime)
    {
        local Vehicle CurrentVehicle;

        CurrentVehicle = Vehicle(Pawn);
        UpdateRotation(DeltaTime);
        // End:0xE0
        if(int(Role) < int(ROLE_Authority))
        {
            // End:0x73
            if(CurrentVehicle != none)
            {
                CurrentVehicle.SetInputs(PlayerInput.RawJoyUp, -PlayerInput.RawJoyRight, PlayerInput.aUp);
            }
            ServerDrive(PlayerInput.RawJoyUp, PlayerInput.RawJoyRight, PlayerInput.aUp, bPressedJump, ((32767 & (Rotation.Pitch / 2)) * 32768) + (32767 & (Rotation.Yaw / 2)));            
        }
        else
        {
            ProcessDrive(PlayerInput.RawJoyUp, PlayerInput.RawJoyRight, PlayerInput.aUp, bPressedJump);
        }
        CheckJumpOrDuck();
        bPressedJump = false;
        return;
    }

    unreliable server function ServerUse()
    {
        local Vehicle CurrentVehicle;

        CurrentVehicle = Vehicle(Pawn);
        CurrentVehicle.DriverLeave(false);
        return;
    }

    function BeginState(name PreviousStateName)
    {
        CleanOutSavedMoves();
        return;
    }

    function EndState(name NextStateName)
    {
        CleanOutSavedMoves();
        return;
    }
    stop;
}

state PlayerSpidering
{
    event bool NotifyHitWall(Vector HitNormal, Actor HitActor)
    {
        Pawn.SetPhysics(8);
        Pawn.SetBase(HitActor, HitNormal);
        return true;
        return;
    }

    function UpdateRotation(float DeltaTime)
    {
        local Rotator ViewRotation;
        local Vector MyFloor, CrossDir, FwdDir, OldFwdDir, OldX, RealFloor;

        bSetTurnRot = false;
        // End:0x54
        if((Pawn.Base == none) || Pawn.Floor == vect(0.0000000, 0.0000000, 0.0000000))
        {
            MyFloor = vect(0.0000000, 0.0000000, 1.0000000);            
        }
        else
        {
            MyFloor = Pawn.Floor;
        }
        // End:0x1CD
        if(MyFloor != OldFloor)
        {
            RealFloor = MyFloor;
            MyFloor = Normal(((float(6) * DeltaTime) * MyFloor) + ((float(1) - (float(6) * DeltaTime)) * OldFloor));
            // End:0xD6
            if((RealFloor Dot MyFloor) > 0.9990000)
            {
                MyFloor = RealFloor;
            }
            CrossDir = Normal(RealFloor Cross OldFloor);
            FwdDir = CrossDir Cross MyFloor;
            OldFwdDir = CrossDir Cross OldFloor;
            ViewX = ((MyFloor * (OldFloor Dot ViewX)) + (CrossDir * (CrossDir Dot ViewX))) + (FwdDir * (OldFwdDir Dot ViewX));
            ViewX = Normal(ViewX);
            ViewZ = ((MyFloor * (OldFloor Dot ViewZ)) + (CrossDir * (CrossDir Dot ViewZ))) + (FwdDir * (OldFwdDir Dot ViewZ));
            ViewZ = Normal(ViewZ);
            OldFloor = MyFloor;
            ViewY = Normal(MyFloor Cross ViewX);
        }
        // End:0x359
        if((PlayerInput.aTurn != float(0)) || PlayerInput.aLookUp != float(0))
        {
            // End:0x24B
            if(PlayerInput.aTurn != float(0))
            {
                ViewX = Normal(ViewX + ((float(2) * ViewY) * Sin((0.0005000 * DeltaTime) * PlayerInput.aTurn)));
            }
            // End:0x345
            if(PlayerInput.aLookUp != float(0))
            {
                OldX = ViewX;
                ViewX = Normal(ViewX + ((float(2) * ViewZ) * Sin((0.0005000 * DeltaTime) * PlayerInput.aLookUp)));
                ViewZ = Normal(ViewX Cross ViewY);
                // End:0x345
                if((ViewZ Dot MyFloor) < 0.7070000)
                {
                    OldX = Normal(OldX - (MyFloor * (MyFloor Dot OldX)));
                    // End:0x31D
                    if((ViewX Dot MyFloor) > float(0))
                    {
                        ViewX = Normal(OldX + MyFloor);                        
                    }
                    else
                    {
                        ViewX = Normal(OldX - MyFloor);
                    }
                    ViewZ = Normal(ViewX Cross ViewY);
                }
            }
            ViewY = Normal(MyFloor Cross ViewX);
        }
        ViewRotation = OrthoRotation(ViewX, ViewY, ViewZ);
        SetRotation(ViewRotation);
        ViewShake(DeltaTime);
        Pawn.FaceRotation(ViewRotation, DeltaTime);
        return;
    }

    function bool NotifyLanded(Vector HitNormal)
    {
        Pawn.SetPhysics(8);
        return bUpdating;
        return;
    }

    function NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
    {
        // End:0x25
        if(NewVolume.bWaterVolume)
        {
            GotoState(Pawn.WaterMovementState);
        }
        return;
    }

    function PlayerMove(float DeltaTime)
    {
        local Vector newAccel;
        local Rotator OldRotation, ViewRotation;
        local bool bSaveJump;

        GroundPitch = 0;
        ViewRotation = Rotation;
        Pawn.CheckBob(DeltaTime, vect(0.0000000, 0.0000000, 0.0000000));
        SetRotation(ViewRotation);
        OldRotation = Rotation;
        UpdateRotation(DeltaTime);
        newAccel = (PlayerInput.aForward * Normal(ViewX - (OldFloor * (OldFloor Dot ViewX)))) + (PlayerInput.aStrafe * ViewY);
        // End:0xC1
        if(VSize(newAccel) < 1.0000000)
        {
            newAccel = vect(0.0000000, 0.0000000, 0.0000000);
        }
        // End:0xF2
        if(bPressedJump && Pawn.CannotJumpNow())
        {
            bSaveJump = true;
            bPressedJump = false;            
        }
        else
        {
            bSaveJump = false;
        }
        // End:0x12A
        if(int(Role) < int(ROLE_Authority))
        {
            ReplicateMove(DeltaTime, newAccel, OldRotation - Rotation);            
        }
        else
        {
            ProcessMove(DeltaTime, newAccel, OldRotation - Rotation);
        }
        bPressedJump = bSaveJump;
        return;
    }

    function BeginState(name PreviousStateName)
    {
        OldFloor = vect(0.0000000, 0.0000000, 1.0000000);
        GetAxes(Rotation, ViewX, ViewY, ViewZ);
        DoubleClickDir = 0;
        Pawn.ShouldCrouch(false);
        bPressedJump = false;
        // End:0x71
        if(int(Pawn.Physics) != int(2))
        {
            Pawn.SetPhysics(8);
        }
        GroundPitch = 0;
        Pawn.bCrawler = true;
        Pawn.SetCollisionSize(Pawn.default.CylinderComponent.CollisionHeight, Pawn.default.CylinderComponent.CollisionHeight);
        return;
    }

    function EndState(name NextStateName)
    {
        GroundPitch = 0;
        // End:0x7C
        if(Pawn != none)
        {
            Pawn.SetCollisionSize(Pawn.default.CylinderComponent.CollisionRadius, Pawn.default.CylinderComponent.CollisionHeight);
            Pawn.ShouldCrouch(false);
            Pawn.bCrawler = Pawn.default.bCrawler;
        }
        return;
    }
    stop;
}

state PlayerSwimming
{
    function bool WantsSmoothedView()
    {
        return !Pawn.bJustLanded;
        return;
    }

    function bool NotifyLanded(Vector HitNormal)
    {
        // End:0x2C
        if(Pawn.PhysicsVolume.bWaterVolume)
        {
            Pawn.SetPhysics(3);            
        }
        else
        {
            GotoState(Pawn.LandMovementState);
        }
        return bUpdating;
        return;
    }

    function NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
    {
        local Actor HitActor;
        local Vector HitLocation, HitNormal, checkpoint, X, Y, Z;

        // End:0x220
        if(!NewVolume.bWaterVolume)
        {
            Pawn.SetPhysics(2);
            // End:0x21D
            if(Pawn.Velocity.Z > float(0))
            {
                GetAxes(Rotation, X, Y, Z);
                Pawn.bUpAndOut = ((X Dot Pawn.Acceleration) > float(0)) && (Pawn.Acceleration.Z > float(0)) || Rotation.Pitch > 2048;
                // End:0x13A
                if(Pawn.bUpAndOut && Pawn.CheckWaterJump(HitNormal))
                {
                    Pawn.Velocity.Z = FMax(Pawn.JumpZ, 420.0000000) + (float(2) * Pawn.CylinderComponent.CollisionRadius);
                    GotoState(Pawn.LandMovementState);                    
                }
                else
                {
                    // End:0x183
                    if((Pawn.Velocity.Z > float(160)) || !Pawn.TouchingWaterVolume())
                    {
                        GotoState(Pawn.LandMovementState);                        
                    }
                    else
                    {
                        checkpoint = Pawn.Location;
                        checkpoint.Z -= (Pawn.CylinderComponent.CollisionHeight + 6.0000000);
                        HitActor = Trace(HitLocation, HitNormal, checkpoint, Pawn.Location, false);
                        // End:0x20C
                        if(HitActor != none)
                        {
                            GotoState(Pawn.LandMovementState);                            
                        }
                        else
                        {
                            Enable('Timer');
                            SetTimer(0.7000000, false);
                        }
                    }
                }
            }            
        }
        else
        {
            Disable('Timer');
            Pawn.SetPhysics(3);
        }
        return;
    }

    function PlayerMove(float DeltaTime)
    {
        local Rotator OldRotation;
        local Vector X, Y, Z, newAccel;

        GetAxes(Rotation, X, Y, Z);
        newAccel = ((PlayerInput.aForward * X) + (PlayerInput.aStrafe * Y)) + (PlayerInput.aUp * vect(0.0000000, 0.0000000, 1.0000000));
        // End:0x8B
        if(VSize(newAccel) < 1.0000000)
        {
            newAccel = vect(0.0000000, 0.0000000, 0.0000000);
        }
        Pawn.CheckBob(DeltaTime, Y);
        OldRotation = Rotation;
        UpdateRotation(DeltaTime);
        // End:0xEC
        if(int(Role) < int(ROLE_Authority))
        {
            ReplicateMove(DeltaTime, newAccel, OldRotation - Rotation);            
        }
        else
        {
            ProcessMove(DeltaTime, newAccel, OldRotation - Rotation);
        }
        bPressedJump = false;
        return;
    }

    function Timer()
    {
        // End:0x42
        if(!Pawn.PhysicsVolume.bWaterVolume && int(Role) == int(ROLE_Authority))
        {
            GotoState(Pawn.LandMovementState);
        }
        Disable('Timer');
        return;
    }

    function BeginState(name PreviousStateName)
    {
        Disable('Timer');
        Pawn.SetPhysics(3);
        return;
    }
Begin:

    stop;            
}

state PlayerFlying
{
    function PlayerMove(float DeltaTime)
    {
        local Vector X, Y, Z;

        GetAxes(Rotation, X, Y, Z);
        Pawn.Acceleration = (PlayerInput.aForward * X) + (PlayerInput.aStrafe * Y);
        // End:0x87
        if(VSize(Pawn.Acceleration) < 1.0000000)
        {
            Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        }
        // End:0xCE
        if(bCheatFlying && Pawn.Acceleration == vect(0.0000000, 0.0000000, 0.0000000))
        {
            Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        }
        UpdateRotation(DeltaTime);
        // End:0x113
        if(int(Role) < int(ROLE_Authority))
        {
            ReplicateMove(DeltaTime, Pawn.Acceleration, rot(0, 0, 0));            
        }
        else
        {
            ProcessMove(DeltaTime, Pawn.Acceleration, rot(0, 0, 0));
        }
        return;
    }

    function BeginState(name PreviousStateName)
    {
        Pawn.SetPhysics(4);
        return;
    }
    stop;
}

state BaseSpectating
{
    event bool IsSpectating()
    {
        return true;
        return;
    }

    function PlayerMove(float DeltaTime)
    {
        local Vector X, Y, Z;

        GetAxes(Rotation, X, Y, Z);
        Acceleration = ((PlayerInput.aForward * X) + (PlayerInput.aStrafe * Y)) + (PlayerInput.aUp * vect(0.0000000, 0.0000000, 1.0000000));
        UpdateRotation(DeltaTime);
        // End:0xA3
        if(int(Role) < int(ROLE_Authority))
        {
            ReplicateMove(DeltaTime, Acceleration, rot(0, 0, 0));            
        }
        else
        {
            ProcessMove(DeltaTime, Acceleration, rot(0, 0, 0));
        }
        return;
    }
    stop;
}

state Spectating extends BaseSpectating
{
    ignores RestartLevel, ClientRestart, Suicide, ThrowWeapon;

    exec function StartAltFire(optional byte FireModeNum)
    {
        ResetCameraMode();
        ServerViewSelf();
        return;
    }

    function BeginState(name PreviousStateName)
    {
        // End:0x24
        if(Pawn != none)
        {
            SetLocation(Pawn.Location);
            UnPossess();
        }
        bCollideWorld = true;
        return;
    }

    function EndState(name NextStateName)
    {
        // End:0x1C
        if(PlayerReplicationInfo != none)
        {
            PlayerReplicationInfo.bIsSpectator = false;
        }
        bCollideWorld = false;
        return;
    }
    stop;
}

auto state PlayerWaiting extends BaseSpectating
{
    ignores TakeDamage, NextWeapon, PrevWeapon, SwitchToBestWeapon, Jump, Suicide, 
	    ServerSuicide;

    reliable server function ServerChangeTeam(int N)
    {
        WorldInfo.Game.ChangeTeam(self, N, true);
        return;
    }

    reliable server event ServerRestartPlayer()
    {
        // End:0x1A
        if(WorldInfo.TimeSeconds < WaitDelay)
        {
            return;
        }
        // End:0x35
        if(int(WorldInfo.NetMode) == int(NM_Client))
        {
            return;
        }
        // End:0x65
        if(WorldInfo.Game.IsWaitingToStartMatch())
        {
            PlayerReplicationInfo.bReadyToPlay = true;            
        }
        else
        {
            WorldInfo.Game.RestartPlayer(self);
        }
        return;
    }

    function EndState(name NextStateName)
    {
        // End:0x1C
        if(PlayerReplicationInfo != none)
        {
            PlayerReplicationInfo.SetWaitingPlayer(false);
        }
        bCollideWorld = false;
        return;
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x1C
        if(PlayerReplicationInfo != none)
        {
            PlayerReplicationInfo.SetWaitingPlayer(true);
        }
        bCollideWorld = true;
        return;
    }
    stop;
}

state WaitingForPawn extends BaseSpectating
{
    ignores KilledBy;

    function PlayerTick(float DeltaTime)
    {
        global.PlayerTick(DeltaTime);
        // End:0x46
        if(Pawn != none)
        {
            Pawn.Controller = self;
            Pawn.BecomeViewTarget(self);
            ClientRestart(Pawn);            
        }
        else
        {
            // End:0x76
            if(!IsTimerActive() || GetTimerCount() > 1.0000000)
            {
                SetTimer(0.2000000, true);
                AskForPawn();
            }
        }
        return;
    }

    function Timer()
    {
        AskForPawn();
        return;
    }

    function BeginState(name PreviousStateName)
    {
        SetTimer(0.2000000, true);
        AskForPawn();
        return;
    }

    function EndState(name NextStateName)
    {
        ResetCameraMode();
        SetTimer(0.0000000, false);
        return;
    }
    stop;
}

state RoundEnded
{
    ignores KilledBy, TakeDamage, Suicide, ServerRestartPlayer, ThrowWeapon, Use;

    event bool IsSpectating()
    {
        return true;
        return;
    }

    function Possess(Pawn aPawn, bool bVehicleTransition)
    {
        global.Possess(aPawn, bVehicleTransition);
        // End:0x2C
        if(Pawn != none)
        {
            Pawn.TurnOff();
        }
        return;
    }

    reliable server event ServerRestartGame()
    {
        // End:0x2E
        if(WorldInfo.Game.PlayerCanRestartGame(self))
        {
            GetGameManager().ResetGameLevel();
        }
        return;
    }

    function PlayerMove(float DeltaTime)
    {
        local Vector X, Y, Z;
        local Rotator DeltaRot, ViewRotation;

        GetAxes(Rotation, X, Y, Z);
        ViewRotation = Rotation;
        DeltaRot.Yaw = int(PlayerInput.aTurn);
        DeltaRot.Pitch = int(PlayerInput.aLookUp);
        ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
        SetRotation(ViewRotation);
        ViewShake(DeltaTime);
        // End:0xBA
        if(int(Role) < int(ROLE_Authority))
        {
            ReplicateMove(DeltaTime, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0));            
        }
        else
        {
            ProcessMove(DeltaTime, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0));
        }
        bPressedJump = false;
        return;
    }

    function FindGoodView()
    {
        local Vector cameraLoc;
        local Rotator cameraRot, ViewRotation;
        local int tries, besttry;
        local float bestDist, newdist;
        local int startYaw;

        ViewRotation = Rotation;
        ViewRotation.Pitch = 56000;
        tries = 0;
        besttry = 0;
        bestDist = 0.0000000;
        startYaw = ViewRotation.Yaw;
        tries = 0;
        J0x4B:

        // End:0xE2 [Loop If]
        if(tries < 16)
        {
            cameraLoc = ViewTarget.Location;
            SetRotation(ViewRotation);
            GetPlayerViewPoint(cameraLoc, cameraRot);
            newdist = VSize(cameraLoc - ViewTarget.Location);
            // End:0xC7
            if(newdist > bestDist)
            {
                bestDist = newdist;
                besttry = tries;
            }
            ViewRotation.Yaw += 4096;
            tries++;
            // [Loop Continue]
            goto J0x4B;
        }
        ViewRotation.Yaw = startYaw + (besttry * 4096);
        SetRotation(ViewRotation);
        return;
    }

    function Timer()
    {
        bFrozen = false;
        return;
    }

    function BeginState(name PreviousStateName)
    {
        local Pawn P;

        FOVAngle = DesiredFOV;
        bFire = 0;
        // End:0x46
        if(Pawn != none)
        {
            Pawn.TurnOff();
            Pawn.bSpecialHUD = false;
            StopFiring();
        }
        // End:0x62
        if(myHUD != none)
        {
            myHUD.bShowScores = true;
        }
        bFrozen = true;
        FindGoodView();
        SetTimer(5.0000000, false);
        // End:0xC6
        foreach DynamicActors(Class'Pawn', P)
        {
            // End:0xB5
            if(int(P.Role) == int(ROLE_Authority))
            {
                P.RemoteRole = ROLE_SimulatedProxy;
            }
            P.TurnOff();            
        }        
        return;
    }

    function EndState(name NextStateName)
    {
        EndState(NextStateName);
        // End:0x28
        if(myHUD != none)
        {
            myHUD.bShowScores = false;
        }
        return;
    }
Begin:

    stop;            
}

state Dead
{
    ignores KilledBy, NextWeapon, PrevWeapon, ThrowWeapon;

    event bool IsDead()
    {
        return true;
        return;
    }

    reliable server event ServerRestartPlayer()
    {
        // End:0x21
        if(!WorldInfo.Game.PlayerCanRestart(self))
        {
            return;
        }
        ServerRestartPlayer();
        return;
    }

    function PlayerMove(float DeltaTime)
    {
        local Vector X, Y, Z;
        local Rotator DeltaRot, ViewRotation;

        // End:0xD3
        if(!bFrozen)
        {
            // End:0x25
            if(bPressedJump)
            {
                StartFire(0);
                bPressedJump = false;
            }
            GetAxes(Rotation, X, Y, Z);
            ViewRotation = Rotation;
            DeltaRot.Yaw = int(PlayerInput.aTurn);
            DeltaRot.Pitch = int(PlayerInput.aLookUp);
            ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
            SetRotation(ViewRotation);
            // End:0xD0
            if(int(Role) < int(ROLE_Authority))
            {
                ReplicateMove(DeltaTime, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0));
            }            
        }
        else
        {
            // End:0xFA
            if(!IsTimerActive() || GetTimerCount() > 1.0000000)
            {
                bFrozen = false;
            }
        }
        ViewShake(DeltaTime);
        return;
    }

    function FindGoodView()
    {
        local Vector cameraLoc;
        local Rotator cameraRot, ViewRotation;
        local int tries, besttry;
        local float bestDist, newdist;
        local int startYaw;

        ViewRotation = Rotation;
        ViewRotation.Pitch = 56000;
        tries = 0;
        besttry = 0;
        bestDist = 0.0000000;
        startYaw = ViewRotation.Yaw;
        tries = 0;
        J0x4B:

        // End:0xE2 [Loop If]
        if(tries < 16)
        {
            cameraLoc = ViewTarget.Location;
            SetRotation(ViewRotation);
            GetPlayerViewPoint(cameraLoc, cameraRot);
            newdist = VSize(cameraLoc - ViewTarget.Location);
            // End:0xC7
            if(newdist > bestDist)
            {
                bestDist = newdist;
                besttry = tries;
            }
            ViewRotation.Yaw += 4096;
            tries++;
            // [Loop Continue]
            goto J0x4B;
        }
        ViewRotation.Yaw = startYaw + (besttry * 4096);
        SetRotation(ViewRotation);
        return;
    }

    function Timer()
    {
        // End:0x0D
        if(!bFrozen)
        {
            return;
        }
        bFrozen = false;
        bPressedJump = false;
        return;
    }

    function BeginState(name PreviousStateName)
    {
        // End:0x31
        if((Pawn != none) && Pawn.Controller == self)
        {
            Pawn.Controller = none;
        }
        Pawn = none;
        FOVAngle = DesiredFOV;
        Enemy = none;
        bFrozen = true;
        bJumpStatus = false;
        bPressedJump = false;
        FindGoodView();
        SetTimer(1.0000000, false);
        CleanOutSavedMoves();
        return;
    }

    function EndState(name NextStateName)
    {
        CleanOutSavedMoves();
        Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        // End:0x48
        if(!PlayerReplicationInfo.bOutOfLives)
        {
            ResetCameraMode();
        }
        bPressedJump = false;
        // End:0x6C
        if(myHUD != none)
        {
            myHUD.bShowScores = false;
        }
        return;
    }
Begin:

    // End:0x34
    if(LocalPlayer(Player) != none)
    {
        Sleep(3.0000000);
        // End:0x34
        if(myHUD != none)
        {
            myHUD.bShowScores = true;
        }
    }
    stop;            
}

defaultproperties
{
    CameraClass=Class'Camera'
    bDynamicNetSpeed=true
    m_bDrawDebug=true
    MaxResponseTime=0.1250000
    DesiredFOV=85.0000000
    DefaultFOV=85.0000000
    m_fFOVBias=1.0000000
    SavedMoveClass=Class'SavedMove'
    DynamicPingThreshold=400.0000000
    LastSpeedHackLog=-100.0000000
    preferredTeamIndex=-1
    ProgressTimeOut=8.0000000
    QuickSaveString="Quick Saving"
    NoPauseMessage="Game is not pauseable"
    ViewingFrom="Now viewing from"
    OwnCamera="Now viewing from own camera"
    CheatClass=Class'CheatManager'
    InputClass=Class'PlayerInput'
    InteractDistance=512.0000000
    FOVAngle=85.0000000
    bIsPlayer=true
    bCanDoSpecial=true
    NetPriority=3.0000000
}