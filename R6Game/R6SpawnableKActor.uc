class R6SpawnableKActor extends KActor
    native
    placeable
    hidecategories(lighting);

defaultproperties
{
    // Reference: StaticMeshComponent'Default__R6SpawnableKActor.StaticMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__KActor.StaticMeshComponent0'
    begin object name="StaticMeshComponent0"
        CastShadow=false
        bCastDynamicShadow=false
    end object
    StaticMeshComponent=StaticMeshComponent0
    bNoDelete=false
    bAlwaysRelevant=true
    Components[0]=StaticMeshComponent0
    RemoteRole=0
    m_supportedExplosionEffects[0]=m_iLastTimeCacheUpdate_5313
    m_supportedExplosionEffects[1]=None_319
    m_supportedExplosionEffects[2]=None_255
    CollisionComponent=StaticMeshComponent0
}