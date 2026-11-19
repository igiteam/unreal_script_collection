class DynamicSMActor extends Actor
    abstract
    native
    notplaceable
    hidecategories(lighting);

var(Display) const editconst export editinline StaticMeshComponent StaticMeshComponent;
var Vector m_vOriginalLocation;
var Rotator m_rOriginalRotation;
var() bool bExactProjectileCollision;

function OnSetStaticMesh(SeqAct_SetStaticMesh Action)
{
    // End:0x54
    if((Action.NewStaticMesh != none) && Action.NewStaticMesh != StaticMeshComponent.StaticMesh)
    {
        StaticMeshComponent.SetStaticMesh(Action.NewStaticMesh);
    }
    return;
}

function OnSetMaterial(SeqAct_SetMaterial Action)
{
    StaticMeshComponent.SetMaterial(Action.MaterialIndex, Action.NewMaterial);
    return;
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__DynamicSMActor.StaticMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="StaticMeshComponent0" class=Class'StaticMeshComponent'
    end object
    StaticMeshComponent=StaticMeshComponent0
    bExactProjectileCollision=true
    m_bIsDynamicObstacle=true
    UseCharacterLights=true
    bGameRelevant=true
    bCollideActors=true
    bBlockActors=true
    bEdShouldSnap=true
    bPathColliding=true
    Components[0]=StaticMeshComponent0
    RemoteRole=1
    m_supportedExplosionEffects=/* ERROR: System.ArgumentOutOfRangeException */
    CollisionComponent=StaticMeshComponent0
}