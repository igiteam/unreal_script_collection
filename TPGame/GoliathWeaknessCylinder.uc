// Used for when the player is leaning
class GoliathWeaknessCylinder extends Actor;

event TakeDamage( int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	if (Owner != none)
		Goliath_Tank(Owner).ReallyTakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}

