class PainItem_RingB extends PainItem_Treasure_Base;

simulated function PostBeginPlay()
{
    super(PainItemKActorBase).PostBeginPlay();
    // End:0x5C
    if(int(WorldInfo.NetMode) < int(NM_Client))
    {
        LifeSpan = default.LifeSpan * RandRange(0.8000000, 1.1000000);
    }
    //return;    
}

defaultproperties
{
    Value=20
    bIsBonusItem=true
    // Reference: CylinderComponent'Default__PainItem_RingB.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PainItem_Treasure_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    PickupSound1p=SoundCue'a_Treasures.Cue.item-jewelry-rings'
    PickupSound=SoundCue'a_Treasures.Cue.item-jewelry-rings'
    bWakeOnLevelStart=true
    // Reference: StaticMeshComponent'Default__PainItem_RingB.StaticMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'StaticMeshComponent0'
    // Archetype: StaticMeshComponent'Default__PainItem_Treasure_Base.StaticMeshComponent0'
    begin object name="StaticMeshComponent0"
        StaticMesh=StaticMesh'en_ObjectsTreasures_01.Meshes.sm_en_all_TreasureRing_03_01'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PainItem_RingB.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__PainItem_RingB.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainItem_Treasure_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    Components[2]=CollisionCylinder
    LifeSpan=60.0000000
    CollisionComponent=StaticMeshComponent0
}