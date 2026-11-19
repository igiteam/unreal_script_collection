class EndGameInteraction extends Interaction within MOHAPlayerController
    transient
    hidecategories(Object,UIRoot);

event bool InputKey(int ControllerId, name Key, Object.EInputEvent Event, optional float AmountDepressed = 1.0000000)
{
    // End:0x83
    if(int(Event) == int(0))
    {
        // End:0x59
        if((Key == 'X') || Key == 'XboxTypeS_X')
        {
            Outer.DisplayMainMenu();
            return true;            
        }
        else
        {
            // End:0x83
            if((Key == 'Y') || Key == 'XboxTypeS_Y')
            {
                return true;
            }
        }
    }
    return false;
    //return ReturnValue;    
}
