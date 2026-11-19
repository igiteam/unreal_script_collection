class UTWeaponKillRewardMessage extends UTLocalMessage;

var const localized string RewardString[2];
var SoundNodeWave RewardSounds[2];

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    return default.RewardString[Switch];
    //return ReturnValue;    
}

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    UTPlayerController(P).PlayAnnouncement(default.Class, Switch);
    UTPlayerController(P).ClientMusicEvent(6);
    //return;    
}

static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
    return default.RewardSounds[MessageIndex];
    //return ReturnValue;    
}

defaultproperties
{
    MessageArea=3
    AnnouncementPriority=10
    bIsUnique=true
    DrawColor=(R=255,G=255,B=128,A=255)
    FontSize=2
}