class R6ObjectiveKeepAlive extends R6ObjectiveBasic
    native
    hidecategories(lighting,Movement,Collision);

var array<R6Pawn> m_pawnsToKeepAlive;

function PawnDied(Pawn deadPawn, Controller Killer)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x3F [Loop If]
    if(I < m_pawnsToKeepAlive.Length)
    {
        // End:0x35
        if(m_pawnsToKeepAlive[I] == deadPawn)
        {
            SetFailure();
            return;
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

defaultproperties
{
    bNoDelete=false
}