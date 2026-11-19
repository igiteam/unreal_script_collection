class SPPointEventKillAlphaWW extends SPPointEvent;

function ApplyPoints()
{
    local SPPlayerReplicationInfo PRI;

    super.ApplyPoints();
    PRI = SPPlayerReplicationInfo(GetScorer().PlayerReplicationInfo);
    PRI.KillAlphaWWNum++;
    //return;    
}

static function SPPointEventKillAlphaWW CreateSPPointEventKillAlphaWW(Controller theKiller)
{
    local SPPointEventKillAlphaWW theEvent;

    theEvent = new (none) Class'SPPointEventKillAlphaWW';
    theEvent.SetScorer(theKiller);
    return theEvent;
    //return ReturnValue;    
}

defaultproperties
{
    Points=25.0000000
}