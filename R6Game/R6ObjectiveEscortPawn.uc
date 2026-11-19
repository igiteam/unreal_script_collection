class R6ObjectiveEscortPawn extends R6ObjectiveBasicMP
    native
    hidecategories(lighting,Movement,Collision);

var Pawn m_pPawnToExtract;

function SetPawnToExtract(R6Pawn pPawn)
{
    m_pPawnToExtract = pPawn;
    return;
}

function PawnDied(Pawn pPawn, Controller Killer)
{
    PawnDied(pPawn, Killer);
    // End:0x22
    if(pPawn != m_pPawnToExtract)
    {
        return;
    }
    SetFailure();
    return;
}

function ZoneEntered(R6ExtractionZone PZone, R6Pawn pPawn)
{
    ZoneEntered(PZone, pPawn);
    // End:0x22
    if(pPawn != m_pPawnToExtract)
    {
        return;
    }
    SetSuccess();
    return;
}

function ResetOriginalData()
{
    ResetOriginalData();
    SetPawnToExtract(none);
    return;
}

defaultproperties
{
    m_szTeamDescription[0]="PROTECT AND ESCORT THE V.I.P. TO THE EXTRACTION POINT."
    m_szTeamDescription[1]="LOCATE AND ELIMINATE YOUR TARGET BEFORE HE IS EXTRACTED."
    m_szMsgSuccess="MISSION SUCCESSFUL"
    m_szMsgFailure="MISSION FAILED"
    m_bGameOverIfFailed=true
    MessageClass=Class'R6HostageRescueGameMessage'
}