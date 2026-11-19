class SPDActionList extends Object
    native
    editinlinenew;

/** Removed abstract as these can now be created in the editor VARIABLE DECLARATIONS */
var() bool bEnabled;
var() bool ShowDebug;
var() export editinline array<export editinline SPDAction> Action;
var string DebugString;

function bool HasActions()
{
    local int Idx;

    // End:0x0E
    if(Action.Length < 0)
    {
        return false;
    }
    Idx = 0;
    J0x15:

    // End:0x42 [Loop If]
    if(Idx < Action.Length)
    {
        // End:0x38
        if(Action[Idx] != none)
        {
            return true;
        }
        Idx++;
        // [Loop Continue]
        goto J0x15;
    }
    return false;
    //return ReturnValue;    
}
