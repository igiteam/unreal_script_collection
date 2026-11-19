class R6SBActorStripDoor extends R6SBActor
    native
    placeable
    hidecategories(lighting,Object);

var transient Vector m_vBulletHitImpulseReplicated;
var transient int m_iBulletHitVertexReplicated[4];
var transient byte m_iBulletHitId;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_iBulletHitId, m_iBulletHitVertexReplicated, 
        m_vBulletHitImpulseReplicated;
}

event ReplicateBulletHit(Vector vLocalImpulse, int Hit0, int Hit1, int Hit2, int Hit3)
{
    m_vBulletHitImpulseReplicated = vLocalImpulse;
    // End:0x27
    if(Hit0 != -1)
    {
        m_iBulletHitVertexReplicated[0] = Hit0;
    }
    // End:0x43
    if(Hit1 != -1)
    {
        m_iBulletHitVertexReplicated[1] = Hit1;
    }
    // End:0x60
    if(Hit2 != -1)
    {
        m_iBulletHitVertexReplicated[2] = Hit2;
    }
    // End:0x7D
    if(Hit3 != -1)
    {
        m_iBulletHitVertexReplicated[3] = Hit3;
    }
    m_iBulletHitId++;
    return;
}

defaultproperties
{
    // Reference: R6SBComponentStripDoor'Default__R6SBActorStripDoor.R6SBComponentStripDoor0'
    begin object name="R6SBComponentStripDoor0" class=Class'R6SBComponentStripDoor'
    end object
    m_SoftBody=R6SBComponentStripDoor0
    bNoDelete=true
    // Reference: SpriteComponent'Default__R6SBActorStripDoor.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__R6SBActor.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    Components[1]=R6SBComponentStripDoor0
    RemoteRole=1
    CollisionComponent=R6SBComponentStripDoor0
}