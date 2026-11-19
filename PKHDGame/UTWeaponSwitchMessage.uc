class UTWeaponSwitchMessage extends UTLocalMessage;

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    // End:0x46
    if(Actor(OptionalObject) != none)
    {
        return Actor(OptionalObject).GetHumanReadableName();
    }
    return "";
    //return ReturnValue;    
}

defaultproperties
{
    MessageArea=4
    bIsUnique=true
    bIsConsoleMessage=false
    FontSize=2
}