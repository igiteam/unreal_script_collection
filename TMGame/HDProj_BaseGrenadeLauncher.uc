//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDProj_BaseGrenadeLauncher extends HDBaseProjectile
    abstract;

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

