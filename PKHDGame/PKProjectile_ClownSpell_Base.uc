class PKProjectile_ClownSpell_Base extends EvilProjectile_Base
    abstract
    hidecategories(Navigation);

var class<PKProjectile_ClownSpell_Base> SpellMini;
var int SpellMiniCount;
var Vector SavedHitNormal;
var PKProjectile_ClownSpell_Base SpawnedProjectile;
var Vector Z;
var Vector Dir;
var Rotator Rot;
var int I;

function Init(Vector Direction)
{
    super.Init(Direction);
    TimeToExplode = TimeToExplode * RandRange(0.8000000, 1.2000000);
    SetTimer(0.1000000, false, 'DisableTracking');
    //return;    
}

function DisableTracking()
{
    BaseTrackingStrength = 0.0000000;
    //return;    
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    // End:0x6A
    if(SpellMini != none)
    {
        // End:0x42
        if(!IsInState('SpawningSpellMini'))
        {
            SavedHitNormal = HitNormal;
            GotoState('SpawningSpellMini');
        }
        super.ProcessTouch(Other, HitLocation, HitNormal);        
    }
    else
    {
        // End:0xB6
        if(VSizeSq(Velocity) > float(16))
        {
            Velocity = (HitNormal * VSize(Velocity)) * 1.0000000;
            SetRotation(Rotator(HitNormal));            
        }
        else
        {
            super.ProcessTouch(Other, HitLocation, HitNormal);
        }
    }
    //return;    
}

singular simulated event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    ProcessTouch(Wall, Location, HitNormal);
    super(Actor).HitWall(HitNormal, Wall, WallComp);
    //return;    
}

state SpawningSpellMini
{Begin:

    Z = GetRotatorAxis(Rotator(SavedHitNormal), 2);
    I = 0;
    J0x2C:

    // End:0x1D3 [Loop If]
    if(I < SpellMiniCount)
    {
        Rot = QuatToRotator(QuatFromAxisAndAngle(Z, (-0.5000000 * 3.1415930) + (3.1415930 * (float(I) / float(SpellMiniCount))))) + Rotator(SavedHitNormal);
        Dir = Normal(Vector(Rot));
        SpawnedProjectile = Spawn(SpellMini, Owner,, Location + (Dir * 10.0000000));
        // End:0x1AE
        if((SpawnedProjectile != none) && !SpawnedProjectile.bDeleteMe)
        {
            SpawnedProjectile.Damage = Damage;
            SpawnedProjectile.MomentumTransfer = MomentumTransfer;
            SpawnedProjectile.Init(Dir);
        }
        Sleep(RandRange(0.0400000, 0.0600000));
        I++;
        // [Loop Continue]
        goto J0x2C;
    }
    stop;                    
}

defaultproperties
{
    TimeToExplode=30.0000000
    CheckRadius=10.0000000
    BaseTrackingStrength=0.0500000
    CustomGravityScaling=0.0000000
    Speed=500.0000000
    MaxSpeed=600.0000000
    DamageRadius=400.0000000
    MyDamageType=Class'PKDmgType_ClownSpell'
    // Reference: CylinderComponent'Default__PKProjectile_ClownSpell_Base.CollisionCylinder'
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