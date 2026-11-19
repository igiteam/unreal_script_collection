class SoundProjectile extends Projectile;

var Sound MoveAmbientSound;


simulated function HitWall( vector HitNormal, actor HitWall )
{
	Destroy(); 
}

simulated function Landed( vector HitNormal )
{
	Destroy(); 
}

simulated event Explode(vector HitLocation, vector HitNormal)
{
}

auto State Flying
{
Begin:
	AmbientSound=MoveAmbientSound;
	Velocity = Speed * vector(Rotation);
	RandSpin(1000);
	Speed = VSize(Velocity);
		
	if ( Velocity.Z > 400 )
	{
		Velocity.Z = 0.5 * (400 + Velocity.Z);
	}
	SetPhysics(PHYS_Flying); 
	bBounce = False;
}


// Decompiled with UE Explorer.
defaultproperties
{
    Physics=4
    ForceType=1
}