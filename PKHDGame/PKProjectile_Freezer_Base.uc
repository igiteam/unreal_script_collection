class PKProjectile_Freezer_Base extends EvilProjectile_Base
    abstract
    hidecategories(Navigation);

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    // End:0x73
    if(EvilWeap_Base(Instigator.Weapon) != none)
    {
        EvilWeap_Base(Instigator.Weapon).CheckAndUpdateHitEnemyIndicator(Other);
    }
    Other.TakeDamage(0, InstigatorController, HitLocation, vect(0.0000000, 0.0000000, 0.0000000), MyDamageType);
    ShutDown();
    //return;    
}

defaultproperties
{
    bWaitForEffects=true
    Speed=2800.0000000
    MaxSpeed=2800.0000000
    DamageRadius=200.0000000
    MyDamageType=Class'PKDmgType_Freezer'
    // Reference: CylinderComponent'Default__PKProjectile_Freezer_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'EvilGame.Default__EvilProjectile_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=2.0000000
        CollisionRadius=10.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    bNetTemporary=false
    CollisionComponent=CollisionCylinder
}