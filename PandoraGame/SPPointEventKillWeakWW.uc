class SPPointEventKillWeakWW extends SPPointEvent;

function ApplyPoints()
{
    local SPPlayerReplicationInfo PRI;

    super.ApplyPoints();
    PRI = SPPlayerReplicationInfo(GetScorer().PlayerReplicationInfo);
    PRI.KillWeakWWNum++;
    //return;    
}

static function SPPointEventKillWeakWW CreateSPPointEventKillWeakWW(Controller theKiller)
{
    local SPPointEventKillWeakWW theEvent;

    theEvent = new (none) Class'SPPointEventKillWeakWW';
    theEvent.SetScorer(theKiller);
    return theEvent;
    //return ReturnValue;    
}

defaultproperties
{
    Points=10.0000000
}