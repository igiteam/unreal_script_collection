class UIScene_MarketplaceMessageBox extends UIScene_MessageBox
    config(UI);

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    // End:0x3E
    if(bDiscardNonOwnerInput && GetLP().ControllerId != ControllerId)
    {
        return true;
    }
    // End:0x79
    if((bIsOpening || int(InputEvent) == int(2)) || int(InputEvent) == int(1))
    {
        return true;
    }
    // End:0xA5
    if(ButtonName == 'XboxTypeS_Y')
    {
        Callback_MarketplaceButtonPressed(ControllerId);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function Callback_MarketplaceButtonPressed(int ControllerIdx)
{
    // End:0x68
    if(!bFinished && ContinueString != "")
    {
        PlaySoundFromTheme('Popup_Accept');
        // End:0x68
        if(OnOptionSelected(self, 'GenericMarketplace', ControllerIdx))
        {
            StartExit();
        }
    }
    //return;    
}

function Callback_CancelButtonPressed(int ControllerIdx)
{
    //return;    
}
