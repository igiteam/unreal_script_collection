class HUD extends Actor
    transient
    native
    config(Game)
    notplaceable
    hidecategories(lighting);

struct ConsoleMessage
{
    var string Text;
    var Color TextColor;
    var float MessageLife;
    var PlayerReplicationInfo PRI;

    structdefaultproperties
    {
        Text=""
        TextColor=(R=0,G=0,B=0,A=0)
        MessageLife=0.0000000
        PRI=none
    }
};

struct HudLocalizedMessage
{
    var class<LocalMessage> Message;
    var string StringMessage;
    var int Switch;
    var float EndOfLife;
    var float Lifetime;
    var float PosY;
    var Color DrawColor;
    var int FontSize;
    var Font StringFont;
    var float DX;
    var float DY;
    var bool Drawn;

    structdefaultproperties
    {
        Message=none
        StringMessage=""
        Switch=0
        EndOfLife=0.0000000
        Lifetime=0.0000000
        PosY=0.0000000
        DrawColor=(R=0,G=0,B=0,A=0)
        FontSize=0
        StringFont=none
        DX=0.0000000
        DY=0.0000000
        Drawn=false
    }
};

var const Color WhiteColor;
var const Color GreenColor;
var const Color RedColor;
var PlayerController PlayerOwner;
var HUD HudOwner;
var PlayerReplicationInfo ViewedInfo;
var float ProgressFadeTime;
var Color MOTDColor;
var Actor AnimDebugThis;
var name AnimDebugStartingPoint;
var Actor m_LastAnimDebugThis;
var bool m_bAnimDebugRelevantOnly;
var config bool bShowHUD;
var bool bShowScores;
var bool bShowDebugInfo;
var bool bShowAnimDebug;
var bool m_bShowSequenceDebug;
var() bool bShowBadConnectionAlert;
var config bool bMessageBeep;
var bool bShowBigMessages;
var ScoreBoard ScoreBoard;
var globalconfig float HudCanvasScale;
var array<ConsoleMessage> ConsoleMessages;
var const Color ConsoleColor;
var globalconfig int ConsoleMessageCount;
var globalconfig int ConsoleFontSize;
var globalconfig int MessageFontOffset;
var() transient HudLocalizedMessage LocalMessages[8];
var() float ConsoleMessagePosX;
var() float ConsoleMessagePosY;
var Canvas Canvas;
var transient float LastHUDRenderTime;
var transient float RenderDelta;
var transient float SizeX;
var transient float SizeY;
var transient float CenterX;
var transient float CenterY;
var transient float RatioX;
var transient float RatioY;
var int m_iAnimTreeOffsetX;
var int m_iAnimTreeOffsetY;
var array<string> DebugDisplay;

// Export UHUD::execDraw3DLine(FFrame&, void* const)
native final function Draw3DLine(Vector Start, Vector End, Color LineColor);

// Export UHUD::execDraw2DLine(FFrame&, void* const)
native final function Draw2DLine(int X1, int Y1, int X2, int Y2, Color LineColor);

simulated event PostBeginPlay()
{
    PostBeginPlay();
    PlayerOwner = PlayerController(Owner);
    return;
}

function SpawnScoreBoard(class<ScoreBoard> ScoringType)
{
    // End:0x23
    if(ScoringType != none)
    {
        ScoreBoard = __NFUN_278__(ScoringType, PlayerOwner);
    }
    // End:0x3E
    if(ScoreBoard != none)
    {
        ScoreBoard.HudOwner = self;
    }
    return;
}

simulated event Destroyed()
{
    // End:0x1E
    if(ScoreBoard != none)
    {
        ScoreBoard.Destroy();
        ScoreBoard = none;
    }
    Destroyed();
    return;
}

exec function ToggleHUD()
{
    bShowHUD = !bShowHUD;
    return;
}

exec function ShowScores()
{
    bShowScores = !bShowScores;
    // End:0x30
    if(ScoreBoard != none)
    {
        ScoreBoard.ChangeState(bShowScores);
    }
    return;
}

exec function ShowDebug(string DebugType)
{
    local int I;

    // End:0x1E
    if(DebugType ~= "")
    {
        bShowDebugInfo = !bShowDebugInfo;        
    }
    else
    {
        bShowDebugInfo = true;
        I = 0;
        J0x2D:

        // End:0x6C [Loop If]
        if(I < DebugDisplay.Length)
        {
            // End:0x62
            if(DebugDisplay[I] ~= DebugType)
            {
                DebugDisplay[I] = "";
                return;
            }
            I++;
            // [Loop Continue]
            goto J0x2D;
        }
        I = 0;
        J0x73:

        // End:0xB2 [Loop If]
        if(I < DebugDisplay.Length)
        {
            // End:0xA8
            if(DebugDisplay[I] ~= "")
            {
                DebugDisplay[I] = DebugType;
                return;
            }
            I++;
            // [Loop Continue]
            goto J0x73;
        }
        DebugDisplay[DebugDisplay.Length] = DebugType;
    }
    return;
}

function bool ShouldDisplayDebug(string DebugType)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x38 [Loop If]
    if(I < DebugDisplay.Length)
    {
        // End:0x2E
        if(DebugDisplay[I] ~= DebugType)
        {
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    return;
}

exec function ShowAnimDebugRelevantOnly()
{
    m_bAnimDebugRelevantOnly = !m_bAnimDebugRelevantOnly;
    return;
}

exec function ShowAnimDebug(string StartingPoint)
{
    SetAnimDebugTarget(PlayerOwner.Pawn, StartingPoint);
    return;
}

exec function ShowSequenceDebug()
{
    m_bShowSequenceDebug = !m_bShowSequenceDebug;
    // End:0x6A
    if((PlayerOwner.Pawn != none) && PlayerOwner.Pawn.Mesh != none)
    {
        PlayerOwner.Pawn.Mesh.m_bDebugSequences = m_bShowSequenceDebug;
    }
    return;
}

exec function ShowCameraTree(string StartingPoint)
{
    SetAnimDebugTarget(PlayerOwner.PlayerCamera, StartingPoint);
    return;
}

exec function ShowTurretAnimDebug(string StartingPoint)
{
    return;
}

function SetAnimDebugTarget(Actor pAnimDebugTarget, string StartingPoint)
{
    // End:0x62
    if(pAnimDebugTarget != AnimDebugThis)
    {
        AnimDebugThis = pAnimDebugTarget;
        bShowAnimDebug = true;
        m_bAnimDebugRelevantOnly = true;
        AnimDebugStartingPoint = name(StartingPoint);
        // End:0x5F
        if(m_LastAnimDebugThis != AnimDebugThis)
        {
            m_LastAnimDebugThis = AnimDebugThis;
            m_iAnimTreeOffsetX = 0;
            m_iAnimTreeOffsetY = 0;
        }        
    }
    else
    {
        bShowAnimDebug = !bShowAnimDebug;
    }
    return;
}

exec function ShowPawnAnimDebug(class<Pawn> aClass, string StartingPoint)
{
    local Pawn P, ClosestPawn;
    local float ThisDistance, ClosestPawnDistance;

    ClosestPawn = none;
    ClosestPawnDistance = 10000000.0000000;
    // End:0xAA
    foreach DynamicActors(Class'Pawn', P)
    {
        // End:0xA9
        if(ClassIsChildOf(P.Class, aClass) && P != PlayerOwner.Pawn)
        {
            ThisDistance = VSize(P.Location - PlayerOwner.Pawn.Location);
            // End:0xA9
            if(ThisDistance < ClosestPawnDistance)
            {
                ClosestPawn = P;
                ClosestPawnDistance = ThisDistance;
            }
        }        
    }    
    SetAnimDebugTarget(ClosestPawn, StartingPoint);
    return;
}

exec function OffsetAnimDebug(int iOffsetX, int iOffsetY)
{
    // End:0x21
    if(bShowAnimDebug)
    {
        m_iAnimTreeOffsetX += iOffsetX;
        m_iAnimTreeOffsetY += iOffsetY;
    }
    return;
}

simulated function DrawRoute()
{
    local int I;
    local Controller C;
    local Vector Start, End, RealStart;
    local bool bPath;
    local Actor FirstRouteCache;

    C = Pawn(PlayerOwner.ViewTarget).Controller;
    // End:0x2F
    if(C == none)
    {
        return;
    }
    // End:0x6C
    if(C.CurrentPath != none)
    {
        Start = C.CurrentPath.Start.Location;        
    }
    else
    {
        Start = PlayerOwner.ViewTarget.Location;
    }
    RealStart = Start;
    // End:0xF9
    if(C.bAdjusting)
    {
        Draw3DLine(C.Pawn.Location, C.AdjustLoc, MakeColor(byte(255), 0, byte(255), byte(255)));
        Start = C.AdjustLoc;
    }
    // End:0x124
    if(C.RouteCache.Length > 0)
    {
        FirstRouteCache = C.RouteCache[0];
    }
    // End:0x30A
    if((C == PlayerOwner) || (C.MoveTarget == FirstRouteCache) && C.MoveTarget != none)
    {
        // End:0x20E
        if((C == PlayerOwner) && C.Destination != vect(0.0000000, 0.0000000, 0.0000000))
        {
            // End:0x1F4
            if(C.PointReachable(C.Destination))
            {
                Draw3DLine(C.Pawn.Location, C.Destination, MakeColor(byte(255), byte(255), byte(255), byte(255)));
                return;
            }
            C.FindPathTo(C.Destination);
        }
        // End:0x307
        if(C.RouteCache.Length > 0)
        {
            I = 0;
            J0x22A:

            // End:0x2CF [Loop If]
            if(I < C.RouteCache.Length)
            {
                // End:0x260
                if(C.RouteCache[I] == none)
                {
                    // [Explicit Break]
                    goto J0x2CF;
                }
                bPath = true;
                Draw3DLine(Start, C.RouteCache[I].Location, MakeColor(0, byte(255), 0, byte(255)));
                Start = C.RouteCache[I].Location;
                I++;
                // [Loop Continue]
                goto J0x22A;
            }
            J0x2CF:

            // End:0x307
            if(bPath)
            {
                Draw3DLine(RealStart, C.Destination, MakeColor(byte(255), byte(255), byte(255), byte(255)));
            }
        }        
    }
    else
    {
        // End:0x362
        if(PlayerOwner.ViewTarget.Velocity != vect(0.0000000, 0.0000000, 0.0000000))
        {
            Draw3DLine(RealStart, C.Destination, MakeColor(byte(255), byte(255), byte(255), byte(255)));
        }
    }
    // End:0x373
    if(C == PlayerOwner)
    {
        return;
    }
    // End:0x3A7
    if(C.Focus != none)
    {
        End = C.Focus.Location;        
    }
    else
    {
        End = C.FocalPoint;
    }
    Draw3DLine(PlayerOwner.ViewTarget.Location + (Pawn(PlayerOwner.ViewTarget).BaseEyeHeight * vect(0.0000000, 0.0000000, 1.0000000)), End, MakeColor(byte(255), 0, 0, byte(255)));
    return;
}

simulated function PreCalcValues()
{
    SizeX = float(Canvas.SizeX);
    SizeY = float(Canvas.SizeY);
    CenterX = SizeX * 0.5000000;
    CenterY = SizeY * 0.5000000;
    RatioX = SizeX / 1024.0000000;
    RatioY = SizeY / 768.0000000;
    return;
}

simulated event PostRender()
{
    local float XL, YL, YPos;
    local int I;
    local float fFontDX, fFontDY;

    RenderDelta = WorldInfo.TimeSeconds - LastHUDRenderTime;
    // End:0x58
    if((SizeX != float(Canvas.SizeX)) || SizeY != float(Canvas.SizeY))
    {
        PreCalcValues();
    }
    // End:0x117
    if(PlayerOwner != none)
    {
        // End:0xCC
        if(PlayerOwner.ViewTarget != none)
        {
            // End:0xB5
            if(Pawn(PlayerOwner.ViewTarget) != none)
            {
                ViewedInfo = Pawn(PlayerOwner.ViewTarget).PlayerReplicationInfo;                
            }
            else
            {
                ViewedInfo = PlayerOwner.PlayerReplicationInfo;
            }            
        }
        else
        {
            // End:0x100
            if(PlayerOwner.Pawn != none)
            {
                ViewedInfo = PlayerOwner.Pawn.PlayerReplicationInfo;                
            }
            else
            {
                ViewedInfo = PlayerOwner.PlayerReplicationInfo;
            }
        }        
    }
    else
    {
        ViewedInfo = PlayerOwner.PlayerReplicationInfo;
    }
    // End:0x1E0
    if(bShowDebugInfo)
    {
        Canvas.Font = Class'Engine'.default.TinyFont;
        Canvas.DrawColor = ConsoleColor;
        Canvas.__NFUN_464__("X", XL, YL);
        YPos = 0.0000000;
        PlayerOwner.ViewTarget.DisplayDebug(self, YL, YPos);
        // End:0x1DD
        if((ShouldDisplayDebug("AI")) && Pawn(PlayerOwner.ViewTarget) != none)
        {
            DrawRoute();
        }        
    }
    else
    {
        // End:0x29B
        if(bShowHUD)
        {
            // End:0x23D
            if(bShowScores)
            {
                // End:0x23A
                if(ScoreBoard != none)
                {
                    ScoreBoard.Canvas = Canvas;
                    ScoreBoard.DrawHUD();
                    // End:0x23A
                    if(ScoreBoard.bDisplayMessages)
                    {
                        DisplayConsoleMessages();
                    }
                }                
            }
            else
            {
                PlayerOwner.DrawHUD(self);
                DrawHUD();
                // End:0x28A
                if((PlayerOwner != none) && PlayerOwner.ProgressTimeOut > WorldInfo.TimeSeconds)
                {
                    DisplayProgressMessage();
                }
                DisplayConsoleMessages();
                DisplayLocalMessages();
            }            
        }
        else
        {
            DrawDemoHUD();
            DisplayConsoleMessages();
            DisplayLocalMessages();
        }
    }
    // End:0x2C0
    if(bShowBadConnectionAlert)
    {
        DisplayBadConnectionAlert();
    }
    // End:0x2DD
    if(bShowAnimDebug && AnimDebugThis != none)
    {
        DrawAnimDebugTarget();
    }
    // End:0x404
    if(m_bShowSequenceDebug)
    {
        // End:0x404
        if((PlayerOwner.Pawn != none) && PlayerOwner.Pawn.Mesh != none)
        {
            Canvas.Font = Class'Engine'.default.SmallFont;
            Canvas.DrawColor = WhiteColor;
            Canvas.__NFUN_470__("A", fFontDX, fFontDY);
            YPos = 0.0000000;
            I = 0;
            J0x375:

            // End:0x404 [Loop If]
            if(I < PlayerOwner.Pawn.Mesh.m_DebugSequences.Length)
            {
                Canvas.SetPos(20.0000000, YPos);
                Canvas.__NFUN_465__(string(PlayerOwner.Pawn.Mesh.m_DebugSequences[I]));
                YPos += fFontDY;
                I++;
                // [Loop Continue]
                goto J0x375;
            }
        }
    }
    LastHUDRenderTime = WorldInfo.TimeSeconds;
    return;
}

function DrawAnimDebugTarget()
{
    // End:0xCE
    if(AnimDebugThis != none)
    {
        // End:0x4D
        if(Pawn(AnimDebugThis) != none)
        {
            Pawn(AnimDebugThis).DrawAnimDebug(Canvas, AnimDebugStartingPoint, m_iAnimTreeOffsetX, m_iAnimTreeOffsetY, m_bAnimDebugRelevantOnly);            
        }
        else
        {
            // End:0x8F
            if(Weapon(AnimDebugThis) != none)
            {
                Weapon(AnimDebugThis).DrawAnimDebug(Canvas, AnimDebugStartingPoint, m_iAnimTreeOffsetX, m_iAnimTreeOffsetY, m_bAnimDebugRelevantOnly);                
            }
            else
            {
                // End:0xCE
                if(Camera(AnimDebugThis) != none)
                {
                    Camera(AnimDebugThis).DrawAnimDebug(Canvas, AnimDebugStartingPoint, m_iAnimTreeOffsetX, m_iAnimTreeOffsetY, m_bAnimDebugRelevantOnly);
                }
            }
        }
    }
    return;
}

function DrawHUD()
{
    DrawEngineHUD();
    return;
}

function DrawDemoHUD()
{
    return;
}

function DrawEngineHUD()
{
    return;
}

simulated function DisplayProgressMessage()
{
    local int I, LineCount;
    local float FontDX, FontDY, X, Y;
    local int Alpha;
    local float TimeLeft;

    TimeLeft = PlayerOwner.ProgressTimeOut - WorldInfo.TimeSeconds;
    // End:0x3E
    if(TimeLeft >= ProgressFadeTime)
    {
        Alpha = 255;        
    }
    else
    {
        Alpha = int((float(255) * TimeLeft) / ProgressFadeTime);
    }
    LineCount = 0;
    I = 0;
    J0x66:

    // End:0xA1 [Loop If]
    if(I < 4)
    {
        // End:0x90
        if(PlayerOwner.ProgressMessage[I] == "")
        {
            // [Explicit Continue]
            goto J0x97;
        }
        LineCount++;
        J0x97:

        I++;
        // [Loop Continue]
        goto J0x66;
    }
    // End:0xDC
    if((WorldInfo.GRI != none) && WorldInfo.GRI.MessageOfTheDay != "")
    {
        LineCount++;
    }
    Canvas.Font = Class'Engine'.default.LargeFont;
    Canvas.__NFUN_470__("A", FontDX, FontDY);
    X = ((0.5000000 * HudCanvasScale) * float(Canvas.SizeX)) + (((1.0000000 - HudCanvasScale) / 2.0000000) * float(Canvas.SizeX));
    Y = ((0.5000000 * HudCanvasScale) * float(Canvas.SizeY)) + (((1.0000000 - HudCanvasScale) / 2.0000000) * float(Canvas.SizeY));
    Y -= (FontDY * (float(LineCount) / 2.0000000));
    I = 0;
    J0x1CB:

    // End:0x2BB [Loop If]
    if(I < 4)
    {
        // End:0x1F5
        if(PlayerOwner.ProgressMessage[I] == "")
        {
            // [Explicit Continue]
            goto J0x2B1;
        }
        Canvas.DrawColor = PlayerOwner.ProgressColor[I];
        Canvas.DrawColor.A = byte(Alpha);
        Canvas.__NFUN_470__(PlayerOwner.ProgressMessage[I], FontDX, FontDY);
        Canvas.SetPos(X - (FontDX / 2.0000000), Y);
        Canvas.__NFUN_465__(PlayerOwner.ProgressMessage[I]);
        Y += FontDY;
        J0x2B1:

        I++;
        // [Loop Continue]
        goto J0x1CB;
    }
    // End:0x3BB
    if((WorldInfo.GRI != none) && int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        Canvas.DrawColor = MOTDColor;
        Canvas.DrawColor.A = byte(Alpha);
        // End:0x3BB
        if(WorldInfo.GRI.MessageOfTheDay != "")
        {
            Canvas.__NFUN_470__(WorldInfo.GRI.MessageOfTheDay, FontDX, FontDY);
            Canvas.SetPos(X - (FontDX / 2.0000000), Y);
            Canvas.__NFUN_465__(WorldInfo.GRI.MessageOfTheDay);
            Y += FontDY;
        }
    }
    return;
}

function DisplayBadConnectionAlert()
{
    return;
}

event ConnectFailure(string FailCode, string URL)
{
    PlayerOwner.ReceiveLocalizedMessage(Class'FailedConnect', Class'FailedConnect'.static.GetFailSwitch(FailCode));
    return;
}

function PlayStartupMessage(byte Stage)
{
    return;
}

simulated function ClearMessage(out HudLocalizedMessage M)
{
    M.Message = none;
    M.StringFont = none;
    return;
}

simulated function PlayReceivedMessage(string S, string PName, ZoneInfo PZone)
{
    PlayerOwner.ClientMessage(S);
    // End:0x30
    if(bMessageBeep)
    {
        PlayerOwner.PlayBeepSound();
    }
    return;
}

simulated function Message(PlayerReplicationInfo PRI, coerce string Msg, name MsgType, optional float Lifetime)
{
    // End:0x1A
    if(bMessageBeep)
    {
        PlayerOwner.PlayBeepSound();
    }
    // End:0x5B
    if((MsgType == 'Say') || MsgType == 'TeamSay')
    {
        Msg = (PRI.PlayerName $ ": ") $ Msg;
    }
    AddConsoleMessage(Msg, Class'LocalMessage', PRI, Lifetime);
    return;
}

function DisplayConsoleMessages()
{
    local int I, J, XPos, YPos, MessageCount;

    local float XL, YL;

    I = 0;
    J0x07:

    // End:0xE6 [Loop If]
    if(I < ConsoleMessages.Length)
    {
        // End:0x34
        if(ConsoleMessages[I].Text == "")
        {
            // [Explicit Continue]
            goto J0xDC;
            // [Explicit Continue]
            goto J0xDC;
        }
        // End:0xD5
        if(ConsoleMessages[I].MessageLife < WorldInfo.TimeSeconds)
        {
            ConsoleMessages[I].Text = "";
            // End:0xBF
            if(I < (ConsoleMessages.Length - 1))
            {
                J = I;
                J0x88:

                // End:0xBF [Loop If]
                if(J < (ConsoleMessages.Length - 1))
                {
                    ConsoleMessages[J] = ConsoleMessages[J + 1];
                    J++;
                    // [Loop Continue]
                    goto J0x88;
                }
            }
            ConsoleMessages[J].Text = "";
            // [Explicit Continue]
            goto J0xDC;
        }
        MessageCount++;
        J0xDC:

        I++;
        // [Loop Continue]
        goto J0x07;
    }
    XPos = int(((ConsoleMessagePosX * HudCanvasScale) * float(Canvas.SizeX)) + (((1.0000000 - HudCanvasScale) / 2.0000000) * float(Canvas.SizeX)));
    YPos = int(((ConsoleMessagePosY * HudCanvasScale) * float(Canvas.SizeY)) + (((1.0000000 - HudCanvasScale) / 2.0000000) * float(Canvas.SizeY)));
    Canvas.Font = Class'Engine'.default.SmallFont;
    Canvas.DrawColor = ConsoleColor;
    Canvas.__NFUN_470__("A", XL, YL);
    YPos -= int((YL * float(MessageCount)) + float(1));
    YPos -= int(YL);
    I = 0;
    J0x1FB:

    // End:0x2BC [Loop If]
    if(I < ConsoleMessages.Length)
    {
        // End:0x225
        if(ConsoleMessages[I].Text == "")
        {
            // [Explicit Continue]
            goto J0x2B2;
        }
        Canvas.__NFUN_464__(ConsoleMessages[I].Text, XL, YL);
        Canvas.SetPos(float(XPos), float(YPos));
        Canvas.DrawColor = ConsoleMessages[I].TextColor;
        Canvas.__NFUN_465__(ConsoleMessages[I].Text, false);
        YPos += int(YL);
        J0x2B2:

        I++;
        // [Loop Continue]
        goto J0x1FB;
    }
    return;
}

function AddConsoleMessage(string M, class<LocalMessage> InMessageClass, PlayerReplicationInfo PRI, optional float Lifetime)
{
    local int idx, MsgIdx;

    MsgIdx = -1;
    // End:0x39
    if(bMessageBeep && InMessageClass.default.bBeep)
    {
        PlayerOwner.PlayBeepSound();
    }
    // End:0x58
    if(ConsoleMessages.Length < ConsoleMessageCount)
    {
        MsgIdx = ConsoleMessages.Length;        
    }
    else
    {
        idx = 0;
        J0x5F:

        // End:0xAC [Loop If]
        if((idx < ConsoleMessages.Length) && MsgIdx == -1)
        {
            // End:0xA2
            if(ConsoleMessages[idx].Text == "")
            {
                MsgIdx = idx;
            }
            idx++;
            // [Loop Continue]
            goto J0x5F;
        }
    }
    // End:0x117
    if((MsgIdx == ConsoleMessageCount) || MsgIdx == -1)
    {
        idx = 0;
        J0xD3:

        // End:0x109 [Loop If]
        if(idx < (ConsoleMessageCount - 1))
        {
            ConsoleMessages[idx] = ConsoleMessages[idx + 1];
            idx++;
            // [Loop Continue]
            goto J0xD3;
        }
        MsgIdx = ConsoleMessageCount - 1;
    }
    // End:0x136
    if(MsgIdx >= ConsoleMessages.Length)
    {
        ConsoleMessages.Length = MsgIdx + 1;
    }
    ConsoleMessages[MsgIdx].Text = M;
    // End:0x184
    if(Lifetime != 0.0000000)
    {
        ConsoleMessages[MsgIdx].MessageLife = WorldInfo.TimeSeconds + Lifetime;        
    }
    else
    {
        ConsoleMessages[MsgIdx].MessageLife = WorldInfo.TimeSeconds + float(InMessageClass.default.Lifetime);
    }
    ConsoleMessages[MsgIdx].TextColor = InMessageClass.static.GetConsoleColor(PRI);
    ConsoleMessages[MsgIdx].PRI = PRI;
    return;
}

function LocalizedMessage(class<LocalMessage> InMessageClass, PlayerReplicationInfo RelatedPRI_1, string CriticalString, int Switch, float Position, float Lifetime, int FontSize, Color DrawColor)
{
    local int I, LocalMessagesArrayCount;

    // End:0x0D
    if(InMessageClass == none)
    {
        return;
    }
    // End:0x3A
    if(bMessageBeep && InMessageClass.default.bBeep)
    {
        PlayerOwner.PlayBeepSound();
    }
    // End:0x67
    if(!InMessageClass.default.bIsSpecial)
    {
        AddConsoleMessage(CriticalString, InMessageClass, RelatedPRI_1);
        return;
    }
    LocalMessagesArrayCount = 8;
    I = LocalMessagesArrayCount;
    // End:0xCC
    if(InMessageClass.default.bIsUnique)
    {
        I = 0;
        J0x93:

        // End:0xC9 [Loop If]
        if(I < LocalMessagesArrayCount)
        {
            // End:0xBF
            if(LocalMessages[I].Message == InMessageClass)
            {
                // [Explicit Break]
                goto J0xC9;
            }
            I++;
            // [Loop Continue]
            goto J0x93;
        }
        J0xC9:
        
    }
    else
    {
        // End:0x137
        if(InMessageClass.default.bIsPartiallyUnique)
        {
            I = 0;
            J0xE5:

            // End:0x137 [Loop If]
            if(I < LocalMessagesArrayCount)
            {
                // End:0x12D
                if((LocalMessages[I].Message == InMessageClass) && LocalMessages[I].Switch == Switch)
                {
                    // [Explicit Break]
                    goto J0x137;
                }
                I++;
                // [Loop Continue]
                goto J0xE5;
            }
        }
    }
    J0x137:

    // End:0x17F
    if(I == LocalMessagesArrayCount)
    {
        I = 0;
        J0x14D:

        // End:0x17F [Loop If]
        if(I < LocalMessagesArrayCount)
        {
            // End:0x175
            if(LocalMessages[I].Message == none)
            {
                // [Explicit Break]
                goto J0x17F;
            }
            I++;
            // [Loop Continue]
            goto J0x14D;
        }
    }
    J0x17F:

    // End:0x1CB
    if(I == LocalMessagesArrayCount)
    {
        I = 0;
        J0x195:

        // End:0x1CB [Loop If]
        if(I < (LocalMessagesArrayCount - 1))
        {
            LocalMessages[I] = LocalMessages[I + 1];
            I++;
            // [Loop Continue]
            goto J0x195;
        }
    }
    ClearMessage(LocalMessages[I]);
    LocalMessages[I].Message = InMessageClass;
    LocalMessages[I].Switch = Switch;
    LocalMessages[I].EndOfLife = Lifetime + WorldInfo.TimeSeconds;
    LocalMessages[I].StringMessage = CriticalString;
    LocalMessages[I].Lifetime = Lifetime;
    LocalMessages[I].PosY = Position;
    LocalMessages[I].DrawColor = DrawColor;
    LocalMessages[I].FontSize = FontSize;
    return;
}

simulated function GetScreenCoords(float PosY, out float ScreenX, out float ScreenY, out HudLocalizedMessage InMessage)
{
    ScreenX = 0.5000000 * Canvas.ClipX;
    ScreenY = ((PosY * HudCanvasScale) * Canvas.ClipY) + (((1.0000000 - HudCanvasScale) * 0.5000000) * Canvas.ClipY);
    ScreenX -= (InMessage.DX * 0.5000000);
    ScreenY -= (InMessage.DY * 0.5000000);
    return;
}

simulated function DrawMessage(int I, float PosY, out float DX, out float DY)
{
    local float FadeValue, ScreenX, ScreenY;

    FadeValue = LocalMessages[I].EndOfLife - WorldInfo.TimeSeconds;
    Canvas.DrawColor = LocalMessages[I].DrawColor;
    Canvas.DrawColor.A = byte(float(LocalMessages[I].DrawColor.A) * (FadeValue / LocalMessages[I].Lifetime));
    Canvas.Font = LocalMessages[I].StringFont;
    GetScreenCoords(PosY, ScreenX, ScreenY, LocalMessages[I]);
    Canvas.SetPos(ScreenX, ScreenY);
    DX = LocalMessages[I].DX / Canvas.ClipX;
    DY = LocalMessages[I].DY / Canvas.ClipY;
    Canvas.__NFUN_469__(LocalMessages[I].StringMessage);
    LocalMessages[I].Drawn = true;
    return;
}

simulated function DisplayLocalMessages()
{
    local float PosY, DY, DX;
    local int I, J;
    local float FadeValue;
    local int FontSize;

    Canvas.Reset();
    I = 0;
    J0x17:

    // End:0x219 [Loop If]
    if(I < 8)
    {
        // End:0x3C
        if(LocalMessages[I].Message == none)
        {
            // [Explicit Break]
            goto J0x219;
        }
        LocalMessages[I].Drawn = false;
        // End:0x180
        if(LocalMessages[I].StringFont == none)
        {
            FontSize = LocalMessages[I].FontSize + MessageFontOffset;
            LocalMessages[I].StringFont = GetFontSizeIndex(FontSize);
            Canvas.Font = LocalMessages[I].StringFont;
            Canvas.__NFUN_470__(LocalMessages[I].StringMessage, DX, DY);
            LocalMessages[I].DX = DX;
            LocalMessages[I].DY = DY;
            // End:0x180
            if(LocalMessages[I].StringFont == none)
            {
                J = I;
                J0x131:

                // End:0x164 [Loop If]
                if(J < (8 - 1))
                {
                    LocalMessages[J] = LocalMessages[J + 1];
                    J++;
                    // [Loop Continue]
                    goto J0x131;
                }
                ClearMessage(LocalMessages[J]);
                I--;
                // [Explicit Continue]
                goto J0x20F;
            }
        }
        FadeValue = LocalMessages[I].EndOfLife - WorldInfo.TimeSeconds;
        // End:0x20F
        if(FadeValue <= 0.0000000)
        {
            J = I;
            J0x1C0:

            // End:0x1F3 [Loop If]
            if(J < (8 - 1))
            {
                LocalMessages[J] = LocalMessages[J + 1];
                J++;
                // [Loop Continue]
                goto J0x1C0;
            }
            ClearMessage(LocalMessages[J]);
            I--;
            // [Explicit Continue]
        }
        J0x20F:

        I++;
        // [Loop Continue]
        goto J0x17;
    }
    J0x219:

    I = 0;
    J0x220:

    // End:0x303 [Loop If]
    if(I < 8)
    {
        // End:0x245
        if(LocalMessages[I].Message == none)
        {
            // [Explicit Break]
            goto J0x303;
        }
        // End:0x25C
        if(LocalMessages[I].Drawn)
        {
            // [Explicit Continue]
            goto J0x2F9;
        }
        PosY = LocalMessages[I].PosY;
        J = I;
        J0x27D:

        // End:0x2F9 [Loop If]
        if(J < 8)
        {
            // End:0x2A0
            if(LocalMessages[J].Drawn)
            {
                // [Explicit Continue]
                goto J0x2EF;
            }
            // End:0x2C8
            if(LocalMessages[I].PosY != LocalMessages[J].PosY)
            {
                // [Explicit Continue]
                goto J0x2EF;
            }
            DrawMessage(J, PosY, DX, DY);
            PosY += DY;
            J0x2EF:

            J++;
            // [Loop Continue]
            goto J0x27D;
        }
        J0x2F9:

        I++;
        // [Loop Continue]
        goto J0x220;
    }
    J0x303:

    return;
}

function Font GetFontSizeIndex(int FontSize)
{
    // End:0x1D
    if(FontSize == 0)
    {
        return Class'Engine'.default.TinyFont;        
    }
    else
    {
        // End:0x3A
        if(FontSize == 1)
        {
            return Class'Engine'.default.SmallFont;            
        }
        else
        {
            // End:0x58
            if(FontSize == 2)
            {
                return Class'Engine'.default.MediumFont;                
            }
            else
            {
                // End:0x76
                if(FontSize == 3)
                {
                    return Class'Engine'.default.LargeFont;                    
                }
                else
                {
                    return Class'Engine'.default.LargeFont;
                }
            }
        }
    }
    return;
}

static function Color GetRYGColorRamp(float Pct)
{
    local Color GYRColor;

    GYRColor.A = byte(255);
    // End:0x6C
    if(Pct < 0.3400000)
    {
        GYRColor.R = byte(float(128) + (float(127) * FClamp(3.0000000 * Pct, 0.0000000, 1.0000000)));
        GYRColor.G = 0;
        GYRColor.B = 0;        
    }
    else
    {
        // End:0xCC
        if(Pct < 0.6700000)
        {
            GYRColor.R = byte(255);
            GYRColor.G = byte(float(255) * FClamp(3.0000000 * (Pct - 0.3300000), 0.0000000, 1.0000000));
            GYRColor.B = 0;            
        }
        else
        {
            GYRColor.R = byte(float(255) * FClamp(3.0000000 * (1.0000000 - Pct), 0.0000000, 1.0000000));
            GYRColor.G = byte(255);
            GYRColor.B = 0;
        }
    }
    return GYRColor;
    return;
}

defaultproperties
{
    WhiteColor=(R=255,G=255,B=255,A=255)
    GreenColor=(R=0,G=255,B=0,A=255)
    RedColor=(R=255,G=0,B=0,A=255)
    ProgressFadeTime=1.0000000
    MOTDColor=(R=255,G=255,B=255,A=255)
    bMessageBeep=true
    bShowBigMessages=true
    HudCanvasScale=0.9500000
    ConsoleColor=(R=153,G=216,B=253,A=255)
    ConsoleMessageCount=8
    ConsoleFontSize=5
    ConsoleMessagePosY=0.8000000
    DebugDisplay[0]="AI"
    bHidden=true
    Components=none
    TickGroup=1
}