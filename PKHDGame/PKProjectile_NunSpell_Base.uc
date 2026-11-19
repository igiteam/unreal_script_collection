class PKProjectile_NunSpell_Base extends EvilProjectile_Base
    abstract
    hidecategories(Navigation);

var SoundCue HitPlayerSound;

function Init(Vector Direction)
{
    super.Init(Direction);
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
    local PKPawn PKOtherPawn;

    super.ProcessTouch(Other, HitLocation, HitNormal);
    PKOtherPawn = PKPawn(Other);
    // End:0xD1
    if(NotEqual_InterfaceInterface(EvilPlayer_interface(PKOtherPawn), EvilPlayer_interface(none)))
    {
        PKOtherPawn.PlaySound(HitPlayerSound);
        PKPlayerPawn(PKOtherPawn).PlayClientHitEffects(Damage, MyDamageType);
    }
    PKOtherPawn.DisableWeapons(5.0000000);
    //return;    
}

defaultproperties
{
    TimeToExplode=30.0000000
    CheckRadius=50.0000000
    BaseTrackingStrength=0.0500000
    CustomGravityScaling=0.0000000
    Speed=500.0000000
    MaxSpeed=600.0000000
    DamageRadius=400.0000000
    MyDamageType=Class'PKDmgType_NunSpell'
    // Reference: CylinderComponent'Default__PKProjectile_NunSpell_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'EvilGame.Default__EvilProjectile_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=20.0000000
        CollisionRadius=20.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Physics=EPhysics.PHYS_Falling
    bNetTemporary=false
    CollisionComponent=CollisionCylinder
}