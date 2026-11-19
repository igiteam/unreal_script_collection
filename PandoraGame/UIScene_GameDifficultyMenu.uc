class UIScene_GameDifficultyMenu extends UIScene_BaseFrontEnd;

//var delegate<OnSceneClose> __OnSceneClose__Delegate;
//var delegate<OnFadeOutCompleted> __OnFadeOutCompleted__Delegate;

delegate OnSceneClose()
{
    //return;    
}

delegate bool OnFadeOutCompleted()
{
    //return ReturnValue;    
}

event FadeCompleted()
{
    super(SPUIScene).FadeCompleted();
    // End:0x36
    if(Opacity <= 0.0000000)
    {
        SceneClient.CloseScene(self);
        OnSceneClose();
    }
    //return;    
}

function OnClick(UIScene OpenedScene, int MenuIndex)
{
    local int CurrDifficulty;

    // End:0x37
    if(MenuIndex == (MenuIndexByName("btnGameDifficultyNormal")))
    {
        CurrDifficulty = 0;        
    }
    else
    {
        // End:0x6D
        if(MenuIndex == (MenuIndexByName("btnGameDifficultyHard")))
        {
            CurrDifficulty = 2;            
        }
        else
        {
            CurrDifficulty = 1;
        }
    }
    // End:0xA2
    if(myPC != none)
    {
        myPC.ProfileSettings.SetGameDifficulty(CurrDifficulty);
    }
    // End:0xC2
    if(myPC != none)
    {
        myPC.WriteProfile();
    }
    //return;    
}

event SceneActivated(bool bInitialActivation)
{
    super.SceneActivated(bInitialActivation);
    KillFocusToMenuItem(CurrMenuItemIdx);
    switch(myPC.ProfileSettings.GetGameDifficulty())
    {
        // End:0x6B
        case 2:
            CurrMenuItemIdx = MenuIndexByName("btnGameDifficultyHard");
            // End:0xCC
            break;
        // End:0x99
        case 1:
            CurrMenuItemIdx = MenuIndexByName("btnGameDifficultyEasy");
            // End:0xCC
            break;
        // End:0x9D
        case 0:
        // End:0xFFFF
        default:
            CurrMenuItemIdx = MenuIndexByName("btnGameDifficultyNormal");
            // End:0xCC
            break;
            break;
    }
    SetFocusToMenuItem(CurrMenuItemIdx);
    //return;    
}
