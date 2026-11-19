class SplashZone extends Actor
						hidecategories(Attachment, Collision, Display)
						placeable
						native;
						
var() vector ImpulseOffset;					// Offset from objects location to apply forces
var() float ImpulseForce;					// How much force to apply to nearby objects
var() float AffectedRadius;					// What radius the zone effects
var() float DamageCaused;					// How much damage does this do.
											// (Objects Location) = Full Damage -------> (Objects Location + Affected Radius) = Least Damage
var() array<ParticleSystem>	Emitters;		// Particle Effects
var() array<SoundCue> Sounds;				// Sounds
var() bool bShowRadiusInEditor;

// Used to preview the affected radius.
var	DrawSphereComponent	RenderComponent;
var ParticleSystemComponent EmitterComponent;

// type of dame to apply to the affected radius
var() class<DamageType> 	DamageType;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

simulated function OnToggle(SeqAct_Toggle Action)
{
	// Only let TurnOn and Toggle work for SplashZones
	if (Action.InputLinks[0].bHasImpulse)
	{
		ImpactNearbyObjects();
	}	
	else if (Action.InputLinks[1].bHasImpulse)
	{
		;
	}
	else if (Action.InputLinks[2].bHasImpulse)
	{
		ImpactNearbyObjects();
	}

}

simulated function SpawnExplosionEffectSP(ParticleSystem Template)
{
	local EmitterSpawnable e;

	e = Spawn( class'EmitterSpawnable',,,Location, Rotation);
	e.bDestroyOnSystemFinish = true;
	e.SetTemplate(Template);
	//e.ParticleSystemComponent.OnSystemFinished = OnEffectFinished;
	e.ParticleSystemComponent.ActivateSystem();
}

simulated function SpawnExplosionEffectMP(class<TPReplicatedEmitter> EmitterClass)
{
	local TPReplicatedEmitter e;
	e = Spawn( EmitterClass,,,Location, Rotation);
	e.ParticleSystemComponent.ActivateSystem();
}

function OnEffectFinished(ParticleSystemComponent PSystem)
{
	Destroy();
} 

function ImpactNearbyObjects()
{
	local int i;
	local Actor A;
	
	local vector Offset, Dir;
	local float Percentage, D, M, DamCalc;
	 
	// Spawn Particle Systems if any
	for (i = 0; i < Emitters.Length; i++)
	{
		if (Emitters[i] != none)
		{
			SpawnExplosionEffectSP(Emitters[i]);
		}
	}

//	Spawn(class'FadeOutLight',,,Location);

	// Play the Explosion Sounds
	for (i = 0; i < Sounds.Length; i++)
	{
		if (Sounds[i] != none)
		{
			PlaySound(Sounds[i],,,,Location);
			
			if( Owner != None && TPWeapon(Owner) != None)
			{
				MakeNoise(TPWeapon(Owner).m_ProjectileExplodingLoudness, AudioEventType_NORMAL_EXPLODING);
			}
		}
	}

	if (AffectedRadius > 0)
	{
		Offset = Location + ImpulseOffset;

		
		foreach VisibleCollidingActors(class'Actor', A, AffectedRadius, Location, true)
		{
			//if (VSize(Location - A.Location) < AffectedRadius)
			//{                
				//CauseCameraShake( Instigator, HitLocation+HitNormal*3, default.DamageRadius*4.f );
				M = ImpulseForce * 5;
				DamCalc = DamageCaused;
				D = VSize(A.Location-Offset);

				Dir = Normal(A.Location-Offset);
				
				if (D > AffectedRadius * 0.5)
					Percentage =  D / AffectedRadius;
				else
					Percentage =  0;
				
				DamCalc -= DamageCaused * Percentage;
				M -= ImpulseForce * Percentage;
				A.TakeDamage( DamCalc, none, Offset, Dir*M, DamageType);
			//}
		}
	}
}

