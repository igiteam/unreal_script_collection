class LocalMessage extends Object
    abstract;

var bool bIsSpecial;
var bool bIsUnique;
var bool bIsPartiallyUnique;
var bool bIsConsoleMessage;
var bool bBeep;
var int Lifetime;
var Color DrawColor;
var float PosY;
var int FontSize;

static function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string MessageString;

    MessageString = GetString(Switch, RelatedPRI_1 == P.PlayerReplicationInfo, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    // End:0xCD
    if(P.myHUD != none)
    {
        P.myHUD.LocalizedMessage(default.Class, RelatedPRI_1, MessageString, Switch, GetPos(Switch), GetLifeTime(Switch), GetFontSize(Switch, RelatedPRI_1, RelatedPRI_2, P.PlayerReplicationInfo), GetColor(Switch, RelatedPRI_1, RelatedPRI_2));
    }
    // End:0x135
    if((IsConsoleMessage(Switch)) && LocalPlayer(P.Player).ViewportClient != none)
    {
        LocalPlayer(P.Player).ViewportClient.ViewportConsole.OutputText(MessageString);
    }
    return;
}

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    // End:0x3A
    if(class<Actor>(OptionalObject) != none)
    {
        return class<Actor>(OptionalObject).static.GetLocalString(Switch, RelatedPRI_1, RelatedPRI_2);
    }
    return "";
    return;
}

static function Color GetConsoleColor(PlayerReplicationInfo RelatedPRI_1)
{
    return default.DrawColor;
    return;
}

static function Color GetColor(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
    return default.DrawColor;
    return;
}

static function float GetPos(int Switch)
{
    return default.PosY;
    return;
}

static function int GetFontSize(int Switch, PlayerReplicationInfo RelatedPRI1, PlayerReplicationInfo RelatedPRI2, PlayerReplicationInfo LocalPlayer)
{
    return default.FontSize;
    return;
}

static function float GetLifeTime(int Switch)
{
    return float(default.Lifetime);
    return;
}

static function bool IsConsoleMessage(int Switch)
{
    return default.bIsConsoleMessage;
    return;
}

defaultproperties
{
    bIsSpecial=true
    bIsConsoleMessage=true
    Lifetime=3
    DrawColor=(R=255,G=255,B=255,A=255)
    PosY=0.8300000
}