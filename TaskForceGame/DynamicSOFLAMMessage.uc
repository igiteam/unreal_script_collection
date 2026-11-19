class DynamicSOFLAMMessage extends ZombieWeaponMessage;

var localized String message;

static event string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	return default.message;
}


// Decompiled with UE Explorer.
defaultproperties
{
    Message="Press and hold <action=use> to place SLAM charge"
    Kern=-2.0000000
    Lifetime=0
}