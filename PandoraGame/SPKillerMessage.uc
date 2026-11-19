class SPKillerMessage extends SPLocalMessage;

var(Message) const localized string YouKilled;
var(Message) const localized string YouKilledTrailer;
var(Message) const localized string OtherKilledPrefix;
var(Message) const localized string OtherKilled;
var(Message) const localized string OtherKilledTrailer;

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string Team1Tag, Team2Tag, KilledByTag, WerewolfString;

    Team1Tag = GetTeamTag(RelatedPRI_1.Team.TeamIndex);
    Team2Tag = GetTeamTag(RelatedPRI_2.Team.TeamIndex);
    KilledByTag = GetKilledByTag(OptionalObject.Name);
    // End:0x9F
    if((RelatedPRI_1 == none) || RelatedPRI_2.PlayerName == "")
    {
        return "";        
    }
    else
    {
        WerewolfString = Localize("SPBaseWerewolfAIController", "PlayerName", "PandoraGame");
        // End:0x126
        if(Team1Tag == "")
        {
            return ((((Team1Tag $ WerewolfString) $ "[0]") @ KilledByTag) @ Team2Tag) $ RelatedPRI_2.PlayerName;            
        }
        else
        {
            // End:0x165
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
    YouKilled="Has matado a"
    OtherKilled="ha matado a"
    FontSize=2
}