class SPSuicideSelfMessage extends SPLocalMessage;

var(Message) const localized string KilledSelf;

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string Team2Tag, KilledByTag;

    Team2Tag = GetTeamTag(RelatedPRI_2.Team.TeamIndex);
    KilledByTag = GetKilledByTag(OptionalObject.Name);
    // End:0x86
    if((KilledByTag == "[FellToDeath]") || KilledByTag == "[Grenade]")
    {
        return default.KilledSelf;        
    }
    else
    {
        // End:0x95
        if(KilledByTag == "")
        {
            return "";
        }
    }
    return (KilledByTag @ Team2Tag) $ RelatedPRI_2.PlayerName;
    //return ReturnValue;    
}

defaultproperties
{
    KilledSelf="?Te has suicidado!"
    bIsUnique=true
    DrawColor=(R=255,G=0,B=0,A=255)
    FontSize=2
}