//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDProj_C4Explosive extends HDBaseProjectile;

var editinline PrimitiveComponent	Mesh;
var vector                          ExplodeNormal;
var vector                          ExplodeLocation;
var LightEnvironmentComponent       MyLightEnvironment;
var transient bool                  bHitWall;
// client explosive
var bool                            bClientExplosive;

simulated function TakeDamage(int inDamage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
  	local class<HDDmgType_FlashGrenade> FlashDmgType;
	FlashDmgType = class<HDDmgType_FlashGrenade>(DamageType);
    if ( FlashDmgType != none )
		return;
	if ( inDamage != 0 )
    {
        Explode( GetExplodeLocation(), GetExplodeNormal() );
    }
}

simulated function vector GetExplodeLocation()
{
    return (bHitWall)? ExplodeLocation : Location;
}

simulated function vector GetExplodeNormal()
{
    return (bHitWall)? ExplodeNormal : vect(0,0,1);
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    Velocity = vect(0,0,-20);
}

simulated singular event HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
    local vector HitLocation, StartTrace, EndTrace;
    local TraceHitInfo HitInfo;
    local Actor HitActor;
    local Matrix LToW;
    local vector LocalTrans;

	if ( Wall.bWorldGeometry || Wall.bStatic )
	{
    	Velocity = vect(0,0,0);
    	Acceleration = vect(0,0,0);
    	RotationRate = rot(0,0,0);

    	ExplodeNormal = HitNormal;
    	SetRotation( rotator(-HitNormal) );
    	StartTrace = Location;
    	EndTrace = StartTrace - 100 * HitNormal;
    	ExplodeLocation = Location;
    	foreach TraceActors( class'Actor', HitActor, HitLocation, HitNormal, EndTrace, StartTrace, vect(0,0,0), HitInfo, TRACEFLAG_Bullet)
    	{
    	   if ( HitActor != None )
    	   {
               LToW = MakeRotationTranslationMatrix(Location, Rotation);
    	       ExplodeLocation = HitLocation;
    	       LocalTrans = InverseTransformVector( LToW, HitLocation );
    	       Mesh.SetTranslation(LocalTrans);
    	       bHitWall = True;
    	       break;
    	   }
    	}
	    SetPhysics(PHYS_None);
    	SetCollision(TRUE, TRUE);
	}
}


simulated event PostBeginPlay()
{
    Super.PostBeginPlay();
    Mesh.SetLightEnvironment(MyLightEnvironment);
}
simulated event Destroyed()
{
    if ( Role < Role_Authority && !bClientExplosive )
        Explode( GetExplodeLocation(), GetExplodeNormal() );
    Super.Destroyed();
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    bClientExplosive = True;
    Super.Explode(HitLocation, HitNormal);
}

