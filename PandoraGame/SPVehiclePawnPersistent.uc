class SPVehiclePawnPersistent extends SPPawn
    abstract
    native
    config(Game);

var bool HasPlayer;
var bool bOrientToGround;
var() float TurnSensitivity;
var Rotator TrueRotation;
var Vector ImpactVector;
var float ImpactStrength;
var float ImpactCurStrength;
var float impactTime;
var float ImpactCurTime;
var Vector GroundNormal;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    //return;    
}

simulated function Tick(float Time)
{
    super.Tick(Time);
    //return;    
}
