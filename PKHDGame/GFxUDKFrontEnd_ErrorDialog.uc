class GFxUDKFrontEnd_ErrorDialog extends GFxUDKFrontEnd_Dialog within GFxMoviePlayer;

function OnTopMostView(optional bool bPlayOpenAnimation = false)
{
    super.OnTopMostView(bPlayOpenAnimation);
    MenuManager.SetSelectionFocus(BackBtn);
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

function SetButtonLabel(string ButtonLabel)
{
    BackBtn.SetString("label", ButtonLabel);
    //return;    
}

function OnViewClosed()
{
    super.OnViewClosed();
    DisableSubComponents(false);
    //return;    
}

function DisableSubComponents(bool bDisableComponents)
{
    BackBtn.SetBool("disabled", bDisableComponents);
    //return;    
}
