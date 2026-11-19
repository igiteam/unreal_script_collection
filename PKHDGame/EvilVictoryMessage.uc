class EvilVictoryMessage extends UTLocalMessage;

var SoundNodeWave VictorySounds[6];

static function byte AnnouncementLevel(byte MessageIndex)
{
    return 1;
    //return ReturnValue;    
}

static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
    return default.VictorySounds[MessageIndex];
    //return ReturnValue;    
}

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local UTHUD HUD;

    super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    HUD = UTHUD(P.myHUD);
    // End:0xA1
    if((HUD != none) && HUD.bIsSplitScreen)
    {
        return;
    }
    UTPlayerController(P).PlayAnnouncement(default.Class, Switch);
    //return;    
}

static function bool AddAnnouncement(UTAnnouncer Announcer, int MessageIndex, optional PlayerReplicationInfo PRI, optional Object OptionalObject)
{
    local UTQueuedAnnouncement RemovedAnnouncement;

    J0x02:
    // End:0xBB [Loop If]
    if(Announcer.Queue != none)
    {
        RemovedAnnouncement = Announcer.Queue;
        Announcer.Queue = Announcer.Queue.nextAnnouncement;
        RemovedAnnouncement.Destroy();
        // [Loop Continue]
        goto J0x02;
    }
    super.AddAnnouncement(Announcer, MessageIndex, PRI, OptionalObject);
    return Announcer.PlayingAnnouncementClass.static.KilledByVictoryMessage(Announcer.PlayingAnnouncementIndex);
    //return ReturnValue;    
}

defaultproperties
{
    MessageArea=2
}