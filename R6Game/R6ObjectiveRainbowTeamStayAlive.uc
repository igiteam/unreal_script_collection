class R6ObjectiveRainbowTeamStayAlive extends R6ObjectiveBasic
    hidecategories(lighting,Movement,Collision);

var string m_DeadPawnName;

function PawnDied(Pawn deadPawn, Controller Killer)
{
    local R6RainbowPawn pR6Pawn;

    pR6Pawn = R6RainbowPawn(deadPawn);
    // End:0x61
    if(((pR6Pawn != none) && pR6Pawn.m_bIsNPCPawn) && pR6Pawn.IsARainbow())
    {
        m_DeadPawnName = pR6Pawn.GetRainbowName();
        SetFailure();
    }
    return;
}

event bool GetOptionalParamString(out string strParam)
{
    strParam = m_DeadPawnName;
    return true;
    return;
}

event float GetFailureWaitTime()
{
    return 2.0000000;
    return;
}

defaultproperties
{
    m_sFailureDescId="RainbowKilled"
    m_bHiddenInManager=true
    m_bGameOverIfFailed=true
    bNoDelete=false
}