class PKItem_Boss_Swamp_Firefly_Base extends PKItem_Boss_Base_Item
    notplaceable
    hidecategories(Navigation);

var export editinline StaticMeshComponent FireflyMesh;
var Vector FlightDestination;
var Vector DefaultLocation;
var int Speed;
var float DistanceTraveled;
var Vector StartLocation;
var bool bActive;
var int Phase;
var Pawn BossPawn;
var ParticleSystem ParticlesOnFlight;
var export editinline ParticleSystemComponent Particles;

function GoToDestination(Vector Destination, int PhaseChange)
{
    DistanceTraveled = 0.0000000;
    Phase = PhaseChange;
    FlightDestination = Destination;
    StartLocation = Location;
    // End:0x7B
    if((Phase == 1) || Phase == 3)
    {
        Speed = 4000;        
    }
    else
    {
        // End:0x9A
        if(Phase == 2)
        {
            Speed = 2000;
        }
    }
    Velocity = Normal(FlightDestination - StartLocation) * float(Speed);
    GotoState('FlyingToDestination');
    //return;    
}

function Disperse()
{
    bActive = true;
    GoToDestination(DefaultLocation, 3);
    //return;    
}

event Tick(float DeltaTime)
{
    super(Actor).Tick(DeltaTime);
    // End:0x203
    if(bActive)
    {
        DistanceTraveled = VSize(Location - StartLocation);
        // End:0x12A
        if(Phase == 1)
        {
            // End:0xB2
            if(VSize(FlightDestination - Location) < float(128))
            {
                SetLocation(BossPawn.Mesh.GetBoneLocation('d_l_srodek'));                
            }
            else
            {
                FlightDestination = BossPawn.Mesh.GetBoneLocation('d_l_srodek');
                Velocity = Normal(FlightDestination - Location) * float(Speed);
            }            
        }
        else
        {
            // End:0x1A8
            if(DistanceTraveled > VSize(FlightDestination - StartLocation))
            {
                bActive = false;
                Velocity = vect(0.0000000, 0.0000000, 0.0000000);
                DistanceTraveled = 0.0000000;
                // End:0x19A
                if(Phase == 2)
                {
                    Disperse();
                }
                GotoState('FlyingAround');
            }
        }
        // End:0x203
        if(Phase == 2)
        {
            Velocity = Normal(FlightDestination - Location) * (float(Speed) + (VSize(FlightDestination - Location) * float(2)));
        }
    }
    //return;    
}

simulated event PostBeginPlay()
{
    Particles = new (self) Class'EvilGame.UTParticleSystemComponent';
    Particles.SetTemplate(ParticlesOnFlight);
    AttachComponent(Particles);
    Particles.ActivateSystem();
    Particles.SetScale(0.2500000);
    //return;    
}

auto state FlyingAround
{Begin:

    Sleep(0.5000000);
    goto 'Begin';
    stop;        
}

state FlyingToDestination
{Begin:

    bActive = true;
    goto 'Flying';
Flying:


    Sleep(0.5000000);
    goto 'Flying';
    stop;                
}
