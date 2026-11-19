class GrenadeSplashZone extends SplashZone
									placeable;

var class<TPReplicatedEmitter> ReplicatedEmitter;
var TPPlayerController		controllerOwner;

function ImpactNearbyObjects()
{
	local int i;
	local Actor A;
	local vector Offset, Dir;
	local float Percentage, D, M, DamCalc, TempDamage;

	//`log("KMSK - ImpactNearbyObjects()");

	TempDamage = DamageCaused;

	// Spawn Particle Systems if any
	for (i = 0; i < Emitters.Length; i++)
	{
		if (Emitters[i] != none)
		{
			if (WorldInfo.NetMode == NM_Standalone)
			{
				SpawnExplosionEffectSP(Emitters[i]);
			}
			else
			{
				SpawnExplosionEffectMP(ReplicatedEmitter);
			}
		}
	}

	// Play light FX
	Spawn(class'FadeOutLight',,,Location);

	// Play the Explosion Sounds
	for (i = 0; i < Sounds.Length; i++)
	{
		if (Sounds[i] != none)
		{
			PlaySound(Sounds[i],,,,Location);
			MakeNoise( class'Grenade_Persistent'.Default.m_ProjectileExplodingLoudness, AudioEventType_GRENADE_EXPLODING);
		}
	}

	if (AffectedRadius > 0)
	{
		Offset = Location + ImpulseOffset;

		//OverlappingActors
		foreach VisibleCollidingActors(class'Actor', A, AffectedRadius, Location, true)
		{
			M = ImpulseForce;
			DamCalc = TempDamage;
			D = VSize(A.Location-Offset);

			Dir = Normal(A.Location-Offset);

			if (D > AffectedRadius * 0.5)
			{
				Percentage =  D / AffectedRadius;
			}
			else
			{
				Percentage =  0;
			}

			if (TPBaseVehicle(A) != None)
			{
				//for vehicles, since they're so large just do the full damage
				Percentage = 0;
			}
			DamCalc -= TempDamage * Percentage;
			M -= ImpulseForce * Percentage;

			A.TakeDamage( DamCalc, controllerOwner, Offset, Dir*M, DamageType);
		}
	}
}

