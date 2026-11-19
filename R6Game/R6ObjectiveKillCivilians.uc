class R6ObjectiveKillCivilians extends R6ObjectiveBasic
    native
    config(Game)
    hidecategories(lighting,Movement,Collision);

var config int m_iMaxCivilsKilledForGameOver;

function PawnDied(Pawn deadPawn, Controller Killer)
{
    local R6CivilPawn pCivil;
    local int iKills;

    pCivil = R6CivilPawn(deadPawn);
    // End:0x69
    if(((pCivil != none) && Killer != none) && Killer.bIsPlayer)
    {
        iKills = GetGameManager().IncrementCivKills();
        // End:0x69
        if(iKills >= m_iMaxCivilsKilledForGameOver)
        {
            SetFailure();
        }
    }
    return;
}

defaultproperties
{
    m_iMaxCivilsKilledForGameOver=3
    m_sFailureDescId="CivilianKilled"
    m_bHiddenInManager=true
    m_bGameOverIfFailed=true
    bNoDelete=false
}