class SASMPMatchOverMessage extends LocalMessage;

var localized string	TeamWinMessage;
var localized string	FragWinMessage;
var localized string 	TimeLimitMessage;
var localized string 	MatchDrawMessage;

static function string GetString(
	optional int					Switch,
	optional PlayerReplicationInfo	RelatedPRI_1, 
	optional PlayerReplicationInfo	RelatedPRI_2,
	optional Object					OptionalObject )
{
	switch ( Switch )
	{
	case 0:
		// Team wins message.
		if ( RelatedPRI_1.Team != None )
		{
			return RelatedPRI_1.Team.TeamName @ Default.TeamWinMessage;
		}
		break;
		
	case 1:
		// Indiviual frag limit winner.
		return RelatedPRI_1.playername @ Default.FragWinMessage;
		
	case 2:
		// Time up, team has won.
		if ( RelatedPRI_1.Team != None )
		{
			return Default.TimeLimitMessage @ RelatedPRI_1.Team.TeamName @ Default.TeamWinMessage;
		}
		break;
			
	case 3:
		// Time up, match drawn.
		return Default.TimeLimitMessage @ Default.MatchDrawMessage;

	case 4:
		// Match drawn.
		return Default.MatchDrawMessage;
	}

	return "";
}


// Decompiled with UE Explorer.
defaultproperties
{
    TeamWinMessage="team wins"
    FragWinMessage="reached frag count"
    TimeLimitMessage="Time limit up:"
    MatchDrawMessage="Match drawn"
}