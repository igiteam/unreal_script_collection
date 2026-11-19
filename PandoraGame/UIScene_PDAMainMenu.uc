class UIScene_PDAMainMenu extends UIScene_BaseFrontEnd;

struct MsgCountInfo
{
    /** INCLUDES MACROS STRUCT DECLARATIONS */
    var() string LabelName;
    var UILabel LabelObj;

    structdefaultproperties
    {
        LabelName=""
        LabelObj=none
    }
};

/** VARIABLE DECLARATIONS */
var(Menu) array<MsgCountInfo> NewMsgCountList;
var transient bool bOverrideEmulateButtonPress;

event SceneActivated(bool bInitialActivation)
{
    super.SceneActivated(bInitialActivation);
    // End:0x52
    if(bInitialActivation)
    {
        InitNewMsgCountList();
        bOverrideEmulateButtonPress = GameUISceneClient(SceneClient).bOverrideEmulateButtonPress;
        GameUISceneClient(SceneClient).bOverrideEmulateButtonPress = false;
    }
    AppendNewMsgCountToLabel();
    myPC.PlayAmBxScript("menu_pda", 0);
    //return;    
}

event SceneDeactivated()
{
    super.SceneDeactivated();
    myPC.StopAmBxScript("menu_pda");
    //return;    
}

function amBXPulseMenuItemChange()
{
    // End:0x2F
    if(bSceneUsesAmBxEffects)
    {
        myPC.PlayAmBxScript("menu_pda_pulse", 30);
    }
    //return;    
}

function InitNewMsgCountList()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x5C [Loop If]
    if(I < NewMsgCountList.Length)
    {
        NewMsgCountList[I].LabelObj = UILabel(FindChild(name(NewMsgCountList[I].LabelName), true));
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function OnClick(UIScene OpenedScene, int MenuIndex)
{
    // End:0x15F
    if((myPC != none) && myPC.PDAManager != none)
    {
        // End:0x60
        if(MenuIndex == (MenuIndexByName("btnPickup")))
        {
            myPC.PDAManager.SortBy = 8;            
        }
        else
        {
            // End:0xA1
            if(MenuIndex == (MenuIndexByName("btnCreatures")))
            {
                myPC.PDAManager.SortBy = 2;                
            }
            else
            {
                // End:0xE3
                if(MenuIndex == (MenuIndexByName("btnObjectives")))
                {
                    myPC.PDAManager.SortBy = 1;                    
                }
                else
                {
                    // End:0x125
                    if(MenuIndex == (MenuIndexByName("btnEquipments")))
                    {
                        myPC.PDAManager.SortBy = 3;                        
                    }
                    else
                    {
                        // End:0x15F
                        if(MenuIndex == (MenuIndexByName("btnNotes")))
                        {
                            myPC.PDAManager.SortBy = 4;
                        }
                    }
                }
            }
        }
    }
    //return;    
}

function AppendNewMsgCountToLabel()
{
    local int I;
    local PandoraPDAManager PDAManager;
    local int NewMessageCount;
    local string labelText;

    // End:0x20
    if(myPC != none)
    {
        PDAManager = myPC.PDAManager;
    }
    // End:0x2D
    if(PDAManager == none)
    {
        return;
    }
    I = 0;
    J0x34:

    // End:0x283 [Loop If]
    if(I < MenuItems.Length)
    {
        // End:0x279
        if(MenuItems[I].ButtonObj != none)
        {
            // End:0x9B
            if(MenuItems[I].ButtonName == "btnPickup")
            {
                PDAManager.SortBy = 8;                
            }
            else
            {
                // End:0xD9
                if(MenuItems[I].ButtonName == "btnCreatures")
                {
                    PDAManager.SortBy = 2;                    
                }
                else
                {
                    // End:0x118
                    if(MenuItems[I].ButtonName == "btnObjectives")
                    {
                        PDAManager.SortBy = 1;                        
                    }
                    else
                    {
                        // End:0x157
                        if(MenuItems[I].ButtonName == "btnEquipments")
                        {
                            PDAManager.SortBy = 3;                            
                        }
                        else
                        {
                            // End:0x191
                            if(MenuItems[I].ButtonName == "btnNotes")
                            {
                                PDAManager.SortBy = 4;                                
                            }
                            else
                            {
                                PDAManager.SortBy = 0;
                            }
                        }
                    }
                }
            }
            NewMessageCount = PDAManager.GetUnlockedNewMessageCount();
            // End:0x243
            if(NewMessageCount > 0)
            {
                labelText = "";
                labelText = labelText $ string(NewMessageCount);
                // End:0x240
                if(I < NewMsgCountList.Length)
                {
                    NewMsgCountList[I].LabelObj.SetVisibility(true);
                    NewMsgCountList[I].LabelObj.SetValue(labelText);
                }
                // [Explicit Continue]
                goto J0x279;
            }
            // End:0x279
            if(I < NewMsgCountList.Length)
            {
                NewMsgCountList[I].LabelObj.SetVisibility(false);
            }
        }
        J0x279:

        I++;
        // [Loop Continue]
        goto J0x34;
    }
    //return;    
}

function bool ProcessAcceptInput(const out InputEventParameters EventParms)
{
    local UIScene newScene;
    local UIScene_BaseFrontEnd newBFEScene;

    // End:0x13B
    if(IsInputAccept(EventParms))
    {
        PlayUISound('Clicked');
        OnClick(none, CurrMenuItemIdx);
        // End:0x139
        if(DoesThisMenuItemHaveValidSceneRef(MenuItems[CurrMenuItemIdx]))
        {
            FadeOut(fadeOutTimeEd);
            ActivateRemoteEvent(MenuItems[CurrMenuItemIdx].RemoteEvent);
            SceneClient.OpenScene(GetMenuItemsValidSceneRef(MenuItems[CurrMenuItemIdx]), LocPlayer, newScene);
            newBFEScene = UIScene_BaseFrontEnd(newScene);
            // End:0x139
            if(newBFEScene != none)
            {
                newBFEScene.PreviousMenuScene = self;
                newBFEScene.LocPlayer = LocPlayer;
                newBFEScene.BaseScene = BaseScene;
                newBFEScene.SetVisibility(true);
                newBFEScene.FadeIn(fadeInTimeEd, fadeOutTimeEd / float(2));
            }
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool ProcessCancelInput(const out InputEventParameters EventParms)
{
    local PandoraPDAManager PDAManager;
    local PandoraPlayerInput PanInput;

    // End:0x135
    if(IsInputCancel(EventParms))
    {
        PlayUISound('SceneClosed');
        ActivateRemoteEvent(OnExitRemoteEventName);
        SceneClient.CloseScene(self);
        GameUISceneClient(SceneClient).bOverrideEmulateButtonPress = bOverrideEmulateButtonPress;
        // End:0xE3
        if(myPC != none)
        {
            PDAManager = myPC.PDAManager;
            // End:0xCE
            if(PDAManager != none)
            {
                PDAManager.ConvertPDAMsgData();
                myPC.ProfileSettings.SaveUnlockedPDAMessageData(PDAManager.PDAMsgData);                
            }
            myPC.WriteProfile();
        }
        // End:0x133
        if((myPC != none) && myPC.PlayerInput != none)
        {
            PanInput = PandoraPlayerInput(myPC.PlayerInput);
            PanInput.ForceFlushOfInput();
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool ProcessEscapeInput(const out InputEventParameters EventParms)
{
    local PandoraPlayerInput PanInput;

    // End:0xB1
    if(IsInputEscape(EventParms))
    {
        PlayUISound('SceneClosed');
        ActivateRemoteEvent(OnExitRemoteEventName);
        SceneClient.CloseScene(self);
        GameUISceneClient(SceneClient).bOverrideEmulateButtonPress = bOverrideEmulateButtonPress;
        // End:0xAF
        if((myPC != none) && myPC.PlayerInput != none)
        {
            PanInput = PandoraPlayerInput(myPC.PlayerInput);
            PanInput.ForceFlushOfInput();
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}
