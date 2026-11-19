class UTAnnouncer extends Info
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var globalconfig byte AnnouncerLevel;
var class<UTLocalMessage> PlayingAnnouncementClass;
var int PlayingAnnouncementIndex;
var UTQueuedAnnouncement Queue;
var UTPlayerController PlayerOwner;
var SoundCue AnnouncerSoundCue;
var globalconfig string CustomAnnouncerSoundCue;
var SoundCue UTVoiceSoundCue;
var globalconfig string UTVoiceSoundCueSoundCue;
var export editinline AudioComponent CurrentAnnouncementComponent;

function Destroyed()
{
    local UTQueuedAnnouncement A;

    super(Actor).Destroyed();
    // End:0x5B
    if(CurrentAnnouncementComponent != none)
    {
        // End:0x50
        if(PlayerOwner != none)
        {
            PlayerOwner.DetachComponent(CurrentAnnouncementComponent);
        }
        CurrentAnnouncementComponent = none;
    }
    A = Queue;
    J0x6E:

    // End:0xC0 [Loop If]
    if(A != none)
    {
        A.Destroy();
        A = A.nextAnnouncement;
        // [Loop Continue]
        goto J0x6E;
    }
    //return;    
}

function PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    PlayerOwner = UTPlayerController(Owner);
    // End:0x8E
    if(CustomAnnouncerSoundCue != "")
    {
        AnnouncerSoundCue = SoundCue(DynamicLoadObject(CustomAnnouncerSoundCue, Class'Engine.SoundCue'));
        AnnouncerSoundCue.SoundClass = 'Announcer';
    }
    // End:0xF6
    if(UTVoiceSoundCueSoundCue != "")
    {
        UTVoiceSoundCue = SoundCue(DynamicLoadObject(UTVoiceSoundCueSoundCue, Class'Engine.SoundCue'));
        UTVoiceSoundCue.SoundClass = 'SFX';
    }
    //return;    
}

function PlayNextAnnouncement()
{
    local UTQueuedAnnouncement PlayedAnnouncement;

    PlayingAnnouncementClass = none;
    // End:0x13F
    if(Queue != none)
    {
        PlayedAnnouncement = Queue;
        Queue = PlayedAnnouncement.nextAnnouncement;
        PlayAnnouncementNow(PlayedAnnouncement.AnnouncementClass, PlayedAnnouncement.MessageIndex, PlayedAnnouncement.PRI, PlayedAnnouncement.OptionalObject);
        PlayingAnnouncementClass = PlayedAnnouncement.AnnouncementClass;
        PlayingAnnouncementIndex = PlayedAnnouncement.MessageIndex;
        PlayedAnnouncement.Destroy();
    }
    //return;    
}

function PlayAnnouncementNow(class<UTLocalMessage> InMessageClass, int MessageIndex, optional PlayerReplicationInfo PRI, optional Object OptionalObject)
{
    local SoundNodeWave ASound;
    local bool bUsingVoiceCue;

    ASound = InMessageClass.static.AnnouncementSound(MessageIndex, OptionalObject, PlayerOwner);
    // End:0x4E6
    if(ASound != none)
    {
        // End:0xA6
        if(CurrentAnnouncementComponent != none)
        {
            // End:0x9B
            if(PlayerOwner != none)
            {
                PlayerOwner.DetachComponent(CurrentAnnouncementComponent);
            }
            CurrentAnnouncementComponent = none;
        }
        // End:0x11E
        if(ClassIsChildOf(InMessageClass, Class'UTVoice') || ClassIsChildOf(InMessageClass, Class'UTScriptedVoiceMessage'))
        {
            CurrentAnnouncementComponent = PlayerOwner.CreateAudioComponent(UTVoiceSoundCue, false, false);
            bUsingVoiceCue = true;            
        }
        else
        {
            CurrentAnnouncementComponent = PlayerOwner.CreateAudioComponent(AnnouncerSoundCue, false, false);
            bUsingVoiceCue = false;
        }
        // End:0x348
        if(CurrentAnnouncementComponent != none)
        {
            CurrentAnnouncementComponent.SetWaveParameter('Announcement', ASound);
            // End:0x22B
            if(bUsingVoiceCue)
            {
                UTVoiceSoundCue.Duration = ASound.Duration;
                UTVoiceSoundCue.VolumeMultiplier = InMessageClass.default.AnnouncementVolume;                
            }
            else
            {
                AnnouncerSoundCue.Duration = ASound.Duration;
                AnnouncerSoundCue.VolumeMultiplier = InMessageClass.default.AnnouncementVolume;
            }
            CurrentAnnouncementComponent.bAutoDestroy = true;
            CurrentAnnouncementComponent.bShouldRemainActiveIfDropped = true;
            CurrentAnnouncementComponent.bAllowSpatialization = false;
            CurrentAnnouncementComponent.bAlwaysPlay = true;
            CurrentAnnouncementComponent.Play();
        }
        PlayingAnnouncementClass = InMessageClass;
        PlayingAnnouncementIndex = MessageIndex;
        SetTimer((ASound.Duration * WorldInfo.TimeDilation) + 0.0500000, false, 'AnnouncementFinished');
        // End:0x4E3
        if(((InMessageClass.default.bShowPortrait && UTHUD(PlayerOwner.myHUD) != none) && EvilPlayerReplicationInfo(PRI) != none) && PRI != PlayerOwner.PlayerReplicationInfo)
        {
            UTHUD(PlayerOwner.myHUD).ShowPortrait(EvilPlayerReplicationInfo(PRI), ASound.Duration + 0.5000000, ClassIsChildOf(InMessageClass, Class'UTScriptedVoiceMessage'));
        }        
    }
    else
    {
        PlayNextAnnouncement();
    }
    //return;    
}

function AnnouncementFinished(AudioComponent AC)
{
    // End:0x48
    if((PlayerOwner != none) && CurrentAnnouncementComponent != none)
    {
        PlayerOwner.DetachComponent(CurrentAnnouncementComponent);
    }
    CurrentAnnouncementComponent = none;
    PlayingAnnouncementClass = none;
    PlayNextAnnouncement();
    //return;    
}

function PlayAnnouncement(class<UTLocalMessage> InMessageClass, int MessageIndex, optional PlayerReplicationInfo PRI, optional Object OptionalObject)
{
    // End:0x40
    if(int(InMessageClass.static.AnnouncementLevel(byte(MessageIndex))) > int(AnnouncerLevel))
    {
        return;
    }
    // End:0x89
    if((CurrentAnnouncementComponent == none) || CurrentAnnouncementComponent.bFinished)
    {
        PlayingAnnouncementClass = none;
        CurrentAnnouncementComponent = none;
    }
    // End:0x176
    if(PlayingAnnouncementClass == none)
    {
        // End:0x12A
        if((InMessageClass.default.AnnouncementDelay == 0.0000000) || (PRI != none) && !PRI.bBot)
        {
            PlayAnnouncementNow(InMessageClass, MessageIndex, PRI, OptionalObject);
            return;            
        }
        else
        {
            SetTimer(InMessageClass.default.AnnouncementDelay * WorldInfo.TimeDilation, false, 'AnnouncementFinished');
        }
    }
    // End:0x22E
    if(InMessageClass.static.AddAnnouncement(self, MessageIndex, PRI, OptionalObject))
    {
        // End:0x224
        if(CurrentAnnouncementComponent != none)
        {
            CurrentAnnouncementComponent.Stop();
            // End:0x219
            if(PlayerOwner != none)
            {
                PlayerOwner.DetachComponent(CurrentAnnouncementComponent);
            }
            CurrentAnnouncementComponent = none;
        }
        PlayNextAnnouncement();
    }
    //return;    
}

defaultproperties
{
    AnnouncerLevel=2
}