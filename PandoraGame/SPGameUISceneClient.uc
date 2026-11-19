class SPGameUISceneClient extends GameUISceneClient within UIInteraction
    transient
    native
    config(UI);

var int LastViewportX;
var UIScene LastConfirmUIScene;
var bool bDisableMouseSelect;
var transient bool bFirstFrame;
var transient bool bToastVisible;
var transient bool bHidingToast;
var transient bool bDimScreen;
var Class MessageBoxClass;
var UIScene MessageBoxScene;
var transient string ToastMessage;
var transient float ShowStartTime;
var transient float HideStartTime;
var transient float ToastDuration;
var transient float ToastTransitionTime;
var transient Font ToastFont;
var transient Texture2D ToastImage;
var transient float ToastImageU;
var transient float ToastImageV;
var transient float ToastImageUL;
var transient float ToastImageVL;
var transient float ToastScale;
var transient LinearColor ToastColor;
var transient LinearColor ToastTextColor;
var transient string ScreenWarningMessage;
//var delegate<CBPreActivateControlByMouse> __CBPreActivateControlByMouse__Delegate;
//var delegate<CBPostActivateControlByMouse> __CBPostActivateControlByMouse__Delegate;

delegate bool CBPreActivateControlByMouse(UIObject Widget)
{
    //return ReturnValue;    
}

delegate CBPostActivateControlByMouse(UIObject Widget)
{
    //return;    
}

// Export USPGameUISceneClient::execGetWorldInfo(FFrame&, void* const)
native static function WorldInfo GetWorldInfo();

// Export USPGameUISceneClient::execIsInSystemMenu(FFrame&, void* const)
native function bool IsInSystemMenu();

// Export USPGameUISceneClient::execUpdateActiveControl(FFrame&, void* const)
native function UpdateActiveControl();

// Export USPGameUISceneClient::execActivateControlByMouse(FFrame&, void* const)
native function ActivateControlByMouse(UIObject Widget);

event bool PreActivateControlByMouse(UIObject Widget)
{
    // End:0x20
    if(__CBPreActivateControlByMouse__Delegate != none)
    {
        return CBPreActivateControlByMouse(Widget);
    }
    return true;
    //return ReturnValue;    
}

event PostActivateControlByMouse(UIObject Widget)
{
    // End:0x1F
    if(__CBPostActivateControlByMouse__Delegate != none)
    {
        CBPostActivateControlByMouse(Widget);
    }
    //return;    
}

function ResetMouseProcessing()
{
    __CBPreActivateControlByMouse__Delegate = None;
    __CBPostActivateControlByMouse__Delegate = None;
    //return;    
}

event ConditionalPause(bool bDesiredPauseState)
{
    local PlayerController PlayerOwner;

    // End:0xD4
    if(Outer.Outer.Outer.GamePlayers.Length > 0)
    {
        PlayerOwner = Outer.Outer.Outer.GamePlayers[0].Actor;
        // End:0xD4
        if(PlayerOwner != none)
        {
            // End:0x96
            if(int(PlayerOwner.WorldInfo.NetMode) != int(NM_Standalone))
            {
                bDesiredPauseState = false;
            }
            // End:0xD4
            if(bDesiredPauseState != PlayerOwner.IsPaused())
            {
                PlayerOwner.SetPause(bDesiredPauseState, CanUnpauseInternalUI);
            }
        }
    }
    //return;    
}

function bool NetworkSceneIsActive()
{
    local int I;
    local UIScene_BaseFrontEnd UISceneBFE;

    I = 0;
    J0x07:

    // End:0x59 [Loop If]
    if(I < ActiveScenes.Length)
    {
        UISceneBFE = UIScene_BaseFrontEnd(ActiveScenes[I]);
        // End:0x4F
        if((UISceneBFE != none) && UISceneBFE.bIsNetworkScene)
        {
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    //return ReturnValue;    
}

function bool MainMenuIsActive()
{
    local int I;
    local UIScene_BaseFrontEnd UISceneBFE;

    I = 0;
    J0x07:

    // End:0x72 [Loop If]
    if(I < ActiveScenes.Length)
    {
        UISceneBFE = UIScene_BaseFrontEnd(ActiveScenes[I]);
        // End:0x68
        if((UISceneBFE != none) && UISceneBFE.IsA('UIScene_MainMenu'))
        {
            // End:0x68
            if(UISceneBFE.IsVisible())
            {
                return true;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    //return ReturnValue;    
}

function UIScene GetActiveUIScene(name ClassName)
{
    local int I;
    local UIScene_BaseFrontEnd UISceneBFE;

    I = 0;
    J0x07:

    // End:0x5E [Loop If]
    if(I < ActiveScenes.Length)
    {
        UISceneBFE = UIScene_BaseFrontEnd(ActiveScenes[I]);
        // End:0x54
        if((UISceneBFE != none) && UISceneBFE.IsA(ClassName))
        {
            return UISceneBFE;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return none;
    //return ReturnValue;    
}

function bool CloseScenesByClass(name ClassName)
{
    local int I;
    local UIScene_BaseFrontEnd UISceneBFE;
    local bool bClosed;

    bClosed = false;
    I = 0;
    J0x0F:

    // End:0x74 [Loop If]
    if(I < ActiveScenes.Length)
    {
        UISceneBFE = UIScene_BaseFrontEnd(ActiveScenes[I]);
        // End:0x6A
        if((UISceneBFE != none) && UISceneBFE.IsA(ClassName))
        {
            CloseScene(UISceneBFE);
            bClosed = true;
        }
        I++;
        // [Loop Continue]
        goto J0x0F;
    }
    return bClosed;
    //return ReturnValue;    
}

static function UIScene_ConfirmationDialog CreateMessageBox(optional class<UIScene_ConfirmationDialog> CustomMessageBoxClass = default.MessageBoxClass)
{
    local UIScene_ConfirmationDialog Result;
    local GameUISceneClient GameSceneClient;

    GameSceneClient = Class'Engine.UIRoot'.static.GetSceneClient();
    // End:0x4F
    if(GameSceneClient != none)
    {
        Result = GameSceneClient.CreateScene(CustomMessageBoxClass, 'Confirmation_Dialog');
    }
    return Result;
    //return ReturnValue;    
}

static function UIScene_ConfirmationDialog ShowMessageBox(LocalPlayer ScenePlayerOwner, UIScene_BaseFrontEnd.eMsgBoxPriorityType msgPriority, string msg, string boxTitle, PandoraGRI.eMsgBoxType Mode, int nTimeoutValue, optional delegate<OnResults> OnResultsDelegate, optional delegate<OnMessage> OnMessageDelegate)
{
    local UIScene ExistingScene;
    local UIScene_ConfirmationDialog MessageBox;
    local GameUISceneClient GameSceneClient;
    local PandoraGameViewportClient pvc;

    GameSceneClient = Class'Engine.UIRoot'.static.GetSceneClient();
    MessageBox = none;
    // End:0xC1
    if(int(msgPriority) >= int(7))
    {
        pvc = PandoraGameViewportClient(ScenePlayerOwner.ViewportClient);
        // End:0xC1
        if(pvc != none)
        {
            // End:0xC1
            if(pvc.FullScreenIsMoviePlaying() == true)
            {
                pvc.DisableGameRendering();
                // End:0xB0
                if(pvc.FullScreenIsMoviePlaying())
                {
                    pvc.FullScreenSetNeedLoadingMovieOnCineCancel(false);
                }
                Class'Engine.GameEngine'.static.StopMovie(false);
            }
        }
    }
    // End:0x299
    if(GameSceneClient != none)
    {
        ExistingScene = GameSceneClient.FindSceneByTag('Confirmation_Dialog', ScenePlayerOwner);
        // End:0x130
        if(ExistingScene != none)
        {
            // End:0x11D
            if(UIScene_ConfirmationDialog(ExistingScene).msgPriority > int(msgPriority))
            {
                return none;
            }
            // End:0x130
            if(!ClearMessageScene(ScenePlayerOwner, true))
            {
                return none;
            }
        }
        // End:0x299
        if(GameSceneClient.OpenScene(default.MessageBoxScene, ScenePlayerOwner, ExistingScene) && ExistingScene != none)
        {
            MessageBox = UIScene_ConfirmationDialog(ExistingScene);
            MessageBox.msgPriority = int(msgPriority);
            MessageBox.SetMessageDatastoreBinding(msg);
            // End:0x1C5
            if(boxTitle != "")
            {
                MessageBox.SetTitleDatastoreBinding(boxTitle);
            }
            MessageBox.SimpleMode(Mode);
            MessageBox.nTimeout = nTimeoutValue;
            MessageBox.__OnResults__Delegate = OnResultsDelegate;
            // End:0x228
            if(OnMessageDelegate == none)
            {
                MessageBox.bOnFunctionMessage = false;                
            }
            else
            {
                MessageBox.bOnFunctionMessage = true;
                MessageBox.__OnMessage__Delegate = OnMessageDelegate;
            }
            MessageBox.nStartTime = int(ScenePlayerOwner.Actor.WorldInfo.RealTimeSeconds);
            MessageBox.eConfirmed = 0;            
        }
    }
    return MessageBox;
    //return ReturnValue;    
}

static final function bool ClearMessageScene(optional LocalPlayer ScenePlayerOwner, optional bool bCloseChildScenes = false)
{
    local GameUISceneClient GameSceneClient;
    local UIScene ExistingScene;
    local bool bResult;

    GameSceneClient = Class'Engine.UIRoot'.static.GetSceneClient();
    // End:0x8F
    if(GameSceneClient != none)
    {
        ExistingScene = GameSceneClient.FindSceneByTag('Confirmation_Dialog', ScenePlayerOwner);
        // End:0x8F
        if(ExistingScene != none)
        {
            UIScene_ConfirmationDialog(ExistingScene).eConfirmed = 4;
            bResult = GameSceneClient.CloseScene(ExistingScene, bCloseChildScenes);
        }
    }
    return bResult;
    //return ReturnValue;    
}

function SetToastMessage(string Message, optional float ToastTime = 6.0000000)
{
    // End:0x60
    if(bToastVisible == false)
    {
        bToastVisible = true;
        bHidingToast = false;
        ToastDuration = ToastTime;
        ToastMessage = Message;
        ShowStartTime = GetWorldInfo().RealTimeSeconds;
        bFirstFrame = false;        
    }
    else
    {
        // End:0x9B
        if(ToastDuration > 0.0000000)
        {
            ToastMessage = Message;
            ShowStartTime = GetWorldInfo().RealTimeSeconds + ToastTransitionTime;
        }
    }
    //return;    
}

event FinishToast()
{
    HideStartTime = GetWorldInfo().RealTimeSeconds;
    bHidingToast = true;
    bFirstFrame = false;
    //return;    
}

function ShowScreenWarningMessage(string Message)
{
    ScreenWarningMessage = Message;
    //return;    
}

function ClearScreenWarningMessage()
{
    ScreenWarningMessage = "";
    //return;    
}
