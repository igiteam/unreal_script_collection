class EvilNoiseActor extends Actor
    notplaceable
    hidecategories(Navigation);

var name NoiseType;
var float LastNoiseTime;
var Vector LastNoiseLocation;
var float NoiseMinTimeDelta;
var float NoiseMinLocationDelta;

static function EvilNoiseActor CreateNoiseActor(Actor InInstigator, name InNoiseType)
{
    local EvilNoiseActor NoiseActor;

    NoiseActor = InInstigator.Spawn(default.Class, InInstigator);
    NoiseActor.NoiseType = InNoiseType;
    return NoiseActor;
    //return ReturnValue;    
}

function MakeNoiseInLocation(Vector InLocation, optional float Loudness = 1.0000000, optional name InNoiseType)
{
    local float LocationDeltaSq;

    LocationDeltaSq = VSizeSq(LastNoiseLocation - InLocation);
    // End:0x103
    if((WorldInfo.TimeSeconds > (LastNoiseTime + NoiseMinTimeDelta)) || LocationDeltaSq > (NoiseMinLocationDelta * NoiseMinLocationDelta))
    {
        SetLocation(InLocation);
        MakeNoise(Loudness, ((InNoiseType != 'None') ? InNoiseType : NoiseType));
        LastNoiseTime = WorldInfo.TimeSeconds;
        LastNoiseLocation = Location;
    }
    //return;    
}

defaultproperties
{
    NoiseMinTimeDelta=0.5000000
    NoiseMinLocationDelta=3000.0000000
    CollisionType=ECollisionType.COLLIDE_CustomDefault
}