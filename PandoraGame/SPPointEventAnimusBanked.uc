class SPPointEventAnimusBanked extends SPPointEvent;

var private int Amount;

function ApplyPoints()
{
    local SPPlayerReplicationInfo PRI;

    super.ApplyPoints();
    PRI = SPPlayerReplicationInfo(GetScorer().PlayerReplicationInfo);
    PRI.AnimusBanked += Amount;
    //return;    
}

private final function SetAmount(int theAmount)
{
    Amount = theAmount;
    //return;    
}

private final function int GetAmount()
{
    return Amount;
    //return ReturnValue;    
}

static function SPPointEventAnimusBanked CreateSPPointEventAnimusBanked(Controller theBanker, int theAmount)
{
    local SPPointEventAnimusBanked theEvent;

    theEvent = new (none) Class'SPPointEventAnimusBanked';
    theEvent.SetScorer(theBanker);
    theEvent.SetAmount(theAmount);
    return theEvent;
    //return ReturnValue;    
}

defaultproperties
{
    Points=1.0000000
}