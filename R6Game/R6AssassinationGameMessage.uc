class R6AssassinationGameMessage extends LocalMessage;

var const localized string AssassinationIsTheVIP;
var const localized string AssassinationVIPEscaped;
var const localized string AssassinationVIPKilled;

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string szTextMsg;
    local SoundCue sndVoiceMsg;
    local R6PlayerController PC;

    PC = R6PlayerController(P);
    switch(byte(Switch))
    {
        // End:0x22
        case 37:
        // End:0x27
        case 39:
        // End:0x166
        case 43:
            // End:0x163
            if(PC.m_MagmaInteraction != none)
            {
                szTextMsg = RetrieveString(PC, Switch, RelatedPRI_1 == P.PlayerReplicationInfo, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                PC.m_MagmaInteraction.ShowTextInformationBox(Caps(szTextMsg), GetLifeTime(Switch), GetColor(Switch, RelatedPRI_1, RelatedPRI_2));
                sndVoiceMsg = RetrieveSound(PC, Switch, RelatedPRI_1 == P.PlayerReplicationInfo, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                PC.StopSound(PC.GetPlayerInfo().GetGameStatusVoiceMsg());
                PC.PlaySound(sndVoiceMsg, 13, false, true);
                PC.GetPlayerInfo().SaveGameStatus(szTextMsg, sndVoiceMsg);
            }
            // End:0x16C
            break;
        // End:0xFFFF
        default:
            // End:0x16C
            break;
            break;
    }
    return;
}

static simulated function string RetrieveString(R6PlayerController PC, optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch(byte(Switch))
    {
        // End:0x19
        case 37:
            return default.AssassinationVIPEscaped;
        // End:0x24
        case 39:
            return default.AssassinationVIPKilled;
        // End:0xB9
        case 43:
            // End:0xB6
            if(RelatedPRI_1 != none)
            {
                // End:0x77
                if(PC.PlayerReplicationInfo.Team == RelatedPRI_1.Team)
                {
                    return RelatedPRI_1.PlayerName @ default.AssassinationIsTheVIP;                    
                }
                else
                {
                    return Localize("R6ObjectiveEscortPawn", "m_szTeamDescription[1]", "R6Game");
                }
            }
            // End:0xBF
            break;
        // End:0xFFFF
        default:
            // End:0xBF
            break;
            break;
    }
    return "";
    return;
}

static simulated function SoundCue RetrieveSound(R6PlayerController PC, optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    return none;
    return;
}

defaultproperties
{
    AssassinationIsTheVIP="IS THE V.I.P."
    AssassinationVIPEscaped="THE V.I.P. HAS ESCAPED."
    AssassinationVIPKilled="THE V.I.P. WAS KILLED."
    Lifetime=5
}