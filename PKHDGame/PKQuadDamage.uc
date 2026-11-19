class PKQuadDamage extends PainWeaponPickup_Base
    placeable
    hidecategories(Navigation)
    classgroup(PK_Gameplay);

var SoundCue ActiveSound1p;
var SoundCue ActiveSound;
var SoundCue TimeoutSound1p;
var SoundCue TimeoutSound;
var array<Controller> quadCollectors;

function bool CanPickUp(PKPlayerPawn P, PainPRI PRI)
{
    // End:0x8F
    if((PKPlayerController_MP(P.Controller) == none) || PainPRI(PKPlayerController_MP(P.Controller).PlayerReplicationInfo).bQuadDamage)
    {
        return false;
    }
    return super.CanPickUp(P, PRI);
    //return ReturnValue;    
}

function Pickup(PKPlayerPawn P, PainPRI PRI)
{
    super(PainItemBase).Pickup(P, PRI);
    PKPlayerController_MP(P.Controller).EnableQuadDamage();
    // End:0xB5
    if(quadCollectors.Find(P.Controller) < 0)
    {
        quadCollectors.AddItem(P.Controller);
    }
    //return;    
}

function SetRespawn()
{
    GotoState('Sleeping');
    //return;    
}

defaultproperties
{
    ActiveSound1p=SoundCue'a_Quad.Cue.item-quad-loop'
    ActiveSound=SoundCue'a_Quad.Cue.item-quad-loop-mono'
    TimeoutSound1p=SoundCue'a_Quad.Cue.item-quad-timeout'
    TimeoutSound=SoundCue'a_Quad.Cue.item-quad-timeout-mono'
    // Reference: SkeletalMeshComponent'Default__PKQuadDamage.ItemMeshSkelComp0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ItemMeshSkelComp0'
    // Archetype: SkeletalMeshComponent'Default__PainWeaponPickup_Base.ItemMeshSkelComp0'
    begin object name="ItemMeshSkelComp0"
        SkeletalMesh=SkeletalMesh'pi_Quad_01.Mesh.sk_pi_Quad_01'
        // Reference: AnimNodeSequence'Default__PKQuadDamage.ItemMeshSkelComp0.AnimNodeSeq0'
        // Archetype: AnimNodeSequence'Default__PainWeaponPickup_Base.ItemMeshSkelComp0.AnimNodeSeq0'
        begin object name="AnimNodeSeq0"
        end object
        Animations=AnimNodeSeq0
        AnimSets[0]=AnimSet'pi_Quad_01.Anim.as_pi_Quad_01'
        ReplacementPrimitive=none
        CastShadow=false
        bCastDynamicShadow=false
        bAcceptsLights=false
        bAcceptsDynamicLights=false
        Scale=2.0000000
    end object
    ItemMeshSkel=ItemMeshSkelComp0
    AnimationName="sk_pi_Quad_01"
    BindParticles[0]=(Particle=ParticleSystem'ps_wp_Pickup.Effects.ps_QuadPickup',ParticleScale=1.0000000,BoneName="Root")
    BindParticles[1]=(Particle=ParticleSystem'ps_wp_Pickup.Effects.ps_QuadPickupHorn',ParticleScale=1.0000000,BoneName="joint667")
    // Reference: CylinderComponent'Default__PKQuadDamage.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PainWeaponPickup_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=40.0000000
        CollisionRadius=40.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    PickupSound1p=SoundCue'a_Quad.Cue.item-quad-take'
    PickupSound=SoundCue'a_Quad.Cue.item-quad-take-mono'
    MaxPickCount=0
    // Reference: DynamicLightEnvironmentComponent'Default__PKQuadDamage.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainWeaponPickup_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    bWaitForEffects=true
    bIsPowerUpMP=true
    RespawnItemTime=40.0000000
    Components[0]=CollisionCylinder
    Components[1]=MyLightEnvironment
    Components[2]=ItemMeshSkelComp0
    Components[3]=none
    CollisionComponent=CollisionCylinder
}