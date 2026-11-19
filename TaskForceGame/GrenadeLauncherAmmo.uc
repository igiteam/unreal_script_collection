//
// GrenadeLauncherAmmo
//

class GrenadeLauncherAmmo extends ProjectileAmmo;

function SpawnProjectile(vector Start, rotator Dir)
{
	local Projectile P;
	
//	P = Spawn(ProjectileClass,Owner,, Start,Dir);
	P = Spawn(ProjectileClass,,, Start,Dir);
	if( instigator != None )
		P.InstigatorController = instigator.controller;
}


// Decompiled with UE Explorer.
defaultproperties
{
    MaxAmmo=4
    AmmoAmount=2
    ProjectileClass=Class'GrenadeLauncherProjectile'
    MyDamageType=Class'ZombieGame.DamageTypeGrenade'
    PickupClass=Class'AmmoPickupGrenadeLauncher'
    ItemName="Grenade launcher ammo"
}