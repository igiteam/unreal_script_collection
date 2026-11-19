class EvilKillsRemainingMessage extends UTLocalMessage;

var SoundNodeWave KillsRemainSounds[3];
var const localized string KillsRemainStrings[3];

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    return default.KillsRemainStrings[Switch];
    //return ReturnValue;    
}

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local UTHUD HUD;

    super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    HUD = UTHUD(P.myHUD);
    // End:0xC7
    if(((HUD != none) && HUD.bIsSplitScreen) && !HUD.bIsFirstPlayer)
    {
        return;
    }
    UTPlayerController(P).PlayAnnouncement(default.Class, Switch);
    //return;    
}

static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
    return default.KillsRemainSounds[MessageIndex];
    //return ReturnValue;    
}

defaultproperties
{
    MessageArea=2
    AnnouncementPriority=8
    bIsUnique=true
    DrawColor=(R=255,G=0,B=0,A=255)
    FontSize=3
}