class R6ObjectiveTerroristHunt extends R6ObjectiveBasic
    native
    hidecategories(lighting,Movement,Collision);

var int m_iMaxTerrorists;
var int m_iTerroristsEliminated;
var R6EngineEnums.EGameHostileDensity m_eTerroDensity;

function MatchStarting()
{
    ResetTerrorists(false);
    return;
}

function ResetTerrorists(bool initTerroSpawns)
{
    local int iTerroHuntPointCount;
    local R6TerroHuntPoint aTHP;
    local array<R6TerroHuntPoint> arrTerroHuntPoints;

    // End:0xFA
    if(initTerroSpawns)
    {
        // End:0x33
        foreach DynamicActors(Class'R6TerroHuntPoint', aTHP)
        {
            ++iTerroHuntPointCount;
            arrTerroHuntPoints[arrTerroHuntPoints.Length] = aTHP;            
        }        
        switch(m_eTerroDensity)
        {
            // End:0x62
            case 1:
                m_iMaxTerrorists = int(float(iTerroHuntPointCount) * WorldInfo.m_fTHDensityPercentageLow);
                // End:0xC1
                break;
            // End:0x89
            case 2:
                m_iMaxTerrorists = int(float(iTerroHuntPointCount) * WorldInfo.m_fTHDensityPercentageMedium);
                // End:0xC1
                break;
            // End:0xB0
            case 3:
                m_iMaxTerrorists = int(float(iTerroHuntPointCount) * WorldInfo.m_fTHDensityPercentageHigh);
                // End:0xC1
                break;
            // End:0xFFFF
            default:
                m_iMaxTerrorists = iTerroHuntPointCount;
                // End:0xC1
                break;
                break;
        }
        R6GameInfo(WorldInfo.Game).m_pAIInfo.m_pTerroHuntManager.ApplyTerroHuntPointDensity(arrTerroHuntPoints, m_iMaxTerrorists);
    }
    m_iTerroristsEliminated = 0;
    R6GameReplicationInfo(WorldInfo.GRI).m_iHostiles = GetRemainingTerrorists();
    return;
}

function ResetOriginalData()
{
    ResetOriginalData();
    ResetTerrorists(false);
    return;
}

function PawnDied(Pawn deadPawn, Controller Killer)
{
    // End:0x24
    if(deadPawn.IsA('R6TerroristPawn'))
    {
        TerroristDied(R6TerroristPawn(deadPawn));
    }
    return;
}

function TerroristDied(R6TerroristPawn pPawn)
{
    // End:0x0D
    if(pPawn == none)
    {
        return;
    }
    m_iTerroristsEliminated++;
    // End:0x47
    if(m_iTerroristsEliminated <= m_iMaxTerrorists)
    {
        R6GameReplicationInfo(WorldInfo.GRI).m_iHostiles = GetRemainingTerrorists();
    }
    // End:0x58
    if(AllTerroristsEliminated())
    {
        SetSuccess();
    }
    return;
}

function bool AllTerroristsEliminated()
{
    return m_iTerroristsEliminated >= m_iMaxTerrorists;
    return;
}

function int GetRemainingTerrorists()
{
    return m_iMaxTerrorists - m_iTerroristsEliminated;
    return;
}

defaultproperties
{
    m_eTerroDensity=3
    m_bGameOverIfFailed=true
    m_bUnloadForDeathMatch=true
    m_bUnloadForTeamDeathMatch=true
    m_bUnloadForAttackDefend=true
    m_bUnloadForConquest=true
    m_bUnloadForAssassination=true
    m_bUnloadForRetrieval=true
    bNoDelete=false
    MessageClass=Class'R6TerroristHuntGameMessage'
}