class SkyMultiKillMessage extends SkyLocalMessage;

var const localized string KillString[6];
var name KillSoundName[6];

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    // End:0x2E
    if(Class'SkyPlayerController'.default.bNoMatureLanguage)
    {
        return default.KillString[Min(Switch, 6) - 1];        
    }
    else
    {
        return default.KillString[Min(Switch, 7) - 1];
    }
    //return ReturnValue;    
}

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    // End:0x21
    if(P.GamePlayEndedState())
    {
        ScriptTrace();
    }
    super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    // End:0x83
    if(Class'SkyPlayerController'.default.bNoMatureLanguage)
    {
        SkyPlayerController(P).SPlayAnnouncement(default.Class, byte(Min(Switch - 1, 4)));        
    }
    else
    {
        SkyPlayerController(P).SPlayAnnouncement(default.Class, byte(Min(Switch - 1, 5)));
    }
    //return;    
}

static function name AnnouncementSound(byte MessageIndex, optional Object OptionalObject)
{
    return default.KillSoundName[int(MessageIndex)];
    //return ReturnValue;    
}

static function bool IsRewardAnnouncement(byte MessageIndex)
{
    return true;
    //return ReturnValue;    
}

static function int GetFontSize(int Switch, PlayerReplicationInfo RelatedPRI1, PlayerReplicationInfo RelatedPRI2, PlayerReplicationInfo LocalPlayer)
{
    // End:0x0E
    if(Switch < 4)
    {
        return 1;
    }
    // End:0x1C
    if(Switch == 4)
    {
        return 1;
    }
    // End:0x2B
    if(Switch == 7)
    {
        return 3;
    }
    return 2;
    //return ReturnValue;    
}
