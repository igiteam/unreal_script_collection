class MergedStaticMeshActor extends StaticMeshActor
    native
    notplaceable
    hidecategories(lighting);

struct MSMA_BackupData
{
    var Vector m_Location;
    var Rotator m_Rotation;
    var float m_DrawScale;
    var Vector m_DrawScale3D;
    var StaticMesh m_StaticMesh;

    structdefaultproperties
    {
        m_Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_Rotation=(Pitch=0,Yaw=0,Roll=0)
        m_DrawScale=0.0000000
        m_DrawScale3D=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_StaticMesh=none
    }
};

var array<MSMA_BackupData> m_BackupActorsProperties;
