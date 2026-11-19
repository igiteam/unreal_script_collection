class SeqEvent_SpAnimusUsedAndHeld extends SeqEvent_UsedAndHeld
    native;

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
