//
// ProjectileAmmo
//
// Projectile Ammo type base class
//

class ProjectileAmmo extends SFRMAmmunition;

function SpawnProjectile(vector Start, rotator Dir)
{
	local Projectile P;
	
//	P = Spawn(ProjectileClass,Owner,, Start,Dir);
	P = Spawn(ProjectileClass,,, Start,Dir);

}


// Decompiled with UE Explorer.
defaultproperties
{
    MaxAmmo=300
    AmmoAmount=30
    bSplashDamage=true
    MyDamageType=Class'DamageTypeProjectile'
    WarnTargetPct=1.0000000
    MomentumTransfer=15000.0000000
}