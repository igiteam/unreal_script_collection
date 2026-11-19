class AdvGFxUI_GameOverMenu extends AdvGFxUI_PauseMenu
    config(UI);

function OnPressLoadCheckpointButton(EventData ev)
{
    local AdvPlayerController PC;
    local AdvEngine Engine;

    PC = AdvPlayerController(GetPC());
    Engine = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    Engine.ClearTemporaryCheckpointData();
    // End:0x150
    if((((PC != none) && Engine != none) && Engine.CurrentCheckpoint != none) && !Engine.CurrentCheckpoint.CheckpointIsEmpty())
    {
        AdvGFxHudWrapper(GetPC().myHUD).UnPauseGame();
        PC.LoadCheckpoint();        
    }
    else
    {
        PC.RestartLevel();
    }
    //return;    
}

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
    local AdvGFxHudWrapper AdvHUD;

    AdvHUD = AdvGFxHudWrapper(GetPC().myHUD);
    // End:0x61
    if(AdvHUD != none)
    {
        AdvHUD.GameOverMovie = none;
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
    PauseMenuOptions[0]=169
    PauseMenuOptions[1]=31
    PauseMenuOptions[2]=0
}