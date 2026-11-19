class UTVehicleMessage extends UTLocalMessage;

var const localized array<localized string> MessageText;
var array<Color> DrawColors;
var array<SoundNodeWave> MessageAnnouncements;
var array<int> CustomMessageArea;

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    // End:0x90
    if(default.MessageAnnouncements[Switch] != none)
    {
        UTPlayerController(P).PlayAnnouncement(default.Class, Switch);
    }
    //return;    
}

static function byte AnnouncementLevel(byte MessageIndex)
{
    return 2;
    //return ReturnValue;    
}

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    return default.MessageText[Switch];
    //return ReturnValue;    
}

static function Color GetColor(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    return default.DrawColors[Switch];
    //return ReturnValue;    
}

static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
    return default.MessageAnnouncements[MessageIndex];
    //return ReturnValue;    
}

defaultproperties
{
    DrawColors[0]=none
    DrawColors[1]=none
    DrawColors[2]=none
    DrawColors[3]=(MessageAnnouncements=/* Array type was not detected. */,MessageArea=2,AnnouncementPriority=5,bIsPartiallyUnique=true,bIsConsoleMessage=false,FontSize=2)
    DrawColors[4]=none
    DrawColors[5]=none
    MessageAnnouncements[0]=none
    MessageAnnouncements[1]=none
    MessageAnnouncements[2]=none
    MessageAnnouncements[3]=none
    MessageAnnouncements[4]=none
    MessageAnnouncements[5]=none
    MessageArea=2
    AnnouncementPriority=5
    bIsPartiallyUnique=true
    bIsConsoleMessage=false
    FontSize=2
}