class R6ExtractionItemGameMessage extends LocalMessage;

var const localized string ItemEnemyPossessionMsg;
var const localized string ItemTeamPossessionMsg;
var const localized string ItemPlayerPossessionMsg;
var const localized string ItemLostTeamMsg;
var const localized string ItemLostEnemyMsg;
var const localized string ItemDeliveredMsg;

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
        case 34:
        // End:0x169
        case 36:
            // End:0x166
            if(PC.m_MagmaInteraction != none)
            {
                szTextMsg = RetrieveString(PC, Switch, RelatedPRI_1 == P.PlayerReplicationInfo, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                PC.m_MagmaInteraction.ShowTextInformationBox(Caps(szTextMsg), GetLifeTime(Switch), GetColor(Switch, RelatedPRI_1, RelatedPRI_2));
                sndVoiceMsg = RetrieveSound(PC, Switch, RelatedPRI_1 == P.PlayerReplicationInfo, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                PC.StopSound(PC.GetPlayerInfo().GetGameStatusVoiceMsg());
                PC.PlaySound(sndVoiceMsg, 13, false, true);
                PC.GetPlayerInfo().SaveGameStatus(szTextMsg, sndVoiceMsg);
            }
            // End:0x39D
            break;
        // End:0x221
        case 47:
            // End:0x21E
            if(PC.m_MagmaInteraction != none)
            {
                szTextMsg = RetrieveString(PC, iObjectTaken, RelatedPRI_1 == P.PlayerReplicationInfo, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                PC.m_MagmaInteraction.ShowTextInformationBox(Caps(szTextMsg), GetLifeTime(iObjectTaken), GetColor(iObjectTaken, RelatedPRI_1, RelatedPRI_2));
                PC.GetPlayerInfo().m_szGameStatusTextMsg = szTextMsg;
            }
            // End:0x39D
            break;
        // End:0x226
        case 23:
        // End:0x397
        case 24:
            // End:0x394
            if(PC.m_MagmaInteraction != none)
            {
                szTextMsg = RetrieveString(PC, Switch, RelatedPRI_1 == P.PlayerReplicationInfo, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                PC.m_MagmaInteraction.ShowGameMessage(byte(Switch), Caps(szTextMsg), GetLifeTime(Switch));
                PC.m_MagmaInteraction.ShowTextInformationBox(default.ItemDeliveredMsg, GetLifeTime(Switch), MakeColor(byte(255), byte(255), byte(255), byte(255)));
                sndVoiceMsg = RetrieveSound(PC, Switch, RelatedPRI_1 == P.PlayerReplicationInfo, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                PC.StopSound(PC.GetPlayerInfo().GetGameStatusVoiceMsg());
                PC.PlaySound(sndVoiceMsg, 3, false, true);
                PC.GetPlayerInfo().SaveGameStatus(szTextMsg, sndVoiceMsg);
            }
            // End:0x39D
            break;
        // End:0xFFFF
        default:
            // End:0x39D
            break;
            break;
    }
    return;
}

static simulated function string RetrieveString(R6PlayerController PC, optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch(byte(Switch))
    {
        // End:0x7B
        case 34:
            // End:0x78
            if(RelatedPRI_1 != none)
            {
                // End:0x72
                if(PC.PlayerReplicationInfo.Team == RelatedPRI_1.Team)
                {
                    // End:0x69
                    if(PC.PlayerReplicationInfo == RelatedPRI_1)
                    {
                        return default.ItemPlayerPossessionMsg;                        
                    }
                    else
                    {
                        return default.ItemTeamPossessionMsg;
                    }                    
                }
                else
                {
                    return default.ItemEnemyPossessionMsg;
                }
            }
            // End:0xF0
            break;
        // End:0xBC
        case 36:
            // End:0xB3
            if(RelatedPRI_1.Team == PC.PlayerReplicationInfo.Team)
            {
                return default.ItemLostTeamMsg;                
            }
            else
            {
                return default.ItemLostEnemyMsg;
            }
            // End:0xF0
            break;
        // End:0xD3
        case 23:
            return Class'R6ObjectiveExtractionItem'.default.m_szMsgSuccess;
            // End:0xF0
            break;
        // End:0xEA
        case 24:
            return Class'R6ObjectiveExtractionItem'.default.m_szMsgFailure;
            // End:0xF0
            break;
        // End:0xFFFF
        default:
            // End:0xF0
            break;
            break;
    }
    return "";
    return;
}

static simulated function SoundCue RetrieveSound(R6PlayerController PC, optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local R6GameEnums.ETEAMIDENTITY ePlayerTeam;

    ePlayerTeam = PC.GetTeamNum();
    switch(byte(Switch))
    {
        // End:0xE0
        case 34:
            // End:0xDD
            if((RelatedPRI_1 != none) && PC.PlayerReplicationInfo != none)
            {
                // End:0xC4
                if(PC.PlayerReplicationInfo.Team == RelatedPRI_1.Team)
                {
                    // End:0xA8
                    if(PC.PlayerReplicationInfo == RelatedPRI_1)
                    {
                        return PC.GetMiscConfig().m_sndItemPossessionPlayer;                        
                    }
                    else
                    {
                        return PC.GetMiscConfig().m_sndItemPossessionTeam;
                    }                    
                }
                else
                {
                    return PC.GetMiscConfig().m_sndItemPossessionEnemy;
                }
            }
            // End:0x1E7
            break;
        // End:0x147
        case 36:
            // End:0x12B
            if(RelatedPRI_1.Team == PC.PlayerReplicationInfo.Team)
            {
                return PC.GetMiscConfig().m_sndItemLostTeam;                
            }
            else
            {
                return PC.GetMiscConfig().m_sndItemLostEnemy;
            }
            // End:0x1E7
            break;
        // End:0x194
        case 23:
            // End:0x178
            if(int(ePlayerTeam) == int(0))
            {
                return PC.GetMiscConfig().m_sndAttackerItemDeliverySucceeded;                
            }
            else
            {
                return PC.GetMiscConfig().m_sndDefenderItemDeliveryFailed;
            }
            // End:0x1E7
            break;
        // End:0x1E1
        case 24:
            // End:0x1C5
            if(int(ePlayerTeam) == int(0))
            {
                return PC.GetMiscConfig().m_sndAttackerItemDeliveryFailed;                
            }
            else
            {
                return PC.GetMiscConfig().m_sndDefenderItemDeliverySucceeded;
            }
            // End:0x1E7
            break;
        // End:0xFFFF
        default:
            // End:0x1E7
            break;
            break;
    }
    return none;
    return;
}

defaultproperties
{
    ItemEnemyPossessionMsg="THE ENEMY TEAM HAS THE BRIEFCASE! INTERCEPT THE CARRIER BEFORE HE REACHES THE EXTRACTION POINT!"
    ItemTeamPossessionMsg="YOUR TEAM HAS THE BRIEFCASE! PROTECT THE BRIEFCASE CARRIER!"
    ItemPlayerPossessionMsg="YOU HAVE THE BRIEFCASE, TAKE IT TO THE EXTRACTION POINT!"
    ItemLostTeamMsg="THE BRIEFCASE HAS BEEN DROPPED!"
    ItemLostEnemyMsg="PACKAGE NEUTRALIZED!"
    ItemDeliveredMsg="THE EXTRACTION POINT HAS BEEN REACHED!"
    Lifetime=5
}