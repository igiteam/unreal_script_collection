class PKGFxUI_GameOverMenu extends PainGFxUI_PauseMenu
    config(UI);

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    // End:0x7D
    if(((((ButtonName == 'XboxTypeS_B') || ButtonName == 'XboxTypeS_Start') || ButtonName == 'XboxTypeS_Back') || ButtonName == 'Escape') || ButtonName == 'BackSpace')
    {
        return true;
    }
    return super.FilterButtonInput(ControllerId, ButtonName, InputEvent);
    //return ReturnValue;    
}

event OnClose()
{
    local PainGFxHudWrapper PainHUD;

    PainHUD = PainGFxHudWrapper(GetPC().myHUD);
    // End:0x61
    if(PainHUD != none)
    {
        PainHUD.GameOverMovie = none;
    }
    super.OnClose();
    //return;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericSelect');
    footer.FooterUpdate(ButtonAliases);
    //return;    
}

defaultproperties
{
    PauseMenuOptions[0]=.EPO_LoadCheckpoint
    PauseMenuOptions[1]=.EPO_RestartChapter
    PauseMenuOptions[2]=.EPO_ReturnToMainMenu
}