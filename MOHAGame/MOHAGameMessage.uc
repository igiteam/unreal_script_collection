class MOHAGameMessage extends GameMessage
    config(Game);

var config float MessageLifeTime;
var const localized string MOHAEnteredMessage;
var const localized string MOHALeftMessage;
var const localized string MOHASwitchLevelMessage;

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    return "";
    //return ReturnValue;    
}

static function int GetFontSize(int Switch, PlayerReplicationInfo RelatedPRI1, PlayerReplicationInfo RelatedPRI2, PlayerReplicationInfo LocalPlayer)
{
    return 4;
    //return ReturnValue;    
}

static function float GetLifeTime(int Switch)
{
    return default.MessageLifeTime;
    //return ReturnValue;    
}

defaultproperties
{
    MessageLifeTime=10.0000000
    MOHAEnteredMessage="%1 entered the game."
    MOHALeftMessage="%1 left the game."
    MOHASwitchLevelMessage="Switching Maps"
    PosY=0.2000000
}