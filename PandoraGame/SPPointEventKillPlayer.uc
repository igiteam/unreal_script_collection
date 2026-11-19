class SPPointEventKillPlayer extends SPPointEvent;

var private Controller Victim;

function Controller GetVictim()
{
    return Victim;
    //return ReturnValue;    
}

function SetVictim(Controller theVictim)
{
    Victim = theVictim;
    //return;    
}

defaultproperties
{
    Points=10.0000000
}