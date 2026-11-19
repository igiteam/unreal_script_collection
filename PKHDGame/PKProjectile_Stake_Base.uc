class PKProjectile_Stake_Base extends PKProjectile_Bolt_Base
    abstract
    hidecategories(Navigation);

var EvilExplosion ExplosionBurningArchetype;
var class<DamageType> MyDamageTypeBurning;
var() float BurningDamage;

function Init(Vector Direction)
{
    // End:0x7A
    if((PKPlayerPawn(Instigator) != none) && PainPRI(Instigator.PlayerReplicationInfo).bHasWeaponModifier)
    {
        Speed *= 1.6000000;
        MaxSpeed *= 1.6000000;
    }
    super(EvilProjectile_Base).Init(Direction);
    SetTimer(ComboCkeckInterval, true, 'CheckForCombo');
    //return;    
}

simulated function StartBurning()
{
    Damage = BurningDamage;
    DamageVSPlayer = int(BurningDamage);
    MyDamageType = MyDamageTypeBurning;
    super.StartBurning();
    //return;    
}

defaultproperties
{
    MyDamageTypeBurning=Class'PKDmgType_StakeBurning'
    BurningDamage=180.0000000
    BurnStartTime=0.4500000
    // Reference: EvilDissolvingStaticMeshComponent'Default__PKProjectile_Stake_Base.StaticMesh'
    // Archetype: EvilDissolvingStaticMeshComponent'Default__PKProjectile_Bolt_Base.StaticMesh'
    begin object name="StaticMesh"
        ReplacementPrimitive=none
    end object
    Mesh=StaticMesh
    CustomGravityScaling=0.8000000
    Speed=3900.0000000
    MaxSpeed=3900.0000000
    MyDamageType=Class'PKDmgType_Stake'
    // Reference: CylinderComponent'Default__PKProjectile_Stake_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PKProjectile_Bolt_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=StaticMesh
    CollisionComponent=CollisionCylinder
}