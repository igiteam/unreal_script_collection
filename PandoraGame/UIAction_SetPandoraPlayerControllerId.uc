class UIAction_SetPandoraPlayerControllerId extends UIAction
    native;

event SetPlayerControllerId()
{
    local LocalPlayer PlayerOwner;
    local PandoraPlayerController PlayerController;

    // End:0xC3
    if((GamepadID >= 0) && GamepadID < 4)
    {
        PlayerOwner = GetOwner().GetPlayerOwner();
        // End:0xC3
        if(PlayerOwner != none)
        {
            PlayerController = PandoraPlayerController(PlayerOwner.Actor);
            // End:0xC3
            if(PlayerController != none)
            {
                PlayerController.ClearOnlineDelegates();
                PlayerOwner.SetControllerId(GamepadID);
                PlayerIndex = Class'Engine.UIInteraction'.static.GetPlayerIndex(PlayerOwner.ControllerId);
                PlayerController.RegisterOnlineDelegates();
            }
        }
    }
    //return;    
}
