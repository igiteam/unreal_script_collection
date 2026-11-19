class SkyVictoryMessage extends SkyLocalMessage;

var name VictorySoundName[6];

static function byte AnnouncementLevel(byte MessageIndex)
{
    return 2;
    //return ReturnValue;    
}

static function name AnnouncementSound(byte MessageIndex, optional Object OptionalObject)
{
    return default.VictorySoundName[int(MessageIndex)];
    //return ReturnValue;    
}

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    SkyPlayerController(P).SPlayAnnouncement(default.Class, byte(Switch));
    //return;    
}

static function PrecacheGameAnnouncements(SkyAnnouncer Announcer, class<GameInfo> GameClass)
{
    Announcer.PrecacheStatusSound(default.VictorySoundName[0]);
    Announcer.PrecacheStatusSound(default.VictorySoundName[1]);
    // End:0x84
    if(GameClass.default.bTeamGame)
    {
        Announcer.PrecacheStatusSound(default.VictorySoundName[4]);
        Announcer.PrecacheStatusSound(default.VictorySoundName[5]);        
    }
    else
    {
        Announcer.PrecacheStatusSound(default.VictorySoundName[2]);
        Announcer.PrecacheStatusSound(default.VictorySoundName[3]);
    }
    //return;    
}
