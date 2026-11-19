class SkyKillerMessage extends SkyLocalMessage;

var(Message) const localized string YouKilled;
var(Message) const localized string YouKilledTrailer;

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    // End:0x13
    if(RelatedPRI_1 == none)
    {
        return "";
    }
    // End:0x47
    if(RelatedPRI_2.PlayerName != "")
    {
        return (default.YouKilled @ RelatedPRI_2.PlayerName) @ default.YouKilledTrailer;
    }
    //return ReturnValue;    
}
