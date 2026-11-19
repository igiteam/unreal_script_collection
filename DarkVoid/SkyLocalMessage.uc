class SkyLocalMessage extends LocalMessage
    abstract;

static function byte AnnouncementLevel(byte MessageIndex)
{
    return 1;
    //return ReturnValue;    
}

static function bool IsRewardAnnouncement(byte MessageIndex)
{
    return false;
    //return ReturnValue;    
}

static function name AnnouncementSound(byte MessageIndex, optional Object OptionalObject)
{
    return 'None';
    //return ReturnValue;    
}

static function bool ShouldBeRemoved(int MyMessageIndex, class<SkyLocalMessage> NewAnnouncementClass, int NewMessageIndex)
{
    return false;
    //return ReturnValue;    
}

static function AddAnnouncement(SkyAnnouncer Announcer, byte MessageIndex, optional Object OptionalObject)
{
    local SkyQueuedAnnouncement NewAnnouncement, A, RemovedAnnouncement;

    NewAnnouncement = Announcer.Spawn(Class'SkyQueuedAnnouncement');
    NewAnnouncement.AnnouncementClass = default.Class;
    NewAnnouncement.MessageIndex = MessageIndex;
    NewAnnouncement.OptionalObject = OptionalObject;
    // End:0x115
    if((Announcer.Queue != none) && Announcer.Queue.AnnouncementClass.static.ShouldBeRemoved(int(Announcer.Queue.MessageIndex), default.Class, int(MessageIndex)))
    {
        RemovedAnnouncement = Announcer.Queue;
        Announcer.Queue = Announcer.Queue.nextAnnouncement;
        RemovedAnnouncement.Destroy();
    }
    // End:0x161
    if(Announcer.Queue == none)
    {
        NewAnnouncement.nextAnnouncement = Announcer.Queue;
        Announcer.Queue = NewAnnouncement;        
    }
    else
    {
        A = Announcer.Queue;
        J0x176:

        // End:0x266 [Loop If]
        if(A != none)
        {
            // End:0x1B1
            if(A.nextAnnouncement == none)
            {
                A.nextAnnouncement = NewAnnouncement;
                // [Explicit Break]
                goto J0x266;                
            }
            else
            {
                // End:0x24E
                if(A.nextAnnouncement.AnnouncementClass.static.ShouldBeRemoved(int(A.nextAnnouncement.MessageIndex), default.Class, int(MessageIndex)))
                {
                    RemovedAnnouncement = A.nextAnnouncement;
                    A.nextAnnouncement = A.nextAnnouncement.nextAnnouncement;
                    RemovedAnnouncement.Destroy();
                }
            }
            A = A.nextAnnouncement;
            // [Loop Continue]
            goto J0x176;
        }
    }
    J0x266:

    //return;    
}

static function PrecacheGameAnnouncements(SkyAnnouncer Announcer, class<GameInfo> GameClass)
{
    //return;    
}
