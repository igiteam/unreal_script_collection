class SOFLAMExploder extends GrenadeProjectile;

/*event Destroyed()
{
	Explode(Location,vector(Rotation));
	Super.Destroyed();
}*/

// Decompiled with UE Explorer.
defaultproperties
{
    DPExplosionSound=Sound'CBW_DYN_weapons.explosions.C4_explosion1'
    RumbleRadiusMultiplier=10.0000000
    ImpactDamage=50
    Damage=500.0000000
    BotDamage=500.0000000
}