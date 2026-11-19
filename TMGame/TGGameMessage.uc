/**
 *
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */


class TGGameMessage extends GameMessage
	abstract;

static function ClientReceive( PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1,
				optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	//local TGPC PC;

	// no messages in the menu level
	if (class'WorldInfo'.static.IsMenuLevel())
	{
		return;
	}

	// only display leave and join messages on HUD
	if (Switch == 4 || Switch == 1)
	{
		//PC = TGPC(P);

		// only show join messages during the match
		if (Switch == 1 && (TGGRI(P.WorldInfo.GRI).GameStatus == GS_PreMatch || TGGRI(P.WorldInfo.GRI).GameStatus == GS_None || TGGRI(P.WorldInfo.GRI).GameStatus == GS_WaitingForHost))
		{
			return;
		}

		//if (PC != None && PC.MyUTHUD != None)
		//{
		//	PC.MyUTHUD.AddPlayerJoinMessage(RelatedPRI_1, static.GetString(Switch, false, RelatedPRI_1, RelatedPRI_2, OptionalObject));
		//}
	}
}
