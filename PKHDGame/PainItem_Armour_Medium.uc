class PainItem_Armour_Medium extends PainItem_Armour_Base
    placeable
    hidecategories(Navigation)
    classgroup(PK_Health);

defaultproperties
{
    ArmorAdd=150
    RescueFactor=0.6000000
    RespawnTime=20
    // Reference: SkeletalMeshComponent'Default__PainItem_Armour_Medium.ItemMeshSkelComp0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ItemMeshSkelComp0'
    // Archetype: SkeletalMeshComponent'Default__PainItem_Armour_Base.ItemMeshSkelComp0'
    begin object name="ItemMeshSkelComp0"
        SkeletalMesh=SkeletalMesh'pi_Armors_01.Mesh.pi_Armor_01_01'
        // Reference: AnimNodeSequence'Default__PainItem_Armour_Medium.ItemMeshSkelComp0.AnimNodeSeq0'
        // Archetype: AnimNodeSequence'Default__PainItem_Armour_Base.ItemMeshSkelComp0.AnimNodeSeq0'
        begin object name="AnimNodeSeq0"
        end object
        Animations=AnimNodeSeq0
        Materials=/* Array type was not detected. */
        ReplacementPrimitive=none
    end object
    ItemMeshSkel=ItemMeshSkelComp0
    // Reference: CylinderComponent'Default__PainItem_Armour_Medium.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PainItem_Armour_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    PickupSound1p=SoundCue'a_ArmorPickables.Cue.item-shield-medium'
    PickupSound=SoundCue'a_ArmorPickables.Cue.item-shield-medium'
    // Reference: DynamicLightEnvironmentComponent'Default__PainItem_Armour_Medium.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainItem_Armour_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=CollisionCylinder
    Components[1]=MyLightEnvironment
    Components[2]=ItemMeshSkelComp0
    CollisionComponent=CollisionCylinder
}