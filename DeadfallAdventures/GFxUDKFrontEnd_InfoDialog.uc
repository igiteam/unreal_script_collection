class GFxUDKFrontEnd_InfoDialog extends GFxUDKFrontEnd_Dialog within GFxMoviePlayer;

function OnViewClosed()
{
    super.OnViewClosed();
    DisableSubComponents(false);
    //return;    
}

function OnTopMostView(optional bool bPlayOpenAnimation = false)
{
    super.OnTopMostView(bPlayOpenAnimation);
    MenuManager.SetSelectionFocus(BackBtn);
    //return;    
}

function DisableSubComponents(bool bDisableComponents)
{
    AcceptBtn.SetBool("disabled", bDisableComponents);
    BackBtn.SetBool("disabled", bDisableComponents);
    //return;    
}

function SetTitle(string Title)
{
    TitleTxt.SetText(Title);
    //return;    
}

function SetInfo(string Info)
{
    InfoTxt.SetText(Info);
    //return;    
}

function SetAcceptButtonLabel(string Label)
{
    AcceptBtn.SetString("label", Label);
    //return;    
}

function SetBackButtonLabel(string Label)
{
    BackBtn.SetString("label", Label);
    //return;    
}

function SetAcceptButton_OnPress(delegate<EventListener> EventListener)
{
    AcceptBtn.RemoveAllEventListeners("CLIK_press");
    AcceptBtn.RemoveAllEventListeners("press");
    AcceptBtn.AddEventListener('CLIK_press', EventListener);
    //return;    
}
