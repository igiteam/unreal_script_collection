class SPPointEventAnimusCollected extends SPPointEvent;

var private int Amount;

function SetAmount(int theAmount)
{
    Amount = theAmount;
    //return;    
}

function int GetAmount()
{
    return Amount;
    //return ReturnValue;    
}

defaultproperties
{
    Points=0.1000000
}