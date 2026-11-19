class PainItem_RingR extends PainItem_RingB;

defaultproperties
{
    // Reference: CylinderComponent'Default__PainItem_RingR.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PainItem_RingB.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: StaticMeshComponent'Default__PainItem_RingR.StaticMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'StaticMeshComponent0'
    // Archetype: StaticMeshComponent'Default__PainItem_RingB.StaticMeshComponent0'
    begin object name="StaticMeshComponent0"
        StaticMesh=StaticMesh'en_ObjectsTreasures_01.Meshes.sm_en_all_TreasureRing_01_01'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PainItem_RingR.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__PainItem_RingR.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainItem_RingB.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    Components[2]=CollisionCylinder
    CollisionComponent=StaticMeshComponent0
}