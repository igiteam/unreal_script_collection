class PKPentagram extends PainItemBaseSkelMesh
    placeable
    hidecategories(Navigation)
    classgroup(PK_Gameplay);

function bool CanPickUp(PKPlayerPawn P, PainPRI PRI)
{
    // End:0x8F
    if((PKPlayerController_MP(P.Controller) == none) || PainPRI(PKPlayerController_MP(P.Controller).PlayerReplicationInfo).bPentagram)
    {
        return false;
    }
    return super(PainItemBase).CanPickUp(P, PRI);
    //return ReturnValue;    
}

function Pickup(PKPlayerPawn P, PainPRI PRI)
{
    super(PainItemBase).Pickup(P, PRI);
    PKPlayerController_MP(P.Controller).EnablePentagram();
    //return;    
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__PKPentagram.ItemMeshSkelComp0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ItemMeshSkelComp0'
    // Archetype: SkeletalMeshComponent'Default__PainItemBaseSkelMesh.ItemMeshSkelComp0'
    begin object name="ItemMeshSkelComp0"
        SkeletalMesh=SkeletalMesh'pi_Pentagram_01.Mesh.sk_pi_Pentagram_01'
        // Reference: AnimNodeSequence'Default__PKPentagram.ItemMeshSkelComp0.AnimNodeSeq0'
        // Archetype: AnimNodeSequence'Default__PainItemBaseSkelMesh.AnimNodeSeq0'
        begin object name="AnimNodeSeq0"
        end object
        Animations=AnimNodeSeq0
        AnimSets[0]=AnimSet'pi_Pentagram_01.Anim.as_pi_Pentagram_01'
        ReplacementPrimitive=none
        CastShadow=false
        bCastDynamicShadow=false
        bAcceptsLights=false
        bAcceptsDynamicLights=false
        Scale=2.0000000
    end object
    ItemMeshSkel=ItemMeshSkelComp0
    AnimationName="e_soul_01"
    BindParticles[0]=(Particle=ParticleSystem'ps_wp_Pickup.Effects.ps_PentagramPickup',ParticleScale=1.0000000,BoneName="Root")
    // Reference: CylinderComponent'Default__PKPentagram.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PainItemBaseSkelMesh.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=40.0000000
        CollisionRadius=40.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    PickupSound1p=SoundCue'a_Quad.Cue.item-quad-take'
    PickupSound=SoundCue'a_Quad.Cue.item-quad-take-mono'
    MaxPickCount=0
    // Reference: DynamicLightEnvironmentComponent'Default__PKPentagram.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainItemBaseSkelMesh.MyLightEnvironment'
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