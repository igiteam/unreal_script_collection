class SASMPMessage extends LocalMessage;

var localized string TeamKillMessage;
var localized string SwapTeamMessage;

static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	switch (Switch)
	{
		case 0:
			return class'GameInfo'.static.ParseKillMessage
				( 
				RelatedPRI_1.PlayerName,
				RelatedPRI_2.PlayerName,
				default.TeamKillMessage
				);
			
		case 1:
			return class'GameInfo'.static.ParseKillMessage
				( 
				RelatedPRI_1.PlayerName,
				RelatedPRI_2.PlayerName,
				default.SwapTeamMessage
				);
	
		//case 2:
			//return RelatedPRI_1.playername @"snuffed it";
			
		//case 3:
		//	return "The level will restart";
	}
	return "";
}


// Decompiled with UE Explorer.
defaultproperties
{
    TeamKillMessage="%o was team killed by %k"
    SwapTeamMessage="%o will swap teams with %k"
}