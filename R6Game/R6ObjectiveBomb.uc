class R6ObjectiveBomb extends R6ObjectiveBasicMP
    native
    hidecategories(lighting,Movement,Collision);

var() R6InteractiveBomb m_pTargetBomb;

function PostBeginPlay()
{
    local R6InteractiveBomb pBomb;

    PostBeginPlay();
    // End:0x57
    if(m_pTargetBomb == none)
    {
        // End:0x56
        foreach AllActors(Class'R6InteractiveBomb', pBomb)
        {
            // End:0x55
            if(!pBomb.m_bShutdown)
            {
                m_pTargetBomb = pBomb;
                m_pTargetBomb.EnableRadarDetection(true);
                // End:0x56
                break;
            }            
        }        
    }
    return;
}

function MatchStarting()
{
    ActivateBomb();
    return;
}

event SetTeamNum(byte u8TeamNum)
{
    SetTeamNum(u8TeamNum);
    // End:0x4F
    if(m_pTargetBomb != none)
    {
        m_pTargetBomb.m_eAllowedInteractTeam = m_eTeamNumber;
        m_pTargetBomb.NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
    }
    return;
}

function int GetTimer()
{
    // End:0x1F
    if(m_pTargetBomb != none)
    {
        return int(m_pTargetBomb.m_fBombTimer);        
    }
    else
    {
        return -1;
    }
    return;
}

function ActivateBomb()
{
    // End:0x71
    if(m_pTargetBomb != none)
    {
        // End:0x61
        if(float(R6MultiPlayerGame(WorldInfo.Game).m_iTimeLimitSeconds) > 0.0000000)
        {
            m_pTargetBomb.ChangeBombTimer(float(R6MultiPlayerGame(WorldInfo.Game).m_iTimeLimitSeconds));
        }
        m_pTargetBomb.StartBombTimer();
    }
    return;
}

function bool IsValidInteractor(Pawn pPawn)
{
    local R6Pawn pInteractorPawn;

    pInteractorPawn = R6Pawn(pPawn);
    return (pInteractorPawn != none) && pInteractorPawn.PlayerReplicationInfo != none;
    return;
}

function bool IsValidBomb(R6InteractiveActor pActor)
{
    local R6InteractiveBomb pBomb;

    // End:0x1B
    if(pActor != none)
    {
        pBomb = R6InteractiveBomb(pActor);
    }
    return (pBomb != none) && pBomb == m_pTargetBomb;
    return;
}

function OnInteracted(R6InteractiveActor pActor, Pawn pPawn, bool bSuccess)
{
    local R6PlayerController pR6Controller;

    // End:0x0D
    if(!bSuccess)
    {
        return;
    }
    // End:0x20
    if(!IsValidBomb(pActor))
    {
        return;
    }
    // End:0x9F
    if(IsValidInteractor(pPawn))
    {
        m_pScorer = pPawn.PlayerReplicationInfo;
        pR6Controller = R6PlayerController(pPawn.Controller);
        // End:0x9F
        if(pR6Controller != none)
        {
            // End:0x9F
            if(WorldInfo.Game.GameReplicationInfo.ElapsedTime <= 120)
            {
                pR6Controller.ClientGiveAward(12);
            }
        }
    }
    m_pTargetBomb.StopRadarSignal();
    SetSuccess();
    return;
}

function OnExploded(R6InteractiveBomb pBomb)
{
    // End:0x13
    if(!IsValidBomb(pBomb))
    {
        return;
    }
    SetFailure();
    return;
}

defaultproperties
{
    m_szTeamDescription[0]="ASSAULT TEAM: FIND AND DEFUSE THE BOMB BEFORE THE TIMER EXPIRES."
    m_szTeamDescription[1]="DEFENDERS: PREVENT THE ENEMY TEAM FROM DEFUSING THE BOMB."
    m_iScore=10
    m_szMsgSuccess="MISSION SUCCESSFUL"
    m_szMsgFailure="MISSION FAILED"
    m_bGameOverIfFailed=true
    m_bUnloadForDeathMatch=true
    m_bUnloadForTeamDeathMatch=true
    m_bUnloadForConquest=true
    m_bUnloadForAssassination=true
    m_bUnloadForRetrieval=true
    m_bUnloadForTerroristHunt=true
    m_bUnloadForSoloTerroristHunt=true
    MessageClass=Class'R6BombGameMessage'
}