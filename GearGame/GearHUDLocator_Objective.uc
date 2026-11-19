/**
 * GearHUDLocator_Objective
 *
 * Class that controls and draws a single UI HUD locator for an objective location
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearHUDLocator_Objective extends GearHUDLocator;

/************************************************************************/
/* Member variables                                                     */
/************************************************************************/

//Name of the objective text
var name ObjectiveName;

//How long to linger when it initially appears
var float TimeToLingerWithoutTaccom;

//The time when it initially appeared
var float StartTime;

//Whether or not we are fading away the initial appearance
var bool bFadingAway;


/************************************************************************/
/* Script functions                                                     */
/************************************************************************/
/** Whether or not this locator should be removed from the HUD */
function bool ShouldDeleteLocator()
{
	local GearPC PC;
	local int Index;
	local GearObjectiveManager GOM;
	
	PC = GearPC(OwningHUD.PlayerOwner);
	
	GOM = PC.ObjectiveMgr;
	if (GOM == none)
	{
		return true;
	}
	Index = GOM.Objectives.Find('ObjectiveName', ObjectiveName);
	
	return (Index == -1
			|| GOM.Objectives[Index].bFailed
			|| GOM.Objectives[Index].bCompleted
			);
}

/** Set the text to the subject's name, then draw it */
function DrawText()
{
	local GearObjectiveLocator ObjLocator;
	local float TempFloat;
	
	ObjLocator = GearObjectiveLocator(LocatorSubject);
	if (ObjLocator != None && ObjLocator.DisplayName != "")
	{
		Text = Localize("OBJECTIVE LOCATOR NAMES",ObjLocator.DisplayName, "level_objectives");
	}
	else
	{
		Text = "";
	}
	
	//Make the text alpha act essentially in the reverse way that the locator alpha does
	if (LocatorAlpha != 0.0)
	{
		if (CurrAlphaRegion.RegionName == 'OmenRegion' && CurrAlphaRegion.bIsActive)
		{
			TempFloat = 1.0+CurrAlphaRegion.DestinationAlpha-LocatorAlpha;
			if (TempFloat > 1.0)
			{
				TempFloat = 1.0;
			}
			TextAlpha = TempFloat/LocatorAlpha;
		}
		else
		{
			TextAlpha = (1.0-LocatorAlpha)/LocatorAlpha;
		}
	}
	Super.DrawText();
}

function DrawLocator()
{
	local GearPC PC;
	PC = GearPC(OwningHud.PlayerOwner);
	//If we want to linger without taccom
	if (TimeToLingerWithoutTaccom > 0)
	{
		if (PC != None)
		{
			//If the PC is not in assess mode, we need to see if our linger time is up
			if (!PC.bAssessMode)
			{
				//If it is up, start the fadeout and no longer desire to linger
				if (StartTime + TimeToLingerWithoutTaccom < OwningHUD.WorldInfo.TimeSeconds)
				{
					StartCompleteFadeOut();
					bFadingAway = true;
					TimeToLingerWithoutTaccom = 0;
				}
			}
			//If we are in taccom, then we never want to linger ever again.
			else
			{
				`log("ASSESS");
				TimeToLingerWithoutTaccom = 0;
				bUpdateOutsideOfTacCom=false;
			}
		}
	}

	super.DrawLocator();
	if (PC != None && (PC.bAssessMode || !bFadingAway))
	{
		LocatorMI.SetScalarParameterValue('Alpha', 1.0);
	}
}

/** Sets the icon values up (textures, colors, alphas, etc.) */
function SetIconValues()
{
	SquareIconAlpha = 1.0f;
	SquareIconColor = NormalWhite;
}

simulated function bool InitializeLocator(Actor Subject, GearHUD_Base TheHUD)
{
	local bool Retval;
	
	RetVal = Super.InitializeLocator(Subject, TheHUD);
	StartTime = OwningHUD.WorldInfo.TimeSeconds;
	
	return Retval;
}

function FinishedFadingOut()
{
	bUpdateOutsideOfTacCom=false;
}

defaultproperties
{
	bLocatorIsSubjectAndTypeUnique=true
	bUpdateInTacCom=true
	bUpdateOutsideOfTacCom=true
	
	SquareIconTexture=Texture'Warfare_HUD.HUD.UI_HUD_Leader'
	
	Priority=100
	
	
	TimeToLingerWithoutTaccom=5.0
}
