class SPPointEventAnimusCollectedWW extends SPPointEventAnimusCollected;

function ApplyPoints()
{
    local SPPlayerReplicationInfo PRI;

    super(SPPointEvent).ApplyPoints();
    PRI = SPPlayerReplicationInfo(GetScorer().PlayerReplicationInfo);
    PRI.AnimusCollectedWWNum++;
    //return;    
}

static function SPPointEventAnimusCollectedWW CreateSPPointEventAnimusCollectedWW(Controller theScorer, float theAmount)
{
    local SPPointEventAnimusCollectedWW theEvent;

    theEvent = new (none) Class'SPPointEventAnimusCollectedWW';
    theEvent.SetScorer(theScorer);
    theEvent.SetAmount(int(theAmount));
    return theEvent;
    //return ReturnValue;    
}
