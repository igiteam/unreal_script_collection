class SPSuicideOthersMessage extends SPLocalMessage;

var(Message) const localized string KilledSelf;

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string Team2Tag, KilledByTag;

    Team2Tag = GetTeamTag(RelatedPRI_2.Team.TeamIndex);
    KilledByTag = GetKilledByTag(OptionalObject.Name);
    // End:0xF5
    if((RelatedPRI_2 != none) && RelatedPRI_2.PlayerName != "")
    {
        // End:0xC8
        if((KilledByTag == "[FellToDeath]") || KilledByTag == "[Grenade]")
        {
            return ((Team2Tag $ RelatedPRI_2.PlayerName) $ "[0]") @ default.KilledSelf;            
        }
        else
        {
            // End:0xD7
            if(KilledByTag == "")
            {
                return "";
            }
        }
        return (KilledByTag @ Team2Tag) $ RelatedPRI_2.PlayerName;
    }
    //return ReturnValue;    
}

defaultproperties
{
    KilledSelf="?se ha suicidado!"
    DrawColor=(R=255,G=0,B=0,A=255)
    FontSize=2
}