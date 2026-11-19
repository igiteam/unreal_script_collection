class SPMiniGameManager extends Actor
    native
    notplaceable;

enum eButton
{
    eButtonA,                       // 0
    eButtonB,                       // 1
    eButtonX,                       // 2
    eButtonY,                       // 3
    eButtonUnknown,                 // 4
    eButton_MAX                     // 5
};

struct native UIElement
{
    var float X;
    var float Y;
    var float DestX;
    var float DestY;
    var Color Color;
    var Color colorStart;
    var Color colorEnd;
    var Texture2D Tex;
    var float InterpDuration;
    var float CumlativeDelta;
    var float InterpColorDuration;
    var float CumlativeColorDelta;
    var bool bRender;
    var bool bNoRenderOnDone;
    var int TrailCount;
    var int CurTrail;
    var bool bColorLoop;

    structdefaultproperties
    {
        X=0.0000000
        Y=0.0000000
        DestX=0.0000000
        DestY=0.0000000
        Color=(R=0,G=0,B=0,A=0)
        colorStart=(R=0,G=0,B=0,A=0)
        colorEnd=(R=0,G=0,B=0,A=0)
        Tex=none
        InterpDuration=0.0000000
        CumlativeDelta=0.0000000
        InterpColorDuration=0.0000000
        CumlativeColorDelta=0.0000000
        bRender=false
        bNoRenderOnDone=false
        TrailCount=0
        CurTrail=0
        bColorLoop=false
    }
};

var array<UIElement> UIElements;
var Texture2D ButtonGlow;
var Texture2D ButtonColor[4];
var Texture2D ButtonBW[4];
var int UIInteractionIndex;
var int UIHandlerIndex;
var PandoraMiniGameUI MGUI;
var float GameStartTime;
var name SuccessKey;
var bool bEnabled;
var bool bCanCounter;
var bool bCanDodge;
var bool bCanFail;
var int UserData;
//var delegate<OnCounterCB> __OnCounterCB__Delegate;
//var delegate<OnDodgeCB> __OnDodgeCB__Delegate;
//var delegate<OnFailCB> __OnFailCB__Delegate;

delegate OnCounterCB(float fTime, int Data)
{
    //return;    
}

delegate OnDodgeCB(float fTime, int Data)
{
    //return;    
}

delegate OnFailCB(float fTime, int Data)
{
    //return;    
}

// Export USPMiniGameManager::execGetWorldInfo(FFrame&, void* const)
native static final function WorldInfo GetWorldInfo();

// Export USPMiniGameManager::execSPSpawn(FFrame&, void* const)
native static final function Actor SPSpawn(class<Actor> SpawnClass, optional Actor SpawnOwner, optional name SpawnTag, optional Vector SpawnLocation, optional Rotator SpawnRotation, optional Actor Template);

// Export USPMiniGameManager::execGetViewportClient(FFrame&, void* const)
native static final function GameViewportClient GetViewportClient();

function SPMiniGameManager.eButton ButtonIntToEnum(int I)
{
    switch(I)
    {
        // End:0x0F
        case 0:
            return 0;
        // End:0x16
        case 1:
            return 1;
        // End:0x1E
        case 2:
            return 2;
        // End:0x26
        case 3:
            return 3;
        // End:0xFFFF
        default:
            return 4;
            break;
    }
    //return ReturnValue;    
}

function name ButtonEnumToName(SPMiniGameManager.eButton button_type)
{
    local name ButtonName;

    switch(button_type)
    {
        // End:0x1F
        case 0:
            ButtonName = 'A';
            // End:0x67
            break;
        // End:0x36
        case 1:
            ButtonName = 'B';
            // End:0x67
            break;
        // End:0x4D
        case 2:
            ButtonName = 'X';
            // End:0x67
            break;
        // End:0x64
        case 3:
            ButtonName = 'Y';
            // End:0x67
            break;
        // End:0xFFFF
        default:
            break;
    }
    return ButtonName;
    //return ReturnValue;    
}

function AddUIButtonElement(SPMiniGameManager.eButton button_type, optional SPMiniGameManager.eButton button_typeDodge = 4)
{
    local int I, TargetX1, TargetY1, TargetX2, TargetY2;

    UIElements.Insert(0, 12);
    // End:0x35
    if(int(button_typeDodge) == int(4))
    {
        TargetX1 = 260;
        TargetY1 = 250;        
    }
    else
    {
        TargetX1 = (640 / 3) - 64;
        TargetY1 = 250;
        TargetX2 = ((640 * 2) / 3) - 64;
        TargetY2 = 250;
    }
    I = 0;
    J0x76:

    // End:0x3C4 [Loop If]
    if(I < 10)
    {
        UIElements[I].colorStart.R = 255;
        UIElements[I].colorStart.G = 255;
        UIElements[I].colorStart.B = 255;
        UIElements[I].colorStart.A = 128;
        UIElements[I].Color.R = 255;
        UIElements[I].Color.G = 255;
        UIElements[I].Color.B = 255;
        UIElements[I].Color.A = 128;
        UIElements[I].colorEnd.R = 255;
        UIElements[I].colorEnd.G = 255;
        UIElements[I].colorEnd.B = 255;
        UIElements[I].colorEnd.A = 0;
        UIElements[I].Tex = ButtonGlow;
        UIElements[I].X = 0.0000000;
        UIElements[I].Y = 480.0000000;
        UIElements[I].DestX = float(TargetX1);
        UIElements[I].DestY = float(TargetY1);
        UIElements[I].InterpDuration = 20.0000000;
        UIElements[I].CumlativeDelta = 0.0000000;
        UIElements[I].InterpColorDuration = 20.0000000 - float(I * 2);
        UIElements[I].CumlativeColorDelta = 0.0000000;
        UIElements[I].bRender = true;
        UIElements[I].bNoRenderOnDone = true;
        UIElements[I].TrailCount = 0;
        UIElements[I].CurTrail = 0;
        UIElements[I].bColorLoop = false;
        I++;
        // [Loop Continue]
        goto J0x76;
    }
    UIElements[I].colorStart.R = 255;
    UIElements[I].colorStart.G = 255;
    UIElements[I].colorStart.B = 255;
    UIElements[I].colorStart.A = 255;
    UIElements[I].Color.R = 255;
    UIElements[I].Color.G = 255;
    UIElements[I].Color.B = 255;
    UIElements[I].Color.A = 255;
    UIElements[I].colorEnd.R = 255;
    UIElements[I].colorEnd.G = 255;
    UIElements[I].colorEnd.B = 255;
    UIElements[I].colorEnd.A = 0;
    UIElements[I].Tex = ButtonGlow;
    UIElements[I].X = 0.0000000;
    UIElements[I].Y = 480.0000000;
    UIElements[I].DestX = float(TargetX1);
    UIElements[I].DestY = float(TargetY1);
    UIElements[I].InterpDuration = 0.6600000;
    UIElements[I].CumlativeDelta = 0.0000000;
    UIElements[I].InterpColorDuration = 2.0000000;
    UIElements[I].CumlativeColorDelta = 0.0000000;
    UIElements[I].bRender = true;
    UIElements[I].bNoRenderOnDone = false;
    UIElements[I].TrailCount = 10;
    UIElements[I].CurTrail = 0;
    UIElements[I].bColorLoop = true;
    UIElements[I + 1].colorStart.R = 255;
    UIElements[I + 1].colorStart.G = 255;
    UIElements[I + 1].colorStart.B = 255;
    UIElements[I + 1].colorStart.A = 255;
    UIElements[I + 1].Color.R = 255;
    UIElements[I + 1].Color.G = 255;
    UIElements[I + 1].Color.B = 255;
    UIElements[I + 1].Color.A = 255;
    UIElements[I + 1].colorEnd.R = 255;
    UIElements[I + 1].colorEnd.G = 255;
    UIElements[I + 1].colorEnd.B = 255;
    UIElements[I + 1].colorEnd.A = 255;
    UIElements[I + 1].Tex = ButtonColor[int(button_type)];
    UIElements[I + 1].X = 0.0000000;
    UIElements[I + 1].Y = 480.0000000;
    UIElements[I + 1].DestX = float(TargetX1);
    UIElements[I + 1].DestY = float(TargetY1);
    UIElements[I + 1].InterpDuration = 0.6600000;
    UIElements[I + 1].CumlativeDelta = 0.0000000;
    UIElements[I + 1].InterpColorDuration = 2.0000000;
    UIElements[I + 1].CumlativeColorDelta = 0.0000000;
    UIElements[I + 1].bRender = true;
    UIElements[I + 1].bNoRenderOnDone = false;
    UIElements[I + 1].TrailCount = 10;
    UIElements[I + 1].CurTrail = 0;
    UIElements[I + 1].bColorLoop = false;
    // End:0x1490
    if(int(button_typeDodge) != int(4))
    {
        UIElements.Insert(12, 12);
        I = 12;
        J0xA94:

        // End:0xDE2 [Loop If]
        if(I < 22)
        {
            UIElements[I].colorStart.R = 255;
            UIElements[I].colorStart.G = 255;
            UIElements[I].colorStart.B = 255;
            UIElements[I].colorStart.A = 128;
            UIElements[I].Color.R = 255;
            UIElements[I].Color.G = 255;
            UIElements[I].Color.B = 255;
            UIElements[I].Color.A = 128;
            UIElements[I].colorEnd.R = 255;
            UIElements[I].colorEnd.G = 255;
            UIElements[I].colorEnd.B = 255;
            UIElements[I].colorEnd.A = 0;
            UIElements[I].Tex = ButtonGlow;
            UIElements[I].X = 640.0000000;
            UIElements[I].Y = 480.0000000;
            UIElements[I].DestX = float(TargetX2);
            UIElements[I].DestY = float(TargetY2);
            UIElements[I].InterpDuration = 20.0000000;
            UIElements[I].CumlativeDelta = 0.0000000;
            UIElements[I].InterpColorDuration = 20.0000000 - float(I * 2);
            UIElements[I].CumlativeColorDelta = 0.0000000;
            UIElements[I].bRender = true;
            UIElements[I].bNoRenderOnDone = true;
            UIElements[I].TrailCount = 0;
            UIElements[I].CurTrail = 0;
            UIElements[I].bColorLoop = false;
            I++;
            // [Loop Continue]
            goto J0xA94;
        }
        UIElements[I].colorStart.R = 255;
        UIElements[I].colorStart.G = 255;
        UIElements[I].colorStart.B = 255;
        UIElements[I].colorStart.A = 255;
        UIElements[I].Color.R = 255;
        UIElements[I].Color.G = 255;
        UIElements[I].Color.B = 255;
        UIElements[I].Color.A = 255;
        UIElements[I].colorEnd.R = 255;
        UIElements[I].colorEnd.G = 255;
        UIElements[I].colorEnd.B = 255;
        UIElements[I].colorEnd.A = 0;
        UIElements[I].Tex = ButtonGlow;
        UIElements[I].X = 640.0000000;
        UIElements[I].Y = 480.0000000;
        UIElements[I].DestX = float(TargetX2);
        UIElements[I].DestY = float(TargetY2);
        UIElements[I].InterpDuration = 0.6600000;
        UIElements[I].CumlativeDelta = 0.0000000;
        UIElements[I].InterpColorDuration = 2.0000000;
        UIElements[I].CumlativeColorDelta = 0.0000000;
        UIElements[I].bRender = true;
        UIElements[I].bNoRenderOnDone = false;
        UIElements[I].TrailCount = 10;
        UIElements[I].CurTrail = 0;
        UIElements[I].bColorLoop = true;
        UIElements[I + 1].colorStart.R = 255;
        UIElements[I + 1].colorStart.G = 255;
        UIElements[I + 1].colorStart.B = 255;
        UIElements[I + 1].colorStart.A = 255;
        UIElements[I + 1].Color.R = 255;
        UIElements[I + 1].Color.G = 255;
        UIElements[I + 1].Color.B = 255;
        UIElements[I + 1].Color.A = 255;
        UIElements[I + 1].colorEnd.R = 255;
        UIElements[I + 1].colorEnd.G = 255;
        UIElements[I + 1].colorEnd.B = 255;
        UIElements[I + 1].colorEnd.A = 255;
        UIElements[I + 1].Tex = ButtonColor[int(button_typeDodge)];
        UIElements[I + 1].X = 640.0000000;
        UIElements[I + 1].Y = 480.0000000;
        UIElements[I + 1].DestX = float(TargetX2);
        UIElements[I + 1].DestY = float(TargetY2);
        UIElements[I + 1].InterpDuration = 0.6600000;
        UIElements[I + 1].CumlativeDelta = 0.0000000;
        UIElements[I + 1].InterpColorDuration = 2.0000000;
        UIElements[I + 1].CumlativeColorDelta = 0.0000000;
        UIElements[I + 1].bRender = true;
        UIElements[I + 1].bNoRenderOnDone = false;
        UIElements[I + 1].TrailCount = 10;
        UIElements[I + 1].CurTrail = 0;
        UIElements[I + 1].bColorLoop = false;
    }
    //return;    
}

function GameStateTimeout()
{
    // End:0x3E
    if(bCanFail)
    {
        TermMiniGameState();
        OnFailCB(GameStartTime - GetWorldInfo().TimeSeconds, UserData);
    }
    //return;    
}

function InitMGState(float Time, int ButtonID, optional int ButtonID2 = -1)
{
    local PlayerController PC;

    GameStartTime = GetWorldInfo().TimeSeconds;
    SuccessKey = ButtonEnumToName(ButtonIntToEnum(ButtonID));
    MGUI.LastKey = 'None';
    // End:0x83
    if(ButtonID2 == -1)
    {
        AddUIButtonElement(ButtonIntToEnum(ButtonID));        
    }
    else
    {
        AddUIButtonElement(ButtonIntToEnum(ButtonID), ButtonIntToEnum(ButtonID2));
    }
    // End:0x100
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0xFF
        if((PandoraPlayerController(PC) != none) && PC.Pawn != none)
        {
            PandoraPlayerController(PC).ResetLookDownSiteState(true);
        }        
    }    
    Bind();
    SetTimer(Time, false, 'GameStateTimeout');
    bEnabled = true;
    //return;    
}

function BeginMiniGame(float Time, int Data, delegate<OnCounterCB> counter_func, delegate<OnFailCB> fail_func)
{
    local int ButtonID;

    TermMiniGameState();
    __OnCounterCB__Delegate = counter_func;
    __OnFailCB__Delegate = fail_func;
    UserData = Data;
    bCanCounter = true;
    bCanDodge = false;
    bCanFail = true;
    ButtonID = Rand(2);
    InitMGState(Time, ButtonID);
    //return;    
}

function BeginMiniGameDodge(float Time, int Data, delegate<OnCounterCB> counter_func, delegate<OnFailCB> fail_func, delegate<OnDodgeCB> dodge_func)
{
    local int ButtonID;

    TermMiniGameState();
    __OnCounterCB__Delegate = counter_func;
    __OnDodgeCB__Delegate = dodge_func;
    __OnFailCB__Delegate = fail_func;
    UserData = Data;
    bCanCounter = true;
    bCanDodge = true;
    bCanFail = true;
    ButtonID = Rand(2);
    InitMGState(Time, ButtonID, 3);
    //return;    
}

static event SPMiniGameManager Get()
{
    local PandoraGameInfo spGameInfo;
    local SPMiniGameManager MiniGameManager;

    spGameInfo = PandoraGameInfo(GetWorldInfo().Game);
    // End:0x28
    if(spGameInfo == none)
    {
        return none;
    }
    // End:0x4D
    if(spGameInfo.ActiveMiniGameManager != none)
    {
        return spGameInfo.ActiveMiniGameManager;
    }
    MiniGameManager = SPMiniGameManager(SPSpawn(Class'SPMiniGameManager'));
    // End:0x85
    if(MiniGameManager != none)
    {
        MiniGameManager.bKillDuringLevelTransition = true;
    }
    spGameInfo.ActiveMiniGameManager = MiniGameManager;
    return MiniGameManager;
    //return ReturnValue;    
}

function bool Bind()
{
    local PandoraGameInfo spGameInfo;
    local GameViewportClient Viewport;

    Viewport = GetViewportClient();
    // End:0x19
    if(Viewport == none)
    {
        return false;
    }
    spGameInfo = PandoraGameInfo(GetWorldInfo().Game);
    // End:0x41
    if(spGameInfo == none)
    {
        return false;
    }
    // End:0x58
    if(spGameInfo.ActiveMiniGameManager == none)
    {
        return false;
    }
    UIInteractionIndex = Viewport.FindInteraction(Viewport.ViewportConsole);
    // End:0x92
    if(UIInteractionIndex == -1)
    {
        return false;
    }
    UIInteractionIndex += 1;
    UIHandlerIndex = Viewport.InsertInteraction(MGUI, UIInteractionIndex);
    Viewport.ClearInteractions();
    // End:0xE3
    if(UIHandlerIndex == -1)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function bool UnBind()
{
    local GameViewportClient Viewport;

    Viewport = GetViewportClient();
    // End:0x19
    if(Viewport == none)
    {
        return false;
    }
    // End:0x37
    if(Viewport.RemoveInteraction(MGUI))
    {
        return true;
    }
    Viewport.ClearInteractions();
    return false;
    //return ReturnValue;    
}

function PostBeginPlay()
{
    MGUI = new (self) Class'PandoraMiniGameUI';
    //return;    
}

function float Interp(float S, float E, float T)
{
    return Lerp(S, E, T);
    //return ReturnValue;    
}

function TermMiniGameState()
{
    bEnabled = false;
    ClearTimer('GameStateTimeout');
    UIElements.Remove(0, UIElements.Length);
    UnBind();
    //return;    
}

function Tick(float Delta)
{
    local int I;
    local float T, ct;

    // End:0x0D
    if(!bEnabled)
    {
        return;
    }
    I = 0;
    J0x14:

    // End:0x64E [Loop If]
    if(I < UIElements.Length)
    {
        // End:0x164
        if(UIElements[I].CumlativeDelta < UIElements[I].InterpDuration)
        {
            UIElements[I].CumlativeDelta += Delta;
            T = UIElements[I].CumlativeDelta / UIElements[I].InterpDuration;
            // End:0xC0
            if(T >= 1.0000000)
            {
                T = 1.0000000;
            }
            UIElements[I].X = Interp(UIElements[I].X, UIElements[I].DestX, T);
            UIElements[I].Y = Interp(UIElements[I].Y, UIElements[I].DestY, T);
        }
        // End:0x4E2
        if(UIElements[I].CumlativeColorDelta < UIElements[I].InterpColorDuration)
        {
            UIElements[I].CumlativeColorDelta += Delta;
            ct = UIElements[I].CumlativeColorDelta / UIElements[I].InterpColorDuration;
            // End:0x200
            if(ct >= 1.0000000)
            {
                ct = 1.0000000;
            }
            UIElements[I].Color.R = byte(Interp(float(UIElements[I].colorStart.R), float(UIElements[I].colorEnd.R), ct));
            UIElements[I].Color.G = byte(Interp(float(UIElements[I].colorStart.G), float(UIElements[I].colorEnd.G), ct));
            UIElements[I].Color.B = byte(Interp(float(UIElements[I].colorStart.B), float(UIElements[I].colorEnd.B), ct));
            UIElements[I].Color.A = byte(Interp(float(UIElements[I].colorStart.A), float(UIElements[I].colorEnd.A), ct));
            // End:0x4E2
            if((ct == 1.0000000) && UIElements[I].bColorLoop == true)
            {
                UIElements[I].CumlativeColorDelta = 0.0000000;
                UIElements[I].Color = UIElements[I].colorStart;
                UIElements[I].colorStart = UIElements[I].colorEnd;
                UIElements[I].colorEnd = UIElements[I].Color;
                UIElements[I].Color = UIElements[I].colorStart;
            }
        }
        // End:0x537
        if(((T == 1.0000000) && ct == 1.0000000) && UIElements[I].bNoRenderOnDone)
        {
            UIElements[I].bRender = false;
        }
        // End:0x644
        if(UIElements[I].TrailCount > 0)
        {
            // End:0x59C
            if(UIElements[I].CurTrail == UIElements[I].TrailCount)
            {
                UIElements[I].CurTrail = 0;
            }
            UIElements[(I - UIElements[I].CurTrail) - 1].X = UIElements[I].X;
            UIElements[(I - UIElements[I].CurTrail) - 1].Y = UIElements[I].Y;
            UIElements[I].CurTrail++;
        }
        I++;
        // [Loop Continue]
        goto J0x14;
    }
    // End:0x6A5
    if(MGUI.LastKey == SuccessKey)
    {
        // End:0x6A5
        if(bCanCounter)
        {
            TermMiniGameState();
            OnCounterCB(GetWorldInfo().TimeSeconds - GameStartTime, UserData);
        }
    }
    // End:0x700
    if(MGUI.LastKey == 'Y')
    {
        // End:0x700
        if(bCanDodge)
        {
            TermMiniGameState();
            OnDodgeCB(GetWorldInfo().TimeSeconds - GameStartTime, UserData);
        }
    }
    //return;    
}

function Render(Canvas Canvas, Vector2D extents)
{
    local int I;

    // End:0x0D
    if(!bEnabled)
    {
        return;
    }
    I = 0;
    J0x14:

    // End:0x193 [Loop If]
    if(I < UIElements.Length)
    {
        // End:0x189
        if(UIElements[I].bRender)
        {
            Canvas.SetDrawColor(UIElements[I].Color.R, UIElements[I].Color.G, UIElements[I].Color.B, UIElements[I].Color.A);
            Canvas.SetPos((UIElements[I].X * extents.X) / float(640), (UIElements[I].Y * extents.Y) / float(480));
            Canvas.DrawTile(UIElements[I].Tex, 128.0000000, 128.0000000, 0.0000000, 0.0000000, 64.0000000, 64.0000000);
        }
        I++;
        // [Loop Continue]
        goto J0x14;
    }
    Canvas.SetDrawColor(255, 255, 255);
    Canvas.SetPos(50.0000000, 50.0000000);
    //return;    
}
