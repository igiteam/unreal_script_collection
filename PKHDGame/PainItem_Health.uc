class PainItem_Health extends PainItem_Health_Base
    placeable
    hidecategories(Navigation)
    classgroup(PK_Health);

function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x71
    if(PainGRI(WorldInfo.GRI).IsCoopMultiplayerGame())
    {
        MaxPickCount = 2;
        LastPickerClearDelay = 0.0000000;
        bHidePickupFromLastPicker = true;
    }
    //return;    
}

defaultproperties
{
    HealthToAdd=25
    MaxHealthLimit=100
    // Reference: SkeletalMeshComponent'Default__PainItem_Health.ItemMeshSkelComp0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ItemMeshSkelComp0'
    // Archetype: SkeletalMeshComponent'Default__PainItem_Health_Base.ItemMeshSkelComp0'
    begin object name="ItemMeshSkelComp0"
        // Reference: AnimNodeSequence'Default__PainItem_Health.ItemMeshSkelComp0.AnimNodeSeq0'
        // Archetype: AnimNodeSequence'Default__PainItem_Health_Base.ItemMeshSkelComp0.AnimNodeSeq0'
        begin object name="AnimNodeSeq0"
        end object
        Animations=AnimNodeSeq0
        ReplacementPrimitive=none
        Scale=2.5000000
    end object
    ItemMeshSkel=ItemMeshSkelComp0
    BindParticles[0]=(Particle=ParticleSystem'ps_all_Levels.Effects.ps_all_health',ParticleScale=1.5000000,BoneName="joint3")
    BindParticles[1]=(Particle=ParticleSystem'ps_all_Levels.Effects.ps_all_health',ParticleScale=1.5000000,BoneName="joint5")
    BindParticles[2]=(Particle=ParticleSystem'ps_all_Levels.Effects.ps_all_health',ParticleScale=1.5000000,BoneName="joint8")
    BindParticles[3]=(Particle=ParticleSystem'ps_all_Levels.Effects.ps_all_health',ParticleScale=1.5000000,BoneName="joint10")
    BindParticles[4]=(Particle=ParticleSystem'ps_all_Levels.Effects.ps_all_healthAura',ParticleScale=1.5000000,BoneName="Root666")
    // Reference: CylinderComponent'Default__PainItem_Health.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PainItem_Health_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    PickupSound1p=SoundCue'a_HealthPickables.Cue.item-soul-gold'
    PickupSound=SoundCue'a_HealthPickables.Cue.item-soul-gold'
    // Reference: DynamicLightEnvironmentComponent'Default__PainItem_Health.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainItem_Health_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    BindedLightArchetype=EvilLightActor'ps_all_Levels.Archetypes.ar_healthLight'
    Components[0]=CollisionCylinder
    Components[1]=MyLightEnvironment
    Components[2]=ItemMeshSkelComp0
    Components[3]=none
    CollisionComponent=CollisionCylinder
}