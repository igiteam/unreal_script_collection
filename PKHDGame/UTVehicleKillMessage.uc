class UTVehicleKillMessage extends UTLocalMessage;

var const localized string KillString[8];
var SoundNodeWave KillSounds[8];

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    return default.KillString[Min(Switch, 7)];
    //return ReturnValue;    
}

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    UTPlayerController(P).PlayAnnouncement(default.Class, Min(Switch, 7));
    //return;    
}

static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
    return default.KillSounds[MessageIndex];
    //return ReturnValue;    
}

defaultproperties
{
    MessageArea=3
    AnnouncementPriority=10
    bIsUnique=true
    DrawColor=(R=255,G=0,B=0,A=255)
    FontSize=2
}