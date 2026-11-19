class R6CoverTable extends R6SpawnableKActor
    native
    hidecategories(lighting);

var RB_HingeActor m_Hinge;
var bool m_bInUse;
var R6_BreakableActorTemplate m_pTemplate;

// Export UR6CoverTable::execCreateHinge(FFrame&, void* const)
native final function CreateHinge(Vector vFrom);

event Bump(Actor other, PrimitiveComponent pComponent, Vector vBumpNormal)
{
    local R6Pawn pR6Pawn;

    pR6Pawn = R6Pawn(other);
    // End:0x43
    if(pR6Pawn != none)
    {
        // End:0x43
        if(pR6Pawn.m_pAI == none)
        {
            CreateHinge(pR6Pawn.Location);
        }
    }
    Bump(other, pComponent, vBumpNormal);
    return;
}

defaultproperties
{
    RemoteRole=1
}