class HEGrenadeAmmo extends GrenadeAmmo;

function Projectile SpawnProjectileEx(vector Start, rotator Dir, float SpeedMod, float TimeDelta)
{
	local Projectile P; 

//	P = Spawn(ProjectileClass,Owner,, Start,Dir);	
	
	P = Spawn(ProjectileClass,Owner,, Start,Dir);	
	P.Speed = ProjectileClass.Default.Speed * SpeedMod; 
	if( instigator != None )
		P.InstigatorController = instigator.controller;

	//this line makes no sense.  Level.TimeSEconds is passed in for TimeDelta ?!?
	//P.LifeSpan = TimeDelta; 

	return P;
}


// Decompiled with UE Explorer.
defaultproperties
{
    MaxAmmo=3
    AmmoAmount=2
    ProjectileClass=Class'ZombieGame.GrenadeProjectile'
    MyDamageType=Class'ZombieGame.DamageTypeHEGrenade'
    PickupClass=Class'AmmoPickupHEGrenade'
    ItemName="HE Grenades"
}