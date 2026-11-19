class R6ObjectivePlayerStayAlive extends R6ObjectiveBasic
    hidecategories(lighting,Movement,Collision);

function PawnDied(Pawn deadPawn, Controller Killer)
{
    // End:0x3D
    if(((deadPawn != none) && !deadPawn.m_bIsNPCPawn) && deadPawn.IsARainbow())
    {
        SetFailure();
    }
    return;
}

event float GetFailureWaitTime()
{
    return GetCameraConfig().m_fDeadCamDuration;
    return;
}

defaultproperties
{
    m_sFailureDescId="PlayerKilled"
    m_bHiddenInManager=true
    m_bGameOverIfFailed=true
    bNoDelete=false
}