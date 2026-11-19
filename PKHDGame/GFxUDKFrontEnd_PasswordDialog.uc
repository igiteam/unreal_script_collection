class GFxUDKFrontEnd_PasswordDialog extends GFxUDKFrontEnd_Dialog within GFxMoviePlayer;

var GFxClikWidget PasswordRendererMC;
var GFxObject PasswordTextField;
var GFxClikWidget JoinBtn;

function OnTopMostView(optional bool bPlayOpenAnimation = false)
{
    TitleTxt.SetText("SERVER REQUIRES A PASSWORD");
    SetBackButtonListener(Select_Back);
    MenuManager.SetSelectionFocus(PasswordRendererMC);
    ClearPasswordRenderer();
    //return;    
}

function OnViewClosed()
{
    super.OnViewClosed();
    DisableSubComponents(false);
    //return;    
}

function DisableSubComponents(bool bEnableComponents)
{
    PasswordRendererMC.SetBool("disabled", bEnableComponents);
    BackBtn.SetBool("disabled", bEnableComponents);
    //return;    
}

function SetBackButtonListener(delegate<EventListener> DelegateListener)
{
    BackBtn.SetString("label", "BACK");
    BackBtn.RemoveAllEventListeners("CLIK_press");
    BackBtn.RemoveAllEventListeners("press");
    BackBtn.AddEventListener('CLIK_press', DelegateListener);
    //return;    
}

function SetOKButtonListener(delegate<EventListener> DelegateListener)
{
    JoinBtn.SetString("label", "OK");
    JoinBtn.RemoveAllEventListeners("CLIK_press");
    JoinBtn.RemoveAllEventListeners("press");
    JoinBtn.AddEventListener('CLIK_press', DelegateListener);
    //return;    
}

function string GetPassword()
{
    return PasswordTextField.GetText();
    //return ReturnValue;    
}

private final function ClearPasswordRenderer()
{
    PasswordTextField.SetText("");
    PasswordTextField.SetBool("password", true);
    //return;    
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
    local bool bWasHandled;

    bWasHandled = false;
    switch(WidgetName)
    {
        // End:0xDD
        case 'item1':
            // End:0xDA
            if(PasswordRendererMC == none)
            {
                PasswordRendererMC = GFxClikWidget(Widget);
                PasswordRendererMC.SetString("label", "PASSWORD:");
                PasswordTextField = GFxClikWidget(PasswordRendererMC.GetObject("textinput", Class'GFxUI.GFxClikWidget'));
                bWasHandled = true;
            }
            // End:0x1A6
            break;
        // End:0x163
        case 'join':
            JoinBtn = GFxClikWidget(Widget.GetObject("btn", Class'GFxUI.GFxClikWidget'));
            JoinBtn.SetString("label", "OK");
            bWasHandled = true;
            // End:0x1A6
            break;
        // End:0x1A0
        case 'popup_title':
            // End:0x19D
            if(TitleTxt == none)
            {
                TitleTxt = Widget;
                bWasHandled = true;
            }
            // End:0x1A6
            break;
        // End:0xFFFF
        default:
            // End:0x1A6
            break;
            break;
    }
    // End:0x1E3
    if(bWasHandled)
    {
        bWasHandled = super.WidgetInitialized(WidgetName, WidgetPath, Widget);
    }
    return bWasHandled;
    //return ReturnValue;    
}

defaultproperties
{
    SubWidgetBindings=/* Array type was not detected. */
}