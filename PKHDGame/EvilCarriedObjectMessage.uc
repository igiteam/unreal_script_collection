class EvilCarriedObjectMessage extends UTLocalMessage
    abstract;

var(Message) const localized string ReturnBlue;
var(Message) const localized string ReturnRed;
var(Message) const localized string ReturnedBlue;
var(Message) const localized string ReturnedRed;
var(Message) const localized string CaptureBlue;
var(Message) const localized string CaptureRed;
var(Message) const localized string DroppedBlue;
var(Message) const localized string DroppedRed;
var(Message) const localized string HasBlue;
var(Message) const localized string HasRed;
var(Message) const localized string KilledBlue;
var(Message) const localized string KilledRed;
var SoundNodeWave ReturnSounds[2];
var SoundNodeWave DroppedSounds[2];
var SoundNodeWave TakenSounds[2];

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local UTHUD HUD;

    super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    // End:0x128
    if(RelatedPRI_1 == P.PlayerReplicationInfo)
    {
        // End:0xB5
        if((Switch == 1) || Switch == 8)
        {
            EvilPlayerController(P).ClientMusicEvent(3);            
        }
        else
        {
            // End:0x125
            if((((Switch == 4) || Switch == 6) || Switch == 11) || Switch == 13)
            {
                EvilPlayerController(P).ClientMusicEvent(7);
            }
        }        
    }
    else
    {
        // End:0x1E5
        if((Switch == 4) || Switch == 11)
        {
            // End:0x1E5
            if((RelatedPRI_1 != none) && !P.WorldInfo.GRI.OnSameTeam(P, RelatedPRI_1))
            {
                EvilPlayerController(P).ClientMusicEvent(4);
            }
        }
    }
    HUD = UTHUD(P.myHUD);
    // End:0x271
    if(((HUD != none) && HUD.bIsSplitScreen) && !HUD.bIsFirstPlayer)
    {
        return;
    }
    EvilPlayerController(P).PlayAnnouncement(default.Class, Switch);
    //return;    
}

static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
    switch(MessageIndex)
    {
        // End:0x17
        case 0:
        // End:0x1B
        case 1:
        // End:0x20
        case 3:
        // End:0x34
        case 5:
            return default.ReturnSounds[0];
            // End:0xB4
            break;
        // End:0x48
        case 2:
            return default.DroppedSounds[0];
            // End:0xB4
            break;
        // End:0x4D
        case 4:
        // End:0x61
        case 6:
            return default.TakenSounds[0];
            // End:0xB4
            break;
        // End:0x66
        case 7:
        // End:0x6B
        case 8:
        // End:0x70
        case 10:
        // End:0x84
        case 12:
            return default.ReturnSounds[1];
            // End:0xB4
            break;
        // End:0x98
        case 9:
            return default.DroppedSounds[1];
            // End:0xB4
            break;
        // End:0x9D
        case 11:
        // End:0xB1
        case 13:
            return default.TakenSounds[1];
            // End:0xB4
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return ReturnValue;    
}

static function byte AnnouncementLevel(byte MessageIndex)
{
    return 2;
    //return ReturnValue;    
}

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch(Switch)
    {
        // End:0x5B
        case 0:
            // End:0x2E
            if(RelatedPRI_1 == none)
            {
                return "";
            }
            return RelatedPRI_1.PlayerName @ default.CaptureRed;
            // End:0x3C1
            break;
        // End:0xA5
        case 1:
            // End:0x78
            if(RelatedPRI_1 == none)
            {
                return default.ReturnedRed;
            }
            return RelatedPRI_1.PlayerName @ default.ReturnRed;
            // End:0x3C1
            break;
        // End:0x13E
        case 2:
            // End:0xBC
            if(RelatedPRI_1 == none)
            {
                return "";
            }
            // End:0x111
            if((RelatedPRI_2 != none) && RelatedPRI_2 != RelatedPRI_1)
            {
                return RelatedPRI_2.PlayerName @ default.KilledRed;                
            }
            else
            {
                return RelatedPRI_1.PlayerName @ default.DroppedRed;
            }
            // End:0x3C1
            break;
        // End:0x150
        case 3:
            return default.ReturnedRed;
            // End:0x3C1
            break;
        // End:0x194
        case 4:
            // End:0x167
            if(RelatedPRI_1 == none)
            {
                return "";
            }
            return RelatedPRI_1.PlayerName @ default.HasRed;
            // End:0x3C1
            break;
        // End:0x1A6
        case 5:
            return default.ReturnedRed;
            // End:0x3C1
            break;
        // End:0x1EA
        case 6:
            // End:0x1BD
            if(RelatedPRI_1 == none)
            {
                return "";
            }
            return RelatedPRI_1.PlayerName @ default.HasRed;
            // End:0x3C1
            break;
        // End:0x22E
        case 7:
            // End:0x201
            if(RelatedPRI_1 == none)
            {
                return "";
            }
            return RelatedPRI_1.PlayerName @ default.CaptureBlue;
            // End:0x3C1
            break;
        // End:0x279
        case 8:
            // End:0x24C
            if(RelatedPRI_1 == none)
            {
                return default.ReturnedBlue;
            }
            return RelatedPRI_1.PlayerName @ default.ReturnBlue;
            // End:0x3C1
            break;
        // End:0x312
        case 9:
            // End:0x290
            if(RelatedPRI_1 == none)
            {
                return "";
            }
            // End:0x2E5
            if((RelatedPRI_2 != none) && RelatedPRI_2 != RelatedPRI_1)
            {
                return RelatedPRI_2.PlayerName @ default.KilledBlue;                
            }
            else
            {
                return RelatedPRI_1.PlayerName @ default.DroppedBlue;
            }
            // End:0x3C1
            break;
        // End:0x324
        case 10:
            return default.ReturnedBlue;
            // End:0x3C1
            break;
        // End:0x368
        case 11:
            // End:0x33B
            if(RelatedPRI_1 == none)
            {
                return "";
            }
            return RelatedPRI_1.PlayerName @ default.HasBlue;
            // End:0x3C1
            break;
        // End:0x37A
        case 12:
            return default.ReturnedBlue;
            // End:0x3C1
            break;
        // End:0x3BE
        case 13:
            // End:0x391
            if(RelatedPRI_1 == none)
            {
                return "";
            }
            return RelatedPRI_1.PlayerName @ default.HasBlue;
            // End:0x3C1
            break;
        // End:0xFFFF
        default:
            break;
    }
    return "";
    //return ReturnValue;    
}

static function bool ShouldBeRemoved(UTQueuedAnnouncement MyAnnouncement, class<UTLocalMessage> NewAnnouncementClass, int NewMessageIndex)
{
    return ShouldRemoveFlagAnnouncement(MyAnnouncement.MessageIndex, NewAnnouncementClass, NewMessageIndex);
    //return ReturnValue;    
}

static function bool ShouldRemoveFlagAnnouncement(int MyMessageIndex, class<UTLocalMessage> NewAnnouncementClass, int NewMessageIndex)
{
    // End:0x19
    if(default.Class != NewAnnouncementClass)
    {
        return false;
    }
    // End:0x4B
    if(((MyMessageIndex < 7) != (NewMessageIndex < 7)) || MyMessageIndex == 0)
    {
        return false;
    }
    // End:0x68
    if(MyMessageIndex > 6)
    {
        MyMessageIndex -= 7;
    }
    // End:0x85
    if(NewMessageIndex > 6)
    {
        NewMessageIndex -= 7;
    }
    // End:0x97
    if(MyMessageIndex == 6)
    {
        return false;
    }
    // End:0xEF
    if(((((NewMessageIndex == 1) || NewMessageIndex == 3) || NewMessageIndex == 5) || NewMessageIndex == 12) || NewMessageIndex == 0)
    {
        return true;
    }
    return (MyMessageIndex == 2) || MyMessageIndex == 4;
    //return ReturnValue;    
}

static function bool AddAnnouncement(UTAnnouncer Announcer, int MessageIndex, optional PlayerReplicationInfo PRI, optional Object OptionalObject)
{
    super.AddAnnouncement(Announcer, MessageIndex, PRI, OptionalObject);
    return (Announcer.PlayingAnnouncementClass == none) || (Announcer.PlayingAnnouncementClass == default.Class) && ShouldRemoveFlagAnnouncement(Announcer.PlayingAnnouncementIndex, default.Class, MessageIndex);
    //return ReturnValue;    
}

static function bool PartiallyDuplicates(int Switch1, int Switch2, Object OptionalObject1, Object OptionalObject2)
{
    return ShouldRemoveFlagAnnouncement(Switch1, default.Class, Switch2);
    //return ReturnValue;    
}

defaultproperties
{
    AnnouncementPriority=4
    bIsUnique=true
    DrawColor=(R=0,G=160,B=255,A=255)
    FontSize=1
}