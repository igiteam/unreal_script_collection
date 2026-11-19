class SPPointEventKillPlayerNormal extends SPPointEventKillPlayer;

function ApplyPoints()
{
    local SPPlayerReplicationInfo PRI;

    super(SPPointEvent).ApplyPoints();
    PRI = SPPlayerReplicationInfo(GetScorer().PlayerReplicationInfo);
    PRI.KillPlayerNormalNum++;
    //return;    
}

static function SPPointEventKillPlayerNormal CreateSPPointEventKillPlayerNormal(Controller theKiller, Controller theVictim)
{
    local SPPointEventKillPlayerNormal theEvent;

    theEvent = new (none) Class'SPPointEventKillPlayerNormal';
    theEvent.SetScorer(theKiller);
    theEvent.SetVictim(theVictim);
    return theEvent;
    //return ReturnValue;    
}
