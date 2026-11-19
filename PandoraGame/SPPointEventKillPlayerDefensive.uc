class SPPointEventKillPlayerDefensive extends SPPointEventKillPlayer;

function ApplyPoints()
{
    local SPPlayerReplicationInfo PRI;

    super(SPPointEvent).ApplyPoints();
    PRI = SPPlayerReplicationInfo(GetScorer().PlayerReplicationInfo);
    PRI.KillPlayerDefensiveNum++;
    //return;    
}

static function SPPointEventKillPlayerDefensive CreateSPPointEventKillPlayerDefensive(Controller theKiller, Controller theVictim)
{
    local SPPointEventKillPlayerDefensive theEvent;

    theEvent = new (none) Class'SPPointEventKillPlayerDefensive';
    theEvent.SetScorer(theKiller);
    theEvent.SetVictim(theVictim);
    return theEvent;
    //return ReturnValue;    
}

defaultproperties
{
    Points=25.0000000
}