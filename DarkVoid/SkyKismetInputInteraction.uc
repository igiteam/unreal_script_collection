class SkyKismetInputInteraction extends Interaction within SkyPlayerController
    transient;

var array<SkySeqEvent_DemoInput> InputEvents;
var array<SkySeqEvent_MultiButtonPress> MultiInputEvents;

function bool InputKey(int ControllerId, name Key, Object.EInputEvent Event, optional float AmountDepressed = 1.0000000, optional bool bGamepad)
{
    local int I;

    I = 0;
    J0x11:

    // End:0x5E [Loop If]
    if(I < InputEvents.Length)
    {
        // End:0x54
        if(InputEvents[I].CheckInput(Outer, ControllerId, Key, Event))
        {
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x11;
    }
    I = 0;
    J0x65:

    // End:0xBE [Loop If]
    if(I < MultiInputEvents.Length)
    {
        // End:0xB4
        if(MultiInputEvents[I] != none)
        {
            MultiInputEvents[I].CheckInput(Outer, ControllerId, Key, Event);
        }
        ++I;
        // [Loop Continue]
        goto J0x65;
    }
    return false;
    //return ReturnValue;    
}
