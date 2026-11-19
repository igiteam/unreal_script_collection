class R6ConquestGameMessage extends LocalMessage;

var const localized string ConquestTeamControlMsg;
var const localized string ConquestEnemyControlMsg;
var const localized string ConquestTeamHasCapturedMsg;
var const localized string ConquestEnemyHasCapturedMsg;
var const localized string ConquestYouHaveCapturedMsg;

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string szTextMsg;
    local SoundCue sndVoiceMsg;
    local R6PlayerController PC;

    PC = R6PlayerController(P);
    switch(byte(Switch))
    {
        // End:0x22
        case 34:
        // End:0x161
        case 35:
            // End:0x15E
            if(PC.m_MagmaInteraction != none)
            {
                szTextMsg = RetrieveString(PC, Switch, RelatedPRI_1 == P.PlayerReplicationInfo, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                PC.m_MagmaInteraction.ShowTextInformationBox(Caps(szTextMsg), GetLifeTime(Switch), GetColor(Switch, RelatedPRI_1, RelatedPRI_2));
                sndVoiceMsg = RetrieveSound(PC, Switch, RelatedPRI_1 == P.PlayerReplicationInfo, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                PC.StopSound(PC.GetPlayerInfo().GetGameStatusVoiceMsg());
                PC.PlaySound(sndVoiceMsg, 13, false, true);
                PC.GetPlayerInfo().SaveGameStatus(szTextMsg, sndVoiceMsg);
            }
            // End:0x167
            break;
        // End:0xFFFF
        default:
            // End:0x167
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
        case 35:
            // End:0x57
            if(RelatedPRI_1 != none)
            {
                // End:0x51
                if(PC.PlayerReplicationInfo.Team == RelatedPRI_1.Team)
                {
                    return default.ConquestTeamControlMsg;                    
                }
                else
                {
                    return default.ConquestEnemyControlMsg;
                }
            }
            // End:0xCD
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
                        return default.ConquestYouHaveCapturedMsg;                        
                    }
                    else
                    {
                        return default.ConquestTeamHasCapturedMsg;
                    }                    
                }
                else
                {
                    return default.ConquestEnemyHasCapturedMsg;
                }
            }
            // End:0xCD
            break;
        // End:0xFFFF
        default:
            // End:0xCD
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
    ConquestTeamControlMsg="YOUR TEAM IS CONTROLLING ALL THE SATELLITE INSTALLATIONS. DEFEND THEM."
    ConquestEnemyControlMsg="THE ENEMY TEAM IS CONTROLLING ALL THE SATELLITE INSTALLATIONS."
    ConquestTeamHasCapturedMsg="YOUR TEAM CAPTURED A SATELLITE INSTALLATION."
    ConquestEnemyHasCapturedMsg="THE ENEMY TEAM CAPTURED A SATELLITE INSTALLATION."
    ConquestYouHaveCapturedMsg="YOU CAPTURED A SATELLITE INSTALLATION."
    Lifetime=5
}