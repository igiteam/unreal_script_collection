class SkyAnnouncer extends Info
    config(Game);

struct AnnouncerPackageInfo
{
    var string PackageName;
    var string SoundPrefix;

    structdefaultproperties
    {
        PackageName=""
        SoundPrefix=""
    }
};

struct CachedSound
{
    var name CacheName;
    var SoundNodeWave CacheSound;

    structdefaultproperties
    {
        CacheName="None"
        CacheSound=none
    }
};

var globalconfig AnnouncerPackageInfo StatusSoundPackage;
var globalconfig AnnouncerPackageInfo RewardSoundPackage;
var AnnouncerPackageInfo FallbackStatusSoundPackage;
var AnnouncerPackageInfo FallbackRewardSoundPackage;
var globalconfig byte AnnouncerLevel;
var byte PlayingAnnouncementIndex;
var array<CachedSound> CachedSounds;
var array<CachedSound> CachedPrimarySounds;
var bool bPrecachedBaseSounds;
var bool bPrecachedGameSounds;
var const bool bEnglishOnly;
var class<SkyLocalMessage> PlayingAnnouncementClass;
var SkyQueuedAnnouncement Queue;
var float GapTime;
var SkyPlayerController PlayerOwner;
var SoundCue AnnouncerSoundCue;

function Destroyed()
{
    local SkyQueuedAnnouncement A;

    super(Actor).Destroyed();
    A = Queue;
    J0x11:

    // End:0x41 [Loop If]
    if(A != none)
    {
        A.Destroy();
        A = A.nextAnnouncement;
        // [Loop Continue]
        goto J0x11;
    }
    //return;    
}

function PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    PlayerOwner = SkyPlayerController(Owner);
    //return;    
}

function AnnouncementFinished(AudioComponent AC)
{
    // End:0x25
    if(GapTime > 0.0000000)
    {
        SetTimer(GapTime, false, 'PlayNextAnnouncement');        
    }
    else
    {
        PlayNextAnnouncement();
    }
    //return;    
}

function PlayNextAnnouncement()
{
    local SkyQueuedAnnouncement PlayedAnnouncement;

    PlayingAnnouncementClass = none;
    // End:0x76
    if(Queue != none)
    {
        PlayedAnnouncement = Queue;
        Queue = PlayedAnnouncement.nextAnnouncement;
        PlayAnnouncementNow(PlayedAnnouncement.AnnouncementClass, PlayedAnnouncement.MessageIndex, PlayedAnnouncement.OptionalObject);
        PlayedAnnouncement.Destroy();
    }
    //return;    
}

function PlayAnnouncementNow(class<SkyLocalMessage> InMessageClass, byte MessageIndex, optional Object OptionalObject)
{
    local SoundNodeWave ASound;
    local editinline AudioComponent AC;

    ASound = GetSound(InMessageClass.static.AnnouncementSound(MessageIndex, OptionalObject), InMessageClass.static.IsRewardAnnouncement(MessageIndex));
    // End:0x106
    if(ASound != none)
    {
        AC = PlayerOwner.GetPooledAudioComponent(AnnouncerSoundCue, PlayerOwner, false);
        // End:0xF0
        if(AC != none)
        {
            AC.SetWaveParameter('Announcement', ASound);
            AC.bAutoDestroy = true;
            AC.bShouldRemainActiveIfDropped = true;
            AC.__OnAudioFinished__Delegate = AnnouncementFinished;
            AC.Play();
        }
        PlayingAnnouncementClass = InMessageClass;
        PlayingAnnouncementIndex = MessageIndex;
    }
    //return;    
}

function PlayAnnouncement(class<SkyLocalMessage> InMessageClass, byte MessageIndex, optional Object OptionalObject)
{
    // End:0x2A
    if(int(InMessageClass.static.AnnouncementLevel(MessageIndex)) > int(AnnouncerLevel))
    {
        return;
    }
    // End:0x50
    if(PlayingAnnouncementClass == none)
    {
        PlayAnnouncementNow(InMessageClass, MessageIndex, OptionalObject);
        return;
    }
    InMessageClass.static.AddAnnouncement(self, MessageIndex, OptionalObject);
    //return;    
}

function string GetFullSoundName(AnnouncerPackageInfo Package, name CueName)
{
    return ((Package.PackageName $ ".") $ Package.SoundPrefix) $ string(CueName);
    //return ReturnValue;    
}

function SoundNodeWave GetSound(name AName, bool bIsReward)
{
    local SoundNodeWave NewSound;
    local string FullName;
    local int I;

    I = CachedSounds.Find('CacheName', AName);
    // End:0x42
    if(I != -1)
    {
        return CachedSounds[I].CacheSound;
    }
    FullName = GetFullSoundName(((bIsReward) ? RewardSoundPackage : StatusSoundPackage), AName);
    NewSound = SoundNodeWave(DynamicLoadObject(FullName, Class'Engine.SoundNodeWave', true));
    // End:0xC2
    if(NewSound == none)
    {
        NewSound = ((bIsReward) ? PrecacheRewardSound(AName) : PrecacheStatusSound(AName));
    }
    return NewSound;
    //return ReturnValue;    
}

function SoundNodeWave PrecacheRewardSound(name AName)
{
    local SoundNodeWave NewSound;
    local string FullName;

    FullName = GetFullSoundName(RewardSoundPackage, AName);
    NewSound = SoundNodeWave(DynamicLoadObject(FullName, Class'Engine.SoundNodeWave', true));
    // End:0x75
    if(NewSound == none)
    {
        // End:0x72
        if(FallbackRewardSoundPackage.PackageName != "")
        {
            NewSound = PrecacheFallbackPackage(FallbackRewardSoundPackage, AName);
        }        
    }
    else
    {
        SaveCachedSound(NewSound, AName);
    }
    // End:0x94
    if(NewSound == none)
    {
    }
    return NewSound;
    //return ReturnValue;    
}

function SoundNodeWave PrecacheStatusSound(name AName)
{
    local SoundNodeWave NewSound;
    local string FullName;

    FullName = GetFullSoundName(StatusSoundPackage, AName);
    NewSound = SoundNodeWave(DynamicLoadObject(FullName, Class'Engine.SoundNodeWave', true));
    // End:0x75
    if(NewSound == none)
    {
        // End:0x72
        if(FallbackStatusSoundPackage.PackageName != "")
        {
            NewSound = PrecacheFallbackPackage(FallbackStatusSoundPackage, AName);
        }        
    }
    else
    {
        SaveCachedSound(NewSound, AName);
    }
    // End:0x94
    if(NewSound == none)
    {
    }
    return NewSound;
    //return ReturnValue;    
}

function SoundNodeWave PrecacheFallbackPackage(AnnouncerPackageInfo Package, name AName)
{
    local SoundNodeWave NewSound;
    local int I;
    local string FullName;

    FullName = GetFullSoundName(Package, AName);
    NewSound = SoundNodeWave(DynamicLoadObject(FullName, Class'Engine.SoundNodeWave', true));
    // End:0xE4
    if(NewSound != none)
    {
        I = CachedSounds.Find('CacheName', AName);
        // End:0x8E
        if(I != -1)
        {
            CachedSounds[I].CacheSound = NewSound;
            return NewSound;
        }
        CachedSounds.Length = CachedSounds.Length + 1;
        CachedSounds[CachedSounds.Length - 1].CacheName = AName;
        CachedSounds[CachedSounds.Length - 1].CacheSound = NewSound;
        return NewSound;
    }
    return none;
    //return ReturnValue;    
}

function SaveCachedSound(SoundNodeWave NewSound, name AName)
{
    // End:0x70
    if(CachedPrimarySounds.Find('CacheSound', NewSound) == -1)
    {
        CachedPrimarySounds.Length = CachedPrimarySounds.Length + 1;
        CachedPrimarySounds[CachedPrimarySounds.Length - 1].CacheName = AName;
        CachedPrimarySounds[CachedPrimarySounds.Length - 1].CacheSound = NewSound;
    }
    //return;    
}

function PrecacheAnnouncements()
{
    local class<SkyGame> GameClass;

    // End:0x8F
    if((!bPrecachedGameSounds && WorldInfo.GRI != none) && WorldInfo.GRI.GameClass != none)
    {
        bPrecachedGameSounds = true;
        GameClass = class<SkyGame>(WorldInfo.GRI.GameClass);
        // End:0x8F
        if(GameClass != none)
        {
            GameClass.static.PrecacheGameAnnouncements(self);
        }
    }
    // End:0x290
    if(!bPrecachedBaseSounds)
    {
        bPrecachedBaseSounds = true;
        PrecacheRewardSound('Headshot');
        PrecacheRewardSound('Headhunter');
        PrecacheRewardSound('FlakMonkey');
        PrecacheRewardSound('Combowhore');
        PrecacheRewardSound('FirstBlood');
        PrecacheRewardSound('DoubleKill');
        PrecacheRewardSound('MultiKill');
        PrecacheRewardSound('MegaKill');
        PrecacheRewardSound('UltraKill');
        PrecacheRewardSound('MonsterKill');
        PrecacheRewardSound('HolyShit');
        PrecacheRewardSound('KillingSpree');
        PrecacheRewardSound('Rampage');
        PrecacheRewardSound('Dominating');
        PrecacheRewardSound('Unstoppable');
        PrecacheRewardSound('GodLike');
        PrecacheStatusSound('Count01');
        PrecacheStatusSound('Count02');
        PrecacheStatusSound('Count03');
        PrecacheStatusSound('Count04');
        PrecacheStatusSound('Count05');
        PrecacheStatusSound('Count06');
        PrecacheStatusSound('Count07');
        PrecacheStatusSound('Count08');
        PrecacheStatusSound('Count09');
        PrecacheStatusSound('Count10');
    }
    //return;    
}
