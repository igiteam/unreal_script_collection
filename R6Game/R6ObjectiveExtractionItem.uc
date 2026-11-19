class R6ObjectiveExtractionItem extends R6ObjectiveBasicMP
    native
    config(Game)
    hidecategories(lighting,Movement,Collision);

var() R6ExtractionItem m_pTargetItem;
var array<R6ExtractionZone> m_arrExtractionZones;
var R6RadarObjectiveRepInfo m_pRadarInfo;
var R6GameInfo m_pGameInfo;
var float m_fItemTimer;
var config float m_fItemTimeOut;

function PostBeginPlay()
{
    local R6ExtractionItem pItem;

    PostBeginPlay();
    m_fItemTimer = 0.0000000;
    // End:0x65
    if(m_pTargetItem == none)
    {
        // End:0x64
        foreach AllActors(Class'R6ExtractionItem', pItem)
        {
            // End:0x63
            if(!pItem.m_bShutdown)
            {
                m_pTargetItem = pItem;
                m_pTargetItem.m_fMaxDropTime = 0.0000000;
                // End:0x64
                break;
            }            
        }        
    }
    return;
}

function MatchStarting()
{
    m_pGameInfo = R6GameInfo(WorldInfo.Game);
    FindExtractionZones();
    StartRadarSignal();
    return;
}

function Tick(float fDeltaTime)
{
    local R6GameInfo pGameInfo;

    pGameInfo = R6GameInfo(WorldInfo.Game);
    Tick(fDeltaTime);
    // End:0xF5
    if(((((pGameInfo != none) && int(pGameInfo.GetGameStatus()) == int(5)) && int(pGameInfo.GetGameMode()) == int(1)) && m_pTargetItem != none) && m_pTargetItem.m_pCarrier != none)
    {
        m_fItemTimer += fDeltaTime;
        // End:0xF5
        if(m_fItemTimer > (m_fItemTimeOut + float(Class'R6ExtractionItemGameMessage'.default.Lifetime)))
        {
            m_fItemTimer = 0.0000000;
            pGameInfo.BroadcastGameMessage(MessageClass, 47, m_pTargetItem.m_pCarrier.PlayerReplicationInfo);
        }
    }
    return;
}

function FindExtractionZones()
{
    local R6ExtractionZone PZone;

    ResetZones();
    // End:0x3E
    foreach AllActors(Class'R6ExtractionZone', PZone)
    {
        // End:0x3D
        if(!PZone.m_bShutdown)
        {
            m_arrExtractionZones[m_arrExtractionZones.Length] = PZone;
        }        
    }    
    return;
}

function ResetZones()
{
    ActivateZonesSignal(m_pTargetItem, false);
    m_arrExtractionZones.Remove(0, m_arrExtractionZones.Length);
    return;
}

event SetTeamNum(byte u8TeamNum)
{
    local R6ExtractionZone PZone;

    SetTeamNum(u8TeamNum);
    // End:0x2B
    if(m_pTargetItem != none)
    {
        m_pTargetItem.m_eAllowedTeam = m_eTeamNumber;
    }
    // End:0x64
    foreach AllActors(Class'R6ExtractionZone', PZone)
    {
        // End:0x63
        if(!PZone.m_bShutdown)
        {
            PZone.m_eAllowedTeam = m_eTeamNumber;
        }        
    }    
    return;
}

function bool IsValidItem(R6CarriedObject pItem)
{
    local R6ExtractionItem pExtractionItem;

    // End:0x1B
    if(pItem != none)
    {
        pExtractionItem = R6ExtractionItem(pItem);
    }
    return ((pExtractionItem != none) && pExtractionItem.m_bShutdown == false) && pExtractionItem == m_pTargetItem;
    return;
}

function bool IsValidZone(R6ExtractionZone PZone)
{
    return (PZone != none) && !PZone.m_bShutdown;
    return;
}

function bool IsValidCarrier(R6Pawn pPawn)
{
    return ((pPawn != none) && pPawn.PlayerReplicationInfo != none) && pPawn.PlayerReplicationInfo.bHasFlag;
    return;
}

function bool IsGameInProgress()
{
    return int(m_pGameInfo.GetGameStatus()) == int(5);
    return;
}

function ActivateZonesSignal(R6ExtractionItem pItem, bool bActivate)
{
    local int iZone;
    local bool bTeamGame;

    // End:0x0D
    if(pItem == none)
    {
        return;
    }
    // End:0x44
    if(WorldInfo.GetGameClass() != none)
    {
        bTeamGame = WorldInfo.static.GetGameClass().default.bTeamGame;
    }
    iZone = 0;
    J0x4B:

    // End:0xD7 [Loop If]
    if(iZone < m_arrExtractionZones.Length)
    {
        // End:0x85
        if(!bTeamGame)
        {
            m_arrExtractionZones[iZone].EnableRadarSignal(bActivate);
            // [Explicit Continue]
            goto J0xCD;
        }
        // End:0xCD
        if(WorldInfo.GRI.OnSameTeam(m_arrExtractionZones[iZone], pItem))
        {
            m_arrExtractionZones[iZone].EnableRadarSignal(bActivate);
        }
        J0xCD:

        ++iZone;
        // [Loop Continue]
        goto J0x4B;
    }
    return;
}

function OnTaken(R6CarriedObject pItem)
{
    // End:0x0E
    if(!IsGameInProgress())
    {
        return;
    }
    // End:0x21
    if(!IsValidItem(pItem))
    {
        return;
    }
    // End:0x112
    if(pItem.m_pCarrier != none)
    {
        pItem.m_pCarrier.PlayerReplicationInfo.bHasFlag = true;
        pItem.m_pCarrier.PlayerReplicationInfo.NetUpdateTime = WorldInfo.TimeSeconds - float(1);
        // End:0xC0
        if(m_pRadarInfo != none)
        {
            m_pRadarInfo.AssignTeam(pItem.m_pCarrier.GetTeamNum());
        }
        // End:0x112
        if(WorldInfo.Game != none)
        {
            R6GameInfo(WorldInfo.Game).BroadcastGameMessage(MessageClass, 34, pItem.m_pCarrier.PlayerReplicationInfo);
        }
    }
    ActivateZonesSignal(R6ExtractionItem(pItem), true);
    return;
}

function OnDropped(R6CarriedObject pItem)
{
    local PlayerReplicationInfo pCarrier;

    // End:0x0E
    if(!IsGameInProgress())
    {
        return;
    }
    // End:0x21
    if(!IsValidItem(pItem))
    {
        return;
    }
    // End:0x85
    if(pItem.m_pCarrier != none)
    {
        pCarrier = pItem.m_pCarrier.PlayerReplicationInfo;
        pCarrier.bHasFlag = false;
        pCarrier.NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    }
    // End:0xA2
    if(m_pRadarInfo != none)
    {
        m_pRadarInfo.AssignTeam(2);
    }
    // End:0xE2
    if(WorldInfo.Game != none)
    {
        R6GameInfo(WorldInfo.Game).BroadcastGameMessage(MessageClass, 36, pCarrier);
    }
    ActivateZonesSignal(R6ExtractionItem(pItem), false);
    return;
}

function ZoneEntered(R6ExtractionZone PZone, R6Pawn pPawn)
{
    local R6PlayerController pR6Controller;

    // End:0x0E
    if(!IsGameInProgress())
    {
        return;
    }
    // End:0x38
    if(!WorldInfo.GRI.OnSameTeam(pPawn, PZone))
    {
        return;
    }
    // End:0xE3
    if((IsValidZone(PZone)) && IsValidCarrier(pPawn))
    {
        m_pScorer = pPawn.PlayerReplicationInfo;
        ActivateZonesSignal(m_pTargetItem, false);
        StopRadarSignal();
        SetSuccess();
        pR6Controller = R6PlayerController(pPawn.Controller);
        // End:0xE3
        if(pR6Controller != none)
        {
            // End:0xE3
            if(WorldInfo.Game.GameReplicationInfo.ElapsedTime <= 120)
            {
                pR6Controller.ClientGiveAward(13);
            }
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
    m_pScorer = none;
    ResetZones();
    StopRadarSignal();
    return;
}

function StartRadarSignal()
{
    // End:0x62
    if(m_pTargetItem != none)
    {
        // End:0x62
        if(m_pRadarInfo == none)
        {
            m_pRadarInfo = __NFUN_278__(Class'R6RadarObjectiveRepInfo');
            m_pRadarInfo.Init(m_pTargetItem);
            m_pRadarInfo.m_eObjectiveType = 13;
            m_pRadarInfo.AssignTeam(2);
        }
    }
    return;
}

function StopRadarSignal()
{
    // End:0x1E
    if(m_pRadarInfo != none)
    {
        m_pRadarInfo.Destroy();
        m_pRadarInfo = none;
    }
    return;
}

defaultproperties
{
    m_fItemTimeOut=30.0000000
    m_szTeamDescription[0]="ASSAULT TEAM: INFILTRATE THE DEFENDERS' BASE AND RETRIEVE THE BRIEFCASE."
    m_szTeamDescription[1]="DEFENDERS: PREVENT THE ATTACKERS FROM EXTRACTING THE BRIEFCASE."
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
    MessageClass=Class'R6ExtractionItemGameMessage'
}