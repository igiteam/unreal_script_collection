class R6HostageRescueGameMessage extends LocalMessage;

var const localized string HostageDeathMsg;
var const localized string AllHostagesDeathMsg;
var const localized string HostageRescueMsg;
var const localized string HostageIncapacitateMsg;
var const localized string HostageEscortMsg;
var const localized string HostageEscortTeamMsg;
var const localized string HostageEscortEnemyMsg;
var const localized string AttackerKilledHostageMsg;
var const localized string DefenderKilledHostageMsg;

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string szTextMsg;
    local SoundCue sndVoiceMsg;
    local R6PlayerController PC;
    local int iHostageEscorted;

    iHostageEscorted = 37;
    PC = R6PlayerController(P);
    switch(byte(Switch))
    {
        // End:0x2A
        case 37:
        // End:0x2F
        case 38:
        // End:0x34
        case 39:
        // End:0x173
        case 40:
            // End:0x170
            if(PC.m_MagmaInteraction != none)
            {
                szTextMsg = RetrieveString(PC, Switch, RelatedPRI_1 == P.PlayerReplicationInfo, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                PC.m_MagmaInteraction.ShowTextInformationBox(Caps(szTextMsg), GetLifeTime(Switch), GetColor(Switch, RelatedPRI_1, RelatedPRI_2));
                sndVoiceMsg = RetrieveSound(PC, Switch, RelatedPRI_1 == P.PlayerReplicationInfo, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                PC.StopSound(PC.GetPlayerInfo().GetGameStatusVoiceMsg());
                PC.PlaySound(sndVoiceMsg, 3, false, true);
                PC.GetPlayerInfo().SaveGameStatus(szTextMsg, sndVoiceMsg);
            }
            // End:0x3D7
            break;
        // End:0x22B
        case 48:
            // End:0x228
            if(PC.m_MagmaInteraction != none)
            {
                szTextMsg = RetrieveString(PC, iHostageEscorted, RelatedPRI_1 == P.PlayerReplicationInfo, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                PC.m_MagmaInteraction.ShowTextInformationBox(Caps(szTextMsg), GetLifeTime(iHostageEscorted), GetColor(iHostageEscorted, RelatedPRI_1, RelatedPRI_2));
                PC.GetPlayerInfo().m_szGameStatusTextMsg = szTextMsg;
            }
            // End:0x3D7
            break;
        // End:0x230
        case 23:
        // End:0x3D1
        case 24:
            // End:0x3CE
            if(PC.m_MagmaInteraction != none)
            {
                szTextMsg = RetrieveString(PC, Switch, RelatedPRI_1 == P.PlayerReplicationInfo, RelatedPRI_1, P.PlayerReplicationInfo, OptionalObject);
                PC.m_MagmaInteraction.ShowGameMessage(byte(Switch), Caps(szTextMsg), GetLifeTime(Switch));
                sndVoiceMsg = PC.GetPlayerInfo().GetGameStatusVoiceMsg();
                // End:0x3A9
                if((sndVoiceMsg != PC.GetMiscConfig().m_sndAttackerHostageDeath) && sndVoiceMsg != PC.GetMiscConfig().m_sndDefenderHostageDeath)
                {
                    sndVoiceMsg = RetrieveSound(PC, Switch, RelatedPRI_1 == P.PlayerReplicationInfo, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                    PC.StopSound(PC.GetPlayerInfo().GetGameStatusVoiceMsg());
                    PC.PlaySound(sndVoiceMsg, 13, false, true);
                }
                PC.GetPlayerInfo().SaveGameStatus(szTextMsg, sndVoiceMsg);
            }
            // End:0x3D7
            break;
        // End:0xFFFF
        default:
            // End:0x3D7
            break;
            break;
    }
    return;
}

static simulated function string RetrieveString(R6PlayerController PC, optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local R6GameEnums.ETEAMIDENTITY eTeam;

    switch(byte(Switch))
    {
        // End:0x8B
        case 37:
            // End:0x88
            if(RelatedPRI_1 != none)
            {
                // End:0x82
                if(PC.PlayerReplicationInfo.Team == RelatedPRI_1.Team)
                {
                    // End:0x69
                    if(PC.PlayerReplicationInfo == RelatedPRI_1)
                    {
                        return default.HostageEscortMsg;                        
                    }
                    else
                    {
                        return RelatedPRI_1.PlayerName @ default.HostageEscortTeamMsg;
                    }                    
                }
                else
                {
                    return default.HostageEscortEnemyMsg;
                }
            }
            // End:0x196
            break;
        // End:0x99
        case 38:
            return default.HostageRescueMsg;
            // End:0x196
            break;
        // End:0x154
        case 39:
            LogInternal((("Hostage killed RelatedPRI_1=" @ string(RelatedPRI_1)) @ ",RelatedPRI_1.Team=") @ string(RelatedPRI_1.Team));
            // End:0x151
            if((RelatedPRI_1 != none) && RelatedPRI_1.Team != none)
            {
                eTeam = byte(RelatedPRI_1.Team.TeamIndex);
                // End:0x14B
                if(int(eTeam) == int(0))
                {
                    return default.AttackerKilledHostageMsg;                    
                }
                else
                {
                    return default.DefenderKilledHostageMsg;
                }
            }
            // End:0x196
            break;
        // End:0x162
        case 40:
            return default.AllHostagesDeathMsg;
            // End:0x196
            break;
        // End:0x179
        case 23:
            return Class'R6ObjectiveHostageRescue'.default.m_szMsgSuccess;
            // End:0x196
            break;
        // End:0x190
        case 24:
            return Class'R6ObjectiveHostageRescue'.default.m_szMsgFailure;
            // End:0x196
            break;
        // End:0xFFFF
        default:
            // End:0x196
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
        case 38:
            // End:0x55
            if(int(ePlayerTeam) == int(0))
            {
                return PC.GetMiscConfig().m_sndAttackerHostageRescued;                
            }
            else
            {
                return PC.GetMiscConfig().m_sndDefenderHostageRescued;
            }
            // End:0x1B1
            break;
        // End:0xBE
        case 39:
            // End:0xA2
            if(int(ePlayerTeam) == int(0))
            {
                return PC.GetMiscConfig().m_sndAttackerHostageDeath;                
            }
            else
            {
                return PC.GetMiscConfig().m_sndDefenderHostageDeath;
            }
            // End:0x1B1
            break;
        // End:0x10B
        case 40:
            // End:0xEF
            if(int(ePlayerTeam) == int(0))
            {
                return PC.GetMiscConfig().m_sndAttackerAllHostagesDeath;                
            }
            else
            {
                return PC.GetMiscConfig().m_sndDefenderAllHostagesDeath;
            }
            // End:0x1B1
            break;
        // End:0x15B
        case 23:
            // End:0x13C
            if(int(ePlayerTeam) == int(0))
            {
                return PC.GetMiscConfig().m_sndAttackerAllHostagesRescued;                
            }
            else
            {
                return PC.GetMiscConfig().m_sndDefenderNoHostagesRescued;
            }
            // End:0x1B1
            break;
            // End:0x1B1
            break;
        // End:0x1AB
        case 24:
            // End:0x18C
            if(int(ePlayerTeam) == int(0))
            {
                return PC.GetMiscConfig().m_sndAttackerNoHostagesRescued;                
            }
            else
            {
                return PC.GetMiscConfig().m_sndDefenderAllHostagesRescued;
            }
            // End:0x1B1
            break;
            // End:0x1B1
            break;
        // End:0xFFFF
        default:
            // End:0x1B1
            break;
            break;
    }
    return none;
    return;
}

defaultproperties
{
    HostageDeathMsg="HOSTAGE HAS BEEN KILLED."
    AllHostagesDeathMsg="ALL HOSTAGES HAVE BEEN EXECUTED."
    HostageRescueMsg="HOSTAGE HAS BEEN RESCUED."
    HostageIncapacitateMsg="HOSTAGE DOWN."
    HostageEscortMsg="YOU'RE ESCORTING A HOSTAGE. PROCEED TO EXTRACTION POINT."
    HostageEscortTeamMsg="IS ESCORTING A HOSTAGE. COVER HIM!"
    HostageEscortEnemyMsg="ENEMY IS ESCORTING A HOSTAGE."
    AttackerKilledHostageMsg="ATTACKERS HAVE KILLED A HOSTAGE."
    DefenderKilledHostageMsg="DEFENDERS HAVE KILLED A HOSTAGE."
    Lifetime=5
}