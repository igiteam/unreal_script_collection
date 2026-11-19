//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDProj_FlashGrenade extends HDProj_GrenadeBase;

simulated function Explode(vector HitLocation, vector HitNormal)
{
	if ( Role == ROLE_Authority )
		MakeNoise(1.0);
	ProjectileHurtRadius2(Damage,DamageRadius, MyDamageType, MomentumTransfer, HitLocation, HitNormal );
	SpawnExplosionEffects(HitLocation, HitNormal);

	ShutDown();
}

/**
 * Hurt locally authoritative actors within the radius.
 * Projectile version if needed offsets the start of the radius check to prevent hits embedded in walls from failing to cause damage
 */
simulated function bool ProjectileHurtRadius2( float DamageAmount, float InDamageRadius, class<DamageType> DamageType, float Momentum,
 						vector HurtOrigin, vector HitNormal, optional class<DamageType> ImpactedActorDamageType )
{
	local bool bCausedDamage, bInitializedAltOrigin, bFailedAltOrigin;
	local Actor	Victim, HitActor;
	local vector AltOrigin;
	local vector HurtNormal, HurtLocation;
	local Pawn VictimPawn;
	local bool bViewGrenade;

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

	foreach CollidingActors( class'Actor', Victim, DamageRadius, HurtOrigin )
	{
		if ( !Victim.bWorldGeometry && (Victim != self) && (Victim != ImpactedActor) && (Victim.bProjTarget || (NavigationPoint(Victim) == None)) )
		{
            VictimPawn = Pawn(Victim);

            if ( VictimPawn == none ) continue;

            HitActor = Trace( HurtNormal, HurtLocation, HurtOrigin, Victim.Location,true,,, TRACEFLAG_Bullet);
			if ( HitActor != none && HitActor != Victim )
			{
				// try out from wall, in case trace start was embedded
				if ( !bInitializedAltOrigin )
				{
					// initialize alternate trace start
					bInitializedAltOrigin = true;
					AltOrigin = HurtOrigin + VictimPawn.MaxStepHeight * HitNormal;
					HitActor = Trace( HurtNormal, HurtLocation, HurtOrigin, AltOrigin, true,,, TRACEFLAG_Bullet);
					if ( HitActor != none && HitActor != Victim )
					{
						if ( Velocity == vect(0,0,0) )
						{
							bFailedAltOrigin = true;
						}
						else
						{
							AltOrigin = HurtOrigin - VictimPawn.Default.MaxStepHeight * normal(Velocity);
							HitActor = Trace( HurtNormal, HurtLocation, HurtOrigin, AltOrigin,true,,, TRACEFLAG_Bullet);
							bFailedAltOrigin = (HitActor != Victim);
						}
					}
				}
				HitActor = Trace( HurtNormal, HurtLocation, AltOrigin, Victim.Location,true,,, TRACEFLAG_Bullet);
				if ( bFailedAltOrigin || ( HitActor != none && HitActor != Victim ) )
				{
					continue;
				}
			}
            bViewGrenade = (VictimPawn.Controller!=none) ? VictimPawn.Controller.CanSeeByPoints( VictimPawn.GetPawnViewLocation(), HurtOrigin, VictimPawn.GetBaseAimRotation() ) : TRUE;
            DamageAmount *= (bViewGrenade) ? 1.0f : 0.5f;
			Victim.TakeRadiusDamage(InstigatorController, DamageAmount, DamageRadius, DamageType, Momentum, HurtOrigin, false, self);
			bCausedDamage = bCausedDamage || Victim.bProjTarget;
		}
	}
	bHurtEntry = false;

	return bCausedDamage;
}



