class R6SBActorCable extends R6SBActor
    native
    notplaceable
    hidecategories(lighting,Object);

var Actor m_Links[2];
var transient Vector m_vBulletHitImpulseReplicated;
var transient int m_iBulletHitVertexReplicated[2];
var transient byte m_iBulletHitId;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_iBulletHitId, m_iBulletHitVertexReplicated, 
        m_vBulletHitImpulseReplicated;
}

event ReplicateBulletHit(Vector vLocalImpulse, int Hit0, int Hit1)
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
    m_iBulletHitId++;
    return;
}

// Export UR6SBActorCable::execSetLinks(FFrame&, void* const)
native final function SetLinks(Actor pLinkA, Actor pLinkB);

defaultproperties
{
    // Reference: R6SBComponentCable'Default__R6SBActorCable.R6SBComponentCable0'
    begin object name="R6SBComponentCable0" class=Class'R6SBComponentCable'
    end object
    m_SoftBody=R6SBComponentCable0
    bNoDelete=true
    Components[0]=R6SBComponentCable0
    RemoteRole=1
    CollisionComponent=R6SBComponentCable0
}