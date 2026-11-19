class R6CoopLeashingGameMessage extends LocalMessage;

var const localized string TooFarFromLeaderMsg;

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string szMessageString;

    switch(byte(Switch))
    {
        // End:0xBF
        case 46:
            // End:0xBC
            if(R6PlayerController(P).m_MagmaInteraction != none)
            {
                szMessageString = GetString(Switch, RelatedPRI_1 == P.PlayerReplicationInfo, RelatedPRI_1, P.PlayerReplicationInfo, OptionalObject);
                szMessageString = Caps(szMessageString);
                R6PlayerController(P).m_MagmaInteraction.ShowTextInformationBox(szMessageString, GetLifeTime(Switch), GetColor(Switch, RelatedPRI_1, RelatedPRI_2));
            }
            // End:0xC5
            break;
        // End:0xFFFF
        default:
            // End:0xC5
            break;
            break;
    }
    return;
}

static simulated function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch(byte(Switch))
    {
        // End:0x1C
        case 46:
            return default.TooFarFromLeaderMsg;
            // End:0x22
            break;
        // End:0xFFFF
        default:
            // End:0x22
            break;
            break;
    }
    return "";
    return;
}

defaultproperties
{
    TooFarFromLeaderMsg="YOU ARE TOO FAR AWAY FROM YOUR TEAMMATES; RELOCATION IMMINENT."
}