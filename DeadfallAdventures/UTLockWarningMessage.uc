class UTLockWarningMessage extends UTLocalMessage;

var(Message) const localized string MissileLockOnString;
var(Message) const localized string RadarLockString;
var Color RedColor;
var Color YellowColor;

static function byte AnnouncementLevel(byte MessageIndex)
{
    return 2;
    //return ReturnValue;    
}

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch(Switch)
    {
        // End:0x29
        case 1:
            return default.MissileLockOnString;
            // End:0x3E
            break;
        // End:0x3B
        case 4:
            return default.RadarLockString;
            // End:0x3E
            break;
        // End:0xFFFF
        default:
            break;
    }
    return "";
    //return ReturnValue;    
}

static function Color GetColor(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    return default.RedColor;
    //return ReturnValue;    
}

defaultproperties
{
    RedColor=(R=255,G=0,B=0,A=255)
    YellowColor=(R=255,G=255,B=0,A=255)
    MessageArea=3
    bIsPartiallyUnique=true
    Lifetime=2.5000000
    DrawColor=(R=0,G=160,B=255,A=255)
    FontSize=1
}