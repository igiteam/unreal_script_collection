/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoHUDMP_Base extends NanoHUD_Base
	abstract;

var int PlayerOwnerTeam;

function DrawHUD()
{
	PlayerOwnerTeam = PlayerOwner.GetTeamNum();
	Super.DrawHUD();

	if (PlayerOwner.GetTeamNum() != 255)
	{
		Canvas.SetPos(30,30);
		Canvas.DrawText("TEAM SCORE:"@int(PlayerOwner.PlayerReplicationInfo.Team.Score));
		Canvas.DrawText("ENEMY TEAM SCORE:"@int(WorldInfo.GRI.Teams[(PlayerOwner.GetTeamNum() + 1) % 2].Score));
	}
}

function SetHUDDrawColor( ENanoHUDColor eColor, byte Alpha = 255 )
{
	switch ( eColor )
	{
	case eNANOHUDCOLOR_WHITE:
		if (PlayerOwnerTeam == 0)
		{
			Canvas.SetDrawColor( 140, 140, 240, Alpha );
		}
		else if (PlayerOwnerTeam == 1)
		{
			Canvas.SetDrawColor( 240, 140, 140, Alpha );
		}
		else
		{
			Canvas.SetDrawColor( 240, 240, 240, Alpha );
		}
		break;

	case eNANOHUDCOLOR_RED:
		Canvas.SetDrawColor( 170, 0, 0, Alpha );
		break;

	case eNANOHUDCOLOR_BLACK:
		Canvas.SetDrawColor( 0, 0, 0, Alpha );
		break;

	case eNANOHUDCOLOR_WHITE_DK:
		if (PlayerOwnerTeam == 0)
		{
			Canvas.SetDrawColor( 100, 100, 200, Alpha );
		}
		else if (PlayerOwnerTeam == 1)
		{
			Canvas.SetDrawColor( 200, 100, 100, Alpha );
		}
		else
		{
			Canvas.SetDrawColor( 200, 200, 200, Alpha );
		}
		break;

	case eNANOHUDCOLOR_TEAMRED:
		Canvas.SetDrawColor( 205, 22, 22, Alpha );
		break;

	case eNANOHUDCOLOR_TEAMBLUE:
		Canvas.SetDrawColor( 139, 255, 255, Alpha );
		break;

	case eNANOHUDCOLOR_CHATICONRED:
		Canvas.SetDrawColor( 164, 63, 63, Alpha );
		break;

	case eNANOHUDCOLOR_CHATICONBLUE:
		Canvas.SetDrawColor( 170, 192, 205, Alpha );
		break;
	}
}

defaultproperties
{

}

