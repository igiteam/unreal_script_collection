class PKGFxUI_Confirm extends PKGFxUI_Info
    config(UI);

simulated function bool Start(optional bool StartPaused = false)
{
    super.Start(StartPaused);
    Advance(0.0000000);
    CancelBtn.SetBool("visible", true);
    OkBtn.SetString("label", Yes);
    CancelBtn.SetString("label", No);
    return true;
    //return ReturnValue;    
}

function PlayOpenAnimation()
{
    MenuMC.GotoAndPlay("open");
    ButtonsMC.GotoAndStop("confirm");
    //return;    
}

defaultproperties
{
    TitleString="Confirmation"
}