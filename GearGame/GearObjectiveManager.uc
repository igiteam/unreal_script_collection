/*****************************************************************************
 * GearObjectiveManager
 * Manages the objective system for the GearPC
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *****************************************************************************/
class GearObjectiveManager extends Object within GearPC
	config(Game);

/*****************************************************************************
	Structs, enums, and variables
*****************************************************************************/

/** List of current objectives */
var array<ObjectiveInfo> Objectives;

/** Amount of time an objective will draw on the screen since it was last updated. */
var const float TotalDisplayTime;
/** The maximum number of objectives to show at one time. */
var const int TotalObjectivesToDraw;

/** Displays when there is no objective */
var localized String ObjectivesCompleteText;

/** number of points to award for objectives in Arcade Mode (this many subtracted for failed objectives) */
var config int ObjectiveScore;

/** Icon to be shown next to active objectives */
var transient CanvasIcon ActiveObjectiveIcon;

/** font info used to draw objective text */
var FontRenderInfo ObjectiveRenderInfo;

/**
* The text in the objective structure is actually a path to the localized string,
* so we have to go retrieve it from the localization system.
*/
final function string RetrieveObjectiveString(string TagName, string Variables)
{
	local array<string> Replacements;
	local string Result;
	local int i;

	Result = ParseLocalizedPropertyPath(TagName);

	ParseStringIntoArray(Variables, Replacements, "|", false);
	for (i = 0; i < Replacements.length; i++)
	{
		Result = Repl(Result, "~" $ i, Replacements[i], false);
	}

	return Result;
}

/** Handles the update from kismet to the objective system. */
final function OnManageObjectives( SeqAct_ManageObjectives Action )
{
	local Array<Object> PotentialLocators;
	local int LocatorIdx;
	local Object PotLocator;
	local GearObjectiveLocator Locator;
	local GearObjectiveLocator ObjLocators[MAX_OBJLOCATORS];

	// Add or Update an objective
	if ( Action.InputLinks[0].bHasImpulse )
	{
		// Only put in the locators on creation or update
		// Filter out all objects that are not GearObjectiveLocators from the PotentialLocators list

		Action.GetObjectVars(PotentialLocators , "Objective Locator (Max 10)");
		LocatorIdx = 0;
		foreach PotentialLocators(PotLocator)
		{
			Locator = GearObjectiveLocator(PotLocator);
			if (Locator != none)
			{
				ObjLocators[LocatorIdx] = Locator;
				LocatorIdx++;
				if (LocatorIdx >= MAX_OBJLOCATORS)
				{
					break;
				}
			}
		}

		AddObjective(Action.ObjectiveName, "level_objectives.Objectives." $ Action.ObjectiveDesc, Action.bNotifyPlayer, Action.bShowInList, ObjLocators,,Action.bShowAlways);
	}
	// Completed an objective
	else if ( Action.InputLinks[1].bHasImpulse )
	{
		CompleteObjective(Action.ObjectiveName, Action.bNotifyPlayer, "");
	}
	// Failed an objective
	else if ( Action.InputLinks[2].bHasImpulse )
	{
		FailObjective(Action.ObjectiveName, Action.bNotifyPlayer, "");
	}
}

/** Clears the objective list */
final public function ClearObjectives()
{
	Objectives.length = 0;
}

/** Updates the objective list. */
final protected function UpdateObjective(name ObjectiveName, string ObjectiveDesc, bool bCompleted, bool bFailed, bool bNotifyPlayer, optional bool bShowInList=true, optional GearObjectiveLocator Locators[MAX_OBJLOCATORS], optional string ObjectiveDescVars, optional bool bAlwaysDraw)
{
	local GearPRI_SP PRI;
	local int Idx, Iter;
	local float TotalScore;

	// See if the objective is in the list
	Idx = Objectives.Find( 'ObjectiveName',ObjectiveName );

	// If it's not in the list add it.
	if (Idx == -1)
	{
		Idx = Objectives.length;
		Objectives.length = Idx + 1;
		Objectives[Idx].ObjectiveName = ObjectiveName;
	}

	// update Arcade scoring if necessary
	PRI = GearPRI_SP(Outer.PlayerReplicationInfo);
	if (PRI != None)
	{
		// apply score directly instead of calling ModifyScore() so that the multiplier in Arcade is not affected
		if (bCompleted && !Objectives[Idx].bCompleted)
		{
			TotalScore = ObjectiveScore;
			if (GearGRI_SP_Arcade(WorldInfo.GRI) != None)
			{
				TotalScore *= GearGRI_SP_Arcade(WorldInfo.GRI).TeamMultiplier;
			}
			PRI.Score += TotalScore;
			PRI.bForceNetUpdate = true;
		}
		if (bFailed && !Objectives[Idx].bFailed)
		{
			PRI.Score -= ObjectiveScore;
			PRI.bForceNetUpdate = true;
		}
	}

	// Update the description, time, and flags
	Objectives[Idx].bCompleted = bCompleted;
	Objectives[Idx].bFailed = bFailed;
	Objectives[Idx].ObjectiveDesc = ObjectiveDesc;
	Objectives[Idx].ObjectiveDescVars = ObjectiveDescVars;
	Objectives[Idx].UpdatedTime = WorldInfo.TimeSeconds;
	Objectives[Idx].bNotifyPlayer = bNotifyPlayer;
	Objectives[Idx].bShowInList = bShowInList;
	Objectives[Idx].bLocatorWasSent = false;
	Objectives[Idx].bAlwaysDraw = bAlwaysDraw;
	for (Iter =0; Iter < MAX_OBJLOCATORS; Iter++)
	{
		Objectives[Idx].Locators[Iter] = Locators[Iter];
		if (Locators[Iter] != None)
		{
			Objectives[Idx].bLocatorWasSent = true;
		}
	}


	// Replicate to the client if not a local controller
	if ( !IsLocalPlayerController() )
	{
		ClientReplicateObjective( Objectives[Idx], Idx );
	}
	//Otherwise we have to do the work ourselves since ClientReplicateObjective will not be called
	else
	{
		CreateLocatorsForObjective(Objectives[Idx]);
	}
}

/** adds, updates, completes, or fails an objective based on the data in the passed in ObjectiveInfo */
final function AddObjectiveInfo(const out ObjectiveInfo ObjInfo)
{
	if (ObjInfo.bFailed)
	{
		FailObjective(ObjInfo.ObjectiveName, ObjInfo.bNotifyPlayer, ObjInfo.ObjectiveDescVars);
	}
	else if (ObjInfo.bCompleted)
	{
		CompleteObjective(ObjInfo.ObjectiveName, ObjInfo.bNotifyPlayer, ObjInfo.ObjectiveDescVars);
	}
	else
	{
		AddObjective(ObjInfo.ObjectiveName, ObjInfo.ObjectiveDesc, ObjInfo.bNotifyPlayer, ObjInfo.bShowInList, ObjInfo.Locators, ObjInfo.ObjectiveDescVars);
	}
}

/** Adds or updates an objective */
final function AddObjective( Name ObjName, string ObjDesc, bool bNotifyPlayer, optional bool bShowInList=true, optional GearObjectiveLocator Locators[MAX_OBJLOCATORS], optional string ObjectiveDescVars, optional bool bAlwaysDraw)
{
	local int Idx;
	local bool bUpdate;

	if (ObjName != '')
	{
		// See if the objective is in the list
		Idx = Objectives.Find('ObjectiveName', ObjName);

		// Set the updated flag based on whether the objective already exists or not.
		bUpdate = (Idx != -1);

		// Update the objective
		UpdateObjective(ObjName, ObjDesc, FALSE, FALSE, bNotifyPlayer, bShowInList, Locators, ObjectiveDescVars, bAlwaysDraw);

		// Play sound if needed
		if (bNotifyPlayer)
		{
			if (bUpdate)
			{
				ClientPlaySound(SoundCue'Interface_Audio.Objectives.UpdateObjective');
			}
			else
			{
				ClientPlaySound(SoundCue'Interface_Audio.Objectives.AddObjective');
			}
		}
	}
}

/** Completes an objective from the list and optionally plays a sound. */
final function CompleteObjective(name ObjName, bool bNotifyPlayer, string ObjectiveDescVars)
{
	local int Idx;

	if (ObjName != '')
	{
		// Make sure the objective already exists
		Idx = Objectives.Find('ObjectiveName',ObjName);
		if (Idx != -1 )
		{
			// Update the objective
			UpdateObjective(ObjName, Objectives[Idx].ObjectiveDesc, TRUE, FALSE, Objectives[Idx].bShowInList, bNotifyPlayer,, ObjectiveDescVars);

			// Play sound if needed
			if (bNotifyPlayer)
			{
				ClientPlaySound(SoundCue'Interface_Audio.Objectives.CompleteObjective');
			}
		}
	}
}

/** Fails an objective from the list and optionally plays a sound. */
final function FailObjective(name ObjName, bool bNotifyPlayer, string ObjectiveDescVars)
{
	local int Idx;

	if (ObjName != '')
	{
		// Make sure the objective already exists
		Idx = Objectives.Find('ObjectiveName', ObjName);
		if (Idx != -1 )
		{
			// Update the objective
			UpdateObjective(ObjName, Objectives[Idx].ObjectiveDesc, FALSE, TRUE, Objectives[Idx].bShowInList, bNotifyPlayer,, ObjectiveDescVars);

			// Play sound if needed
			if (bNotifyPlayer)
			{
				ClientPlaySound(SoundCue'Interface_Audio.Objectives.FailObjective');
			}
		}
	}
}

/** removes an objective, clearing it from the display immediately without completing or failing it */
final function RemoveObjective(name ObjName)
{
	local int Idx;

	Idx = Objectives.Find('ObjectiveName', ObjName);
	if (Idx != INDEX_NONE)
	{
		Objectives.Remove(Idx, 1);
	}

	Outer.ClientRemoveObjective(ObjName);
}

/** Loops backwards through all of the objectives and draws them to the HUD in the top left corner of the screen. */
final function DrawObjectives(GearHUD_Base GHUD, optional float AlphaPercent = 1.0, optional float ExtraYOffset, optional bool bUseUpdateCheck, optional bool bIsGameoverScreen)
{
	local float DrawX, DrawY, ObjectiveWidth;
	local int Idx;
	local float TextSizeX, TextSizeY;
	local byte TextAlpha, BGAlpha;
	local EGearHUDColor TextColor;
	local float BackgroundOffset, ObjTime, CalcAlpha;
	local bool bDrawStrike;
	local int StrikeCount, NumActiveObjs, NumNonActiveToDraw, NumObjsToDraw, ObjectiveCount;
	local String ObjDesc;

	// Draw nothing if there is no opacity
	if ( AlphaPercent <= 0.f || GHUD == None || GHUD.Canvas == None)
	{
		return;
	}

	// Set the font
	GHUD.Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);

	// Initialize some variables

	BackgroundOffset = 2.f;
	if ( bIsGameoverScreen )
	{
		DrawX = 8;
		DrawY = 2;
	}
	else
	{
		DrawX = GHUD.SafeZoneLeft;
		DrawY = GHUD.SafeZoneTop + BackgroundOffset;
	}
	DrawY += ExtraYOffset;

	StrikeCount = 0;
	NumObjsToDraw = TotalObjectivesToDraw;

	// If we have objectives...
	if ( Objectives.Length > 0 )
	{
		// See how many active objectives are left
		for ( Idx = Objectives.Length-1; Idx >= 0; Idx-- )
		{
			if ( !Objectives[Idx].bCompleted && !Objectives[Idx].bFailed && Objectives[Idx].bShowInList)
			{
				NumActiveObjs++;
			}
		}
		NumNonActiveToDraw = max( 0, NumObjsToDraw-NumActiveObjs );

		// Draw each one
		for ( Idx = 0; Idx < Objectives.Length; Idx++ )
		{
			// Don't draw more than 'TotalObjectivesToDraw' number of objectives
			if ( NumObjsToDraw <= 0 )
			{
				break;
			}

			// abort if the description is invalid or if it should not be drawn
			if (Objectives[Idx].ObjectiveDesc == "" || !Objectives[Idx].bShowInList)
			{
				continue;
			}

			// We can only draw 'TotalObjectivesToDraw' number of objectives so we may have to skip some completed ones to
			// get to the uncompleted ones.
			if ( Objectives[Idx].bCompleted || Objectives[Idx].bFailed )
			{
				if ( (Objectives[Idx].bCompleted && ((WorldInfo.TimeSeconds - Objectives[Idx].UpdatedTime) >= TotalDisplayTime)) || (NumNonActiveToDraw <= 0) )
				{
					continue;
				}
				else
				{
					NumNonActiveToDraw--;
				}
			}

			if ( !Objectives[Idx].bAlwaysDraw && bUseUpdateCheck && (!Objectives[Idx].bNotifyPlayer || ((WorldInfo.TimeSeconds - Objectives[Idx].UpdatedTime) >= TotalDisplayTime)) )
			{
				continue;
			}

			// Figure out the alpha based on updated time
			ObjTime = WorldInfo.TimeSeconds - Objectives[Idx].UpdatedTime;
			if ( !Objectives[Idx].bAlwaysDraw && bUseUpdateCheck )
			{
				CalcAlpha = (ObjTime > TotalDisplayTime-2.0f) ? 1.f - ((ObjTime - (TotalDisplayTime-2.0f))/2.f) : 1.f;
				if ( CalcAlpha <= 0.f )
				{
					CalcAlpha = 0.f;
				}
				AlphaPercent *= CalcAlpha;
			}

			// No opacity so continue
			if ( AlphaPercent <= 0.f )
				continue;

			// Determine the alphas, colors, and whether to strike through or not
			if ( Objectives[Idx].bCompleted )
			{
				TextAlpha = 120;
				BGAlpha = 100;
				TextColor = eWARHUDCOLOR_WHITE;
				bDrawStrike = true;
			}
			else if ( Objectives[Idx].bFailed )
			{
				TextAlpha = 255;
				BGAlpha = 200;
				TextColor = eWARHUDCOLOR_RED;
				bDrawStrike = true;
			}
			else
			{
				TextAlpha = 255;
				BGAlpha = 200;
				TextColor = eWARHUDCOLOR_WHITE;
			}

			// Get the objective text
			ObjDesc = RetrieveObjectiveString(Objectives[Idx].ObjectiveDesc, Objectives[Idx].ObjectiveDescVars);

			GHUD.Canvas.TextSize( ObjDesc, TextSizeX, TextSizeY );
			ObjectiveWidth = bIsGameoverScreen ? GHUD.Canvas.ClipX : FMax(TextSizeX+16, (GHUD.Canvas.ClipX/3));

			// Move the objectives down if the countdown timer is showing and will cause overlap
			if ( !bIsGameoverScreen && (ObjectiveCount == 0) && GHUD.CountdownTimerIsShowing() && ((DrawX - 8.0f + ObjectiveWidth + 5.0f) > GHUD.GetCountdownXPosition())
				&& DrawY < GHUD.GetCountdownYPosition() + GHUD.CountdownSize.Y )
			{
				DrawY += TextSizeY + 6.f;
			}

			// ActiveObjectiveIcon - only drawn if objective is still pending AND it has an objective locator connected
			if (!Objectives[Idx].bCompleted  && !Objectives[Idx].bFailed && Objectives[Idx].Locators[0] != None)
			{
				`SetHUDDrawColorExt(GHUD,GHUD.HudColors[eWARHUDCOLOR_WHITE], TextAlpha*AlphaPercent );
				GHUD.Canvas.DrawIcon( ActiveObjectiveIcon, DrawX - ActiveObjectiveIcon.UL/2, DrawY-BackgroundOffset-4, 1.0f );
				DrawX += ActiveObjectiveIcon.UL;
			}

			// Background
			`SetHUDDrawColorExt(GHUD,GHUD.HudColors[eWARHUDCOLOR_BLACK], BGAlpha*AlphaPercent );
			GHUD.DrawObjectiveBack( Texture2D'Warfare_HUD.WarfareHUD_main', 156, 29, 21, 19, DrawX-8, DrawY-BackgroundOffset, ObjectiveWidth, TextSizeY+2*BackgroundOffset );

			// Label
			GHUD.Canvas.SetPos(DrawX,DrawY);
			`SetHUDDrawColorExt(GHUD, GHUD.HudColors[TextColor], TextAlpha*AlphaPercent );
			ObjectiveRenderInfo.GlowInfo.bEnableGlow =(!Objectives[Idx].bFailed && Objectives[Idx].bNotifyPlayer && ObjTime < 1.0);
			if (ObjectiveRenderInfo.GlowInfo.bEnableGlow)
			{
				ObjectiveRenderInfo.GlowInfo.GlowColor.A = Abs(Sin(Pi * ObjTime));
			}
			GHUD.Canvas.DrawText(ObjDesc,,,, ObjectiveRenderInfo);

			// Strike through
			if ( bDrawStrike )
			{
				DrawStrikeThru( GHUD, StrikeCount, DrawX-8, DrawY-BackgroundOffset, bIsGameoverScreen ? GHUD.Canvas.ClipX : fmax(TextSizeX+16, (GHUD.Canvas.ClipX/3)), TextSizeY, TextColor, 255*AlphaPercent );
				StrikeCount++;
			}

			DrawY += TextSizeY + 6.f;
			bDrawStrike = false;
			NumObjsToDraw--;
			ObjectiveCount++;
		}
	}
	// Otherwise pretend all objectives are completed
	else if ( !bUseUpdateCheck )
	{
		// Background
		GHUD.Canvas.TextSize( ObjectivesCompleteText, TextSizeX, TextSizeY );
		ObjectiveWidth = bIsGameoverScreen ? GHUD.Canvas.ClipX : fmax(TextSizeX+16, (GHUD.Canvas.ClipX/3));

		// Move the objectives down if the countdown timer is showing and will cause overlap
		if ( !bIsGameoverScreen && GHUD.CountdownTimerIsShowing() && ((DrawX - 8.0f + ObjectiveWidth + 5.0f) > GHUD.GetCountdownXPosition()) )
		{
			DrawY += TextSizeY + 6.f;
		}

		`SetHUDDrawColorExt(GHUD,GHUD.HudColors[eWARHUDCOLOR_BLACK], 130*AlphaPercent );
		GHUD.DrawObjectiveBack( Texture2D'Warfare_HUD.WarfareHUD_main', 156, 29, 21, 19, DrawX-8, DrawY-BackgroundOffset, bIsGameoverScreen ? GHUD.Canvas.ClipX : fmax(TextSizeX+16, (GHUD.Canvas.ClipX/3)), TextSizeY+2*BackgroundOffset );

		// Label
		`SetHUDDrawColorExt(GHUD,GHUD.HudColors[eWARHUDCOLOR_WHITE], 255*AlphaPercent );
		GHUD.Canvas.SetPos(DrawX,DrawY);
		GHUD.Canvas.DrawText( ObjectivesCompleteText );
	}
}

/** Draws a strike through */
final protected function DrawStrikeThru( GearHUD_Base GHUD, int StrikeCount, float DrawX, float DrawY, float Width, float Height, EGearHUDColor eColor, byte Alpha )
{
	GHUD.Canvas.SetPos( DrawX, DrawY );
	`SetHUDDrawColorExt(GHUD,GHUD.HudColors[eColor], Alpha );

	switch ( StrikeCount % 4 )
	{
	case 0:
		GHUD.Canvas.DrawTile( Texture2D'Warfare_HUD.HUD_Objective_Strike', Width, Height, 0, 0, 512, 32 );
		break;
	case 1:
		GHUD.Canvas.DrawTile( Texture2D'Warfare_HUD.HUD_Objective_Strike', Width, Height, 512, 0, -512, 32 );
		break;
	case 2:
		GHUD.Canvas.DrawTile( Texture2D'Warfare_HUD.HUD_Objective_Strike', Width, Height, 0, 32, 512, -32 );
		break;
	case 3:
		GHUD.Canvas.DrawTile( Texture2D'Warfare_HUD.HUD_Objective_Strike', Width, Height, 512, 32, -512, -32 );
		break;
	}
}

/** Function to create the hud locator objects for the specified objective
 *  @param Info - The ObjectiveInfo structure for the objective to create the locators for
 */
final simulated function CreateLocatorsForObjective(ObjectiveInfo Info)
{
	local int Index;
	local GearHUDLocator HUDLocator;
	local GearHUDLocator_Objective ObjHUDLocator;
	local GearPRI PRI;

	if ( MyGearHud != none)
	{
		//First remove old locators
		foreach MyGearHud.HUDLocators(HUDLocator)
		{
			ObjHUDLocator = GearHUDLocator_Objective(HUDLocator);
			if (ObjHUDLocator != none && ObjHUDLocator.ObjectiveName == Info.ObjectiveName)
			{
				MyGearHud.RemoveHUDLocator(ObjHUDLocator);
			}
		}

		PRI = GearPRI(PlayerReplicationInfo);
		if (PRI != None)
		{
			//Then add new locators
			for (Index = 0; Index < MAX_OBJLOCATORS; Index++)
			{
				// Only add the locator if it's of the appropriate difficulty level
				if (Info.Locators[Index] != none &&
					Info.Locators[Index].DiffLevel >= PRI.Difficulty.default.DifficultyLevel)
				{
					ObjHUDLocator = GearHUDLocator_Objective(MyGearHud.AddHUDLocator(class'GearHUDLocator_Objective', Info.Locators[Index]));
					if (ObjHUDLocator != none)
					{
						ObjHUDLocator.ObjectiveName = Info.ObjectiveName;
						if(Info.bAlwaysDraw)
						{
							ObjHUDLocator.TimeToLingerWithoutTaccom = -1;
						}
					}
				}
			}
		}
	}
}

defaultproperties
{
	TotalDisplayTime=5.0f
	TotalObjectivesToDraw=3
	ActiveObjectiveIcon=(Texture=Texture2D'Warfare_HUD.HUD.UI_HUD_Leader',U=0,V=0,UL=32,VL=32)
	ObjectiveRenderInfo=(bEnableShadow=true,GlowInfo=(GlowColor=(R=1.0,G=1.0,B=1.0,A=1.0),GlowOuterRadius=(X=0.3,Y=0.45),GlowInnerRadius=(X=0.45,Y=0.5)))
}
