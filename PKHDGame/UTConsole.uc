class UTConsole extends Console within GameViewportClient
    transient
    native
    config(Input)
    hidecategories(Object,UIRoot);

var int TextCount;

function bool InputKey(int ControllerId, name Key, Object.EInputEvent Event, optional float AmountDepressed = 1.0000000, optional bool bGamepad = false)
{
    // End:0x6D
    if((ConsoleTargetPlayer != none) && ConsoleTargetPlayer.Actor.WorldInfo.IsInSeamlessTravel())
    {
        return false;
    }
    // End:0xF2
    if(int(Event) == int(0))
    {
        bCaptureKeyInput = false;
        // End:0xC1
        if(Key == ConsoleKey)
        {
            GotoState('Open');
            bCaptureKeyInput = true;            
        }
        else
        {
            // End:0xF2
            if(Key == TypeKey)
            {
                GotoState('Typing');
                bCaptureKeyInput = true;
            }
        }
    }
    return bCaptureKeyInput;
    //return ReturnValue;    
}

function OutputTextLine(coerce string Text)
{
    TextCount++;
    super.OutputTextLine(Text);
    //return;    
}

state Typing
{
    function bool InputKey(int ControllerId, name Key, Object.EInputEvent Event, optional float AmountDepressed = 1.0000000, optional bool bGamepad = false)
    {
        // End:0x4B
        if((Key == 'Escape') && int(Event) == int(1))
        {
            GotoState('None');
            return true;
        }
        return super.InputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
        //return ReturnValue;        
    }
    stop;    
}
