class UTScriptedVoiceMessage extends UTLocalMessage
    abstract;

static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
    return SoundNodeWave(OptionalObject);
    //return ReturnValue;    
}

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    // End:0x9F
    if(SoundNodeWave(OptionalObject) != none)
    {
        super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
        UTPlayerController(P).PlayAnnouncement(default.Class, Switch, RelatedPRI_1, OptionalObject);
    }
    //return;    
}

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    return "";
    //return ReturnValue;    
}

static function byte AnnouncementLevel(byte MessageIndex)
{
    return 0;
    //return ReturnValue;    
}

defaultproperties
{
    bShowPortrait=true
    bIsConsoleMessage=false
}