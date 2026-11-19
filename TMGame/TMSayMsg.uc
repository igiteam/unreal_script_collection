/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMSayMsg extends TMLocalMessage;

var color RedTeamColor,BlueTeamColor;

static function color GetConsoleColor( PlayerReplicationInfo RelatedPRI_1 )
{
	if ( (RelatedPRI_1 == None) || (RelatedPRI_1.Team == None) )
		return Default.DrawColor;

	if ( RelatedPRI_1.Team.TeamIndex == 0 )
		return Default.RedTeamColor;
	else
		return Default.BlueTeamColor;
}

