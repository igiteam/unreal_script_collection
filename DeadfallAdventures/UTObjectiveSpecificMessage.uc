class UTObjectiveSpecificMessage extends UTLocalMessage
    abstract;

static function ObjectiveAnnouncementInfo GetObjectiveAnnouncement(byte MessageIndex, Object Objective, PlayerController PC)
{
    //return ReturnValue;    
}

static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
    local ObjectiveAnnouncementInfo Announcement;

    Announcement = GetObjectiveAnnouncement(byte(MessageIndex), OptionalObject, PC);
    return Announcement.AnnouncementSound;
    //return ReturnValue;    
}

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local UTPlayerController UTP;
    local ObjectiveAnnouncementInfo Announcement;

    UTP = UTPlayerController(P);
    // End:0x234
    if(UTP != none)
    {
        Announcement = GetObjectiveAnnouncement(byte(Switch), OptionalObject, P);
        // End:0xBD
        if(Announcement.AnnouncementSound != none)
        {
            UTP.PlayAnnouncement(default.Class, Switch,, OptionalObject);
        }
        // End:0x134
        if(P.myHUD != none)
        {
            SetHUDDisplay(P, Switch, Announcement.AnnouncementText, RelatedPRI_1, RelatedPRI_2, OptionalObject);
        }
        // End:0x234
        if(Announcement.AnnouncementText != "")
        {
            // End:0x234
            if((IsConsoleMessage(Switch)) && LocalPlayer(P.Player).ViewportClient != none)
            {
                LocalPlayer(P.Player).ViewportClient.ViewportConsole.OutputText(Announcement.AnnouncementText);
            }
        }
    }
    //return;    
}

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local ObjectiveAnnouncementInfo Announcement;

    // End:0x61
    if(IsConsoleMessage(Switch))
    {
        Announcement = GetObjectiveAnnouncement(byte(Switch), OptionalObject, none);
        return Announcement.AnnouncementText;
    }
    return "";
    //return ReturnValue;    
}

static simulated function SetHUDDisplay(PlayerController P, int Switch, string Text, PlayerReplicationInfo RelatedPRI_1, PlayerReplicationInfo RelatedPRI_2, Object OptionalObject)
{
    // End:0x127
    if(Text != "")
    {
        P.myHUD.LocalizedMessage(default.Class, RelatedPRI_1, RelatedPRI_2, Text, Switch, GetPos(Switch, P.myHUD), GetLifeTime(Switch), GetFontSize(Switch, RelatedPRI_1, RelatedPRI_2, P.PlayerReplicationInfo), GetColor(Switch, RelatedPRI_1, RelatedPRI_2), OptionalObject);
    }
    //return;    
}

defaultproperties
{
    MessageArea=6
}