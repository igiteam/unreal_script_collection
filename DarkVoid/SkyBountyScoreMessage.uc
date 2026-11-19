class SkyBountyScoreMessage extends SkyLocalMessage;

var const localized string EarnedMoneyMessage;
var const localized string LostMoneyMessage;
var const localized string KilledMessage;
var const localized string ReasonMessage;
var name TeamScoreSoundName[7];

static function PrecacheGameAnnouncements(SkyAnnouncer Announcer, class<GameInfo> GameClass)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x3C [Loop If]
    if(I < 6)
    {
        Announcer.PrecacheStatusSound(default.TeamScoreSoundName[I]);
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    Announcer.PrecacheRewardSound(default.TeamScoreSoundName[6]);
    //return;    
}

static function byte AnnouncementLevel(byte MessageIndex)
{
    return 2;
    //return ReturnValue;    
}

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    SkyPlayerController(P).SPlayAnnouncement(default.Class, byte(Switch));
    //return;    
}

static function name AnnouncementSound(byte MessageIndex, optional Object OptionalObject)
{
    return default.TeamScoreSoundName[int(MessageIndex)];
    //return ReturnValue;    
}

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string Temp;

    // End:0x138
    if((RelatedPRI_1 != none) && Switch != 0)
    {
        // End:0x36
        if(Switch > 0)
        {
            Temp = default.EarnedMoneyMessage;            
        }
        else
        {
            Temp = default.LostMoneyMessage;
        }
        Temp = Repl(Temp, "%p", RelatedPRI_1.PlayerName);
        Temp = Repl(Temp, "$$", "$" $ string(Switch));
        Temp = Repl(Temp, "%t", RelatedPRI_1.Team.GetHumanReadableName());
        // End:0xF0
        if(PlayerReplicationInfo(OptionalObject) != none)
        {
            Temp = Temp $ Repl(default.KilledMessage, "%v", PlayerReplicationInfo(OptionalObject).PlayerName);            
        }
        else
        {
            // End:0x132
            if(SkyGameObjective(OptionalObject) != none)
            {
                Temp = (Temp $ default.ReasonMessage) $ SkyGameObjective(OptionalObject).GetScoredAnnounceString(RelatedPRI_1);
            }
        }
        return Temp;
    }
    return super(LocalMessage).GetString(Switch, bPRI1HUD, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    //return ReturnValue;    
}
