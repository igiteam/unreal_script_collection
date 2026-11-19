class TurokUIScriptController extends UIScriptController
    native;

var array Scripts;
var @NULL CurrentScript;

// Export UTurokUIScriptController::execTick(FFrame&, void* const)
native function Tick(@NULL applicant);

// Export UTurokUIScriptController::execSetCurrentValues(FFrame&, void* const)
native function SetCurrentValues(@NULL applicant);

event @NULL AddScript(string script_name, optional bool move_to = false, optional @NULL applicant)
{
    local int I, Index;

    I = 0;
    J0x0D:

    // End:0x4C [Loop If]
    if(I < Scripts.Length)
    {
        // End:0x42
        if(Scripts[I].GetName() == script_name)
        {
            return none;
        }
        I++;
        // [Loop Continue]
        goto J0x0D;
    }
    Index = Scripts.Length;
    Scripts.Insert(Index, 1);
    Scripts[Index] = new (self) Class'TurokUIScript';
    // End:0xD1
    if(Scripts[Index] != none)
    {
        Scripts[Index].bMoveTo = move_to;
        Scripts[Index].SetName(script_name);
        return Scripts[Index];
    }
    return none;
    //return ReturnValue;    
}

function @NULL GetCurrentScript()
{
    return CurrentScript;
    //return ReturnValue;    
}

event @NULL GetScript(string script_name)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x50 [Loop If]
    if(I < Scripts.Length)
    {
        // End:0x46
        if(Scripts[I].GetName() == script_name)
        {
            return Scripts[I];
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return none;
    //return ReturnValue;    
}

// Export UTurokUIScriptController::execClearScripts(FFrame&, void* const)
native function ClearScripts();

event bool Play(string script_name, optional float start_time = 0.0000000, optional @NULL move_to)
{
    local int I;

    I = 0;
    J0x11:

    // End:0x7E [Loop If]
    if(I < Scripts.Length)
    {
        // End:0x74
        if(Scripts[I].GetName() == script_name)
        {
            CurrentScript = Scripts[I];
            CurrentScript.Start(start_time, move_to);
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x11;
    }
    return false;
    //return ReturnValue;    
}

// Export UTurokUIScriptController::execStop(FFrame&, void* const)
native function Stop();

function Pause()
{
    // End:0x1E
    if(CurrentScript != none)
    {
        CurrentScript.Pause();
    }
    //return;    
}

function UnPause()
{
    // End:0x1E
    if(CurrentScript != none)
    {
        CurrentScript.UnPause();
    }
    //return;    
}

function Reset()
{
    // End:0x24
    if(CurrentScript != none)
    {
        CurrentScript.Start(0.0000000);
    }
    //return;    
}
