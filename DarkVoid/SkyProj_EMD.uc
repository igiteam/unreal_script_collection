class SkyProj_EMD extends SkyProjectile;

var repnotify byte FlockIndex;
var() float FlockRadius;
var() float FlockStiffness;
var() float FlockMaxForce;
var() float FlockCurlForce;
var bool bCurl;
var Vector Dir;
var SkyPawn Target;
var float DistanceToNarrow;

replication
{
    // Pos:0x000
    if(bNetInitial && int(Role) == int(ROLE_Authority)
        FlockIndex, bCurl;
}

simulated function Destroyed()
{
    ClearTimer('FlockTimer');
    super.Destroyed();
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    //return;    
}

simulated function FlockTimer()
{
    //return;    
}
