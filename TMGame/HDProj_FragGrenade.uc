//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDProj_FragGrenade extends HDProj_GrenadeBase
      native(HDWeapon);



/** Overridden to allow explosions to blow up other grenades. */
simulated function TakeDamage(int Dmg, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local vector ApplyImpulse;

	super.TakeDamage(Dmg, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);

    if ( damageType.default.KDamageImpulse > 0 )
    {
		if ( VSize(momentum) < 0.001 )
		{
			;
			return;
		}

		// Make sure we have a valid TraceHitInfo with our SkeletalMesh
		// we need a bone to apply proper impulse
		CheckHitInfo( HitInfo, Mesh, Normal(Momentum), hitlocation );

		ApplyImpulse = Normal(momentum) * damageType.default.KDamageImpulse;
		if ( HitInfo.HitComponent != None )
		{
			HitInfo.HitComponent.AddImpulse(ApplyImpulse, HitLocation, HitInfo.BoneName);
		}
    }
}




