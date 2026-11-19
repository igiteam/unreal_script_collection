class ZombieInfoMessage extends ZombieWeaponMessage;

static event string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	if(InfoTrigger(OptionalObject) != None)
	{
		return InfoTrigger(OptionalObject).InfoMessage;	
	}
}


static function float GetZLifetime(int switch, Object optionalObject)
{
	return 0;
}


// Decompiled with UE Explorer.
defaultproperties
{
    hJust=0
    bHasMarkup=false
    xWrap=540
    xReset=100
    bCenter=true
    Lifetime=0
    XPos=100.0000000
    YPos=250.0000000
}