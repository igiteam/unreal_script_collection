class R6SBActorTripWire extends R6SBActorCable
    native
    notplaceable
    hidecategories(lighting,Object,Object);

event Bump(Actor other, PrimitiveComponent pComponent, Vector vBumpNormal)
{
    Bump(other, pComponent, vBumpNormal);
    // End:0x4D
    if((Owner != none) && other != Owner)
    {
        Owner.Bump(other, none, vBumpNormal);
    }
    return;
}

event ReplicateBulletHit(Vector vLocalImpulse, int Hit0, int Hit1)
{
    return;
}

defaultproperties
{
    // Reference: R6SBComponentCable'Default__R6SBActorTripWire.R6SBComponentCable0'
    // Archetype: R6SBComponentCable'Default__R6SBActorCable.R6SBComponentCable0'
    begin object name="R6SBComponentCable0"
    end object
    m_SoftBody=R6SBComponentCable0
    bNoDelete=false
    bMovable=true
    m_fHeat=1.0000000
    Components[0]=R6SBComponentCable0
    RemoteRole=0
    CollisionComponent=R6SBComponentCable0
}