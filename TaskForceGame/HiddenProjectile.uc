class HiddenProjectile extends ImpactProjectile;

simulated event Explode(vector HitLocation, vector HitNormal)
{
	BlowUp ( HitLocation );
	Destroy ( );
}


// Decompiled with UE Explorer.
defaultproperties
{
    DamageRadius=3000.0000000
    MyDamageType=Class'DamageTypeRPG'
    bHidden=true
}