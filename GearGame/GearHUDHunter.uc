/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearHUDHunter extends GearHUDMP_Base
	abstract;

var GearHUDLocator LeaderLocator;

function DrawHUD()
{
	local GearPawn P, LeaderPawn;
	local GearHunterPRI PRI;
	local byte BestNumHats;

	Super.DrawHUD();

	if (bShowHud && !HideHUDFromScenes() && GRI.GameStatus == GS_RoundInProgress)
	{
		BestNumHats = 0;
		foreach WorldInfo.AllPawns(class'GearPawn', P)
		{
			if (P != PlayerOwner.ViewTarget)
			{
				// select player with most hats on enemy team
				PRI = GearHunterPRI(P.PlayerReplicationInfo);
				if (PRI != None && PRI.NumHats > BestNumHats && !WorldInfo.GRI.OnSameTeam(PRI, PlayerOwner.ViewTarget))
				{
					LeaderPawn = P;
				}
			}
		}

		if (LeaderPawn != None)
		{
			if (LeaderLocator != None && HUDLocators.Find(LeaderLocator) != INDEX_NONE)
			{
				LeaderLocator.LocatorSubject = LeaderPawn;
			}
			else
			{
				LeaderLocator = AddHUDLocator(class'GearHUDLocator_Leader', LeaderPawn);
			}
		}
		else
		{
			RemoveHUDLocator(LeaderLocator);
			LeaderLocator = None;
		}
	}
}
