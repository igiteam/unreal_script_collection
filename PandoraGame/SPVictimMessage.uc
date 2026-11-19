class SPVictimMessage extends SPLocalMessage;

var(Message) const localized string YouWereKilledBy;
var(Message) const localized string KilledByTrailer;

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string Team1Tag, Team2Tag, KilledByTag, WerewolfString;

    Team1Tag = GetTeamTag(RelatedPRI_1.Team.TeamIndex);
    Team2Tag = GetTeamTag(RelatedPRI_2.Team.TeamIndex);
    // End:0x65
    if(RelatedPRI_1 == none)
    {
        return "";
    }
    KilledByTag = GetKilledByTag(OptionalObject.Name);
    // End:0x1B5
    if((RelatedPRI_1.PlayerName != "") && RelatedPRI_2.PlayerName != "")
    {
        WerewolfString = Localize("SPBaseWerewolfAIController", "PlayerName", "PandoraGame");
        // End:0x139
        if(Team1Tag == "")
        {
            return ((((Team1Tag $ WerewolfString) $ "[0]") @ KilledByTag) @ Team2Tag) $ RelatedPRI_2.PlayerName;            
        }
        else
        {
            // End:0x178
            if(Team2Tag == "")
            {
                return ((((Team1Tag $ RelatedPRI_1.PlayerName) $ "[0]") @ KilledByTag) @ Team2Tag) $ WerewolfString;
            }
        }
        return ((((Team1Tag $ RelatedPRI_1.PlayerName) $ "[0]") @ KilledByTag) @ Team2Tag) $ RelatedPRI_2.PlayerName;
    }
    //return ReturnValue;    
}

defaultproperties
{
    YouWereKilledBy="?Te ha matado"
    KilledByTrailer="!"
    DrawColor=(R=255,G=0,B=0,A=255)
    FontSize=2
}