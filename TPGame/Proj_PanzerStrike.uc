class Proj_PanzerStrike extends TPProjectile;

var float                   TotalTime;
var float                   EmitterDistance;
var ParticleSystemComponent	ProjEffects;
var ParticleSystem          ParticleFlightTemplate;
var ParticleSystem          ParticleSmokeTemplate;
var EmitterSpawnable        ParticleSmokeEmitter;
var vector                  LastLocation;
var vector                  ProjDirection;
var ParticleSystem			NormalExplosionTemplate;
var ParticleSystem			WaterExplosionTemplate;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    LastLocation = Location;
    SpawnFlightEffects();
}

// Overriden from parent so we can store the direction
function Init(vector Direction)
{
    ProjDirection=Direction;

	super.TPInit(Direction, true);
}

simulated function Tick(float DeltaTime)
{
    local float Percent;
    local float CurrentSpeed;
  
	TotalTime += DeltaTime;
    Percent = TotalTime / 0.2f; // 0.2 seconds to reach full speed
    Percent = FClamp(Percent, 0, 1.0f);

    CurrentSpeed = (MaxSpeed - Speed)*Percent;

    Velocity = (Speed+CurrentSpeed) * ProjDirection;

    super.Tick(DeltaTime);
}

function CauseBoomNow (vector HitNormal, Actor HitActor)
{
    local PhysicsGrenade PhyGrenade;

	//`log(" ChadAI - Panzer Rocket: " @ Self @ " CauseBoomNow Owner: " @ Owner @ " - Instigator: " @ Instigator @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

    PhyGrenade = Spawn(class'PhysicsGrenade',Instigator,,Location+30*HitNormal);

	if( Instigator != None && Instigator.Controller != None && TPPlayerController(Instigator.Controller) != None )
	{
		PhyGrenade.controllerOwner = TPPlayerController(Instigator.Controller);
	}

	if (!HitActor.IsA('TPPatrolBoat_Persistent') && !HitActor.IsA('TPWaterVolume'))
		PhyGrenade.Activate(0.001f, class'Grenade_Persistent'.static.GetDefaultImpulseForce(), 400, Damage, false, class'TPDamageTypeImpactPanzer', NormalExplosionTemplate);
	else
		PhyGrenade.Activate(0.001f, class'Grenade_Persistent'.static.GetDefaultImpulseForce(), 400, Damage, false, class'TPDamageTypeImpactPanzer', WaterExplosionTemplate);
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	//`log("ProcessTouch"@Other);
	if (ParticleSmokeEmitter != None)
		ParticleSmokeEmitter.Destroy();

    CauseBoomNow(HitNormal, Other);
    Shutdown();
}

simulated function HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	//`log("HitWall"@Wall);
	if (ParticleSmokeEmitter != None)
		ParticleSmokeEmitter.Destroy();

    CauseBoomNow(HitNormal, Wall);
    Shutdown();
}

simulated function SpawnFlightEffects()
{
	if ( WorldInfo.NetMode != NM_DedicatedServer )
	{
		ParticleSmokeEmitter = Spawn(class'EmitterSpawnable',,, LastLocation, rotator(Velocity));
	    ParticleSmokeEmitter.SetTemplate(ParticleFlightTemplate);
	    ParticleSmokeEmitter.LifeSpan = 10.0f;
		ParticleSmokeEmitter.ParticleSystemComponent.SetScale(0.2);
		ParticleSmokeEmitter.ParticleSystemComponent.SetAbsolute(false, false, true);
		AttachComponent(ParticleSmokeEmitter.ParticleSystemComponent);
	}
}

simulated function Shutdown()
{
    // @todo Turn off flight particles here?

    Super.Shutdown();
}

