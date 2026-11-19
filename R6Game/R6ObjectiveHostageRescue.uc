class R6ObjectiveHostageRescue extends R6ObjectiveBasicMP
    native
    config(Game)
    hidecategories(lighting,Movement,Collision);

struct HostageInfo
{
    var R6HostagePawn m_pPawn;
    var R6RadarObjectiveRepInfo m_pEmitter;

    structdefaultproperties
    {
        m_pPawn=none
        m_pEmitter=none
    }
};

var array<HostageInfo> m_arrHostages;
var array<R6ExtractionZone> m_arrExtractionZones;
var int m_iHostagesTotal;
var float m_fHostageTimer;
var config float m_fHostageTimeOut;
var PlayerReplicationInfo m_HostageKiller;

function MatchStarting()
{
    FindExtractionZones();
    m_fHostageTimer = 0.0000000;
    m_HostageKiller = none;
    return;
}

function Tick(float DeltaTime)
{
    local R6HostageManager pHostageMgr;
    local R6HostagePawn pHostage;
    local int iHostage;
    local Actor.ETacticType eHostageTactic;
    local R6GameInfo pGameInfo;

    pGameInfo = R6GameInfo(WorldInfo.Game);
    Tick(DeltaTime);
    m_fHostageTimer += DeltaTime;
    // End:0x1AB
    if(((((WorldInfo.Game != none) && int(pGameInfo.GetGameStatus()) == int(5)) && R6GameInfo(WorldInfo.Game) != none) && int(pGameInfo.GetGameMode()) == int(1)) && m_fHostageTimer > (m_fHostageTimeOut + float(Class'R6HostageRescueGameMessage'.default.Lifetime)))
    {
        iHostage = 0;
        J0xC4:

        // End:0x1AB [Loop If]
        if(iHostage < m_arrHostages.Length)
        {
            pHostage = m_arrHostages[iHostage].m_pPawn;
            // End:0x100
            if(pHostage.IsIncapacitated())
            {
                // [Explicit Continue]
                goto J0x1A1;
            }
            pHostageMgr = R6HostageManager(pHostage.m_pTeamManager);
            // End:0x1A1
            if(pHostageMgr != none)
            {
                eHostageTactic = pHostageMgr.GetCurrentTacticFor(pHostage);
                // End:0x1A1
                if((int(eHostageTactic) == int(13)) && pHostage.m_pR6PawnFollowing != none)
                {
                    m_fHostageTimer = 0.0000000;
                    pGameInfo.BroadcastGameMessage(MessageClass, 48, pHostage.m_pR6PawnFollowing.PlayerReplicationInfo);
                    return;
                }
            }
            J0x1A1:

            ++iHostage;
            // [Loop Continue]
            goto J0xC4;
        }
    }
    return;
}

function FindExtractionZones()
{
    local R6ExtractionZone PZone;

    ResetZones();
    // End:0x54
    foreach AllActors(Class'R6ExtractionZone', PZone)
    {
        // End:0x53
        if(!PZone.m_bShutdown)
        {
            PZone.m_eAllowedTeam = GetTeamNum();
            m_arrExtractionZones[m_arrExtractionZones.Length] = PZone;
        }        
    }    
    return;
}

function FindHostages()
{
    local HostageInfo Hostage;
    local R6HostagePawn pHostage;

    ResetHostages();
    // End:0xAD
    foreach AllActors(Class'R6HostagePawn', pHostage)
    {
        // End:0xAC
        if(!pHostage.m_bShutdown)
        {
            Hostage.m_pPawn = pHostage;
            Hostage.m_pEmitter = __NFUN_278__(Class'R6RadarObjectiveRepInfo');
            Hostage.m_pEmitter.Init(pHostage);
            Hostage.m_pEmitter.m_eObjectiveType = 14;
            Hostage.m_pEmitter.m_eTeamNumber = 2;
            m_arrHostages[m_arrHostages.Length] = Hostage;
        }        
    }    
    m_iHostagesTotal = m_arrHostages.Length;
    return;
}

function OnHostagesSpawned()
{
    FindHostages();
    return;
}

function ResetHostages()
{
    local int iHostage;

    iHostage = 0;
    J0x07:

    // End:0x4A [Loop If]
    if(iHostage < m_arrHostages.Length)
    {
        m_arrHostages[iHostage].m_pPawn = none;
        m_arrHostages[iHostage].m_pEmitter.Destroy();
        ++iHostage;
        // [Loop Continue]
        goto J0x07;
    }
    m_arrHostages.Remove(0, m_arrHostages.Length);
    return;
}

function ResetZones()
{
    m_arrExtractionZones.Remove(0, m_arrExtractionZones.Length);
    return;
}

function PawnDied(Pawn deadPawn, Controller Killer)
{
    local int iHostage;
    local R6PlayerController pHostageKiller;

    iHostage = HostageExists(R6HostagePawn(deadPawn));
    // End:0xF3
    if(iHostage != -1)
    {
        m_arrHostages[iHostage].m_pEmitter.Destroy();
        m_arrHostages[iHostage].m_pEmitter = none;
        m_arrHostages.Remove(iHostage, 1);
        // End:0xA4
        if(WorldInfo.Game != none)
        {
            R6GameInfo(WorldInfo.Game).BroadcastGameMessage(MessageClass, 39, Killer.PlayerReplicationInfo);
        }
        pHostageKiller = R6PlayerController(Killer);
        // End:0xE9
        if((pHostageKiller != none) && pHostageKiller.PlayerReplicationInfo != none)
        {
            m_HostageKiller = pHostageKiller.PlayerReplicationInfo;
        }
        SetFailure();        
    }
    else
    {
        UpdateHostagesTacticOnDeath(deadPawn);
    }
    ActivateExtractionZonesSignal(false);
    return;
}

function UpdateHostagesTacticOnDeath(Pawn pDeadPawn)
{
    local R6HostageManager pHostageMgr;
    local R6HostagePawn pHostage;
    local int iHostage;

    iHostage = 0;
    J0x07:

    // End:0xD0 [Loop If]
    if(iHostage < m_arrHostages.Length)
    {
        pHostage = m_arrHostages[iHostage].m_pPawn;
        // End:0x51
        if((pHostage == none) || pHostage.m_pTeamManager == none)
        {
            // [Explicit Continue]
            goto J0xC6;
        }
        pHostageMgr = R6HostageManager(pHostage.m_pTeamManager);
        // End:0x8B
        if(pHostageMgr.GetCurrentTacticLeaderFor(pHostage) != pDeadPawn)
        {
            // [Explicit Continue]
            goto J0xC6;
        }
        // End:0xC6
        if(int(pHostageMgr.GetCurrentTacticFor(pHostage)) == int(13))
        {
            pHostageMgr.ChangeTacticFor(pHostage, 31, pHostage);
        }
        J0xC6:

        ++iHostage;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function int HostageExists(R6HostagePawn pHostage)
{
    local int iHostageFound, iHostage;

    iHostageFound = -1;
    iHostage = 0;
    J0x12:

    // End:0x7A [Loop If]
    if((iHostage < m_arrHostages.Length) && iHostageFound == -1)
    {
        // End:0x70
        if((m_arrHostages[iHostage].m_pPawn != none) && m_arrHostages[iHostage].m_pPawn == pHostage)
        {
            iHostageFound = iHostage;
        }
        ++iHostage;
        // [Loop Continue]
        goto J0x12;
    }
    return iHostageFound;
    return;
}

function HostageRescued(int iHostage)
{
    local R6Pawn pEscort;
    local R6HostagePawn pHostage;
    local R6PlayerController pEscortController;

    pHostage = m_arrHostages[iHostage].m_pPawn;
    // End:0x157
    if(pHostage != none)
    {
        // End:0x5D
        if(pHostage.m_pTeamManager != none)
        {
            pEscort = R6HostageManager(pHostage.m_pTeamManager).GetCurrentTacticLeaderFor(pHostage);
        }
        // End:0xD6
        if(pEscort != none)
        {
            m_pScorer = pEscort.PlayerReplicationInfo;
            pEscortController = R6PlayerController(pEscort.Controller);
            pEscortController.ClientOnHostageRescued(m_iHostagesTotal);
            GetGameManager().m_StatisticsManager.IncrementHostages(R6PlayerReplicationInfo(m_pScorer).m_iStatsPlayerID);
        }
        m_arrHostages[iHostage].m_pEmitter.Destroy();
        m_arrHostages[iHostage].m_pEmitter = none;
        m_arrHostages.Remove(iHostage, 1);
        // End:0x147
        if(WorldInfo.Game != none)
        {
            R6GameInfo(WorldInfo.Game).BroadcastGameMessage(MessageClass, 38);
        }
        pHostage.RemoveHostage();
    }
    return;
}

function bool AllHostagesRescued()
{
    return m_arrHostages.Length == 0;
    return;
}

function bool AtLeastOneEscort()
{
    local R6HostagePawn pHostage;
    local bool bHostageFound;
    local int iHostage;

    iHostage = 0;
    J0x07:

    // End:0x9A [Loop If]
    if((iHostage < m_arrHostages.Length) && !bHostageFound)
    {
        pHostage = m_arrHostages[iHostage].m_pPawn;
        // End:0x90
        if((pHostage != none) && pHostage.m_pTeamManager != none)
        {
            // End:0x90
            if(int(R6HostageManager(pHostage.m_pTeamManager).GetCurrentTacticFor(pHostage)) == int(13))
            {
                bHostageFound = true;
            }
        }
        ++iHostage;
        // [Loop Continue]
        goto J0x07;
    }
    return bHostageFound;
    return;
}

function ActivateExtractionZonesSignal(bool bActivate)
{
    local int iZone;

    // End:0x19
    if(!bActivate && AtLeastOneEscort())
    {
        return;
    }
    iZone = 0;
    J0x20:

    // End:0x56 [Loop If]
    if(iZone < m_arrExtractionZones.Length)
    {
        m_arrExtractionZones[iZone].EnableRadarSignal(bActivate);
        ++iZone;
        // [Loop Continue]
        goto J0x20;
    }
    return;
}

function OnPawnInteracted(R6Pawn pPawn, Pawn pInteractor, bool bSuccess)
{
    local Actor.ETacticType eHostageTactic;
    local R6HostageManager pHostageMgr;
    local int iHostage;

    iHostage = HostageExists(R6HostagePawn(pPawn));
    // End:0x28
    if(iHostage == -1)
    {
        return;
    }
    // End:0x35
    if(!bSuccess)
    {
        return;
    }
    // End:0x55
    if(m_arrHostages[iHostage].m_pPawn.IsIncapacitated())
    {
        return;
    }
    pHostageMgr = R6HostageManager(m_arrHostages[iHostage].m_pPawn.m_pTeamManager);
    // End:0x199
    if(pHostageMgr != none)
    {
        eHostageTactic = pHostageMgr.GetCurrentTacticFor(m_arrHostages[iHostage].m_pPawn);
        // End:0x12A
        if(int(eHostageTactic) != int(13))
        {
            eHostageTactic = 13;
            pHostageMgr.ChangeTacticFor(m_arrHostages[iHostage].m_pPawn, eHostageTactic, R6Pawn(pInteractor));
            // End:0x127
            if(m_arrHostages[iHostage].m_pEmitter != none)
            {
                m_arrHostages[iHostage].m_pEmitter.m_eTeamNumber = GetTeamNum();
            }            
        }
        else
        {
            eHostageTactic = 31;
            pHostageMgr.ChangeTacticFor(m_arrHostages[iHostage].m_pPawn, eHostageTactic, m_arrHostages[iHostage].m_pPawn);
            // End:0x199
            if(m_arrHostages[iHostage].m_pEmitter != none)
            {
                m_arrHostages[iHostage].m_pEmitter.m_eTeamNumber = 2;
            }
        }
    }
    // End:0x1FD
    if(pInteractor != none)
    {
        // End:0x1FD
        if(int(eHostageTactic) == int(13))
        {
            // End:0x1FD
            if(WorldInfo.Game != none)
            {
                R6GameInfo(WorldInfo.Game).BroadcastGameMessage(MessageClass, 37, pInteractor.PlayerReplicationInfo);
            }
        }
    }
    ActivateExtractionZonesSignal(int(eHostageTactic) == int(13));
    return;
}

function ZoneEntered(R6ExtractionZone PZone, R6Pawn pPawn)
{
    local int iHostage;

    iHostage = HostageExists(R6HostagePawn(pPawn));
    // End:0x4B
    if(iHostage != -1)
    {
        HostageRescued(iHostage);
        ActivateExtractionZonesSignal(false);
        // End:0x4B
        if(AllHostagesRescued())
        {
            SetSuccess();
        }
    }
    return;
}

function ZoneExited(R6ExtractionZone PZone, R6Pawn pPawn)
{
    return;
}

function ResetOriginalData()
{
    ResetOriginalData();
    ResetHostages();
    ResetZones();
    return;
}

defaultproperties
{
    m_fHostageTimeOut=30.0000000
    m_szTeamDescription[0]="ASSAULT TEAM: LOCATE THE HOSTAGES AND ESCORT THEM TO THE EXTRACTION POINT."
    m_szTeamDescription[1]="DEFENDERS: PREVENT THE HOSTAGES FROM BEING FREED."
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
    MessageClass=Class'R6HostageRescueGameMessage'
}