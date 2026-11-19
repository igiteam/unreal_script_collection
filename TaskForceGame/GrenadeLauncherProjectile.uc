class GrenadeLauncherProjectile extends ImpactProjectile;
/*
function PreBeginPlay()
{
	SetStaticMesh(StaticMesh( DynamicLoadObject("SFRM_weapon_meshes.projectiles.M203projectile", class'StaticMesh') ));
}
*/

// Decompiled with UE Explorer.
defaultproperties
{
    IPExplosionSound=Sound'CBW_DYN_weapons.explosions.M203_explosion1'
    Speed=3600.0000000
    MaxSpeed=5000.0000000
    TossZ=300.0000000
    Damage=115.0000000
    DamageRadius=192.0000000
    InnerDamageRadius=102.0000000
    FringeDamageRadius=240.0000000
    MyDamageType=Class'ZombieGame.DamageTypeHEGrenade'
    Physics=2
    DrawType=8
    StaticMesh=StaticMesh'CBS_DYN_Weapon.FX.brass'
    DrawScale3D=(X=1.5000000,Y=3.0000000,Z=3.0000000)
    CollisionRadius=4.0000000
    CollisionHeight=2.0000000
}