class PKTimerMessage extends UTLocalMessage
    abstract;

var array<ObjectiveAnnouncementInfo> Announcements;

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local editinline AudioComponent CurrentAnnouncementComponent;
    local UTHUD HUD;

    super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    // End:0x279
    if(default.Announcements[Switch].AnnouncementSound != none)
    {
        HUD = UTHUD(P.myHUD);
        // End:0xF3
        if(((HUD != none) && HUD.bIsSplitScreen) && !HUD.bIsFirstPlayer)
        {
            return;
        }
        // End:0x23D
        if(Switch < 11)
        {
            CurrentAnnouncementComponent = P.CreateAudioComponent(SoundCue'a_Announcer.SoundCues.AnnouncerCue', false, false);
            // End:0x23A
            if(CurrentAnnouncementComponent != none)
            {
                CurrentAnnouncementComponent.SetWaveParameter('Announcement', default.Announcements[Switch].AnnouncementSound);
                CurrentAnnouncementComponent.bAutoDestroy = true;
                CurrentAnnouncementComponent.bShouldRemainActiveIfDropped = true;
                CurrentAnnouncementComponent.bAllowSpatialization = false;
                CurrentAnnouncementComponent.bAlwaysPlay = true;
                CurrentAnnouncementComponent.Play();
            }            
        }
        else
        {
            UTPlayerController(P).PlayAnnouncement(default.Class, Switch);
        }
    }
    //return;    
}

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    return default.Announcements[Switch].AnnouncementText;
    //return ReturnValue;    
}

static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
    return default.Announcements[MessageIndex].AnnouncementSound;
    //return ReturnValue;    
}

static function int GetFontSize(int Switch, PlayerReplicationInfo RelatedPRI1, PlayerReplicationInfo RelatedPRI2, PlayerReplicationInfo LocalPlayer)
{
    // End:0x13
    if(Switch == 17)
    {
        return 4;
    }
    // End:0x2D
    if(Switch > 10)
    {
        return default.FontSize;
    }
    return 2;
    //return ReturnValue;    
}

defaultproperties
{
    Announcements[0]=(AnnouncementSound=none,AnnouncementText="")
    Announcements[1]=(AnnouncementSound=none,AnnouncementText="")
    Announcements[2]=(AnnouncementSound=none,AnnouncementText="")
    Announcements[3]=(AnnouncementSound=none,AnnouncementText="")
    Announcements[4]=(AnnouncementSound=none,AnnouncementText="")
    Announcements[5]=(AnnouncementSound=none,AnnouncementText="")
    Announcements[6]=(AnnouncementSound=none,AnnouncementText="")
    Announcements[7]=(AnnouncementSound=none,AnnouncementText="")
    Announcements[8]=(AnnouncementSound=none,AnnouncementText="")
    Announcements[9]=(AnnouncementSound=none,AnnouncementText="")
    Announcements[10]=(AnnouncementSound=none,AnnouncementText="")
    Announcements[11]=(AnnouncementSound=none,AnnouncementText="")
    Announcements[12]=(AnnouncementSound=none,AnnouncementText="")
    Announcements[13]=(AnnouncementSound=none,AnnouncementText="")
    Announcements[14]=(AnnouncementSound=none,AnnouncementText="")
    Announcements[15]=(AnnouncementSound=none,AnnouncementText="")
    Announcements[16]=(AnnouncementSound=none,AnnouncementText="")
    Announcements[17]=(AnnouncementSound=none,AnnouncementText="")
    bIsUnique=true
    bIsConsoleMessage=false
    FontSize=1
}