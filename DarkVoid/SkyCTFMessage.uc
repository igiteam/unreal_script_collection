class SkyCTFMessage extends SkyLocalMessage;

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
var name ReturnSoundNames[2];
var name DroppedSoundNames[2];
var name TakenSoundNames[2];

static function PrecacheGameAnnouncements(SkyAnnouncer Announcer, class<GameInfo> GameClass)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x7A [Loop If]
    if(I < 2)
    {
        Announcer.PrecacheStatusSound(default.ReturnSoundNames[I]);
        Announcer.PrecacheStatusSound(default.DroppedSoundNames[I]);
        Announcer.PrecacheStatusSound(default.TakenSoundNames[I]);
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    //return;    
}

static function name AnnouncementSound(byte MessageIndex, optional Object OptionalObject)
{
    switch(MessageIndex)
    {
        // End:0x0E
        case 0:
        // End:0x13
        case 1:
        // End:0x18
        case 3:
        // End:0x28
        case 5:
            return default.ReturnSoundNames[0];
            // End:0x94
            break;
        // End:0x38
        case 2:
            return default.DroppedSoundNames[0];
            // End:0x94
            break;
        // End:0x3D
        case 4:
        // End:0x4D
        case 6:
            return default.TakenSoundNames[0];
            // End:0x94
            break;
        // End:0x52
        case 7:
        // End:0x57
        case 8:
        // End:0x5C
        case 10:
        // End:0x6C
        case 12:
            return default.ReturnSoundNames[1];
            // End:0x94
            break;
        // End:0x7C
        case 9:
            return default.DroppedSoundNames[1];
            // End:0x94
            break;
        // End:0x81
        case 11:
        // End:0x91
        case 13:
            return default.TakenSoundNames[1];
            // End:0x94
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
        // End:0x39
        case 0:
            // End:0x1F
            if(RelatedPRI_1 == none)
            {
                return "";
            }
            return RelatedPRI_1.PlayerName @ default.CaptureRed;
            // End:0x20E
            break;
        // End:0x68
        case 1:
            // End:0x4E
            if(RelatedPRI_1 == none)
            {
                return default.ReturnedRed;
            }
            return RelatedPRI_1.PlayerName @ default.ReturnRed;
            // End:0x20E
            break;
        // End:0x95
        case 2:
            // End:0x7B
            if(RelatedPRI_1 == none)
            {
                return "";
            }
            return RelatedPRI_1.PlayerName @ default.DroppedRed;
            // End:0x20E
            break;
        // End:0xA3
        case 3:
            return default.ReturnedRed;
            // End:0x20E
            break;
        // End:0xD0
        case 4:
            // End:0xB6
            if(RelatedPRI_1 == none)
            {
                return "";
            }
            return RelatedPRI_1.PlayerName @ default.HasRed;
            // End:0x20E
            break;
        // End:0xDE
        case 5:
            return default.ReturnedRed;
            // End:0x20E
            break;
        // End:0x10B
        case 6:
            // End:0xF1
            if(RelatedPRI_1 == none)
            {
                return "";
            }
            return RelatedPRI_1.PlayerName @ default.HasRed;
            // End:0x20E
            break;
        // End:0x138
        case 7:
            // End:0x11E
            if(RelatedPRI_1 == none)
            {
                return "";
            }
            return RelatedPRI_1.PlayerName @ default.CaptureBlue;
            // End:0x20E
            break;
        // End:0x168
        case 8:
            // End:0x14E
            if(RelatedPRI_1 == none)
            {
                return default.ReturnedBlue;
            }
            return RelatedPRI_1.PlayerName @ default.ReturnBlue;
            // End:0x20E
            break;
        // End:0x195
        case 9:
            // End:0x17B
            if(RelatedPRI_1 == none)
            {
                return "";
            }
            return RelatedPRI_1.PlayerName @ default.DroppedBlue;
            // End:0x20E
            break;
        // End:0x1A3
        case 10:
            return default.ReturnedBlue;
            // End:0x20E
            break;
        // End:0x1D0
        case 11:
            // End:0x1B6
            if(RelatedPRI_1 == none)
            {
                return "";
            }
            return RelatedPRI_1.PlayerName @ default.HasBlue;
            // End:0x20E
            break;
        // End:0x1DE
        case 12:
            return default.ReturnedBlue;
            // End:0x20E
            break;
        // End:0x20B
        case 13:
            // End:0x1F1
            if(RelatedPRI_1 == none)
            {
                return "";
            }
            return RelatedPRI_1.PlayerName @ default.HasBlue;
            // End:0x20E
            break;
        // End:0xFFFF
        default:
            break;
    }
    return "";
    //return ReturnValue;    
}

static function bool ShouldBeRemoved(int MyMessageIndex, class<SkyLocalMessage> NewAnnouncementClass, int NewMessageIndex)
{
    // End:0x11
    if(default.Class != NewAnnouncementClass)
    {
        return false;
    }
    // End:0x37
    if(((MyMessageIndex < 7) != (NewMessageIndex < 7)) || MyMessageIndex == 0)
    {
        return false;
    }
    // End:0x4C
    if(MyMessageIndex > 6)
    {
        MyMessageIndex -= 7;
    }
    // End:0x61
    if(NewMessageIndex > 6)
    {
        NewMessageIndex -= 7;
    }
    // End:0x97
    if((((NewMessageIndex == 1) || NewMessageIndex == 3) || NewMessageIndex == 5) || NewMessageIndex == 0)
    {
        return true;
    }
    return ((MyMessageIndex == 2) || MyMessageIndex == 4) || MyMessageIndex == 6;
    //return ReturnValue;    
}
