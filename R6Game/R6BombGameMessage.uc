class R6BombGameMessage extends LocalMessage;

var const localized string BombDefusedMsg;
var const localized string BombExplodedMsg;
var const localized string TeamBombExplodedMsg;

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string szTextMsg;
    local SoundCue sndVoiceMsg;
    local R6PlayerController PC;

    PC = R6PlayerController(P);
    switch(byte(Switch))
    {
        // End:0x22
        case 23:
        // End:0x168
        case 24:
            // End:0x165
            if(PC.m_MagmaInteraction != none)
            {
                szTextMsg = RetrieveString(PC, Switch, RelatedPRI_1 == P.PlayerReplicationInfo, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                PC.m_MagmaInteraction.ShowGameMessage(byte(Switch), Caps(szTextMsg), GetLifeTime(Switch), GetColor(Switch, RelatedPRI_1, RelatedPRI_2));
                sndVoiceMsg = RetrieveSound(PC, Switch, RelatedPRI_1 == P.PlayerReplicationInfo, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                PC.StopSound(PC.GetPlayerInfo().GetGameStatusVoiceMsg());
                PC.PlaySound(sndVoiceMsg, 13, false, true);
                PC.GetPlayerInfo().SaveGameStatus(szTextMsg, sndVoiceMsg);
            }
            // End:0x16E
            break;
        // End:0xFFFF
        default:
            // End:0x16E
            break;
            break;
    }
    return;
}

static simulated function string RetrieveString(R6PlayerController PC, optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local R6GameEnums.ETEAMIDENTITY ePlayerTeam;

    ePlayerTeam = PC.GetTeamNum();
    switch(byte(Switch))
    {
        // End:0x75
        case 23:
            // End:0x57
            if(int(ePlayerTeam) == int(0))
            {
                return (Class'R6ObjectiveBomb'.default.m_szMsgSuccess $ "\n") $ default.BombDefusedMsg;                
            }
            else
            {
                return (Class'R6ObjectiveBomb'.default.m_szMsgSuccess $ "\n") $ default.TeamBombExplodedMsg;
            }
            // End:0xCC
            break;
        // End:0xC6
        case 24:
            // End:0xA8
            if(int(ePlayerTeam) == int(0))
            {
                return (Class'R6ObjectiveBomb'.default.m_szMsgFailure $ "\n") $ default.BombExplodedMsg;                
            }
            else
            {
                return (Class'R6ObjectiveBomb'.default.m_szMsgFailure $ "\n") $ default.BombDefusedMsg;
            }
            // End:0xCC
            break;
        // End:0xFFFF
        default:
            // End:0xCC
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
        // End:0x71
        case 23:
            // End:0x55
            if(int(ePlayerTeam) == int(0))
            {
                return PC.GetMiscConfig().m_sndAttackerBombDefused;                
            }
            else
            {
                return PC.GetMiscConfig().m_sndDefenderBombExploded;
            }
            // End:0xC4
            break;
        // End:0xBE
        case 24:
            // End:0xA2
            if(int(ePlayerTeam) == int(0))
            {
                return PC.GetMiscConfig().m_sndAttackerBombExploded;                
            }
            else
            {
                return PC.GetMiscConfig().m_sndDefenderBombDefused;
            }
            // End:0xC4
            break;
        // End:0xFFFF
        default:
            // End:0xC4
            break;
            break;
    }
    return none;
    return;
}

defaultproperties
{
    BombDefusedMsg="BOMB NEUTRALIZED!"
    BombExplodedMsg="THE BOMB EXPLODED!"
    TeamBombExplodedMsg="TARGET ELIMINATED!"
    Lifetime=5
}