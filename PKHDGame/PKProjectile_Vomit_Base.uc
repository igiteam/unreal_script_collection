class PKProjectile_Vomit_Base extends EvilProjectile_Base
    hidecategories(Navigation);

var Actor LastHit;
var bool SpawnLight;
var class<DamageType> MyDamageTypeWithLight;

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    // End:0x43
    if(EvilPawn(Other) == none)
    {
        bSuppressExplosionFX = false;
        Explode(HitLocation, HitNormal);        
    }
    else
    {
        // End:0x173
        if(LastHit != Other)
        {
            // End:0x7D
            if(SpawnLight)
            {
                MyDamageType = MyDamageTypeWithLight;                
            }
            else
            {
                MyDamageType = default.MyDamageType;
            }
            // End:0x103
            if(EvilWeap_Base(Instigator.Weapon) != none)
            {
                EvilWeap_Base(Instigator.Weapon).CheckAndUpdateHitEnemyIndicator(Other);
            }
            Other.TakeDamage(int(Damage), InstigatorController, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
            LastHit = Other;
        }
    }
    //return;    
}

defaultproperties
{
    MyDamageTypeWithLight=Class'PKDmgType_FlamerWithLight'
    bSuppressExplosionFX=true
    bWaitForEffects=true
    TimeToExplode=2.0000000
    Speed=1000.0000000
    MaxSpeed=1000.0000000
    Damage=15.0000000
    MyDamageType=Class'PKDmgType_Flamer'
    // Reference: CylinderComponent'Default__PKProjectile_Vomit_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'EvilGame.Default__EvilProjectile_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=30.0000000
        CollisionRadius=30.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    bNetTemporary=false
    LifeSpan=0.5000000
    CollisionComponent=CollisionCylinder
}