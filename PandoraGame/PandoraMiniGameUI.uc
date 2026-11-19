class PandoraMiniGameUI extends Interaction
    transient;

var name LastKey;
var bool bADown;
var bool bBDown;
var bool bXDown;
var bool bYDown;
var bool bDPadDown;

function Reset()
{
    ClearKeyState();
    //return;    
}

function ClearKeyState()
{
    bADown = false;
    bBDown = false;
    bXDown = false;
    bYDown = false;
    bDPadDown = false;
    //return;    
}

function name MapToCommonKey(name Key)
{
    local name KeyName;

    KeyName = Key;
    // End:0x2D
    if(Key == 'XboxTypeS_A')
    {
        KeyName = 'A';
    }
    // End:0x4F
    if(Key == 'XboxTypeS_B')
    {
        KeyName = 'B';
    }
    // End:0x71
    if(Key == 'XboxTypeS_X')
    {
        KeyName = 'X';
    }
    // End:0x93
    if(Key == 'XboxTypeS_Y')
    {
        KeyName = 'Y';
    }
    // End:0xB5
    if(Key == 'XboxTypeS_DPad_Down')
    {
        KeyName = 'Down';
    }
    return KeyName;
    //return ReturnValue;    
}

function bool InputKey(int ControllerId, name Key, Object.EInputEvent EventType, optional float AmountDepressed = 1.0000000, optional bool bGamepad)
{
    // End:0x56
    if(((Key == 'A') || Key == 'XboxTypeS_A') && int(EventType) == int(0))
    {
        ClearKeyState();
        bADown = true;
    }
    // End:0xA2
    if(((Key == 'B') || Key == 'XboxTypeS_B') && int(EventType) == int(0))
    {
        ClearKeyState();
        bBDown = true;
    }
    // End:0xEE
    if(((Key == 'X') || Key == 'XboxTypeS_X') && int(EventType) == int(0))
    {
        ClearKeyState();
        bXDown = true;
    }
    // End:0x13A
    if(((Key == 'Y') || Key == 'XboxTypeS_Y') && int(EventType) == int(0))
    {
        ClearKeyState();
        bYDown = true;
    }
    // End:0x186
    if(((Key == 'Down') || Key == 'XboxTypeS_DPad_Down') && int(EventType) == int(0))
    {
        ClearKeyState();
        bDPadDown = true;
    }
    LastKey = MapToCommonKey(Key);
    return true;
    //return ReturnValue;    
}
