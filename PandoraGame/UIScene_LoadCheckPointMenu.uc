class UIScene_LoadCheckPointMenu extends UIScene_BaseFrontEnd;

function OnClick(UIScene OpenedScene, int MenuIndex)
{
    PlayUISound('SceneClosed');
    // End:0x1D
    if(myPC == none)
    {
        return;
    }
    // End:0x84
    if(MenuIndex == (MenuIndexByName("btnLoadLastCheckPoint")))
    {
        // End:0x69
        if(OpenedScene != none)
        {
            SceneClient.CloseScene(OpenedScene);
        }
        SceneClient.CloseScene(self);
        BaseLoadSavedGame();        
    }
    else
    {
        // End:0x10F
        if(MenuIndex == (MenuIndexByName("btnQuit")))
        {
            // End:0x10F
            if((LocPlayer != none) && LocPlayer.Actor != none)
            {
                myPC.ToggleDeathEffect(false);                
                LocPlayer.Actor.ConsoleCommand("open PandoraStart");
            }
        }
    }
    //return;    
}

function bool ProcessEscapeInput(const out InputEventParameters EventParms)
{
    return false;
    //return ReturnValue;    
}

function bool IsInputCancel(const InputEventParameters EventParms)
{
    return false;
    //return ReturnValue;    
}

event SceneActivated(bool bInitialActivation)
{
    super.SceneActivated(bInitialActivation);
    myPC.PlayAmBxScript("menu_checkpoint", 0);
    //return;    
}

event SceneDeactivated()
{
    super.SceneDeactivated();
    myPC.StopAmBxScript("menu_checkpoint");
    //return;    
}
