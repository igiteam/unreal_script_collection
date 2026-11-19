class GameViewportClient extends Object within Engine
    transient
    native;

var private native const noexport Pointer VfTable_FExec;
var private native const noexport Pointer VfTable_FViewportClient;
var const Pointer Viewport;
var array<Interaction> GlobalInteractions;
var PlayerManagerInteraction PlayerManager;
var Console ViewportConsole;
var const array<string> EnabledStats;
var const localized string LoadingMessage;
var const localized string SavingMessage;
var const localized string ConnectingMessage;
var const localized string PausedMessage;
var const localized string PrecachingMessage;

// Export UGameViewportClient::execConsoleCommand(FFrame&, void* const)
native function string ConsoleCommand(string Command);

// Export UGameViewportClient::execGetViewportSize(FFrame&, void* const)
native final function GetViewportSize(out Vector2D out_ViewportSize);

// Export UGameViewportClient::execSendInputAxis(FFrame&, void* const)
native final function bool SendInputAxis(int iControllerId, name Key, float fDelta, float fDeltaTime);

// Export UGameViewportClient::execSendInputKey(FFrame&, void* const)
native final function bool SendInputKey(int iControllerId, name Key, Object.EInputEvent Event, float fAmountDepressed);

function LocalPlayer CreatePlayer(int ControllerId, out string OutError, bool bSpawnActor)
{
    local LocalPlayer NewPlayer;

    // DebugMode: 0
    assert(Outer.LocalPlayerClass != none);
    NewPlayer = new (Outer) Outer.LocalPlayerClass;    
    NewPlayer.ViewportClient = self;
    NewPlayer.ControllerId = ControllerId;
    NewPlayer.m_iJoystickControllerId = ControllerId;
    AddLocalPlayer(NewPlayer);
    // End:0xAD
    if(bSpawnActor && !NewPlayer.SpawnPlayActor("", OutError))
    {
        RemoveLocalPlayer(NewPlayer);
        NewPlayer = none;
    }
    return NewPlayer;
    return;
}

function RemovePlayer(LocalPlayer ExPlayer)
{
    ExPlayer.ViewportClient = none;
    // End:0x74
    if(ExPlayer.Actor != none)
    {
        // End:0x5F
        if(ExPlayer.Actor.Pawn != none)
        {
            ExPlayer.Actor.Pawn.Destroy();
        }
        ExPlayer.Actor.Destroy();
    }
    RemoveLocalPlayer(ExPlayer);
    return;
}

// Export UGameViewportClient::execFindPlayerByControllerId(FFrame&, void* const)
native final function LocalPlayer FindPlayerByControllerId(int ControllerId);

exec function DebugCreatePlayer(int ControllerId)
{
    local string Error;

    CreatePlayer(ControllerId, Error, true);
    return;
}

exec function DebugRemovePlayer(int ControllerId)
{
    local LocalPlayer ExPlayer;

    ExPlayer = FindPlayerByControllerId(ControllerId);
    // End:0x28
    if(ExPlayer != none)
    {
        RemovePlayer(ExPlayer);
    }
    return;
}

event bool Init(out string OutError)
{
    // DebugMode: 0
    assert(Outer.ConsoleClass != none);
    ViewportConsole = new (self) Outer.ConsoleClass;    
    // End:0x8E
    if((InsertInteraction(ViewportConsole)) == -1)
    {
        OutError = "Failed to add interaction to GlobalInteractions array:" @ string(ViewportConsole);
        return false;
    }
    PlayerManager = new (self) Class'PlayerManagerInteraction';    
    // End:0x105
    if((InsertInteraction(PlayerManager)) == -1)
    {
        OutError = "Failed to add interaction to GlobalInteractions array:" @ string(PlayerManager);
        PlayerManager = none;
        return false;
    }
    return (CreatePlayer(0, OutError, false)) != none;
    return;
}

event int InsertInteraction(Interaction NewInteraction, optional int Index)
{
    local int Result;

    -1
    Result = -1;
    // End:0xB7
    if(NewInteraction != none)
    {
        // End:0x3A
        if(Index == -1)
        {
            Index = GlobalInteractions.Length;
        }
        // End:0x88
        if(Index >= 0)
        {
            Result = Clamp(Index, 0, GlobalInteractions.Length);
            GlobalInteractions.Insert(Result, 1);
            GlobalInteractions[Result] = NewInteraction;
            NewInteraction.Init();            
        }
        else
        {
            WarnInternal("Invalid insertion index specified:" @ string(Index));
        }
    }
    return Result;
    return;
}

event bool RemoveInteraction(Interaction pInteraction)
{
    local int iIndex;

    // End:0x16
    if(PlayerManager == pInteraction)
    {
        PlayerManager = none;
    }
    iIndex = GlobalInteractions.Find(pInteraction);
    // End:0x38
    if(iIndex == -1)
    {
        return false;
    }
    GlobalInteractions.Remove(iIndex, 1);
    return true;
    return;
}

event ResetUI()
{
    return;
}

event Tick(float DeltaTime)
{
    return;
}

exec function SetConsoleTarget(int PlayerIndex)
{
    // End:0x4C
    if((PlayerIndex >= 0) && PlayerIndex < Outer.GamePlayers.Length)
    {
        ViewportConsole.ConsoleTargetPlayer = Outer.GamePlayers[PlayerIndex];        
    }
    else
    {
        ViewportConsole.ConsoleTargetPlayer = none;
    }
    return;
}

event bool InputKey(int ControllerId, name Key, Object.EInputEvent Event, float AmountDepressed)
{
    local LocalPlayer TargetPlayer;

    TargetPlayer = FindPlayerByControllerId(ControllerId);
    // End:0x46
    if((TargetPlayer != none) && TargetPlayer.super(GameViewportClient).InputKey(ControllerId, Key, Event, AmountDepressed))
    {
        return false;
    }
    return SendInputKey(ControllerId, Key, Event, AmountDepressed);
    return;
}

event bool InputChar(int ControllerId, string Unicode)
{
    local int InteractionIndex;

    InteractionIndex = 0;
    J0x07:

    // End:0x46 [Loop If]
    if(InteractionIndex < GlobalInteractions.Length)
    {
        // End:0x3C
        if(GlobalInteractions[InteractionIndex].InputChar(ControllerId, Unicode))
        {
            return true;
        }
        InteractionIndex++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    return;
}

private final function AddLocalPlayer(LocalPlayer NewPlayer)
{
    Outer.GamePlayers[Outer.GamePlayers.Length] = NewPlayer;
    return;
}

private final function RemoveLocalPlayer(LocalPlayer ExistingPlayer)
{
    local int Index;

    Index = Outer.GamePlayers.Find(ExistingPlayer);
    // End:0x3E
    if(Index != -1)
    {
        Outer.GamePlayers.Remove(Index, 1);
    }
    return;
}

defaultproperties
{
    LoadingMessage="LOADING"
    SavingMessage="SAVING"
    ConnectingMessage="CONNECTING"
    PausedMessage="PAUSED"
    PrecachingMessage="PRECACHING"
}