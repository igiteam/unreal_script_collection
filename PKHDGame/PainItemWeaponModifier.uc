class PainItemWeaponModifier extends PainWeaponPickup_Base
    placeable
    hidecategories(Navigation);

var() float PowerUpDuration;
var SoundCue ActiveSound1p;
var SoundCue ActiveSound;
var SoundCue TimeoutSound1p;
var SoundCue TimeoutSound;

function bool CanPickUp(PKPlayerPawn P, PainPRI PRI)
{
    // End:0x0F
    if(bHidden)
    {
        return false;
    }
    return super.CanPickUp(P, PRI);
    //return ReturnValue;    
}

function Pickup(PKPlayerPawn P, PainPRI PRI)
{
    super.Pickup(P, PRI);
    PKPlayerController(P.Controller).EnableWeaponModifier(PowerUpDuration);
    //return;    
}

function SetRespawn()
{
    GotoState('Sleeping');
    //return;    
}

defaultproperties
{
    PowerUpDuration=30.0000000
    ActiveSound1p=SoundCue'a_WeaponModifier.Cue.item-wm-loop'
    ActiveSound=SoundCue'a_WeaponModifier.Cue.item-wm-loop-mono'
    TimeoutSound1p=SoundCue'a_WeaponModifier.Cue.item-wm-timeout'
    TimeoutSound=SoundCue'a_WeaponModifier.Cue.item-wm-timeout-mono'
    BobSpeed=0.5000000
    // Reference: SkeletalMeshComponent'Default__PainItemWeaponModifier.ItemMeshSkelComp0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ItemMeshSkelComp0'
    // Archetype: SkeletalMeshComponent'Default__PainWeaponPickup_Base.ItemMeshSkelComp0'
    begin object name="ItemMeshSkelComp0"
        SkeletalMesh=SkeletalMesh'pi_WeaponModifier_01.Mesh.sk_pi_WeaponModifier_01_001'
        // Reference: AnimNodeSequence'Default__PainItemWeaponModifier.ItemMeshSkelComp0.AnimNodeSeq0'
        // Archetype: AnimNodeSequence'Default__PainWeaponPickup_Base.ItemMeshSkelComp0.AnimNodeSeq0'
        begin object name="AnimNodeSeq0"
        end object
        Animations=AnimNodeSeq0
        AnimSets[0]=AnimSet'pi_WeaponModifier_01.Anim.as_pi_WeaponModifier_01_001'
        ReplacementPrimitive=none
        Scale=2.0000000
    end object
    ItemMeshSkel=ItemMeshSkelComp0
    AnimationName="sk_pi_WeaponModifier_01_001"
    BindParticles[0]=(Particle=ParticleSystem'ps_wp_Pickup.Effects.ps_WeaponModPickup',ParticleScale=1.0000000,BoneName="Root")
    BindParticles[1]=(Particle=ParticleSystem'ps_wp_Pickup.Effects.ps_WeaponModPickupPoint',ParticleScale=1.0000000,BoneName="joint667")
    BindParticles[2]=(Particle=ParticleSystem'ps_wp_Pickup.Effects.ps_WeaponModPickupPoint',ParticleScale=1.0000000,BoneName="joint668")
    BindParticles[3]=(Particle=ParticleSystem'ps_wp_Pickup.Effects.ps_WeaponModPickupPoint',ParticleScale=1.0000000,BoneName="joint669")
    BindParticles[4]=(Particle=ParticleSystem'ps_wp_Pickup.Effects.ps_WeaponModPickupPoint',ParticleScale=1.0000000,BoneName="joint671")
    BindParticles[5]=(Particle=ParticleSystem'ps_wp_Pickup.Effects.ps_WeaponModPickupPoint',ParticleScale=1.0000000,BoneName="joint672")
    BindParticles[6]=(Particle=ParticleSystem'ps_wp_Pickup.Effects.ps_WeaponModPickupPoint',ParticleScale=1.0000000,BoneName="joint673")
    // Reference: CylinderComponent'Default__PainItemWeaponModifier.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PainWeaponPickup_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    PickupSound1p=SoundCue'a_WeaponModifier.Cue.item-wm-take'
    PickupSound=SoundCue'a_WeaponModifier.Cue.item-wm-take-mono'
    // Reference: DynamicLightEnvironmentComponent'Default__PainItemWeaponModifier.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainWeaponPickup_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    bIsPowerUpMP=true
    Components[0]=CollisionCylinder
    Components[1]=MyLightEnvironment
    Components[2]=ItemMeshSkelComp0
    CollisionComponent=CollisionCylinder
}