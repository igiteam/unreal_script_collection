/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearHUDWingman_Base extends GearHUDMP_Base
	abstract;

/** String to display when your buddy has died */
var localized string BuddyDiedString;

/** String to display when weapons are available */
var localized string WeaponsSpawnedString;

/** Played when my buddy is killed **/
var SoundCue MyBuddyDiedSound;
/** Audio component for buddy died sounds */
var AudioComponent BuddyDiedAudioComponent;

/** Reference to my Buddy's PRI */
var GearPRI MyBuddyPRI;
/** Reference to my Buddy's pawn */
var GearPawn MyBuddyPawn;

/** background image for combatants display */
var CanvasIcon CombatantsBG;
/** emblems drawn under the local player's team faces */
var CanvasIcon TeamEmblemCOG, TeamEmblemLOC;
/** blood splat icon for dead characters */
var MaterialInterface BloodSplat;

/** MICs for the various players' head icons */
var array<PawnHeadMIC> HeadMICs;
/** colors to draw on them */
var LinearColor HeadColorDead, HeadColorAlive;

/** Overloaded Draw call */
function DrawHUD()
{
	local GearPawn AWPawn;
	local GearPRI MyGearPRI, OtherPRI;
	local GearPC MyGearPC;
	local int PRIIdx, NewIdx;
	local float DrawX, DrawY, Size;
	local byte bEncounteredTeam[4];

	Super.DrawHUD();

	if (bShowHud &&
		!HideHUDFromScenes() &&
		(WorldInfo.GRI != None) &&
		(GearGRI(WorldInfo.GRI).GameStatus == GS_RoundInProgress) )
	{
		MyGearPC = GearPC(PlayerOwner);
		MyGearPRI = GearPRI(MyGearPC.PlayerReplicationInfo);
		MyBuddyPawn = None;
		MyBuddyPRI = None;

		// Look for my buddy's pawn
		foreach WorldInfo.AllPawns( class'GearPawn', AWPawn )
		{
			if (AWPawn.PlayerReplicationInfo != None && MyGearPRI != AWPawn.PlayerReplicationInfo && MyGearPRI.GetTeamNum() == AWPawn.PlayerReplicationInfo.GetTeamNum())
			{
				MyBuddyPawn = AWPawn;
				MyBuddyPRI = GearPRI(AWPawn.PlayerReplicationInfo);
				break;
			}
		}

		// Didn't find the pawn and pri so lets look for the pri in the priarray (dude might be dead)
		if ( MyBuddyPRI == None )
		{
			for (PRIIdx = 0; PRIIdx < WorldInfo.GRI.PRIArray.length; PRIIdx++)
			{
				if (WorldInfo.GRI.PRIArray[PRIIdx] != MyGearPRI &&
					 WorldInfo.GRI.PRIArray[PRIIdx].GetTeamNum() == MyGearPRI.GetTeamNum() )
				{
					MyBuddyPRI = GearPRI(WorldInfo.GRI.PRIArray[PRIIdx]);
					break;
				}
			}
		}

		// If there is no buddy PRI that means you don't have one
		if ( MyBuddyPRI != None && MyBuddyPawn != None &&
			(MyBuddyPawn.TimeOfDeath == 0.0 || WorldInfo.TimeSeconds - MyBuddyPawn.TimeOfDeath < 2.0) )
		{
			AddHUDLocator(class'GearHUDLocator_Wingman', MyBuddyPawn);
		}

		// draw combatants display
		if (MyGearPRI.Team != None)
		{
			`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], 255);
			Canvas.DrawIcon(CombatantsBG, 137, 53);
			Canvas.DrawIcon(IsCOG(MyGearPRI) ? TeamEmblemCOG : TeamEmblemLOC, 57, 32);

			if (HeadMICs.length != WorldInfo.GRI.PRIArray.length)
			{
				// the array is out of date
				for (PRIIdx = 0; PRIIdx < WorldInfo.GRI.PRIArray.length; PRIIdx++)
				{
					OtherPRI = GearPRI(WorldInfo.GRI.PRIArray[PRIIdx]);
					if (HeadMICs.Find('PRI', OtherPRI) == INDEX_NONE)
					{
						NewIdx = HeadMICs.Add(1);
						HeadMICs[NewIdx].PRI = OtherPRI;
					}
				}
			}
			// draw the heads
			bEncounteredTeam[0] = 0; //@hack: work around erroneous compiler warning
			for (PRIIdx = 0; PRIIdx < HeadMICs.length; PRIIdx++)
			{
				if (HeadMICs[PRIIdx].PRI == None || HeadMICs[PRIIdx].PRI.bDeleteMe)
				{
					HeadMICs.Remove(PRIIdx, 1);
					PRIIdx--;
				}
				else
				{
					if ( HeadMICs[PRIIdx].MIC == None && HeadMICs[PRIIdx].PRI.PawnClass != None &&
						HeadMICs[PRIIdx].PRI.PawnClass.default.HeadIcon != None )
					{
						HeadMICs[PRIIdx].MIC = new(self) class'MaterialInstanceConstant';
						HeadMICs[PRIIdx].MIC.SetParent(HeadMICs[PRIIdx].PRI.PawnClass.default.HeadIcon);
					}
					if (HeadMICs[PRIIdx].PRI.Team != None)
					{
						if (HeadMICs[PRIIdx].PRI == MyGearPRI)
						{
	     						DrawX = 85.0;
	     						DrawY = 62.0;
	     						Size = 52.0;
	     					}
	     					else if (HeadMICs[PRIIdx].PRI.Team == MyGearPRI.Team)
	     					{
	     						DrawX = 56.0;
	     						DrawY = 30.0;
	     						Size = 52.0;
	     					}
	     					else
						{
		     					if (bool(bEncounteredTeam[HeadMICs[PRIIdx].PRI.Team.TeamIndex]))
		     					{
		     						DrawX = 166.0;
		     						DrawY = 64.0;
		     					}
		     					else
		     					{
		     						DrawX = 147.0;
		     						DrawY = 41.0;
		     						bEncounteredTeam[HeadMICs[PRIIdx].PRI.Team.TeamIndex] = 1;
		     					}
		     					if (HeadMICs[PRIIdx].PRI.Team.TeamIndex > MyGearPRI.Team.TeamIndex)
		     					{
		     						DrawX += 52.0 * (HeadMICs[PRIIdx].PRI.Team.TeamIndex - 1);
		     					}
		     					else
		     					{
		     						DrawX += 52.0 * HeadMICs[PRIIdx].PRI.Team.TeamIndex;
		     					}
		     					Size = 39.0;
		     				}
		     				if (HeadMICs[PRIIdx].PRI.bIsDead)
		     				{
		     					HeadMICs[PRIIdx].MIC.SetVectorParameterValue('HeadColor', HeadColorDead);
		     				}
		     				else
		     				{
		     					HeadMICs[PRIIdx].MIC.SetVectorParameterValue('HeadColor', HeadColorAlive);
		     				}
		     				Canvas.SetPos(DrawX, DrawY);
		     				Canvas.DrawMaterialTile(HeadMICs[PRIIdx].MIC, Size, Size, 0.0, 0.0, 1.0, 1.0);
		     				if (HeadMICs[PRIIdx].PRI.bIsDead)
		     				{
		     					Size = (HeadMICs[PRIIdx].PRI.Team == MyGearPRI.Team) ? 1.0 : 0.75;
		     					Canvas.SetPos(DrawX - 2.0, DrawY - 15.0 * Size);
		     					Canvas.DrawMaterialTile(BloodSplat, 68.0 * Size, 76.0 * Size, 0.0, 0.0, 1.0, 1.0);
		     				}
					}
				}
			}
		}
	}
}

function EGearHUDColor GetSquadMateNameColor(GearPawn SquadmatePawn)
{
	// in Wingman we can't rely on team number so look it up by using their pawn class
	return IsCOG(SquadmatePawn.PlayerReplicationInfo) ? eWARHUDCOLOR_TEAMBLUE : eWARHUDCOLOR_TEAMRED;
}

/** Message from the game object that my buddy has died */
function StartBuddyDiedMessage(GearPRI BuddyPRI)
{
	StartDrawingDramaticText(BuddyDiedString, BuddyPRI.PlayerName, 8.0f, 0.25f, 2.0f, GetCountdownYPosition() + CountdownSize.Y + GearPC(PlayerOwner).NumPixelsToMoveDownForDramaText(), 0.25f, 2.0f);

	if (BuddyDiedAudioComponent != None && BuddyDiedAudioComponent.IsPlaying())
	{
		BuddyDiedAudioComponent.Stop();
	}
	BuddyDiedAudioComponent = CreateAudioComponent(MyBuddyDiedSound, true, true);
}

/** Message from the game object that weapons are available */
function StartWeaponSpawnedMessage()
{
	StartDrawingDramaticText(WeaponsSpawnedString, "", 8.0f, 0.25f, 2.0f, GetCountdownYPosition() + CountdownSize.Y + GearPC(PlayerOwner).NumPixelsToMoveDownForDramaText(), 0.25f, 2.0f);
}

/** Whether we should draw the team color of the player */
function bool ShouldDrawTeamColor( PlayerReplicationInfo OtherPRI )
{
	if (PlayerOwner.PlayerReplicationInfo != None && OtherPRI != None)
	{
		return (PlayerOwner.PlayerReplicationInfo.GetTeamNum() == OtherPRI.GetTeamNum());
	}
	else
	{
		return false;
	}
}

/** Sets a timer to close the end of round scene
 *	Overriding this to NOT set a timer, let the EOR scene close itself.
 */
function SetCloseEndOfRoundSceneTimer()
{
}

/** Uses the game status to determine if the scoreboard should be showing or not */
function bool ShouldShowScoreboardBasedOnGameStatus()
{
	return ( GearGRI(WorldInfo.GRI).GameStatus != GS_RoundInProgress && GearGRI(WorldInfo.GRI).GameStatus != GS_RoundOver &&
		 GearGRI(WorldInfo.GRI).GameStatus != GS_Loading );
}

// no need for taccom locator since the wingman one will always be up
function ConstructTaccomLocators(optional GearPawn OtherGP);

defaultproperties
{
	HeadColorDead=(R=0.5,G=0.0,B=0.0,A=1.0)
	HeadColorAlive=(R=1.0,G=1.0,B=1.0,A=1.0)
}
