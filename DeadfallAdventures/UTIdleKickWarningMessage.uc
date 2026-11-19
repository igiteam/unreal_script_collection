class UTIdleKickWarningMessage extends UTLocalMessage;

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    UTPlayerController(OptionalObject).LastKickWarningTime = UTPlayerController(OptionalObject).WorldInfo.TimeSeconds;
    return Class'Engine.GameMessage'.default.KickWarning;
    //return ReturnValue;    
}

defaultproperties
{
    MessageArea=2
    bIsUnique=true
    bIsConsoleMessage=false
    Lifetime=1.0000000
    DrawColor=(R=255,G=255,B=64,A=255)
    FontSize=2
}