class PKProjectile_Rocket_Base extends EvilProjectile_Base
    abstract
    hidecategories(Navigation);

function Init(Vector Direction)
{
    // End:0x7A
    if((PKPlayerPawn(Instigator) != none) && PainPRI(Instigator.PlayerReplicationInfo).bHasWeaponModifier)
    {
        Speed *= 1.5000000;
        MaxSpeed *= 1.5000000;
    }
    super.Init(Direction);
    //return;    
}

defaultproperties
{
    bWaitForEffects=true
    TimeToExplode=2.0000000
    CustomGravityScaling=0.1000000
    Speed=3000.0000000
    MaxSpeed=3000.0000000
    DamageRadius=500.0000000
    MyDamageType=Class'PKDmgType_Rocket'
    // Reference: CylinderComponent'Default__PKProjectile_Rocket_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'EvilGame.Default__EvilProjectile_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Physics=EPhysics.PHYS_Falling
    bNetTemporary=false
    CollisionComponent=CollisionCylinder
}