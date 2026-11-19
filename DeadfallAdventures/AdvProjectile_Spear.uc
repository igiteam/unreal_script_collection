class AdvProjectile_Spear extends EvilProjectile_Base
    hidecategories(Navigation);

defaultproperties
{
    CheckRadius=80.0000000
    Speed=1500.0000000
    MaxSpeed=1500.0000000
    Damage=10.0000000
    DamageRadius=80.0000000
    MomentumTransfer=2500.0000000
    // Reference: CylinderComponent'Default__AdvProjectile_Spear.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    LifeSpan=10.0000000
    CollisionComponent=CollisionCylinder
}