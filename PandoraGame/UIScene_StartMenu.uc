class UIScene_StartMenu extends UIScene_BaseFrontEnd;

var PandoraGRI.EGameStatus LastGameStatus;

event SceneActivated(bool bInitialActivation)
{
    local SPGameUISceneClient GameSceneClient;
    local UIScene_ConfirmationDialog ConfirmDialog;

    GameSceneClient = SPGameUISceneClient(SceneClient);
    // End:0x6E
    if(GameSceneClient != none)
    {
        ConfirmDialog = UIScene_ConfirmationDialog(GameSceneClient.GetActiveUIScene('UIScene_ConfirmationDialog'));
        // End:0x6B
        if(ConfirmDialog != none)
        {
            ConfirmDialog.Reset(OnConfirm);
        }        
    }
    LastGameStatus = SetOnlineStatusMode(0);
    super.SceneActivated(bInitialActivation);
    myPC = GetPC();
    // End:0xC8
    if(myPC != none)
    {
        myPC.PlayAmBxScript("menu_start", 0);
    }
    // End:0x12D
    if(IsPS3Build())
    {
        LocPlayer = GetPlayerOwner();
        // End:0x12A
        if((LocPlayer != none) && LocPlayer.ControllerId != 0)
        {
            SetMainControllerId(0);
            // End:0x12A
            if(myPC != none)
            {
                myPC.DoControllerCheck();
            }
        }        
    }
    else
    {
        // End:0x140
        if(IsPCBuild())
        {
            HandleReturnedFromMultiplayerGameOrMenu();
        }
    }
    //return;    
}

function HandleReturnedFromMultiplayerGameOrMenu()
{
    local string MultiplayerCheck;

    // End:0x97
    if((GetDataStoreStringValue("<Registry:Player_Online>", MultiplayerCheck)) && MultiplayerCheck == "1")
    {
        // End:0x97
        if(DoesThisMenuItemHaveValidSceneRef(MenuItems[CurrMenuItemIdx]))
        {
            // End:0x97
            if(PreOnClick(CurrMenuItemIdx))
            {
                PlayUISound('Clicked');
                ActivateRemoteEvent(MenuItems[CurrMenuItemIdx].RemoteEvent);
            }
        }
    }
    SetDataStoreStringValue("<Registry:FrontEndError_Online>", "0");
    //return;    
}

event SceneDeactivated()
{
    super.SceneDeactivated();
    myPC.StopAmBxScript("menu_start");
    //return;    
}

function OnConfirm(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    GetPC().DestroySession();    
    GetPC().ConsoleCommand("disconnect");
    //return;    
}

function SetMainControllerId(int ControllerId)
{
    local LocalPlayer LP;

    LP = GetPlayerOwner(0);
    LP.SetControllerId(ControllerId);
    //return;    
}

function bool CustomInputKey(const out InputEventParameters EventParms)
{
    UpDateUsingGamePadForPC(EventParms);
    // End:0x1A
    if(bInputDisabled)
    {
        return true;
    }
    // End:0x2BD
    if((int(EventParms.EventType) == int(1)) && IsXboxBuild() || EventParms.ControllerId == 0)
    {
        // End:0x104
        if(bAttractModeEnabled && bAttractModeRunning)
        {
            // End:0x101
            if((((((IsPCBuild() || IsInputAccept(EventParms)) || IsInputCancel(EventParms)) || IsInputAlt2Accept(EventParms)) || IsInputAltAccept(EventParms)) || IsInputStart(EventParms)) || IsInputLeftMouseUp(EventParms))
            {
                RestartAttractMode();
                EnableButtonDelay();
            }            
        }
        else
        {
            // End:0x2BD
            if(((IsPCBuild() || IsInputAccept(EventParms)) || IsInputStart(EventParms)) || IsInputLeftMouseUp(EventParms))
            {
                // End:0x1C1
                if(IsXboxBuild())
                {
                    // End:0x171
                    if(myPC != none)
                    {
                        myPC.ClearOnlineDelegates();
                    }
                    SetMainControllerId(EventParms.ControllerId);
                    // End:0x1BE
                    if(myPC != none)
                    {
                        myPC.RegisterOnlineDelegates();
                        myPC.ReadProfile();
                    }                    
                }
                else
                {
                    SetMainControllerId(0);
                }
                // End:0x2BD
                if(DoesThisMenuItemHaveValidSceneRef(MenuItems[CurrMenuItemIdx]))
                {
                    // End:0x23D
                    if(!IsInputEscape(EventParms))
                    {
                        // End:0x23A
                        if(PreOnClick(CurrMenuItemIdx))
                        {
                            PlayUISound('Clicked');
                            ActivateRemoteEvent(MenuItems[CurrMenuItemIdx].RemoteEvent);
                        }                        
                    }
                    else
                    {
                        ShowMsgBox("<strings:PlatformPC.ErrorMessages.ExitGame_Message>", "<strings:PlatformPC.ErrorMessages.ExitGame_Title>", 1, OnMessageResults);
                    }
                }
            }
        }
    }
    return true;
    //return ReturnValue;    
}

function OnMessageResults(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    // End:0x5C
    if(int(eReturnValue) == int(1))
    {
        // End:0x5C
        if((LocPlayer != none) && LocPlayer.Actor != none)
        {            
            LocPlayer.Actor.ConsoleCommand("exit");
        }
    }
    //return;    
}
