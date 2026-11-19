class PainEndOfGame extends PainItemBaseSkelMesh
    placeable
    hidecategories(Navigation)
    classgroup(PK_Gameplay);

function Pickup(PKPlayerPawn P, PainPRI PRI)
{
    super(PainItemBase).Pickup(P, PRI);
    //return;    
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__PainEndOfGame.ItemMeshSkelComp0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ItemMeshSkelComp0'
    // Archetype: SkeletalMeshComponent'Default__PainItemBaseSkelMesh.ItemMeshSkelComp0'
    begin object name="ItemMeshSkelComp0"
        SkeletalMesh=SkeletalMesh'ps_all_Levels.Mesh.sk_EndOfLevel_01'
        // Reference: AnimNodeSequence'Default__PainEndOfGame.ItemMeshSkelComp0.AnimNodeSeq0'
        // Archetype: AnimNodeSequence'Default__PainItemBaseSkelMesh.AnimNodeSeq0'
        begin object name="AnimNodeSeq0"
        end object
        Animations=AnimNodeSeq0
        AnimSets[0]=AnimSet'ps_all_Levels.Anim.as_EndOfLevel_01'
        ReplacementPrimitive=none
        CastShadow=false
        bCastDynamicShadow=false
        bAcceptsLights=false
        bAcceptsDynamicLights=false
        Scale=4.2500000
    end object
    ItemMeshSkel=ItemMeshSkelComp0
    AnimationName="sk_EndOfLevel_01"
    BindParticles[0]=(Particle=ParticleSystem'ps_all_Levels.Effects.ps_all_endOfgamecircle',ParticleScale=1.7000000,BoneName="circle_small_end")
    BindParticles[1]=(Particle=ParticleSystem'ps_all_Levels.Effects.ps_all_endOfgamecircle',ParticleScale=1.7000000,BoneName="circle_big_end")
    BindParticles[2]=(Particle=ParticleSystem'ps_all_Levels.Effects.ps_all_endOfGamepentagram',ParticleScale=1.7000000,BoneName="Pentagammadion")
    BindParticles[3]=(Particle=ParticleSystem'ps_all_Levels.Effects.ps_all_endOfGameAura',ParticleScale=2.0000000,BoneName="Root")
    // Reference: CylinderComponent'Default__PainEndOfGame.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PainItemBaseSkelMesh.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=30.0000000
        CollisionRadius=30.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    PickupSound=SoundCue'a_Quad.Cue.item-quad-take'
    // Reference: DynamicLightEnvironmentComponent'Default__PainEndOfGame.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainItemBaseSkelMesh.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    bWaitForEffects=true
    BindedLightArchetype=EvilLightActor'ps_all_Levels.Archetypes.ar_EndOfGameLight'
    Components[0]=CollisionCylinder
    Components[1]=MyLightEnvironment
    Components[2]=ItemMeshSkelComp0
    Components[3]=none
    CollisionComponent=CollisionCylinder
}