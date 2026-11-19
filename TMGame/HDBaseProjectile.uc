//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDBaseProjectile extends TMProjectile
    native(HDWeapon);

var transient   bool    bInWaterVolume;
var ParticleSystem      ProjMoveInWaterTemplate;
var ParticleSystem      ProjExplosionInWaterTemplate;
var () bool             bShakePawn;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

/**
 * Hurt locally authoritative actors within the radius.
 * Projectile version if needed offsets the start of the radius check to prevent hits embedded in walls from failing to cause damage
 */
simulated function bool ProjectileHurtRadius2( float DamageAmount, float InDamageRadius, class<DamageType> DamageType, float Momentum,
						vector HurtOrigin, vector HitNormal, optional class<DamageType> ImpactedActorDamageType )
{
	local bool bCausedDamage, bSuccessDamage/*, bFailedAltOrigin*/;
	local Actor	Victim;
	local HDBasePawn   VictimPawn;
	local vector eyePos, footPos;
	local vector /*AltOrigin,*/ BBoxCenter;
	local PhysicsVolume    WaterVolume;
	local HDWaterEffectVolume  WaterEffectVolume;
	local Box BBox;

	// Prevent HurtRadius() from being reentrant.
	if ( bHurtEntry || bShuttingDown )
		return false;

	bHurtEntry = true;
	bCausedDamage = false;

	// if ImpactedActor is set, we actually want to give it full damage, and then let him be ignored by super.HurtRadius()
	if ( (ImpactedActor != None) && (ImpactedActor != self)  )
	{
		ImpactedActor.TakeRadiusDamage( InstigatorController, DamageAmount, InDamageRadius,
						(ImpactedActorDamageType != None) ? ImpactedActorDamageType : DamageType,
						Momentum, HurtOrigin, true, self );
		// need to check again in case TakeRadiusDamage() did something that went through our explosion path a second time
		if (ImpactedActor != None)
		{
			bCausedDamage = ImpactedActor.bProjTarget;
		}
	}

	foreach OverlappingActors( class'Actor', Victim, DamageRadius, HurtOrigin, FALSE )
	{
		WaterVolume = PhysicsVolume(Victim);
		WaterEffectVolume = HDWaterEffectVolume(Victim);
		if ( (WaterVolume != None && WaterVolume.bWaterVolume) || WaterEffectVolume != None )
		{
		    bInWaterVolume = WaterVolume.EncompassesPoint(HurtOrigin);
		    continue;
		}

		if ( (!Victim.bWorldGeometry || !Victim.bStatic) && (Victim != self) && (Victim != ImpactedActor) && (Victim.bProjTarget || (NavigationPoint(Victim) == None)) )
		{
            if ( !FastTrace(HurtOrigin, Victim.Location,, TRUE) )
			{
			    bSuccessDamage = False;

                VictimPawn = HDBasePawn(Victim);
                if ( VictimPawn != None && VictimPawn.Mesh != None )
			    {
                    // test eye
                    if ( !bSuccessDamage )
                    {
                        eyePos = VictimPawn.GetPawnViewLocation();
                        bSuccessDamage = FastTrace(HurtOrigin, eyePos,,TRUE);
                    }

                    if ( !bSuccessDamage )
                    {
                        footPos = VictimPawn.Mesh.GetBoneLocation(VictimPawn.Mesh.GetBoneName(0), 0);
                        bSuccessDamage = FastTrace(HurtOrigin, footPos,,TRUE);
                    }
			    }
				// other actor
				else
				{
				//	AltOrigin = HurtOrigin + class'TMPawn'.Default.MaxStepHeight * HitNormal;
//					if ( !bSuccessDamage )
//					{
//					   bSuccessDamage = FastTrace(HurtOrigin, AltOrigin,, TRUE);
//					}
//					if ( Velocity == vect(0,0,0) )
//					{
//						bFailedAltOrigin = true;
//					}
//					else if ( !bSuccessDamage )
//					{
//					   AltOrigin = HurtOrigin - class'TMPawn'.Default.MaxStepHeight * normal(Velocity);
//					   bSuccessDamage = !FastTrace(HurtOrigin, AltOrigin,, TRUE);
//					}
//
//					if ( !bSuccessDamage )
//					{
//					   bSuccessDamage = FastTrace(AltOrigin, Victim.Location,, TRUE);
//					}

                    bSuccessDamage = Victim.FastTrace(HurtOrigin, Victim.Location,, TRUE);
                    if(!bSuccessDamage)
                    {
                        Victim.GetComponentsBoundingBox(BBox);
        				BBoxCenter = (BBox.Min + BBox.Max) * 0.5f;
                        bSuccessDamage = Victim.FastTrace(HurtOrigin, BBoxCenter,, TRUE);
                    }
				}

				if ( /*bFailedAltOrigin ||*/ !bSuccessDamage )
				{
					continue;
				}
			}
			Victim.TakeRadiusDamage(InstigatorController, DamageAmount, DamageRadius, DamageType, Momentum, HurtOrigin, false, self);
			bCausedDamage = bCausedDamage || Victim.bProjTarget;
		}
	}
	bHurtEntry = false;

	return bCausedDamage;
}

simulated function SpawnExplosionEffects(vector HitLocation, vector HitNormal)
{
    if ( bInWaterVolume && WorldInfo.NetMode != NM_DedicatedServer )
    {
        if ( ProjExplosionInWaterTemplate != None )
        {
            WorldInfo.MyEmitterPool.SpawnEmitter(ProjExplosionInWaterTemplate, HitLocation, rot(-16384,0,0)+rotator(HitNormal));
        }
    }
    else
    {
        Super.SpawnExplosionEffects( HitLocation, HitNormal );
    }
}


simulated function PhysicsVolumeChange( PhysicsVolume NewVolume )
{
	local HDWaterEffectVolume  WaterEffectVolume;
	WaterEffectVolume = HDWaterEffectVolume(NewVolume);
    if ( NewVolume.bWaterVolume == True || WaterEffectVolume != none )
	{
		WorldInfo.MyEmitterPool.SpawnEmitter(ProjMoveInWaterTemplate, Location, rotator(-Velocity));
        Velocity *= 0.25;
	}

	Super.PhysicsVolumeChange(NewVolume);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    local Actor Victim;
    local HDPawn HDP;

    Super.Explode( HitLocation, HitNormal );
    if ( bShakePawn == True )
    {
        foreach CollidingActors( class'Actor', Victim, DamageRadius*2.5, HitLocation )
        {
            HDP = HDPawn(Victim);
            if ( HDP != none )
            {
                HDP.OnShakeCameraEffect(HitLocation);
            }
        }
    }
}

