class ZombieMPMessageNoTeams extends ZombieMPMessage
	native;

static function bool isTeamGame()
{
	return false;
}

static event string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	return Super.GetString(Switch,RelatedPRI_1,RelatedPRI_2,OptionalObject);
}


static event string GetStringPC(
	PlayerController pc,
	optional int SwitchVal,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	return Super.GetStringPC(pc,SwitchVal,RelatedPRI_1,RelatedPRI_2,OptionalObject);
}
