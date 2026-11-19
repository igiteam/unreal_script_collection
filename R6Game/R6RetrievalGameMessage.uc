class R6RetrievalGameMessage extends LocalMessage;

var const localized string CanisterEnemyPossessionMsg;
var const localized string CanisterTeamPossessionMsg;
var const localized string CanisterPlayerPossessionMsg;
var const localized string CanisterLostMsg;
var const localized string MatchEnemyHasScoredMsg;
var const localized string MatchTeamHasScoredMsg;

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string szTextMsg;
    local SoundCue sndVoiceMsg;
    local R6PlayerController PC;
    local int iObjectTaken;

    iObjectTaken = 34;
    PC = R6PlayerController(P);
    switch(byte(Switch))
    {
        // End:0x2A
        case 25:
        // End:0x2F
        case 34:
        // End:0x16E
        case 36:
            // End:0x16B
            if(PC.m_MagmaInteraction != none)
            {
                szTextMsg = RetrieveString(PC, Switch, RelatedPRI_1 == P.PlayerReplicationInfo, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                PC.m_MagmaInteraction.ShowTextInformationBox(Caps(szTextMsg), GetLifeTime(Switch), GetColor(Switch, RelatedPRI_1, RelatedPRI_2));
                sndVoiceMsg = RetrieveSound(PC, Switch, RelatedPRI_1 == P.PlayerReplicationInfo, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                PC.StopSound(PC.GetPlayerInfo().GetGameStatusVoiceMsg());
                PC.PlaySound(sndVoiceMsg, 13, false, true);
                PC.GetPlayerInfo().SaveGameStatus(szTextMsg, sndVoiceMsg);
            }
            // End:0x22C
            break;
        // End:0x226
        case 47:
            // End:0x223
            if(PC.m_MagmaInteraction != none)
            {
                szTextMsg = RetrieveString(PC, iObjectTaken, RelatedPRI_1 == P.PlayerReplicationInfo, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                PC.m_MagmaInteraction.ShowTextInformationBox(Caps(szTextMsg), GetLifeTime(iObjectTaken), GetColor(iObjectTaken, RelatedPRI_1, RelatedPRI_2));
                PC.GetPlayerInfo().m_szGameStatusTextMsg = szTextMsg;
            }
            // End:0x22C
            break;
        // End:0xFFFF
        default:
            // End:0x22C
            break;
            break;
    }
    return;
}

static simulated function string RetrieveString(R6PlayerController PC, optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch(byte(Switch))
    {
        // End:0x5A
        case 25:
            // End:0x57
            if(RelatedPRI_1 != none)
            {
                // End:0x51
                if(PC.PlayerReplicationInfo.Team == RelatedPRI_1.Team)
                {
                    return default.MatchTeamHasScoredMsg;                    
                }
                else
                {
                    return default.MatchEnemyHasScoredMsg;
                }
            }
            // End:0xDB
            break;
        // End:0xC7
        case 34:
            // End:0xC4
            if(RelatedPRI_1 != none)
            {
                // End:0xBE
                if(PC.PlayerReplicationInfo.Team == RelatedPRI_1.Team)
                {
                    // End:0xB5
                    if(PC.PlayerReplicationInfo == RelatedPRI_1)
                    {
                        return default.CanisterPlayerPossessionMsg;                        
                    }
                    else
                    {
                        return default.CanisterTeamPossessionMsg;
                    }                    
                }
                else
                {
                    return default.CanisterEnemyPossessionMsg;
                }
            }
            // End:0xDB
            break;
        // End:0xD5
        case 36:
            return default.CanisterLostMsg;
            // End:0xDB
            break;
        // End:0xFFFF
        default:
            // End:0xDB
            break;
            break;
    }
    return "";
    return;
}

static simulated function SoundCue RetrieveSound(R6PlayerController PC, optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local R6GameEnums.ETEAMIDENTITY ePlayerTeam, ePossessorTeam;

    ePlayerTeam = PC.GetTeamNum();
    // End:0x3C
    if(RelatedPRI_1 != none)
    {
        ePossessorTeam = RelatedPRI_1.GetTeamNum();
    }
    switch(byte(Switch))
    {
        // End:0x124
        case 25:
            // End:0x7E
            if(PC.PlayerReplicationInfo == RelatedPRI_1)
            {
                return PC.GetMiscConfig().m_sndCanisterDeliveredPlayer;                
            }
            else
            {
                // End:0xD9
                if(int(ePossessorTeam) == int(0))
                {
                    // End:0xBD
                    if(int(ePlayerTeam) == int(ePossessorTeam))
                    {
                        return PC.GetMiscConfig().m_sndAlphaItemDeliveredAlpha;                        
                    }
                    else
                    {
                        return PC.GetMiscConfig().m_sndBravoItemDeliveredAlpha;
                    }                    
                }
                else
                {
                    // End:0x108
                    if(int(ePlayerTeam) == int(ePossessorTeam))
                    {
                        return PC.GetMiscConfig().m_sndBravoItemDeliveredBravo;                        
                    }
                    else
                    {
                        return PC.GetMiscConfig().m_sndAlphaItemDeliveredBravo;
                    }
                }
            }
            // End:0x1FE
            break;
        // End:0x1A8
        case 34:
            // End:0x15D
            if(PC.PlayerReplicationInfo == RelatedPRI_1)
            {
                return PC.GetMiscConfig().m_sndCanisterPossessionPlayer;                
            }
            else
            {
                // End:0x18C
                if(int(ePlayerTeam) == int(ePossessorTeam))
                {
                    return PC.GetMiscConfig().m_sndCanisterPossessionTeam;                    
                }
                else
                {
                    return PC.GetMiscConfig().m_sndCanisterPossessionEnemy;
                }
            }
            // End:0x1FE
            break;
        // End:0x1F8
        case 36:
            // End:0x1DC
            if(int(ePlayerTeam) == int(ePossessorTeam))
            {
                return PC.GetMiscConfig().m_sndCanisterLostTeam;                
            }
            else
            {
                return PC.GetMiscConfig().m_sndCanisterLostEnemy;
            }
            // End:0x1FE
            break;
        // End:0xFFFF
        default:
            // End:0x1FE
            break;
            break;
    }
    return none;
    return;
}

defaultproperties
{
    CanisterEnemyPossessionMsg="THE ENEMY TEAM HAS THE CANISTER. INTERCEPT THE CARRIER BEFORE HE REACHES HIS DEPOT STATION."
    CanisterTeamPossessionMsg="YOUR TEAM HAS THE CANISTER. PROTECT THE CANISTER CARRIER."
    CanisterPlayerPossessionMsg="YOU HAVE THE CANISTER. DROP IT OFF AT YOUR TEAM'S DEPOT STATION."
    CanisterLostMsg="THE CANISTER HAS BEEN DROPPED."
    MatchEnemyHasScoredMsg="ENEMY TEAM SCORED A POINT."
    MatchTeamHasScoredMsg="YOUR TEAM SCORED A POINT."
    Lifetime=5
}