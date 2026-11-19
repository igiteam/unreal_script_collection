class C4Ammo extends GrenadeAmmo;

function Projectile SpawnProjectileEx(vector Start, rotator Dir, float SpeedMod, float TimeDelta)
{
	local Projectile P; 

	P = Spawn(ProjectileClass,Owner,, Start,Dir);	
	P.Speed = ProjectileClass.Default.Speed * SpeedMod; 
	if( instigator != None )
		P.InstigatorController = instigator.controller;	

	return P;
}


// Decompiled with UE Explorer.
defaultproperties
{
    MaxAmmo=3
    AmmoAmount=2
    ProjectileClass=Class'C4Projectile'
    MyDamageType=Class'ZombieGame.DamageTypeHEGrenade'
    PickupClass=Class'AmmoPickupC4'
    ItemName="C4 Charges"
}