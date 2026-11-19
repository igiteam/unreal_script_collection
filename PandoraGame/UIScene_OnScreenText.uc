class UIScene_OnScreenText extends UIScene_BaseFrontEnd;

var int CommandIndex;
var string StringBackup;
var bool bLookMoveTutorial;
var array<string> LookMoveTutorialStrings;
//var delegate<OnSceneClose> __OnSceneClose__Delegate;
//var delegate<OnFadeOutCompleted> __OnFadeOutCompleted__Delegate;

delegate OnSceneClose()
{
    //return;    
}

delegate OnFadeOutCompleted()
{
    //return;    
}

event InitScene()
{
    super.InitScene();
    // End:0x17
    if(IsPCBuild())
    {
        bFlushPlayerInput = false;
    }
    __OnSceneActivated__Delegate = PostSceneActived;
    //return;    
}

event SceneActivated(bool bInitialActivation)
{
    local int CurrStickConfig;

    super.SceneActivated(bInitialActivation);
    bPauseGameWhileActive = false;
    bDisplayCursor = false;
    // End:0x94
    if(!bInitialActivation)
    {
        // End:0x84
        if(bLookMoveTutorial && myPC != none)
        {
            CurrStickConfig = int(myPC.ProfileSettings.GetStickConfigOption());
            // End:0x84
            if(CurrStickConfig < LookMoveTutorialStrings.Length)
            {
                StringBackup = LookMoveTutorialStrings[CurrStickConfig];
            }
        }
        SetOnScreenText(StringBackup, true);
    }
    //return;    
}

function SetTitle(string Markup)
{
    local UILabel Lbl;

    Lbl = UILabel(FindChild('lblTitle', true));
    // End:0x51
    if(Lbl != none)
    {
        Lbl.SetVisibility(true);
        Lbl.SetDataStoreBinding(Markup);
    }
    //return;    
}

function SetOnScreenText(string Markup, optional bool bReset = false)
{
    local UILabel lblText;
    local string strToProcess, strModified;
    local PandoraPlayerInput PanInput;

    // End:0x2A
    if(myPC != none)
    {
        PanInput = PandoraPlayerInput(myPC.PlayerInput);
    }
    lblText = UILabel(FindChild('lblTextMsg', true));
    // End:0x102
    if((lblText != none) && PanInput != none)
    {
        // End:0x9D
        if(bReset)
        {
            lblText.SetDataStoreBinding("<strings:PandoraGame.helptext.Empty>");
        }
        lblText.SetDataStoreBinding(Markup);
        strToProcess = lblText.GetValue();
        strModified = PanInput.ProcessButtonToFontMapping(strToProcess);
        lblText.SetValue(strModified);
    }
    //return;    
}

event FadeCompleted()
{
    super(SPUIScene).FadeCompleted();
    // End:0x36
    if(Opacity <= 0.0000000)
    {
        SceneClient.CloseScene(self);
        OnFadeOutCompleted();
    }
    //return;    
}

function bool CustomInputKey(const out InputEventParameters EventParms)
{
    UpDateUsingGamePadForPC(EventParms);
    // End:0x5F
    if(IsButtonPressed(CommandIndex, EventParms))
    {
        // End:0x5F
        if(myPC != none)
        {
            myPC.StopOnScreenText(myPC.currOnScreenText.Action);
        }
    }
    return false;
    //return ReturnValue;    
}

function bool IsButtonPressed(int CommandId, const InputEventParameters EventParms)
{
    local PandoraPlayerInput PanInput;
    local string ButtonName;

    // End:0x0D
    if(CommandId < 0)
    {
        return false;
    }
    ButtonName = "";
    // End:0x3A
    if(myPC != none)
    {
        PanInput = PandoraPlayerInput(myPC.PlayerInput);
    }
    // End:0x64
    if(PanInput != none)
    {
        ButtonName = PanInput.GetCommandButtonNameByIndex(CommandId);
    }
    // End:0xA2
    if((EventParms.InputKeyName == name(ButtonName)) && int(EventParms.EventType) == int(0))
    {
        return true;        
    }
    else
    {
        // End:0x103
        if(IsPCBuild() && PanInput != none)
        {
            // End:0x103
            if(PanInput.DoesKeyBondedCommandMatchThisCommand(CommandId, EventParms.InputKeyName) && int(EventParms.EventType) == int(0))
            {
                return true;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
    super.UpdateScene(DeltaTime, WorldInfo);
    // End:0x3D
    if((myPC != none) && !myPC.IsPaused())
    {
        UpdateOnScreenText(DeltaTime);
    }
    //return;    
}

final function UpdateOnScreenText(float DeltaTime)
{
    // End:0xA2
    if(myPC != none)
    {
        // End:0xA2
        if(myPC.currOnScreenText.DialogDuration != 0.0000000)
        {
            myPC.currOnScreenText.DialogDurationLeft -= DeltaTime;
            // End:0xA2
            if(myPC.currOnScreenText.DialogDurationLeft <= 0.0000000)
            {
                myPC.StopOnScreenText(myPC.currOnScreenText.Action);
            }
        }
    }
    //return;    
}

function PostSceneActived(UIScene ActivatedScene, bool bInitialActivation)
{
    local int PlayerIndex;

    PlayerIndex = ((myPC != none) ? myPC.GetUIPlayerIndex() : 0);
    UnsubscribeInputEventNative('XboxTypeS_B', self, PlayerIndex);
    //return;    
}
