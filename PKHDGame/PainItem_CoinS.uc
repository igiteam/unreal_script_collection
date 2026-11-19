class PainItem_CoinS extends PainItem_CoinG;

defaultproperties
{
    Value=1
    // Reference: CylinderComponent'Default__PainItem_CoinS.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PainItem_CoinG.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: StaticMeshComponent'Default__PainItem_CoinS.StaticMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'StaticMeshComponent0'
    // Archetype: StaticMeshComponent'Default__PainItem_CoinG.StaticMeshComponent0'
    begin object name="StaticMeshComponent0"
        StaticMesh=StaticMesh'en_ObjectsTreasures_01.Meshes.sm_en_all_TreasureCoin_02_01'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PainItem_CoinS.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__PainItem_CoinS.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainItem_CoinG.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    Components[2]=CollisionCylinder
    // Reference: LensFlareComponent'Default__PainItem_CoinS.Flare0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'Flare0'
    // Archetype: LensFlareComponent'Default__PainItem_CoinG.Flare0'
    begin object name="Flare0"
        Template=LensFlare'lf_all_Flares.LensFlares.lf_CoinSilver'
        NextTraceTime=-0.1070895
        ReplacementPrimitive=none
    end object
    Components[3]=Flare0
    CollisionComponent=StaticMeshComponent0
}