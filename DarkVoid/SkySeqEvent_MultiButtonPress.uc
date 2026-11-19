class SkySeqEvent_MultiButtonPress extends SequenceEvent;

struct MultiButtonRecord
{
    var bool bPressed;
    var() name ButtonName;

    structdefaultproperties
    {
        bPressed=false
        ButtonName="None"
    }
};

var() array<MultiButtonRecord> Buttons;

function bool CheckInput(PlayerController Player, int CheckControllerID, name CheckButtonName, Object.EInputEvent CheckInputEvent)
{
    local int I;
    local bool bAllPressed;

    I = 0;
    J0x07:

    // End:0xC5 [Loop If]
    if(I < Buttons.Length)
    {
        // End:0x2A
        if(I == 0)
        {
            bAllPressed = true;
        }
        // End:0x97
        if(Buttons[I].ButtonName == CheckButtonName)
        {
            switch(CheckInputEvent)
            {
                // End:0x73
                case 0:
                    Buttons[I].bPressed = true;
                    // End:0x97
                    break;
                // End:0x94
                case 1:
                    Buttons[I].bPressed = false;
                    // End:0x97
                    break;
                // End:0xFFFF
                default:
                    break;
            }
        }
        else
        {
            // End:0xBB
            if(!Buttons[I].bPressed)
            {
                bAllPressed = false;
            }
            ++I;
            // [Loop Continue]
            goto J0x07;
        }/* !MISMATCHING REMOVE, tried Loop got Type:Else Position:0x097! */
        // End:0xE1
        if(bAllPressed)
        {
            CheckActivate(Player, Player);
        }
        return false;
        //return ReturnValue;        
    }/* !MISMATCHING REMOVE, tried Else got Type:Loop Position:0x007! */
}

static event int GetObjClassVersion()
{
    return 3;
    //return ReturnValue;    
}
