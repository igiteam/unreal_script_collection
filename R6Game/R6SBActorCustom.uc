class R6SBActorCustom extends R6SBActor
    native
    placeable
    hidecategories(lighting,Object);

var transient Vector m_vBulletHitImpulseReplicated;
var transient int m_iBulletHitVertexReplicated;
var transient byte m_iBulletHitId;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_iBulletHitId, m_iBulletHitVertexReplicated, 
        m_vBulletHitImpulseReplicated;
}

event ReplicateBulletHit(Vector vLocalImpulse, int Hit0)
{
    m_vBulletHitImpulseReplicated = vLocalImpulse;
    // End:0x25
    if(Hit0 != -1)
    {
        m_iBulletHitVertexReplicated = Hit0;
    }
    m_iBulletHitId++;
    return;
}

defaultproperties
{
    // Reference: R6SBComponentCustom'Default__R6SBActorCustom.R6SBComponentCustom0'
    begin object name="R6SBComponentCustom0" class=Class'R6SBComponentCustom'
    end object
    m_SoftBody=R6SBComponentCustom0
    bNoDelete=true
    // Reference: SpriteComponent'Default__R6SBActorCustom.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__R6SBActor.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    Components[1]=R6SBComponentCustom0
    RemoteRole=1
    CollisionComponent=R6SBComponentCustom0
}