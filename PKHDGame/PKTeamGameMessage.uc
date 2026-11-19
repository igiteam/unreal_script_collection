class PKTeamGameMessage extends UTLocalMessage;

var const localized string RequestTeamSwapPrefix;
var const localized string RequestTeamSwapPostfix;
var const localized string YouAreOnRedMessage;
var const localized string YouAreOnBlueMessage;
var Color RedDrawColor;
var Color BlueDrawColor;
var SoundNodeWave AnnouncerSounds[2];

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    // End:0xF2
    if(((Switch > 0) && default.AnnouncerSounds[Switch - 1] != none) && !Class'Engine.Engine'.static.IsSplitScreen())
    {
        UTPlayerController(P).PlayAnnouncement(default.Class, Switch);
        UTPlayerController(P).PulseTeamColor();
    }
    //return;    
}

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch(Switch)
    {
        // End:0x54
        case 0:
            return (default.RequestTeamSwapPrefix @ RelatedPRI_1.PlayerName) @ default.RequestTeamSwapPostfix;
            // End:0x7A
            break;
        // End:0x65
        case 1:
            return default.YouAreOnRedMessage;
            // End:0x7A
            break;
        // End:0x77
        case 2:
            return default.YouAreOnBlueMessage;
            // End:0x7A
            break;
        // End:0xFFFF
        default:
            break;
    }
    return "";
    //return ReturnValue;    
}

static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
    // End:0x29
    if(MessageIndex > 0)
    {
        return default.AnnouncerSounds[MessageIndex - 1];        
    }
    else
    {
        return none;
    }
    //return ReturnValue;    
}

static function int GetFontSize(int Switch, PlayerReplicationInfo RelatedPRI1, PlayerReplicationInfo RelatedPRI2, PlayerReplicationInfo LocalPlayer)
{
    // End:0x15
    if(Switch > 0)
    {
        return 2;        
    }
    else
    {
        return default.FontSize;
    }
    //return ReturnValue;    
}

static function float GetPos(int Switch, HUD myHUD)
{
    // End:0x1E
    if(UTHUD(myHUD) == none)
    {
        return 0.5000000;
    }
    // End:0x62
    if(Switch > 0)
    {
        return UTHUD(myHUD).MessageOffset[default.MessageArea];        
    }
    else
    {
        return UTHUD(myHUD).MessageOffset[4];
    }
    //return ReturnValue;    
}

static function Color GetColor(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch(Switch)
    {
        // End:0x28
        case 1:
            return default.RedDrawColor;
            // End:0x3D
            break;
        // End:0x3A
        case 2:
            return default.BlueDrawColor;
            // End:0x3D
            break;
        // End:0xFFFF
        default:
            break;
    }
    return default.DrawColor;
    //return ReturnValue;    
}

defaultproperties
{
    RedDrawColor=(R=255,G=32,B=10,A=255)
    BlueDrawColor=(R=10,G=32,B=255,A=255)
    MessageArea=2
    AnnouncementPriority=19
}