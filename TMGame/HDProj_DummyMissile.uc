//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDProj_DummyMissile extends HDBaseProjectile;

var() float                      ExplosionTime;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(ExplosionTime,false);
}

simulated function Timer()
{
	Explode(Location, vect(0,0,1));
}

simulated event HitWall(vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    Explode(Location, HitNormal);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    Super.Explode( HitLocation, HitNormal );
}

event Tick( float DeltaTime )
{
    local vector dir;
    Super.Tick(DeltaTime);
    dir = Normal(Velocity);
    SetRotation(rotator(dir));
}

