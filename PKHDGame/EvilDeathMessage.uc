class EvilDeathMessage extends UTLocalMessage
    config(Game);

var(Message) const localized string KilledString;
var(Message) const localized string SomeoneString;
var config bool bNoConsoleDeathMessages;
var class<EvilDmgType_Base> DefaultDamage;

static function Color GetConsoleColor(PlayerReplicationInfo RelatedPRI_1)
{
    return Class'Engine.HUD'.default.GreenColor;
    //return ReturnValue;    
}

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string KillerName, VictimName;
    local class<EvilDmgType_Base> KillDamageType;

    KillDamageType = (((class<EvilDmgType_Base>(OptionalObject) != none) && class<EvilDmgType_Melee>(OptionalObject) == none) ? class<EvilDmgType_Base>(OptionalObject) : default.DefaultDamage);
    // End:0x83
    if(RelatedPRI_1 == none)
    {
        KillerName = default.SomeoneString;        
    }
    else
    {
        KillerName = RelatedPRI_1.PlayerName;
    }
    // End:0xD0
    if(RelatedPRI_2 == none)
    {
        VictimName = default.SomeoneString;        
    }
    else
    {
        VictimName = RelatedPRI_2.PlayerName;
    }
    // End:0x161
    if(Switch == 1)
    {
        return Class'EvilGame'.static.ParseKillMessage(KillerName, VictimName, KillDamageType.static.SuicideMessage(RelatedPRI_2));
    }
    return Class'EvilGame'.static.ParseKillMessage(KillerName, VictimName, KillDamageType.static.DeathMessage(RelatedPRI_1, RelatedPRI_2));
    //return ReturnValue;    
}

static function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    // End:0xDA
    if(Switch == 1)
    {
        // End:0x92
        if(RelatedPRI_2 == P.PlayerReplicationInfo)
        {
            UTPlayerController(P).ClientMusicEvent(2);
            EvilPlayerReplicationInfo(RelatedPRI_2).MultiKillLevel = 0;
        }
        // End:0xD8
        if(!default.bNoConsoleDeathMessages)
        {
            super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
        }
        return;
    }
    // End:0x724
    if((RelatedPRI_1 == P.PlayerReplicationInfo) || (((P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo.bIsSpectator) && Pawn(P.ViewTarget) != none) && Pawn(P.ViewTarget).PlayerReplicationInfo == RelatedPRI_1)
    {
        UTPlayerController(P).ClientMusicEvent(1);
        // End:0x3FB
        if(P.myHUD != none)
        {
            P.myHUD.LocalizedMessage(Class'EvilKillerMessage', RelatedPRI_1, RelatedPRI_2, Class'EvilKillerMessage'.static.GetString(Switch, RelatedPRI_1 == P.PlayerReplicationInfo, RelatedPRI_1, RelatedPRI_2, OptionalObject), Switch, Class'EvilKillerMessage'.static.GetPos(Switch, P.myHUD), Class'EvilKillerMessage'.static.GetLifeTime(Switch), Class'EvilKillerMessage'.static.GetFontSize(Switch, RelatedPRI_1, RelatedPRI_2, P.PlayerReplicationInfo), Class'EvilKillerMessage'.static.GetColor(Switch, RelatedPRI_1, RelatedPRI_2), OptionalObject);
        }
        // End:0x441
        if(!default.bNoConsoleDeathMessages)
        {
            super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
        }
        // End:0x4EC
        if(int(P.Role) == int(ROLE_Authority))
        {
            // End:0x4E9
            if(EvilPlayerReplicationInfo(RelatedPRI_1).MultiKillLevel > 0)
            {
                P.ReceiveLocalizedMessage(Class'EvilMultiKillMessage', EvilPlayerReplicationInfo(RelatedPRI_1).MultiKillLevel);
            }            
        }
        else
        {
            // End:0x6F8
            if(((RelatedPRI_1 != RelatedPRI_2) && RelatedPRI_2 != none) && (RelatedPRI_2.Team == none) || RelatedPRI_1.Team != RelatedPRI_2.Team)
            {
                // End:0x671
                if(((P.WorldInfo.TimeSeconds - EvilPlayerReplicationInfo(RelatedPRI_1).LastKillTime) < float(4)) && Switch != 1)
                {
                    EvilPlayerReplicationInfo(RelatedPRI_1).MultiKillLevel++;
                    P.ReceiveLocalizedMessage(Class'EvilMultiKillMessage', EvilPlayerReplicationInfo(RelatedPRI_1).MultiKillLevel);                    
                }
                else
                {
                    EvilPlayerReplicationInfo(RelatedPRI_1).MultiKillLevel = 0;
                }
                EvilPlayerReplicationInfo(RelatedPRI_1).LastKillTime = P.WorldInfo.TimeSeconds;                
            }
            else
            {
                EvilPlayerReplicationInfo(RelatedPRI_1).MultiKillLevel = 0;
            }
        }        
    }
    else
    {
        // End:0x9AE
        if(RelatedPRI_2 == P.PlayerReplicationInfo)
        {
            UTPlayerController(P).ClientMusicEvent(2);
            // End:0x93C
            if(P.myHUD != none)
            {
                P.myHUD.LocalizedMessage(Class'EvilVictimMessage', RelatedPRI_1, RelatedPRI_2, Class'EvilVictimMessage'.static.GetString(Switch, true, RelatedPRI_1, RelatedPRI_2, OptionalObject), 0, Class'EvilVictimMessage'.static.GetPos(Switch, P.myHUD), Class'EvilVictimMessage'.static.GetLifeTime(Switch), Class'EvilVictimMessage'.static.GetFontSize(Switch, RelatedPRI_1, RelatedPRI_2, P.PlayerReplicationInfo), Class'EvilVictimMessage'.static.GetColor(Switch, RelatedPRI_1, RelatedPRI_2), OptionalObject);
            }
            EvilPlayerReplicationInfo(RelatedPRI_2).MultiKillLevel = 0;
            // End:0x9AB
            if(!default.bNoConsoleDeathMessages)
            {
                super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
            }            
        }
        else
        {
            // End:0x9F4
            if(!default.bNoConsoleDeathMessages)
            {
                super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
            }
        }
    }
    //return;    
}

defaultproperties
{
    DefaultDamage=Class'EvilDmgType_Base'
    bIsSpecial=false
    DrawColor=(R=255,G=0,B=0,A=255)
}