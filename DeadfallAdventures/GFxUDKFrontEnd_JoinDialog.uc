class GFxUDKFrontEnd_JoinDialog extends GFxUDKFrontEnd_Dialog within GFxMoviePlayer;

var GFxClikWidget ServerInfoListMC;
var GFxClikWidget MutatorListMC;
var GFxClikWidget JoinBtn;
var GFxClikWidget SpectateBtn;

function OnTopMostView(optional bool bPlayOpenAnimation = false)
{
    // End:0x3C
    if(MenuManager != none)
    {
        MenuManager.SetSelectionFocus(JoinBtn);
    }
    BackBtn.SetString("label", "BACK");
    BackBtn.RemoveAllEventListeners("CLIK_press");
    BackBtn.RemoveAllEventListeners("press");
    BackBtn.AddEventListener('CLIK_press', Select_Back);
    //return;    
}

function DisableSubComponents(bool bDisableComponents)
{
    AcceptBtn.SetBool("disabled", bDisableComponents);
    BackBtn.SetBool("disabled", bDisableComponents);
    //return;    
}

function PopulateServerInfo(OnlineGameSettings GameSettings)
{
    //return;    
}

function SetJoinButtonPress(delegate<EventListener> JoinButtonListener)
{
    JoinBtn.RemoveAllEventListeners("CLIK_press");
    JoinBtn.RemoveAllEventListeners("press");
    JoinBtn.AddEventListener('CLIK_press', JoinButtonListener);
    //return;    
}

function SetSpectateButtonPress(delegate<EventListener> SpectateButtonListener)
{
    SpectateBtn.RemoveAllEventListeners("CLIK_press");
    SpectateBtn.RemoveAllEventListeners("press");
    SpectateBtn.AddEventListener('CLIK_press', SpectateButtonListener);
    //return;    
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
    local bool bWasHandled;

    bWasHandled = false;
    bWasHandled = super.WidgetInitialized(WidgetName, WidgetPath, Widget);
    // End:0x4B
    if(bWasHandled)
    {
        return true;
    }
    switch(WidgetName)
    {
        // End:0x9C
        case 'serverinfo_label':
            Widget.SetText("SERVER INFO");
            return true;
            // End:0x25A
            break;
        // End:0xD8
        case 'serverinfo_list':
            // End:0xD5
            if(ServerInfoListMC == none)
            {
                ServerInfoListMC = GFxClikWidget(Widget);
                return true;
            }
            // End:0x25A
            break;
        // End:0x113
        case 'mutatorinfo_label':
            Widget.SetText("MUTATORS");
            return true;
            // End:0x25A
            break;
        // End:0x14F
        case 'mutatorinfo_list':
            // End:0x14C
            if(MutatorListMC == none)
            {
                MutatorListMC = GFxClikWidget(Widget);
                return true;
            }
            // End:0x25A
            break;
        // End:0x1D2
        case 'join':
            JoinBtn = GFxClikWidget(Widget.GetObject("btn", Class'GFxUI.GFxClikWidget'));
            JoinBtn.SetString("label", "JOIN GAME");
            return true;
            // End:0x25A
            break;
        // End:0x254
        case 'spectate':
            SpectateBtn = GFxClikWidget(Widget.GetObject("btn", Class'GFxUI.GFxClikWidget'));
            SpectateBtn.SetString("label", "SPECTATE");
            return true;
            // End:0x25A
            break;
        // End:0xFFFF
        default:
            // End:0x25A
            break;
            break;
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    SubWidgetBindings=/* Array type was not detected. */
}