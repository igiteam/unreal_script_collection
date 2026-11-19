class GFxUDKFrontEnd_View extends GFxUIView within GFxMoviePlayer;

const FakePlayerIndex = 0;

var GFxUDKFrontEnd MenuManager;
var name ViewName;

function OnViewLoaded()
{
    //return;    
}

function OnTopMostView(optional bool bPlayOpenAnimation = false)
{
    DisableSubComponents(false);
    // End:0x27
    if(bPlayOpenAnimation)
    {
        PlayOpenAnimation();
    }
    // End:0x96
    if(MenuManager != none)
    {
        MenuManager.SetEscapeDelegate(None);
        MenuManager.SetEscapeDelegate(OnEscapeKeyPress);
    }
    //return;    
}

function OnViewActivated()
{
    //return;    
}

function OnViewClosed()
{
    DisableSubComponents(true);
    //return;    
}

function DisableSubComponents(bool bDisableComponents)
{
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

function Select_Back(EventData ev)
{
    MoveBackImpl();
    //return;    
}

function MoveBackImpl()
{
    // End:0x38
    if(MenuManager != none)
    {
        PlayCloseAnimation();
        MenuManager.PopView();
    }
    //return;    
}

function OnEscapeKeyPress()
{
    MoveBackImpl();
    //return;    
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
    return false;
    //return ReturnValue;    
}
