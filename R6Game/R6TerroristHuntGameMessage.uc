class R6TerroristHuntGameMessage extends LocalMessage;

var const localized string TerroristKilledMsg;
var const localized string TerroristsEliminatedMsg;

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string szMessageString;
    local R6PlayerController PC;

    PC = R6PlayerController(P);
    switch(byte(Switch))
    {
        // End:0x22
        case 41:
        // End:0xC6
        case 42:
            // End:0xC3
            if(PC.m_MagmaInteraction != none)
            {
                szMessageString = RetrieveString(PC, Switch, RelatedPRI_1 == P.PlayerReplicationInfo, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                szMessageString = Caps(szMessageString);
                PC.m_MagmaInteraction.ShowTextInformationBox(szMessageString, GetLifeTime(Switch), GetColor(Switch, RelatedPRI_1, RelatedPRI_2));
            }
            // End:0xCC
            break;
        // End:0xFFFF
        default:
            // End:0xCC
            break;
            break;
    }
    return;
}

static simulated function string RetrieveString(R6PlayerController PC, optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch(byte(Switch))
    {
        // End:0x1C
        case 41:
            return default.TerroristKilledMsg;
            // End:0x30
            break;
        // End:0x2A
        case 42:
            return default.TerroristsEliminatedMsg;
            // End:0x30
            break;
        // End:0xFFFF
        default:
            // End:0x30
            break;
            break;
    }
    return "";
    return;
}

defaultproperties
{
    TerroristKilledMsg="STILL OTHER TERRORISTS TO ELIMINATE..."
    TerroristsEliminatedMsg="ALL TERRORISTS HAVE BEEN ELIMINATED."
    Lifetime=5
}