class PKItem_Boss_Swamp_Fireball_Base extends PKItem_Boss_Base_Item
    notplaceable
    hidecategories(Navigation);

const Speed = 4700;

var array<PKItem_Boss_Swamp_Firefly_Base> BallOfFireflies;
var export editinline StaticMeshComponent FireflyMesh;
var Vector FlightDestination;
var Vector MeanLocation;
var float DistanceTraveled;
var Vector StartLocation;
var PKPawn_Boss_Swamp_Base SwampBoss;
var SoundCue SoundOnSpawn;
var SoundCue SoundOnExplode;
var export editinline AudioComponent FlyingSoundLoop;

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    // End:0x52
    if(!Other.IsA('PKPawn_Boss_Swamp_Base'))
    {
        PlaySound(SoundOnExplode,,,, Location);
        DisperseFireflies();
        Destroy();
    }
    //return;    
}

function DisperseFireflies()
{
    local PKItem_Boss_Swamp_Firefly_Base Firefly;
    local PKPlayerPawn PlayerPawn;

    // End:0xE6
    foreach DynamicActors(Class'PKPlayerPawn', PlayerPawn)
    {
        // End:0xE5
        if(VSize(PlayerPawn.Location - Location) < float(SwampBoss.FireBallDamageRadius))
        {
            PlayerPawn.TakeDamage(SwampBoss.FireballDamage, SwampBoss.MyPKAI, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'EvilGame.EvilDmgType_Melee',, self);
        }        
    }    
    // End:0x11E
    foreach BallOfFireflies(Firefly)
    {
        Firefly.Disperse();        
    }    
    //return;    
}

function GoToDestination(Vector Destination)
{
    local PKItem_Boss_Swamp_Firefly_Base Firefly;

    DistanceTraveled = 0.0000000;
    FlightDestination = Destination;
    StartLocation = Location;
    PlaySound(SoundOnSpawn,,,, Location);
    FlyingSoundLoop.Play();
    // End:0xB6
    foreach BallOfFireflies(Firefly)
    {
        Firefly.GoToDestination(Destination, 2);        
    }    
    Velocity = Normal(FlightDestination - StartLocation) * float(4700);
    //return;    
}

function CalculateMeanLocation()
{
    local PKItem_Boss_Swamp_Firefly_Base Firefly;
    local Vector SumOfLocations;

    SumOfLocations = vect(0.0000000, 0.0000000, 0.0000000);
    // End:0x58
    foreach BallOfFireflies(Firefly)
    {
        SumOfLocations += Firefly.Location;        
    }    
    MeanLocation = SumOfLocations / float(20);
    SetLocation(MeanLocation);
    //return;    
}

event Tick(float DeltaTime)
{
    super(Actor).Tick(DeltaTime);
    // End:0x79
    if((DistanceTraveled > VSize(FlightDestination - StartLocation)) || (Location != StartLocation) && DistanceTraveled == VSize(Location - StartLocation))
    {
        Destroy();
    }
    DistanceTraveled = VSize(Location - StartLocation);
    //return;    
}

auto state FlyingAround
{Begin:

    Sleep(0.5000000);
    goto 'Begin';
    stop;        
}
