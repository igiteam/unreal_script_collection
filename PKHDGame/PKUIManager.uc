class PKUIManager extends UIManager within PKUIInteraction;

struct MMHistoryItem
{
    var byte screen;
    var byte SelectedOption;

    structdefaultproperties
    {
        screen=0
        SelectedOption=0
    }
};

struct MMDisabledItem
{
    var byte screen;
    var byte SelectionIdx;
    var bool bIsDisabled;

    structdefaultproperties
    {
        screen=0
        SelectionIdx=0
        bIsDisabled=false
    }
};

var transient class<UIScene_Busy> UpdatingSceneClass;
var transient UIScene_Busy UpdatingScene;
var transient class<UIScene_Checkpoint> CheckpointUpdatingSceneClass;
var transient UIScene_Checkpoint CheckpointScene;
var array<UIScene_MessageBox> OpenMessageBoxes;
var transient class<UIScene_MessageBox> MessageBoxClass;
var transient class<UIScene_PasswordBox> PasswordBoxClass;
var UIScene_PasswordBox ActivePasswordBox;
var byte LastSelectedIndex;
var const float ChatIconHoldTime;
var const float ChatIconFadeTime;

static function OpenUpdatingScene(optional string WaitingString = "", optional string ExplanationString = "", optional bool bIsCheckpoint, optional float MinDisplayTime = -1.0000000)
{
    local PKUIManager Manager;
    local UIScene_Busy Retval;

    Manager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x34E
    if(Manager != none)
    {
        // End:0x8F
        if(bIsCheckpoint)
        {
            Retval = Manager.CheckpointScene;            
        }
        else
        {
            Retval = Manager.UpdatingScene;
        }
        // End:0x30A
        if((Retval == none) || Retval.IsPendingKill())
        {
            // End:0x147
            if(bIsCheckpoint)
            {
                Retval = new (Class'Engine.Engine'.static.GetEngine().GamePlayers[0]) default.CheckpointUpdatingSceneClass;                
            }
            else
            {
                Retval = new (Class'Engine.Engine'.static.GetEngine().GamePlayers[0]) default.UpdatingSceneClass;
            }
            // End:0x30A
            if(Retval != none)
            {
                // End:0x1DB
                if(WaitingString != "")
                {
                    Retval.WaitingString = WaitingString;
                }
                // End:0x213
                if(ExplanationString != "")
                {
                    Retval.ExplanationString = ExplanationString;
                }
                // End:0x24C
                if(MinDisplayTime >= float(0))
                {
                    Retval.MinWaitTime = MinDisplayTime;
                }
                Retval.Init(Class'Engine.Engine'.static.GetEngine().GamePlayers[0]);
                // End:0x2E2
                if(bIsCheckpoint)
                {
                    Manager.CheckpointScene = UIScene_Checkpoint(Retval);                    
                }
                else
                {
                    Manager.UpdatingScene = Retval;
                }
            }
        }
        // End:0x34E
        if(!bIsCheckpoint)
        {
            Manager.UpdatingScene.SetVisible(true);
        }
    }
    //return;    
}

static function CloseUpdatingScene(optional bool bIsCheckpoint)
{
    local PKUIManager Manager;

    Manager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x102
    if(Manager != none)
    {
        // End:0xAA
        if(bIsCheckpoint)
        {
            // End:0xA7
            if(Manager.CheckpointScene != none)
            {
                Manager.CheckpointScene.CloseWaitScreen();
            }            
        }
        else
        {
            // End:0x102
            if(Manager.UpdatingScene != none)
            {
                Manager.UpdatingScene.CloseWaitScreen();
            }
        }
    }
    //return;    
}

static function UpdateUpdatingScene(optional string WaitingString = "", optional string ExplanationString = "")
{
    local PKUIManager Manager;

    Manager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0xB7
    if(Manager != none)
    {
        // End:0xB7
        if(Manager.UpdatingScene != none)
        {
            Manager.UpdatingScene.UpdateBusyStrings(WaitingString, ExplanationString);
        }
    }
    //return;    
}

function UpdatingSceneClosed(UIScene_Busy ClosedScene)
{
    // End:0x22
    if(ClosedScene == UpdatingScene)
    {
        UpdatingScene = none;
    }
    //return;    
}

function bool OnTooManyProfilesErrorAccepted(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x29
    if(Class'Engine.UIInteraction'.static.GetLoggedInPlayerCount() <= 2)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function NotifyPlayerAdded(int PlayerIndex, LocalPlayer AddedPlayer)
{
    //return;    
}

function NotifyPlayerRemoved(int PlayerIndex, LocalPlayer RemovedPlayer)
{
    //return;    
}

function RefreshPlayerDeadZone()
{
    //return;    
}

static final function bool IsUIMessageActive(name SceneTag, optional LocalPlayer LocalPlayerOwner)
{
    local PKUIManager Manager;
    local int I;

    Manager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x17D
    if(Manager != none)
    {
        I = 0;
        J0x4D:

        // End:0x17D [Loop If]
        if(I < Manager.OpenMessageBoxes.Length)
        {
            // End:0x16F
            if((Manager.OpenMessageBoxes[I].MessageName == SceneTag) && ((LocalPlayerOwner == none) || Manager.OpenMessageBoxes[I].LocalPlayerOwnerIndex == -1) || Manager.OpenMessageBoxes[I].GetLP() == LocalPlayerOwner)
            {
                return true;
            }
            I++;
            // [Loop Continue]
            goto J0x4D;
        }
    }
    return false;
    //return ReturnValue;    
}

static function bool ShowUIMessage(name SceneTag, string Title, string Body, array<name> ButtonAliases, optional delegate<OnOptionSelected> SelectionCallback = None, optional LocalPlayer LocalPlayerOwner, optional out UIScene_MessageBox out_CreatedBox, optional byte Priority = 0, optional bool bPauseGameWhileActive, optional bool bOnlyOwnerFocusable = true, optional bool bCloseOnLevelChange = true, optional bool bBlurMoviesUnder = true, optional bool bDiscardNonOwnerInput = false)
{
    local UIScene_MessageBox MessageBox;
    local PKUIManager Manager;
    local bool bResult;
    local int I;
    local string ButtonAliasString;
    local DataStoreClient DSClient;
    local UIDataStore_InputAlias InputAliasDS;

    DSClient = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0xA6
    if(DSClient != none)
    {
        InputAliasDS = UIDataStore_InputAlias(DSClient.FindDataStore('ButtonCallouts'));
    }
    // End:0xB7
    if(InputAliasDS == none)
    {
        return false;
    }
    Manager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x7D1
    if(Manager != none)
    {
        I = 0;
        J0x103:

        // End:0x22A [Loop If]
        if(I < Manager.OpenMessageBoxes.Length)
        {
            // End:0x21C
            if((Manager.OpenMessageBoxes[I].MessageName == SceneTag) && Manager.OpenMessageBoxes[I].LocalPlayerOwnerIndex == Manager.FindLocalPlayerIndex(LocalPlayerOwner))
            {
                MessageBox = Manager.OpenMessageBoxes[I];
                // [Explicit Break]
                goto J0x22A;
            }
            I++;
            // [Loop Continue]
            goto J0x103;
        }
        J0x22A:

        // End:0x7D1
        if(MessageBox == none)
        {
            MessageBox = new (Manager) default.MessageBoxClass;
            // End:0x7D1
            if(MessageBox != none)
            {
                MessageBox.MessageName = SceneTag;
                MessageBox.TitleString = Title;
                MessageBox.BodyString = Body;
                // End:0x398
                if(ButtonAliases.Length > 0)
                {
                    MessageBox.ContinueInputAlias = ButtonAliases[0];
                    ButtonAliasString = InputAliasDS.GetAliasFontMarkup(ButtonAliases[0]);
                    MessageBox.ContinueString = ButtonAliasString;
                    MessageBox.bContinueVisible = true;
                }
                // End:0x450
                if(ButtonAliases.Length > 1)
                {
                    MessageBox.CancelInputAlias = ButtonAliases[1];
                    ButtonAliasString = InputAliasDS.GetAliasFontMarkup(ButtonAliases[1]);
                    MessageBox.CancelString = ButtonAliasString;
                    MessageBox.bCancelVisible = true;
                }
                // End:0x50B
                if(ButtonAliases.Length > 2)
                {
                    MessageBox.RetryInputAlias = ButtonAliases[2];
                    ButtonAliasString = InputAliasDS.GetAliasFontMarkup(ButtonAliases[2]);
                    MessageBox.RetryString = ButtonAliasString;
                    MessageBox.bRetryVisible = true;
                }
                // End:0x542
                if(SelectionCallback != none)
                {
                    MessageBox.__OnOptionSelected__Delegate = SelectionCallback;
                }
                // End:0x57E
                if(int(Priority) != int(0))
                {
                    MessageBox.SetPriority(Priority);
                }
                // End:0x606
                if(bPauseGameWhileActive)
                {
                    MessageBox.bPauseGameWhileActive = bPauseGameWhileActive;
                    Manager.PauseGame(bPauseGameWhileActive, Manager.FindLocalPlayerIndex(LocalPlayerOwner));
                }
                MessageBox.bOnlyOwnerFocusable = bOnlyOwnerFocusable;
                MessageBox.bCloseOnLevelChange = bCloseOnLevelChange;
                MessageBox.bBlurLesserMovies = bBlurMoviesUnder;
                MessageBox.bDiscardNonOwnerInput = bDiscardNonOwnerInput;
                // End:0x720
                if(LocalPlayerOwner != none)
                {
                    MessageBox.LocalPlayerOwnerIndex = Class'Engine.Engine'.static.GetEngine().GamePlayers.Find(LocalPlayerOwner);                    
                }
                else
                {
                    MessageBox.LocalPlayerOwnerIndex = 0;
                }
                MessageBox.Init(LocalPlayerOwner);
                MessageBox.PlayOpenAnimation();
                Manager.OpenMessageBoxes.AddItem(MessageBox);
                out_CreatedBox = MessageBox;
                bResult = true;
            }
        }
    }
    return bResult;
    //return ReturnValue;    
}

static final function bool ClearUIMessage(name SceneTag, optional LocalPlayer LocalPlayerOwner, optional bool bImmediatelyClearReference = false)
{
    local PKUIManager Manager;
    local bool bResult;
    local int I;

    Manager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x214
    if(Manager != none)
    {
        I = 0;
        J0x52:

        // End:0x214 [Loop If]
        if(I < Manager.OpenMessageBoxes.Length)
        {
            // End:0x206
            if((Manager.OpenMessageBoxes[I].MessageName == SceneTag) && ((LocalPlayerOwner == none) || Manager.OpenMessageBoxes[I].LocalPlayerOwnerIndex == -1) || Manager.OpenMessageBoxes[I].GetLP() == LocalPlayerOwner)
            {
                Manager.OpenMessageBoxes[I].StartExit();
                // End:0x1FA
                if(bImmediatelyClearReference)
                {
                    RemoveUIMessageReference(Manager.OpenMessageBoxes[I]);
                    I--;
                }
                bResult = true;
            }
            I++;
            // [Loop Continue]
            goto J0x52;
        }
    }
    return bResult;
    //return ReturnValue;    
}

static final function CloseAllUIMessageBoxes(optional LocalPlayer LP, optional name SkipSceneTag = 'None')
{
    local int I;
    local PKUIManager Manager;
    local bool bSkipSceneTag;

    Manager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x1B3
    if(Manager != none)
    {
        I = 0;
        J0x5A:

        // End:0x1B3 [Loop If]
        if(I < Manager.OpenMessageBoxes.Length)
        {
            bSkipSceneTag = !(SkipSceneTag == 'None') || SkipSceneTag != Manager.OpenMessageBoxes[I].MessageName;
            // End:0x1A5
            if((!bSkipSceneTag || LP == none) || LP == Manager.OpenMessageBoxes[I].GetLP())
            {
                Manager.OpenMessageBoxes[I].Close();                
            }
            else
            {
                I++;
            }
            // [Loop Continue]
            goto J0x5A;
        }
    }
    //return;    
}

static final function RemoveUIMessageReference(UIScene_MessageBox MessageBox)
{
    local PKUIManager Manager;

    Manager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x6C
    if(Manager != none)
    {
        Manager.OpenMessageBoxes.RemoveItem(MessageBox);
    }
    //return;    
}

static final function UIScene_MessageBox DisplayErrorMessage(string MessageKey, optional string TitleKey, optional string ButtonAliasString, optional LocalPlayer OwningPlayer, optional delegate<OnOptionSelected> SelectionCallback = None, optional bool bClearExistingMessages, optional byte ForcedScenePriority, optional bool bOnlyOwnerFocusable = true, optional bool bShouldDiscardNonOwnerInput)
{
    local int I;
    local name ErrorSceneTag;
    local array<name> ButtonAliases;
    local array<string> ButtonAliasStringArray;
    local UIScene_MessageBox ErrorMessageScene;

    ButtonAliasStringArray = SplitString(ButtonAliasString);
    I = 0;
    J0x4A:

    // End:0x99 [Loop If]
    if(I < ButtonAliasStringArray.Length)
    {
        ButtonAliases[I] = name(ButtonAliasStringArray[I]);
        I++;
        // [Loop Continue]
        goto J0x4A;
    }
    // End:0xD5
    if(TitleKey == "")
    {
        TitleKey = "ErrorTitle";
        ErrorSceneTag = 'ErrorMessage';        
    }
    else
    {
        ErrorSceneTag = name(TitleKey);
    }
    Class'PKUIManager'.static.ShowUIMessage(ErrorSceneTag, Localize("MessageBoxErrorStrings", TitleKey, "PKHDGame"), Localize("MessageBoxErrorStrings", MessageKey, "PKHDGame"), ButtonAliases, SelectionCallback, OwningPlayer, ErrorMessageScene, ForcedScenePriority,, bOnlyOwnerFocusable);
    // End:0x211
    if(ErrorMessageScene != none)
    {
        ErrorMessageScene.bCloseOnLevelChange = false;
        ErrorMessageScene.bDiscardNonOwnerInput = bShouldDiscardNonOwnerInput;
    }
    return ErrorMessageScene;
    //return ReturnValue;    
}

static function bool ShowPasswordBox(name SceneTag, string Title, string Body, array<name> ButtonAliases, optional delegate<OnOptionSelected> SelectionCallback = None, optional LocalPlayer LocalPlayerOwner, optional out UIScene_PasswordBox out_CreatedBox, optional byte Priority = 0, optional bool bPauseGameWhileActive, optional bool bOnlyOwnerFocusable = true, optional bool bCloseOnLevelChange = true, optional bool bBlurMoviesUnder = true, optional bool bDiscardNonOwnerInput = false)
{
    local UIScene_PasswordBox MessageBox;
    local PKUIManager Manager;
    local bool bResult;
    local string ButtonAliasString;
    local DataStoreClient DSClient;
    local UIDataStore_InputAlias InputAliasDS;

    DSClient = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0xA6
    if(DSClient != none)
    {
        InputAliasDS = UIDataStore_InputAlias(DSClient.FindDataStore('ButtonCallouts'));
    }
    // End:0xB7
    if(InputAliasDS == none)
    {
        return false;
    }
    Manager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x6C4
    if(Manager != none)
    {
        MessageBox = Manager.ActivePasswordBox;
        // End:0x6C4
        if(MessageBox == none)
        {
            MessageBox = new (Manager) default.PasswordBoxClass;
            // End:0x6C4
            if(MessageBox != none)
            {
                MessageBox.MessageName = SceneTag;
                MessageBox.TitleString = Title;
                MessageBox.BodyString = Body;
                // End:0x28E
                if(ButtonAliases.Length > 0)
                {
                    MessageBox.ContinueInputAlias = ButtonAliases[0];
                    ButtonAliasString = InputAliasDS.GetAliasFontMarkup(ButtonAliases[0]);
                    MessageBox.ContinueString = ButtonAliasString;
                    MessageBox.bContinueVisible = true;
                }
                // End:0x346
                if(ButtonAliases.Length > 1)
                {
                    MessageBox.CancelInputAlias = ButtonAliases[1];
                    ButtonAliasString = InputAliasDS.GetAliasFontMarkup(ButtonAliases[1]);
                    MessageBox.CancelString = ButtonAliasString;
                    MessageBox.bCancelVisible = true;
                }
                // End:0x401
                if(ButtonAliases.Length > 2)
                {
                    MessageBox.RetryInputAlias = ButtonAliases[2];
                    ButtonAliasString = InputAliasDS.GetAliasFontMarkup(ButtonAliases[2]);
                    MessageBox.RetryString = ButtonAliasString;
                    MessageBox.bRetryVisible = true;
                }
                // End:0x438
                if(SelectionCallback != none)
                {
                    MessageBox.__OnOptionSelected__Delegate = SelectionCallback;
                }
                // End:0x474
                if(int(Priority) != int(0))
                {
                    MessageBox.SetPriority(Priority);
                }
                // End:0x4FC
                if(bPauseGameWhileActive)
                {
                    MessageBox.bPauseGameWhileActive = bPauseGameWhileActive;
                    Manager.PauseGame(bPauseGameWhileActive, Manager.FindLocalPlayerIndex(LocalPlayerOwner));
                }
                MessageBox.bOnlyOwnerFocusable = bOnlyOwnerFocusable;
                MessageBox.bCloseOnLevelChange = bCloseOnLevelChange;
                MessageBox.bBlurLesserMovies = bBlurMoviesUnder;
                MessageBox.bDiscardNonOwnerInput = bDiscardNonOwnerInput;
                // End:0x616
                if(LocalPlayerOwner != none)
                {
                    MessageBox.LocalPlayerOwnerIndex = Class'Engine.Engine'.static.GetEngine().GamePlayers.Find(LocalPlayerOwner);                    
                }
                else
                {
                    MessageBox.LocalPlayerOwnerIndex = 0;
                }
                MessageBox.Init(LocalPlayerOwner);
                MessageBox.PlayOpenAnimation();
                Manager.ActivePasswordBox = MessageBox;
                out_CreatedBox = MessageBox;
                bResult = true;
            }
        }
    }
    return bResult;
    //return ReturnValue;    
}

function int FindLocalPlayerIndex(Player P)
{
    local Engine Engine;
    local int I;

    Engine = Class'Engine.Engine'.static.GetEngine();
    I = 0;
    J0x34:

    // End:0xAF [Loop If]
    if(I < Engine.GamePlayers.Length)
    {
        // End:0xA1
        if(Engine.GamePlayers[I] == P)
        {
            return I;
        }
        I++;
        // [Loop Continue]
        goto J0x34;
    }
    return 0;
    //return ReturnValue;    
}

static function float GetChatIconOpacity(PainPRI PlayerPRI)
{
    // End:0x8C
    if(PlayerPRI.bIsTalking || (Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds - PlayerPRI.LastTalkTime) < default.ChatIconHoldTime)
    {
        return 1.0000000;
    }
    return FMax(0.0000000, 1.0000000 - (((Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds - PlayerPRI.LastTalkTime) - default.ChatIconHoldTime) / default.ChatIconFadeTime));
    //return ReturnValue;    
}

defaultproperties
{
    UpdatingSceneClass=Class'UIScene_Busy'
    CheckpointUpdatingSceneClass=Class'UIScene_Checkpoint'
    MessageBoxClass=Class'UIScene_MessageBox'
    PasswordBoxClass=Class'UIScene_PasswordBox'
    ChatIconHoldTime=0.5000000
    ChatIconFadeTime=1.5000000
}