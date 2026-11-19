class SkyVictimMessage extends SkyLocalMessage;

var(Message) const localized string YouWereKilledBy;
var(Message) const localized string KilledByTrailer;

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    // End:0x13
    if(RelatedPRI_1 == none)
    {
        return "";
    }
    // End:0x47
    if(RelatedPRI_1.PlayerName != "")
    {
        return (default.YouWereKilledBy @ RelatedPRI_1.PlayerName) $ default.KilledByTrailer;
    }
    //return ReturnValue;    
}
