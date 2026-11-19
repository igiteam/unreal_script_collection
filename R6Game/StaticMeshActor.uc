class StaticMeshActor extends Actor
    native
    placeable
    hidecategories(lighting);

enum ELODType
{
    LOD_Default,                    // 0
    LOD_HighDetail,                 // 1
    LOD_MAX                         // 2
};

enum ERigidBodyCollision
{
    ERBC_Standard,                  // 0
    ERBC_UseVisualMeshTriangles,    // 1
    ERBC_UseSimplifiedCollisionTriangles,// 2
    ERBC_MAX                        // 3
};

var(Display) const editconst export editinline StaticMeshComponent StaticMeshComponent;
var() bool bExactProjectileCollision;
var() Actor.EAttractorType m_eAttractorType;
var() StaticMeshActor.ELODType LODType;
var() StaticMeshActor.ERigidBodyCollision m_eRigidBodyCollision;

event PreBeginPlay()
{
    return;
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__StaticMeshActor.StaticMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="StaticMeshComponent0" class=Class'StaticMeshComponent'
        bAllowApproximateOcclusion=true
    end object
    StaticMeshComponent=StaticMeshComponent0
    bExactProjectileCollision=true
    bStatic=true
    bWorldGeometry=true
    bGameRelevant=true
    bCollideActors=true
    bBlockActors=true
    bEdShouldSnap=true
    m_bSnakeCamRelevant=true
    Components[0]=StaticMeshComponent0
    CollisionComponent=StaticMeshComponent0
}