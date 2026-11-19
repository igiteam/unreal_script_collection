class PainItem_CoinG extends PainItem_Treasure_Base;

defaultproperties
{
    Value=2
    // Reference: CylinderComponent'Default__PainItem_CoinG.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PainItem_Treasure_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    PickupSound1p=SoundCue'a_Treasures.Cue.item-coin-take'
    PickupSound=SoundCue'a_Treasures.Cue.item-coin-take'
    bWakeOnLevelStart=true
    // Reference: StaticMeshComponent'Default__PainItem_CoinG.StaticMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'StaticMeshComponent0'
    // Archetype: StaticMeshComponent'Default__PainItem_Treasure_Base.StaticMeshComponent0'
    begin object name="StaticMeshComponent0"
        StaticMesh=StaticMesh'en_ObjectsTreasures_01.Meshes.sm_en_all_TreasureCoin_01_01'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PainItem_CoinG.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__PainItem_CoinG.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainItem_Treasure_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    Components[2]=CollisionCylinder
    // Reference: LensFlareComponent'Default__PainItem_CoinG.Flare0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'Flare0'
    begin object name="Flare0" class=Class'Engine.LensFlareComponent'
        Template=LensFlare'lf_all_Flares.LensFlares.lf_Coin'
        NextTraceTime=-0.9568468
        ReplacementPrimitive=none
    end object
    Components[3]=Flare0
    LifeSpan=60.0000000
    CollisionComponent=StaticMeshComponent0
}