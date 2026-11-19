class PKProjectile_Flamer_Base extends EvilProjectile_Base
    hidecategories(Navigation);

var Actor LastHit;
var bool SpawnLight;
var class<DamageType> MyDamageTypeWithLight;

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    // End:0x77
    if(((EvilPawn(Other) == none) && EvilDestructibleObject(Other) == none) && EvilDynamicDestructibleObject(Other) == none)
    {
        bSuppressExplosionFX = false;
        Explode(HitLocation, HitNormal);        
    }
    else
    {
        // End:0x1A7
        if(LastHit != Other)
        {
            // End:0xB1
            if(SpawnLight)
            {
                MyDamageType = MyDamageTypeWithLight;                
            }
            else
            {
                MyDamageType = default.MyDamageType;
            }
            // End:0x137
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

simulated event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    // End:0x80
    if(((EvilPawn(Wall) == none) && EvilDestructibleObject(Wall) == none) && EvilDynamicDestructibleObject(Wall) == none)
    {
        bSuppressExplosionFX = false;
        super.HitWall(HitNormal, Wall, WallComp);        
    }
    else
    {
        // End:0x1B0
        if(LastHit != Wall)
        {
            // End:0xBA
            if(SpawnLight)
            {
                MyDamageType = MyDamageTypeWithLight;                
            }
            else
            {
                MyDamageType = default.MyDamageType;
            }
            // End:0x140
            if(EvilWeap_Base(Instigator.Weapon) != none)
            {
                EvilWeap_Base(Instigator.Weapon).CheckAndUpdateHitEnemyIndicator(Wall);
            }
            Wall.TakeDamage(int(Damage), InstigatorController, Location, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
            LastHit = Wall;
        }
    }
    //return;    
}

simulated function Explode(Vector HitLocation, Vector HitNormal)
{
    local PKBurningLightActor BurningLight;

    super.Explode(HitLocation, HitNormal);
    // End:0x7E
    if(SpawnLight)
    {
        BurningLight = Spawn(Class'PKBurningLightActor');
        BurningLight.SetLocation(HitLocation + (HitNormal * float(100)));
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
    // Reference: CylinderComponent'Default__PKProjectile_Flamer_Base.CollisionCylinder'
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