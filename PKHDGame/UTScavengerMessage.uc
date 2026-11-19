class UTScavengerMessage extends UTLocalMessage;

var const localized array<localized string> MessageText;

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    return default.MessageText[Switch];
    //return ReturnValue;    
}

defaultproperties
{
    MessageArea=2
    bIsPartiallyUnique=true
    DrawColor=(R=255,G=255,B=128,A=255)
    FontSize=2
}