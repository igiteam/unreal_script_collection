class SPPointEventAnimusCollectedPlayer extends SPPointEventAnimusCollected;

function ApplyPoints()
{
    local SPPlayerReplicationInfo PRI;

    super(SPPointEvent).ApplyPoints();
    PRI = SPPlayerReplicationInfo(GetScorer().PlayerReplicationInfo);
    PRI.AnimusCollectedPlayerNum++;
    //return;    
}

static function SPPointEventAnimusCollectedPlayer CreateSPPointEventAnimusCollectedPlayer(Controller theScorer, float theAmount)
{
    local SPPointEventAnimusCollectedPlayer theEvent;

    theEvent = new (none) Class'SPPointEventAnimusCollectedPlayer';
    theEvent.SetScorer(theScorer);
    theEvent.SetAmount(int(theAmount));
    return theEvent;
    //return ReturnValue;    
}
