class SkyAvoidMarker extends Actor
    native
    notplaceable;

var byte TeamNum;
var float FearFactor;

simulated function byte GetTeamNum()
{
    return TeamNum;
    //return ReturnValue;    
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    //return;    
}

function StartleBots()
{
    //return;    
}
