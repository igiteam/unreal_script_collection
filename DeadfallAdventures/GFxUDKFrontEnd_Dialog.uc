class GFxUDKFrontEnd_Dialog extends GFxUDKFrontEnd_View within GFxMoviePlayer;

var GFxObject DialogMC;
var GFxObject TitleTxt;
var GFxObject InfoTxt;
var GFxClikWidget BackBtn;
var GFxClikWidget AcceptBtn;
//var delegate<AcceptDelegate> __AcceptDelegate__Delegate;

delegate AcceptDelegate(EventData ev)
{
    //return;    
}

function OnViewClosed()
{
    //return;    
}

function DisableSubComponents(bool bDisableComponents)
{
    //return;    
}

function OnTopMostView(optional bool bPlayOpenAnimation = false)
{
    super.OnTopMostView(bPlayOpenAnimation);
    //return;    
}

function PlayOpenAnimation()
{
    //return;    
}

function PlayCloseAnimation()
{
    //return;    
}

private final function SetBackButton(GFxObject InBackButton)
{
    ActionScriptVoid("setBackBtn");
    //return;    
}

function SetBackButton_OnPress(delegate<EventListener> EventListener)
{
    BackBtn.RemoveAllEventListeners("CLIK_press");
    BackBtn.RemoveAllEventListeners("press");
    BackBtn.AddEventListener('CLIK_press', EventListener);
    //return;    
}

function Select_Back(EventData ev)
{
    // End:0x38
    if(MenuManager != none)
    {
        PlayCloseAnimation();
        MenuManager.PopView();
    }
    //return;    
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
    local bool bResult;

    switch(WidgetName)
    {
        // End:0x72
        case 'popup_title':
            // End:0x6F
            if(TitleTxt == none)
            {
                TitleTxt = Widget.GetObject("textField");
                bResult = true;
            }
            // End:0x240
            break;
        // End:0xD1
        case 'popup_info':
            // End:0xCE
            if(InfoTxt == none)
            {
                InfoTxt = Widget.GetObject("textField");
                bResult = true;
            }
            // End:0x240
            break;
        // End:0x187
        case 'back':
            BackBtn = GFxClikWidget(Widget.GetObject("btn", Class'GFxUI.GFxClikWidget'));
            SetBackButton_OnPress(Select_Back);
            BackBtn.SetString("label", "BACK");
            SetBackButton(BackBtn);
            bResult = true;
            // End:0x240
            break;
        // End:0x1F1
        case 'Exit':
            // End:0x1EE
            if(AcceptBtn == none)
            {
                AcceptBtn = GFxClikWidget(Widget.GetObject("btn", Class'GFxUI.GFxClikWidget'));
                bResult = true;
            }
            // End:0x240
            break;
        // End:0x22E
        case 'PopUp':
            // End:0x22B
            if(DialogMC == none)
            {
                DialogMC = Widget;
                bResult = true;
            }
            // End:0x240
            break;
        // End:0xFFFF
        default:
            bResult = false;
            // End:0x240
            break;
            break;
    }
    return bResult;
    //return ReturnValue;    
}

defaultproperties
{
    SubWidgetBindings=/* Array type was not detected. */
}