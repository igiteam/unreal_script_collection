class UIScene_GrabKey extends UIScene_BaseMenu;

var float ButtonDelay;
var float CurrentButtonDelay;
var bool bNoInput;
var bool bGrabbedKey;
var UILabel KeyLabel;
var UILabel CommandLabel;
var string KeyMarkup;
var string CommandMarkup;
var name KeyName;
var int PlayerIndex;
//var delegate<OnResults> __OnResults__Delegate;
//var delegate<OnSceneClose> __OnSceneClose__Delegate;
//var delegate<OnFadeOutCompleted> __OnFadeOutCompleted__Delegate;

delegate OnResults(int PlayerIndex, name ReturnButton)
{
    //return;    
}

delegate OnSceneClose()
{
    //return;    
}

delegate bool OnFadeOutCompleted()
{
    //return ReturnValue;    
}

event InitScene()
{
    __OnRawInputKey__Delegate = CustomInputKey;
    SetVisibility(true);
    super.InitScene();
    DelayButtonInput();
    KeyLabel = UILabel(FindChild('CurrentBindName', true));
    KeyLabel.SetDataStoreBinding(KeyMarkup);
    CommandLabel = UILabel(FindChild('CommandName', true));
    KeyLabel.SetDataStoreBinding(CommandMarkup);
    //return;    
}

function SetKeyText(string NewText)
{
    // End:0x20
    if(KeyLabel != none)
    {
        KeyLabel.SetValue(NewText);
    }
    //return;    
}

function SetKeyAndCommandDatastoreBinding(string NewKeyMarkup, string NewCommandMarkup)
{
    KeyMarkup = NewKeyMarkup;
    CommandMarkup = NewCommandMarkup;
    // End:0x37
    if(KeyLabel != none)
    {
        KeyLabel.SetDataStoreBinding(NewKeyMarkup);
    }
    // End:0x58
    if(CommandLabel != none)
    {
        CommandLabel.SetDataStoreBinding(NewCommandMarkup);
    }
    //return;    
}

function Cleanup()
{
    //return;    
}

event SceneDeactivated()
{
    Cleanup();
    super.SceneDeactivated();
    //return;    
}

function NotifyGameSessionEnded()
{
    Cleanup();
    super(UIScene).NotifyGameSessionEnded();
    //return;    
}

function bool CustomInputKey(const out InputEventParameters EventParms)
{
    UpDateUsingGamePadForPC(EventParms);
    // End:0x123
    if((int(EventParms.EventType) == int(1)) && !bGrabbedKey)
    {
        // End:0x5F
        if(Class'PandoraPlayerController'.static.IsAXBoxButton(EventParms.InputKeyName))
        {
            return true;            
        }
        else
        {
            // End:0xCE
            if(EventParms.InputKeyName == 'Escape')
            {
                KeyName = 'None';
                PlayerIndex = EventParms.PlayerIndex;
                FadeOut(0.5000000);
                OnSceneClose();
                bGrabbedKey = true;
                return true;                
            }
            else
            {
                KeyName = EventParms.InputKeyName;
                PlayerIndex = EventParms.PlayerIndex;
                FadeOut(0.5000000);
                OnSceneClose();
                bGrabbedKey = true;
                return true;
            }
        }
    }
    return true;
    //return ReturnValue;    
}

event FadeCompleted()
{
    super(SPUIScene).FadeCompleted();
    // End:0x55
    if(Opacity <= 0.0000000)
    {
        // End:0x55
        if((OnFadeOutCompleted()) == false)
        {
            SceneClient.CloseScene(self);
            OnResults(PlayerIndex, KeyName);
        }
    }
    //return;    
}

event SetVisibility(bool bIsVisible)
{
    super(UIScene).SetVisibility(bIsVisible);
    // End:0x20
    if(bIsVisible)
    {
        SetSceneInputMode(3);        
    }
    else
    {
        SetSceneInputMode(0);
    }
    //return;    
}

function DelayButtonInput()
{
    bNoInput = true;
    CurrentButtonDelay = ButtonDelay;
    //return;    
}

function ButtonDelayOver()
{
    bNoInput = false;
    //return;    
}
