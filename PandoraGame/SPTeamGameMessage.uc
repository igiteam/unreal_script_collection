class SPTeamGameMessage extends GameMessage;

var const localized string Council;
var const localized string BlackOrder;

static function string GetTeamName(PlayerReplicationInfo RelatedPRI_1)
{
    local string strResult;

    // End:0x69
    if(RelatedPRI_1.Team != none)
    {
        // End:0x50
        if(RelatedPRI_1.Team.TeamIndex == 1)
        {
            strResult = ("[1]" $ default.Council) $ "[0]";            
        }
        else
        {
            strResult = ("[2]" $ default.BlackOrder) $ "[0]";
        }
    }
    return strResult;
    //return ReturnValue;    
}

static function string GetTeamCountString(PlayerReplicationInfo RelatedPRI_1)
{
    local string strResult;
    local int CouncilTeamSize, BlackOrderTeamSize, I;
    local PlayerReplicationInfo PRI;

    I = 0;
    J0x07:

    // End:0xD7 [Loop If]
    if(I < RelatedPRI_1.WorldInfo.GRI.PRIArray.Length)
    {
        PRI = RelatedPRI_1.WorldInfo.GRI.PRIArray[I];
        // End:0xCD
        if(((PRI != none) && PRI.Team != none) && !PRI.bBot)
        {
            // End:0xC6
            if(PRI.Team.TeamIndex == 1)
            {
                CouncilTeamSize++;
                // [Explicit Continue]
                goto J0xCD;
            }
            BlackOrderTeamSize++;
        }
        J0xCD:

        I++;
        // [Loop Continue]
        goto J0x07;
    }
    strResult = ((((((((("[1]" $ default.Council) $ ":") $ "[0]") $ string(CouncilTeamSize)) $ ", ") $ "[2]") $ default.BlackOrder) $ ":") $ "[0]") $ string(BlackOrderTeamSize);
    return strResult;
    //return ReturnValue;    
}

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch(Switch)
    {
        // End:0x1A
        case 0:
            return default.OvertimeMessage;
            // End:0x231
            break;
        // End:0x4E
        case 1:
            // End:0x2F
            if(RelatedPRI_1 == none)
            {
                return default.NewPlayerMessage;
            }
            return RelatedPRI_1.GetPlayerAlias() $ default.EnteredMessage;
            // End:0x231
            break;
        // End:0x91
        case 2:
            // End:0x61
            if(RelatedPRI_1 == none)
            {
                return "";
            }
            return (RelatedPRI_1.OldName @ default.GlobalNameChange) @ RelatedPRI_1.GetPlayerAlias();
            // End:0x231
            break;
        // End:0xDB
        case 3:
            // End:0xA4
            if(RelatedPRI_1 == none)
            {
                return "";
            }
            return ((RelatedPRI_1.GetPlayerAlias() @ default.NewTeamMessage) @ (GetTeamName(RelatedPRI_1))) $ default.NewTeamMessageTrailer;
            // End:0x231
            break;
        // End:0x10D
        case 4:
            // End:0xEE
            if(RelatedPRI_1 == none)
            {
                return "";
            }
            return RelatedPRI_1.GetPlayerAlias() $ default.LeftMessage;
            // End:0x231
            break;
        // End:0x11B
        case 5:
            return default.SwitchLevelMessage;
            // End:0x231
            break;
        // End:0x129
        case 6:
            return default.FailedTeamMessage;
            // End:0x231
            break;
        // End:0x137
        case 7:
            return default.MaxedOutMessage;
            // End:0x231
            break;
        // End:0x145
        case 8:
            return default.NoNameChange;
            // End:0x231
            break;
        // End:0x169
        case 9:
            return RelatedPRI_1.GetPlayerAlias() @ default.VoteStarted;
            // End:0x231
            break;
        // End:0x177
        case 10:
            return default.VotePassed;
            // End:0x231
            break;
        // End:0x185
        case 11:
            return default.MustHaveStats;
            // End:0x231
            break;
        // End:0x193
        case 12:
            return default.CantBeSpectator;
            // End:0x231
            break;
        // End:0x1A1
        case 13:
            return default.CantBePlayer;
            // End:0x231
            break;
        // End:0x1C5
        case 14:
            return RelatedPRI_1.GetPlayerAlias() @ default.BecameSpectator;
            // End:0x231
            break;
        // End:0x1D3
        case 15:
            return default.KickWarning;
            // End:0x231
            break;
        // End:0x208
        case 16:
            // End:0x1E9
            if(RelatedPRI_1 == none)
            {
                return default.NewSpecMessage;
            }
            return RelatedPRI_1.GetPlayerAlias() $ default.SpecEnteredMessage;
            // End:0x231
            break;
        // End:0x22E
        case 17:
            // End:0x21B
            if(RelatedPRI_1 == none)
            {
                return "";
            }
            return GetTeamCountString(RelatedPRI_1);
            // End:0x231
            break;
        // End:0xFFFF
        default:
            break;
    }
    return "";
    //return ReturnValue;    
}

defaultproperties
{
    Council="Consejo del 98"
    BlackOrder="La Orden oscura"
}