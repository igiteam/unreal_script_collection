class SPPointEventKillPlayerInterrupt extends SPPointEventKillPlayer;

function ApplyPoints()
{
    local SPPlayerReplicationInfo PRI;

    super(SPPointEvent).ApplyPoints();
    PRI = SPPlayerReplicationInfo(GetScorer().PlayerReplicationInfo);
    PRI.KillPlayerInterruptNum++;
    //return;    
}

static function SPPointEventKillPlayerInterrupt CreateSPPointEventKillPlayerInterrupt(Controller theKiller, Controller theVictim)
{
    local SPPointEventKillPlayerInterrupt theEvent;

    theEvent = new (none) Class'SPPointEventKillPlayerInterrupt';
    theEvent.SetScorer(theKiller);
    theEvent.SetVictim(theVictim);
    return theEvent;
    //return ReturnValue;    
}

defaultproperties
{
    Points=25.0000000
}