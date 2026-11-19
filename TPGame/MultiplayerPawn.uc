
class MultiplayerPawn extends PlayerPawn;

var bool bEnableHitReaction;

replication
{
	if (bNetDirty && Role == ROLE_Authority)
		bEnableHitReaction;
}

event bool IsInHitReaction()
{
	return bEnableHitReaction;
}

reliable client function ClientAddAnimSets(TPWeapon lastWeapon)
{
	AddAnimSets(lastWeapon.PawnAnimSets);
}


event TakeDamage( int Damage, Controller instigatedBy, Vector hitlocation,
						Vector momentum, class<DamageType> damageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local eHitZone	damagedRegion;

	damagedRegion = GetHitZone(HitInfo.BoneName);

	if ( damagedRegion == HZ_None )
		damagedRegion = GetApproxHitZone(hitlocation);

	if ( DamageType != class'TPDamageTypeImpactGrenade' && DamageType != class'DmgType_Fell')
	{
		switch(damagedRegion)
		{
			case HZ_Arm:
				Damage *= DamageMultiplierArms;
				break;

			case HZ_Leg:
				Damage *= DamageMultiplierLegs;
				break;

			case HZ_Head:
				Damage *= DamageMultiplierHead;
				break;

			case HZ_Chest:
			default:
				Damage *= DamageMultiplierChest;
				break;
		}
	}

	;

	Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType, HitInfo, DamageCauser);

	NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
}
