class R6RadarBombRepInfo extends R6RadarReplicationInfo
    native
    notplaceable
    hidecategories(lighting);

var Controller m_pInstigator;

function Init(Actor pLinkedActor)
{
    local R6Pawn pPawn;

    pPawn = R6Pawn(pLinkedActor.Instigator);
    // End:0x3C
    if((pPawn == none) || pPawn.Controller == none)
    {
        return;
    }
    m_pInstigator = pPawn.Controller;
    m_pPlayerRepInfo = R6PlayerReplicationInfo(m_pInstigator.PlayerReplicationInfo);
    // End:0x76
    if(m_pPlayerRepInfo == none)
    {
        return;
    }
    m_pActor = pLinkedActor;
    return;
}

function UnInit()
{
    m_pInstigator = none;
    m_pActor = none;
    m_pPlayerRepInfo = none;
    return;
}
