class DefaultPhysicsVolume extends PhysicsVolume
    transient
    native
    notplaceable
    hidecategories(lighting,Object,Movement,Display);

function Destroyed()
{
    // DebugMode: 0
    assert(false);
    return;
}

defaultproperties
{
    bStatic=false
    bNoDelete=false
    TickGroup=1
}