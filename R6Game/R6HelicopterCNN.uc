class R6HelicopterCNN extends R6HelicopterBase
    native
    placeable
    hidecategories(lighting);

var export editinline StaticMeshComponent m_ChopperStaticMesh;

defaultproperties
{
    // Reference: StaticMeshComponent'Default__R6HelicopterCNN.ChopperStaticMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ChopperStaticMesh" class=Class'Engine.StaticMeshComponent'
    end object
    m_ChopperStaticMesh=ChopperStaticMesh
    m_ChopperMesh=ChopperStaticMesh
    Components[0]=ChopperStaticMesh
    CollisionComponent=ChopperStaticMesh
}