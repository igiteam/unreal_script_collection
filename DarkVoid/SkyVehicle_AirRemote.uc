class SkyVehicle_AirRemote extends SkyAirVehicle
    native
    config(Game);

var(AirRemote) float DistanceForWarning;
var(AirRemote) float DistanceForExplode;
var(AirRemote) float MaxTimeBetweenBeeps;
var(AirRemote) float MinimumTimeForBeep;
var(AirRemote) SoundCue WarningBeep;
var(AirRemote) SoundCue ExplodeBeep;
var float BeepTimeBucket;
var transient bool bDamaged;

simulated function PostBeginPlay()
{
    SetHealth(1000);
    super.PostBeginPlay();
    //return;    
}

simulated function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    DriverLeave(true);
    return super.Died(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    super(SkyVehicle).DisplayDebug(HUD, out_YL, out_YPos);
    DrawDebugCoordinateSystem(Location, Rotation, 50.0000000, false);
    //return;    
}

function Tick(float DeltaTime)
{
    local float Dist, mod;

    // End:0x1E
    if(Driver == none)
    {
        Dist = DistanceForExplode + float(1);        
    }
    else
    {
        Dist = VSize(Driver.Location - Location);
    }
    // End:0x59
    if(Dist < DistanceForWarning)
    {
        BeepTimeBucket = 0.0000000;        
    }
    else
    {
        // End:0x75
        if(Dist > DistanceForExplode)
        {
            AutoDetonate();            
        }
        else
        {
            BeepTimeBucket += DeltaTime;
            mod = (DistanceForExplode - Dist) / (DistanceForExplode - DistanceForWarning);
            // End:0xE7
            if((BeepTimeBucket > (MaxTimeBetweenBeeps * mod)) && BeepTimeBucket > MinimumTimeForBeep)
            {
                PlaySound(WarningBeep, true,,, Location);
                BeepTimeBucket = 0.0000000;
            }
        }
    }
    super(Actor).Tick(DeltaTime);
    //return;    
}

function AutoDetonate()
{
    PlaySound(ExplodeBeep, true,,, Location);
    //return;    
}

// Export USkyVehicle_AirRemote::execTakeDamage(FFrame&, void* const)
native simulated function TakeDamage(int DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);
