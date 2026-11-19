class R6BreakableActorSpawnable extends R6BreakableActor
    native
    notplaceable
    hidecategories(Material);

var float m_fCountdownBeforeTearoff;

defaultproperties
{
    m_fCountdownBeforeTearoff=5.0000000
    bNoDelete=false
}