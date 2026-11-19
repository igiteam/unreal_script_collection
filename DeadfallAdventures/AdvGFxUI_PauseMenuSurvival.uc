class AdvGFxUI_PauseMenuSurvival extends AdvGFxUI_PauseMenu
    config(UI);

function bool Start(optional bool StartPaused = false)
{
    local bool bResult;

    bResult = super.Start(StartPaused);
    AdvGFxHudWrapper(GetPC().myHUD).SetVisible(false);
    return bResult;
    //return ReturnValue;    
}

function OnCloseAnimationComplete()
{
    super.OnCloseAnimationComplete();
    AdvGFxHudWrapper(GetPC().myHUD).SetVisible(true);
    //return;    
}

defaultproperties
{
    PauseMenuOptions[0]=174
    PauseMenuOptions[1]=31
    PauseMenuOptions[2]=0
    bPauseGameWhileActive=false
}