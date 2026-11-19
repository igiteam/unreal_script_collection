class UTVehicleCantCarryFlagMessage extends UTLocalMessage;

var const localized string FlagMessage;
var SoundNodeWave FlagAnnouncement;

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    UTPlayerController(P).PlayAnnouncement(default.Class, Switch);
    //return;    
}

static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
    return default.FlagAnnouncement;
    //return ReturnValue;    
}

static function byte AnnouncementLevel(byte MessageIndex)
{
    return 2;
    //return ReturnValue;    
}

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    return default.FlagMessage;
    //return ReturnValue;    
}

defaultproperties
{
    MessageArea=2
    DrawColor=(R=0,G=160,B=255,A=255)
    FontSize=1
}