class SkyBountyMessage extends SkyLocalMessage;

var const localized string BountyMessage;

static function byte AnnouncementLevel(byte MessageIndex)
{
    return 2;
    //return ReturnValue;    
}

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string Temp;

    // End:0x60
    if(RelatedPRI_1 != none)
    {
        Temp = default.BountyMessage;
        Temp = Repl(Temp, "%p", RelatedPRI_1.PlayerName);
        Temp = Repl(Temp, "$$", "$" $ string(Switch));
        return Temp;
    }
    return super(LocalMessage).GetString(Switch, bPRI1HUD, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    //return ReturnValue;    
}
