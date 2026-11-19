class UTLocalMessage extends LocalMessage
    abstract;

var int MessageArea;
var int AnnouncementPriority;
var bool bShowPortrait;
var float AnnouncementVolume;
var float AnnouncementDelay;

static function byte AnnouncementLevel(byte MessageIndex)
{
    return 1;
    //return ReturnValue;    
}

static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
    //return ReturnValue;    
}

static function bool ShouldBeRemoved(UTQueuedAnnouncement MyAnnouncement, class<UTLocalMessage> NewAnnouncementClass, int NewMessageIndex)
{
    return false;
    //return ReturnValue;    
}

static function bool AddAnnouncement(UTAnnouncer Announcer, int MessageIndex, optional PlayerReplicationInfo PRI, optional Object OptionalObject)
{
    local UTQueuedAnnouncement NewAnnouncement, A, RemovedAnnouncement;
    local bool bPlacedAnnouncement;

    NewAnnouncement = Announcer.Spawn(Class'UTQueuedAnnouncement');
    NewAnnouncement.AnnouncementClass = default.Class;
    NewAnnouncement.MessageIndex = MessageIndex;
    NewAnnouncement.PRI = PRI;
    NewAnnouncement.OptionalObject = OptionalObject;
    // End:0x20E
    if((Announcer.Queue != none) && Announcer.Queue.AnnouncementClass.static.ShouldBeRemoved(Announcer.Queue, default.Class, MessageIndex))
    {
        RemovedAnnouncement = Announcer.Queue;
        Announcer.Queue = Announcer.Queue.nextAnnouncement;
        RemovedAnnouncement.Destroy();
    }
    // End:0x29A
    if(Announcer.Queue == none)
    {
        NewAnnouncement.nextAnnouncement = Announcer.Queue;
        Announcer.Queue = NewAnnouncement;        
    }
    else
    {
        // End:0x361
        if(default.AnnouncementPriority > Announcer.Queue.AnnouncementClass.default.AnnouncementPriority)
        {
            NewAnnouncement.nextAnnouncement = Announcer.Queue;
            Announcer.Queue = NewAnnouncement;
            bPlacedAnnouncement = true;
        }
        A = Announcer.Queue;
        J0x389:

        // End:0x668 [Loop If]
        if(A != none)
        {
            // End:0x3F6
            if(A.nextAnnouncement == none)
            {
                // End:0x3F3
                if(!bPlacedAnnouncement)
                {
                    A.nextAnnouncement = NewAnnouncement;
                }
                // [Explicit Break]
                goto J0x668;
            }
            // End:0x4D1
            if(!bPlacedAnnouncement && default.AnnouncementPriority > A.nextAnnouncement.AnnouncementClass.default.AnnouncementPriority)
            {
                bPlacedAnnouncement = true;
                NewAnnouncement.nextAnnouncement = A.nextAnnouncement;
                A.nextAnnouncement = NewAnnouncement;                
            }
            else
            {
                // End:0x63D
                if(A.nextAnnouncement.AnnouncementClass.static.ShouldBeRemoved(A.nextAnnouncement, default.Class, MessageIndex))
                {
                    RemovedAnnouncement = A.nextAnnouncement;
                    A.nextAnnouncement = A.nextAnnouncement.nextAnnouncement;
                    // End:0x625
                    if(A.nextAnnouncement == none)
                    {
                        // End:0x622
                        if(!bPlacedAnnouncement)
                        {
                            A.nextAnnouncement = NewAnnouncement;
                        }
                        // [Explicit Break]
                        goto J0x668;
                    }
                    RemovedAnnouncement.Destroy();
                }
            }
            A = A.nextAnnouncement;
            // [Loop Continue]
            goto J0x389;
        }
    }
    J0x668:

    return false;
    //return ReturnValue;    
}

static function float GetPos(int Switch, HUD myHUD)
{
    return ((UTHUD(myHUD) != none) ? UTHUD(myHUD).MessageOffset[default.MessageArea] : 0.5000000);
    //return ReturnValue;    
}

static function bool KilledByVictoryMessage(int AnnouncementIndex)
{
    return default.AnnouncementPriority < 6;
    //return ReturnValue;    
}

defaultproperties
{
    MessageArea=1
    AnnouncementVolume=2.0000000
}