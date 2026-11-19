class SPDeathMessage extends SPLocalMessage
    config(Game);

var(Message) const localized string KilledString;
var(Message) const localized string SomeoneString;
var config bool bNoConsoleDeathMessages;

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
    // End:0x25D
    if(Switch == 1)
    {
        // End:0x12E
        if(RelatedPRI_2 != P.PlayerReplicationInfo)
        {
            // End:0x12B
            if(P.myHUD != none)
            {
                P.myHUD.LocalizedMessage(Class'SPSuicideOthersMessage', RelatedPRI_1, Class'SPSuicideOthersMessage'.static.GetString(Switch, true, RelatedPRI_1, RelatedPRI_2, OptionalObject), 0, Class'SPSuicideOthersMessage'.static.GetPos(Switch, P.myHUD), Class'SPSuicideOthersMessage'.static.GetLifeTime(Switch), Class'SPSuicideOthersMessage'.static.GetFontSize(Switch, RelatedPRI_1, RelatedPRI_2, P.PlayerReplicationInfo), Class'SPSuicideOthersMessage'.static.GetColor(Switch, RelatedPRI_1, RelatedPRI_2), OptionalObject);
            }            
        }
        else
        {
            // End:0x231
            if(P.myHUD != none)
            {
                P.myHUD.LocalizedMessage(Class'SPSuicideSelfMessage', RelatedPRI_1, Class'SPSuicideSelfMessage'.static.GetString(Switch, true, RelatedPRI_1, RelatedPRI_2, OptionalObject), 0, Class'SPSuicideSelfMessage'.static.GetPos(Switch, P.myHUD), Class'SPSuicideSelfMessage'.static.GetLifeTime(Switch), Class'SPSuicideSelfMessage'.static.GetFontSize(Switch, RelatedPRI_1, RelatedPRI_2, P.PlayerReplicationInfo), Class'SPSuicideSelfMessage'.static.GetColor(Switch, RelatedPRI_1, RelatedPRI_2), OptionalObject);
            }
        }
        // End:0x25B
        if(!default.bNoConsoleDeathMessages)
        {
            super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
        }
        return;
    }
    // End:0x3BF
    if(RelatedPRI_2 != P.PlayerReplicationInfo)
    {
        // End:0x392
        if(P.myHUD != none)
        {
            P.myHUD.LocalizedMessage(Class'SPKillerMessage', RelatedPRI_1, Class'SPKillerMessage'.static.GetString(Switch, RelatedPRI_1 == P.PlayerReplicationInfo, RelatedPRI_1, RelatedPRI_2, OptionalObject), Switch, Class'SPKillerMessage'.static.GetPos(Switch, P.myHUD), Class'SPKillerMessage'.static.GetLifeTime(Switch), Class'SPKillerMessage'.static.GetFontSize(Switch, RelatedPRI_1, RelatedPRI_2, P.PlayerReplicationInfo), Class'SPKillerMessage'.static.GetColor(Switch, RelatedPRI_1, RelatedPRI_2), OptionalObject);
        }
        // End:0x3BC
        if(!default.bNoConsoleDeathMessages)
        {
            super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
        }        
    }
    else
    {
        // End:0x508
        if(RelatedPRI_2 == P.PlayerReplicationInfo)
        {
            // End:0x4DB
            if(P.myHUD != none)
            {
                P.myHUD.LocalizedMessage(Class'SPVictimMessage', RelatedPRI_1, Class'SPVictimMessage'.static.GetString(Switch, true, RelatedPRI_1, RelatedPRI_2, OptionalObject), 0, Class'SPVictimMessage'.static.GetPos(Switch, P.myHUD), Class'SPVictimMessage'.static.GetLifeTime(Switch), Class'SPVictimMessage'.static.GetFontSize(Switch, RelatedPRI_1, RelatedPRI_2, P.PlayerReplicationInfo), Class'SPVictimMessage'.static.GetColor(Switch, RelatedPRI_1, RelatedPRI_2), OptionalObject);
            }
            // End:0x505
            if(!default.bNoConsoleDeathMessages)
            {
                super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
            }            
        }
        else
        {
            // End:0x532
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
    bNoConsoleDeathMessages=true
    DrawColor=(R=255,G=0,B=0,A=255)
}