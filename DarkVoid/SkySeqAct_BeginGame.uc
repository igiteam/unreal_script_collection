class SkySeqAct_BeginGame extends SequenceAction;

event Activated()
{
    local WorldInfo WI;
    local bool storedRestart;

    WI = GetWorldInfo();
    // End:0xAA
    if((WI != none) && WI.Game != none)
    {
        storedRestart = WI.Game.bRestartLevel;
        WI.Game.bRestartLevel = false;
        WI.Game.StartMatch();
        WI.Game.bRestartLevel = storedRestart;
    }
    // End:0xD7
    if(!OutputLinks[0].bDisabled)
    {
        OutputLinks[0].bHasImpulse = true;
    }
    //return;    
}
