class SeqEvent_spMultiplayerAnimusDevice extends SeqEvent_UsedAndHeld
    native;

/** 0 means any team can use, 1 means team 1 only and 2 means team 2 only */
var() int MultiplayerTeamsThatCanUse;

event bool DoGameSpecificChecksPass(Actor theInstigator)
{
    // End:0x17
    if((IsOnCorrectTeamToActivate(theInstigator)) == false)
    {
        return false;
    }
    // End:0x2E
    if((HasRequiredAnimus(theInstigator)) == false)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

event bool HasRequiredAnimus(Actor theInstigator)
{
    local PlayerPawn thePlayer;

    thePlayer = PlayerPawn(theInstigator);
    // End:0x1D
    if(thePlayer == none)
    {
        return false;
    }
    // End:0x36
    if(thePlayer.LifeForce == float(0))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function bool IsOnCorrectTeamToActivate(Actor theInstigator)
{
    local bool IsOnCorrectTeam;

    // End:0x16
    if(MultiplayerTeamsThatCanUse == 0)
    {
        IsOnCorrectTeam = true;        
    }
    else
    {
        // End:0x41
        if(MultiplayerTeamsThatCanUse == int(theInstigator.GetTeamNum()))
        {
            IsOnCorrectTeam = true;            
        }
        else
        {
            IsOnCorrectTeam = false;
        }
    }
    return IsOnCorrectTeam;
    //return ReturnValue;    
}
