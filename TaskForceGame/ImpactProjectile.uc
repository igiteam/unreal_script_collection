//
// ImpactProjectile.uc
//
// Projectile object that exploads on impact with anything sending damage
// to a pawn object if hit. 
//

class ImpactProjectile extends SFRMProjectile;

var() Sound IPExplosionSound;

simulated function Destroyed()
{
	AmbientSound = None;
	if ( MyHitMaterial == None || (MyHitMaterial != None && MyHitMaterial.MaterialType != EMATERIALTYPE_SKY) )
	{
		// play sound if we have a valid explosion.
		PlaySound(IPExplosionSound,, 1,,5000.0, 0.5+FRand(),true);
	}
	Super.Destroyed(); 
}

simulated function HitWall( vector HitNormal, actor HitWall )
{
	if( Level.bMPWeapLogs )
	{
		if( Pawn(HitWall) != None )
		{
			Log( Level.TimeSeconds $" MPLog:   ## Impact projectile "$ self.class $" launched by "$ instigator.PlayerReplicationInfo.PlayerName $"  hit player named "$ Pawn(HitWall).PlayerReplicationInfo.PlayerName $"  class idx:"$ Pawn(HitWall).PlayerReplicationInfo.ClassIdx $"  terr:"$ Pawn(HitWall).PlayerReplicationInfo.bTerrorist );
		}
		else if( HitWall != None )
		{
			Log( Level.TimeSeconds $" MPLog:   ## Impact projectile "$ self.class $" launched by "$ instigator.PlayerReplicationInfo.PlayerName $"  hit a(n) "$ HitWall.class );
		}
		else
		{
			Log( Level.TimeSeconds $" MPLog:   ## Impact projectile "$ self.class $" launched by "$ instigator.PlayerReplicationInfo.PlayerName $"  couldn't figure out my HitWall.");
		}
	}

	// Handle impact with destructible (may need to break the destructible and keep going)
	if( DestructibleMesh(HitWall) != None && VSize(Velocity) > MinDestructibleBreakSpeed )
	{
		HitWall.TakeDamage( ImpactDamage, instigator, Location, vect(0,0,0), class'DamageTypeProjectile' );

		// If victim (destructible) is being destroyed by the impact, then don't bounce 
		// (just slightly dampen velocity and let projectile pass through).
		if( DestructibleMesh(HitWall).HitPoints <= 0 )
		{
			if( VSize(Velocity) > 40 )
				return;
		}
	}

	// Make projectile less likely to be outside world when it's exploding (MAT 03/07/04)
	SetLocation( Location + 8.0*HitNormal );
	Velocity *= 0.01;

	Explode(Location, HitNormal);
	Destroy();
 
}

simulated function Landed( vector HitNormal )
{
	HitWall(HitNormal, None);
}


simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	local vector HitNormal;

	If ( Other!=Instigator )
	{
		// hack, so we always have a valid location for the HitNormal
		if (Other == None)
			Other = Self; 

		HitNormal = Normal(HitLocation-Other.Location);
		Explode(HitLocation, HitNormal);
//		PlayStreamingSound(IPExplosionSound, , , ,true,false);
		Destroy();
	}
}
	



// Decompiled with UE Explorer.
defaultproperties
{
    Speed=2000.0000000
    MaxSpeed=3000.0000000
    Damage=200.0000000
}