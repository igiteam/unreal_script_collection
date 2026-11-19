class EvilKillerMessage extends EvilWeaponKillMessage;

var(Message) const localized string YouKilled;
var(Message) const localized string YouKilledTrailer;
var(Message) const localized string YouTeamKilled;
var(Message) const localized string YouTeamKilledTrailer;
var(Message) const localized string OtherKilledPrefix;
var(Message) const localized string OtherKilled;
var(Message) const localized string OtherKilledTrailer;

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    // End:0x41
    if((RelatedPRI_1 == none) || RelatedPRI_2.PlayerName == "")
    {
        return "";        
    }
    else
    {
        // End:0x123
        if(bPRI1HUD)
        {
            return (((RelatedPRI_1.Team == none) || RelatedPRI_1.Team != RelatedPRI_2.Team) ? (default.YouKilled @ RelatedPRI_2.PlayerName) @ default.YouKilledTrailer : (default.YouTeamKilled @ RelatedPRI_2.PlayerName) @ default.YouTeamKilledTrailer);            
        }
        else
        {
            return (((default.OtherKilledPrefix @ RelatedPRI_1.PlayerName) @ default.OtherKilled) @ RelatedPRI_2.PlayerName) @ default.OtherKilledTrailer;
        }
    }
    //return ReturnValue;    
}

defaultproperties
{
    bIsUnique=true
    FontSize=2
}