class PainItem_EnergyRed extends PainItem_Energy
    placeable
    hidecategories(Navigation)
    classgroup(PK_Health);

defaultproperties
{
    HealthToAdd=6
    // Reference: SkeletalMeshComponent'Default__PainItem_EnergyRed.ItemMeshSkelComp0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ItemMeshSkelComp0'
    // Archetype: SkeletalMeshComponent'Default__PainItem_Energy.ItemMeshSkelComp0'
    begin object name="ItemMeshSkelComp0"
        // Reference: AnimNodeSequence'Default__PainItem_EnergyRed.ItemMeshSkelComp0.AnimNodeSeq0'
        // Archetype: AnimNodeSequence'Default__PainItem_Energy.ItemMeshSkelComp0.AnimNodeSeq0'
        begin object name="AnimNodeSeq0"
        end object
        Animations=AnimNodeSeq0
        ReplacementPrimitive=none
    end object
    ItemMeshSkel=ItemMeshSkelComp0
    BindParticles[0]=(Particle=ParticleSystem'ps_all_Levels.Effects.ps_all_soulRedSat',ParticleScale=1.5000000,BoneName="joint3")
    BindParticles[1]=(Particle=ParticleSystem'ps_all_Levels.Effects.ps_all_soulRedSat',ParticleScale=1.5000000,BoneName="joint5")
    BindParticles[2]=(Particle=ParticleSystem'ps_all_Levels.Effects.ps_all_soulRedSat',ParticleScale=1.5000000,BoneName="joint8")
    BindParticles[3]=(Particle=ParticleSystem'ps_all_Levels.Effects.ps_all_soulRedSat',ParticleScale=1.5000000,BoneName="joint10")
    BindParticles[4]=(Particle=none,ParticleScale=0.0000000,BoneName="None")
    BindParticles[5]=(Particle=ParticleSystem'ps_all_Levels.Effects.ps_all_redAura',ParticleScale=1.5000000,BoneName="Root666")
    // Reference: CylinderComponent'Default__PainItem_EnergyRed.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PainItem_Energy.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    PickupSound=SoundCue'a_HealthPickables.Cue.item-soul-red'
    // Reference: DynamicLightEnvironmentComponent'Default__PainItem_EnergyRed.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainItem_Energy.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    BindedLightArchetype=EvilLightActor'ps_all_Levels.Archetypes.ar_soulRedLight'
    Components[0]=CollisionCylinder
    Components[1]=MyLightEnvironment
    Components[2]=ItemMeshSkelComp0
    Components[3]=none
    CollisionComponent=CollisionCylinder
}