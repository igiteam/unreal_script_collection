class SkyKillingSpreeMessage extends SkyLocalMessage;

var const localized string EndSpreeNote;
var const localized string EndSelfSpree;
var const localized string EndFemaleSpree;
var const localized string MultiKillString;
var const localized string SpreeNote[10];
var const localized string SelfSpreeNote[10];
var name SpreeSoundName[10];
var const localized string EndSpreeNoteTrailer;

static function int GetFontSize(int Switch, PlayerReplicationInfo RelatedPRI1, PlayerReplicationInfo RelatedPRI2, PlayerReplicationInfo LocalPlayer)
{
    local Pawn ViewPawn;

    // End:0x82
    if(RelatedPRI2 == none)
    {
        // End:0x1D
        if(LocalPlayer == RelatedPRI1)
        {
            return 4;
        }
        // End:0x82
        if(LocalPlayer.bOnlySpectator)
        {
            ViewPawn = Pawn(PlayerController(LocalPlayer.Owner).ViewTarget);
            // End:0x82
            if((ViewPawn != none) && ViewPawn.PlayerReplicationInfo == RelatedPRI1)
            {
                return 4;
            }
        }
    }
    return default.FontSize;
    //return ReturnValue;    
}

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    // End:0x69
    if(RelatedPRI_2 == none)
    {
        // End:0x25
        if(bPRI1HUD)
        {
            return default.SelfSpreeNote[Switch];
        }
        // End:0x33
        if(RelatedPRI_1 == none)
        {
            return "";
        }
        // End:0x66
        if(RelatedPRI_1.PlayerName != "")
        {
            return RelatedPRI_1.PlayerName @ default.SpreeNote[Switch];
        }        
    }
    else
    {
        // End:0xD1
        if(RelatedPRI_1 == none)
        {
            // End:0xCE
            if(RelatedPRI_2.PlayerName != "")
            {
                // End:0xB7
                if(RelatedPRI_2.bIsFemale)
                {
                    return RelatedPRI_2.PlayerName @ default.EndFemaleSpree;                    
                }
                else
                {
                    return RelatedPRI_2.PlayerName @ default.EndSelfSpree;
                }
            }            
        }
        else
        {
            return ((RelatedPRI_1.PlayerName $ default.EndSpreeNote) @ RelatedPRI_2.PlayerName) @ default.EndSpreeNoteTrailer;
        }
    }
    return "";
    //return ReturnValue;    
}

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    // End:0x30
    if(RelatedPRI_2 != none)
    {
        return;
    }
    // End:0xD7
    if((RelatedPRI_1 == P.PlayerReplicationInfo) || (P.PlayerReplicationInfo.bOnlySpectator && Pawn(P.ViewTarget) != none) && Pawn(P.ViewTarget).PlayerReplicationInfo == RelatedPRI_1)
    {
        SkyPlayerController(P).SPlayAnnouncement(default.Class, byte(Switch));        
    }
    else
    {
        P.PlayBeepSound();
    }
    //return;    
}

static function name AnnouncementSound(byte MessageIndex, optional Object OptionalObject)
{
    return default.SpreeSoundName[int(MessageIndex)];
    //return ReturnValue;    
}

static function bool IsRewardAnnouncement(byte MessageIndex)
{
    return true;
    //return ReturnValue;    
}
