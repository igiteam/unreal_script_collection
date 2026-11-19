class SkyDeathMessage extends SkyLocalMessage
    config(Game);

var(Message) const localized string KilledString;
var(Message) const localized string SomeoneString;
var globalconfig bool bNoConsoleDeathMessages;

static function Color GetConsoleColor(PlayerReplicationInfo RelatedPRI_1)
{
    return Class'Engine.HUD'.default.GreenColor;
    //return ReturnValue;    
}

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string KillerName, VictimName;

    // End:0x18
    if(class<DamageType>(OptionalObject) == none)
    {
        return "";
    }
    // End:0x31
    if(RelatedPRI_1 == none)
    {
        KillerName = default.SomeoneString;        
    }
    else
    {
        KillerName = RelatedPRI_1.PlayerName;
    }
    // End:0x5F
    if(RelatedPRI_2 == none)
    {
        VictimName = default.SomeoneString;        
    }
    else
    {
        VictimName = RelatedPRI_2.PlayerName;
    }
    // End:0xBC
    if(Switch == 1)
    {
        return Class'Engine.GameInfo'.static.ParseKillMessage(KillerName, VictimName, class<DamageType>(OptionalObject).static.SuicideMessage(RelatedPRI_2));
    }
    return Class'Engine.GameInfo'.static.ParseKillMessage(KillerName, VictimName, class<DamageType>(OptionalObject).static.DeathMessage(RelatedPRI_1, RelatedPRI_2));
    //return ReturnValue;    
}

static function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    // End:0x3B
    if(Switch == 1)
    {
        // End:0x39
        if(!default.bNoConsoleDeathMessages)
        {
            super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
        }
        return;
    }
    // End:0x393
    if((RelatedPRI_1 == P.PlayerReplicationInfo) || (P.PlayerReplicationInfo.bOnlySpectator && Pawn(P.ViewTarget) != none) && Pawn(P.ViewTarget).PlayerReplicationInfo == RelatedPRI_1)
    {
        // End:0x1BC
        if(P.myHUD != none)
        {
            P.myHUD.LocalizedMessage(Class'SkyKillerMessage', RelatedPRI_1, Class'SkyKillerMessage'.static.GetString(Switch, true, RelatedPRI_1, RelatedPRI_2, OptionalObject), Switch, Class'SkyKillerMessage'.static.GetPos(Switch, P.myHUD), Class'SkyKillerMessage'.static.GetLifeTime(Switch), Class'SkyKillerMessage'.static.GetFontSize(Switch, RelatedPRI_1, RelatedPRI_2, P.PlayerReplicationInfo), Class'SkyKillerMessage'.static.GetColor(Switch, RelatedPRI_1, RelatedPRI_2));
        }
        // End:0x1E6
        if(!default.bNoConsoleDeathMessages)
        {
            super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
        }
        // End:0x24D
        if(int(P.Role) == int(ROLE_Authority))
        {
            // End:0x24A
            if(SkyPlayerReplicationInfo(RelatedPRI_1).MultiKillLevel > 0)
            {
                P.ReceiveLocalizedMessage(Class'SkyMultiKillMessage', SkyPlayerReplicationInfo(RelatedPRI_1).MultiKillLevel);
            }            
        }
        else
        {
            // End:0x37A
            if(((RelatedPRI_1 != RelatedPRI_2) && RelatedPRI_2 != none) && (RelatedPRI_2.Team == none) || RelatedPRI_1.Team != RelatedPRI_2.Team)
            {
                // End:0x333
                if(((P.WorldInfo.TimeSeconds - SkyPlayerReplicationInfo(RelatedPRI_1).LastKillTime) < float(4)) && Switch != 1)
                {
                    SkyPlayerReplicationInfo(RelatedPRI_1).MultiKillLevel++;
                    P.ReceiveLocalizedMessage(Class'SkyMultiKillMessage', SkyPlayerReplicationInfo(RelatedPRI_1).MultiKillLevel);                    
                }
                else
                {
                    SkyPlayerReplicationInfo(RelatedPRI_1).MultiKillLevel = 0;
                }
                SkyPlayerReplicationInfo(RelatedPRI_1).LastKillTime = P.WorldInfo.TimeSeconds;                
            }
            else
            {
                SkyPlayerReplicationInfo(RelatedPRI_1).MultiKillLevel = 0;
            }
        }        
    }
    else
    {
        // End:0x3FA
        if(RelatedPRI_2 == P.PlayerReplicationInfo)
        {
            P.ReceiveLocalizedMessage(Class'SkyVictimMessage', 0, RelatedPRI_1);
            // End:0x3F7
            if(!default.bNoConsoleDeathMessages)
            {
                super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
            }            
        }
        else
        {
            // End:0x424
            if(!default.bNoConsoleDeathMessages)
            {
                super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
            }
        }
    }
    //return;    
}
