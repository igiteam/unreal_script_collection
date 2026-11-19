class EvilMultiKillMessage extends UTLocalMessage;

var const localized string KillString[5];
var SoundNodeWave KillSound[5];

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    return default.KillString[Min(Switch - 1, 4)];
    //return ReturnValue;    
}

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    // End:0x26
    if(P.GamePlayEndedState())
    {
    }
    // End:0x63
    if(Switch < 2)
    {
        UTPlayerController(P).ClientMusicEvent(9);        
    }
    else
    {
        // End:0xA0
        if(Switch < 4)
        {
            UTPlayerController(P).ClientMusicEvent(11);            
        }
        else
        {
            UTPlayerController(P).ClientMusicEvent(12);
        }
    }
    super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    UTPlayerController(P).PlayAnnouncement(default.Class, Min(Switch - 1, 4));
    //return;    
}

static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
    return default.KillSound[MessageIndex];
    //return ReturnValue;    
}

static function int GetFontSize(int Switch, PlayerReplicationInfo RelatedPRI1, PlayerReplicationInfo RelatedPRI2, PlayerReplicationInfo LocalPlayer)
{
    return Clamp(Switch, 2, 4);
    //return ReturnValue;    
}

static function bool ShouldBeRemoved(UTQueuedAnnouncement MyAnnouncement, class<UTLocalMessage> NewAnnouncementClass, int NewMessageIndex)
{
    return default.Class == NewAnnouncementClass;
    //return ReturnValue;    
}

static function bool AddAnnouncement(UTAnnouncer Announcer, int MessageIndex, optional PlayerReplicationInfo PRI, optional Object OptionalObject)
{
    super.AddAnnouncement(Announcer, MessageIndex, PRI, OptionalObject);
    return Announcer.PlayingAnnouncementClass == default.Class;
    //return ReturnValue;    
}

defaultproperties
{
    MessageArea=2
    AnnouncementPriority=8
    bIsUnique=true
    DrawColor=(R=255,G=0,B=0,A=255)
    FontSize=3
}