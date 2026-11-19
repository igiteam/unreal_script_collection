/**
 * GearHUDLocator_TacCom
 *
 * Class that controls and draws a single UI HUD locator for a comrade in TacCom mode
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearHUDLocator_TacCom extends GearHUDLocator;

`include(GearPlayerPersistentDataConstants.uci)

/************************************************************************/
/* Member variables                                                     */
/************************************************************************/

/** Icon to show which award the player has won recently */
var CanvasIcon AwardIcon;

/** offset from top center of locator to the center of the award icon */
var vector2D AwardIconOffset;

/** The desired size of the Award Icon */
var vector2D DesiredAwardIconSize;

/** The UVs we want to be using on the chat icon */
var vector2D ChatIconUVs;

/** Nemesis icon for COGs */
var Texture2D NemesisIconCOG;

/** Nemesis icon for Locust */
var Texture2D NemesisIconLocust;

/**
 * Hook up nemesis icons
 *
 * @param Subject - The object the locator points to (GearPawn, Annex Ring, etc.)
 *
 * @param TheHUD - The HUD which created and owns this locator
 *
 * @return - Whether the locator was able to be initialized
 */
simulated function bool InitializeLocator(Actor Subject, GearHUD_Base TheHUD)
{
	local GearPawn SubjectPawn, HUDOwningPawn;
	local GearPC PC;
	local GearPRI GPRI;

	PC = GearPC(TheHUD.PlayerOwner);
	if (PC != None)
	{
		HUDOwningPawn = GearPawn(PC.Pawn);
		GPRI = GearPRI(PC.PlayerReplicationInfo);
	}

	LocatorSubject = Subject;
	SubjectPawn = GearPawn(LocatorSubject);

	if (HUDOwningPawn != None && SubjectPawn != None && !SubjectPawn.IsSameTeam(HUDOwningPawn))
	{
		if (GPRI.IsNemesis(GetPRI()))
		{
			if (SubjectPawn.GetTeamNum() == 0)
			{
				SquareIconTexture = NemesisIconCOG;
			}
			else
			{
				SquareIconTexture = NemesisIconLocust;
			}
		}
	}

	return Super.InitializeLocator(Subject, TheHUD);
}

/** Sets the icon values up (textures, colors, alphas, etc.) */
function SetIconValues()
{
	if (SquareIconTexture != None)
	{
		SquareIconAlpha = 1.0f;
		SquareIconColor = NormalWhite;
	}
}

/************************************************************************/
/* Script functions                                                     */
/************************************************************************/
/** Whether or not this locator should be removed from the HUD */
function bool ShouldDeleteLocator()
{
	local GearPawn SubjectPawn, HUDOwningPawn;
	local GearPC PC;
	local GearPRI PRI;

	PC = GearPC(OwningHUD.PlayerOwner);
	SubjectPawn = GearPawn(LocatorSubject);
	HUDOwningPawn = GearPawn(PC.Pawn);

	PRI = GetPRI();

	return (SubjectPawn == None || SubjectPawn == OwningHUD.PlayerOwner.ViewTarget || PRI == None || PRI == OwningHUD.PlayerOwner.PlayerReplicationInfo ||
			SubjectPawn.bDeleteMe || PRI.bIsDead || SubjectPawn.IsDBNO() || PC == None ||
			//Will be deleted if you are not in assess mode UNLESS (You are DBNO)
			(!PC.bAssessMode && (HUDOwningPawn == None || !HUDOwningPawn.IsDBNO())));
}

/** @return whether drawing functions should skip this locator because it's a nemesis that can't be seen */
function bool ShouldSkipNemesis()
{
	local GearPawn GP;
	local vector CamPos, TracePoint;
	local rotator CamRot;

	GP = GearPawn(LocatorSubject);
	if (GP != None && OwningHUD.PlayerOwner.Pawn != None && !GP.IsSameTeam(OwningHUD.PlayerOwner.Pawn))
	{
		if (!bSubjectIsInScreen)
		{
			return TRUE;
		}

		OwningHUD.PlayerOwner.GetPlayerViewPoint(CamPos, CamRot);
		TracePoint = GP.Location;
		TracePoint.Z += GP.BaseEyeHeight;
		if (!GP.FastTrace(TracePoint, CamPos))
		{
			return TRUE;
		}
	}

	return FALSE;
}

/** Set the text to the subject's name, then draw it */
function DrawText()
{
	local GearPRI PRI;
	local GearPawn HUDOwningPawn;

	// only draw text in taccom, and not for nemesis
	HUDOwningPawn = GearPawn(OwningHUD.PlayerOwner.Pawn);
	if ((GearPC(OwningHUD.PlayerOwner).bAssessMode || (HUDOwningPawn != None && HUDOwningPawn.IsDBNO())) && OwningHUD.WorldInfo.GRI.OnSameTeam(OwningHUD.PlayerOwner, LocatorSubject))
	{
		PRI = GetPRI();
		if (PRI != None)
		{
			Text = PRI.PlayerName;
		}
		if  (GearGRI_Horde(OwningHUD.WorldInfo.GRI) != None && GearGRI_Horde(OwningHUD.WorldInfo.GRI).bCanPlaceFortifications)
		{
			Text = Text $ ": " $ int(PRI.Score);
		}
		//Readjust Y value to be centered
		TextCoord.Y = (LocatorCoord.Y + (0.5f * LocatorHeight * LocatorScale)) + (TextCoord.Y - LocatorCoord.Y - TextVertOffset*LocatorScale)/2;
		Super.DrawText();
	}
}

/** Overridden to draw the award icon, if any, next to the locator */
function DrawLocator()
{
	local GearPawn_Infantry ComradeGPI;
	local float DrawX, DrawY, IconScale;
	local GearAward Award;
	local GearPRI PRI;
	local float ChatIconOpacity;
	local vector OldChatUVs;

	if (ShouldSkipNemesis() || (!GearPC(OwningHUD.PlayerOwner).bAssessMode && VSize(LocatorSubject.Location - OwningHUD.PlayerOwner.Pawn.Location) < 512.0))
	{
		return;
	}

	Super.DrawLocator();

	IconScale = 1.0f;

	//Draw award!
	ComradeGPI = GearPawn_Infantry(LocatorSubject);
	if (ComradeGPI != None && GearPC_SP(OwningHUD.PlayerOwner) != None && ComradeGPI.AwardEarned != '')
	{
		//Look up the correct texture
		if (GearPC(OwningHUD.PlayerOwner).AwardManager != None)
		{
			Award = GearPC(OwningHUD.PlayerOwner).AwardManager.GetAwardByName(ComradeGPI.AwardEarned);
			if (Award != None)
			{
				AwardIcon.Texture = Texture2D(FindObject(Award.IconPath, class'Texture2D'));
			}
			else
			{
				`log("Invalid PersistentDataID given as an earned award: "$ComradeGPI.AwardEarned);
			}
		}
		//Get the real texture sizes
		AwardIcon.UL = AwardIcon.Texture.GetSurfaceWidth();
		AwardIcon.VL = AwardIcon.Texture.GetSurfaceHeight();

		//Make X fit perfectly
		IconScale = DesiredAwardIconSize.X/AwardIcon.UL;
		//And then set Y to whatever value will work with the scale we are using for x
		AwardIcon.VL = DesiredAwardIconSize.Y/IconScale;
		IconScale = IconScale*LocatorScale;

		DrawX = (LocatorCoord.X + (0.5f * LocatorWidth  * LocatorScale)) - (DesiredAwardIconSize.X*LocatorScale/2.0f) + AwardIconOffset.X;
		DrawY = LocatorCoord.Y - (DesiredAwardIconSize.Y*LocatorScale/2.0f) + AwardIconOffset.Y;

		OwningHUD.Canvas.SetPos(DrawX, DrawY);
		OwningHUD.Canvas.DrawIcon(AwardIcon, DrawX, DrawY, IconScale);
	}

	//Draw Chat icon
	PRI = GetPRI();
	if (PRI != None)
	{
		ChatIconOpacity = class'GearUIManager'.static.GetChatIconOpacity(PRI);
		if (ChatIconOpacity > 0.0)
		{
			OldChatUVs.X = OwningHUD.VoiceTaccomIcon.UL;
			OldChatUVs.Y = OwningHUD.VoiceTaccomIcon.VL;

			OwningHUD.VoiceTaccomIcon.UL = ChatIconUVs.X;
			OwningHUD.VoiceTaccomIcon.VL = ChatIconUVs.Y;
			DrawX = TextCoord.X - (OwningHUD.VoiceTaccomIcon.UL * LocatorScale) - 1;
			DrawY = (LocatorCoord.Y + (0.5f * LocatorHeight * LocatorScale)) + (TextCoord.Y - LocatorCoord.Y - TextVertOffset*LocatorScale)/2 - (OwningHUD.VoiceTaccomIcon.VL * 0.5f * LocatorScale);

			// Color the chat bubble depending on the team the player is on
			if (PRI.Team.TeamIndex == 0)
			{
				`SetHUDDrawColorExt(OwningHUD,OwningHUD.HudColors[eWARHUDCOLOR_CHATICONBLUE], 255 * ChatIconOpacity * LocatorAlpha);
			}
			else
			{
				`SetHUDDrawColorExt(OwningHUD,OwningHUD.HudColors[eWARHUDCOLOR_CHATICONRED], 255 * ChatIconOpacity * LocatorAlpha);
			}

			OwningHUD.Canvas.SetPos(DrawX, DrawY);
			OwningHUD.Canvas.DrawIcon(OwningHUD.VoiceTaccomIcon, DrawX, DrawY, LocatorScale);

			OwningHUD.VoiceTaccomIcon.UL = OldChatUVs.X;
			OwningHUD.VoiceTaccomIcon.VL = OldChatUVs.Y;
		}
	}
}

// Gets the PRI for this locator. Will check for the locator being on a pawn driving a vehicle
function GearPRI GetPRI()
{
	local GearPRI PRI;
	local Pawn P;

	P = Pawn(LocatorSubject);

	if (P != none)
	{
		PRI = GearPRI(P.PlayerReplicationInfo);

		//If the pawn does not have a PRI, it may be controlling a vehicle, so check for that
		if (PRI == none)
		{
			if (P.DrivenVehicle != none)
			{
				PRI = GearPRI(P.DrivenVehicle.PlayerReplicationInfo);
			}
		}
	}

	return PRI;
}

defaultproperties
{
	bLocatorIsSubjectAndTypeUnique=true
	bLocatorIsSubjectUnique=false
	bUpdateInTacCom=true

	AwardIconOffset=(X=0.0f,Y=5.0f)
	AwardIcon=(Texture=Texture2D'UI_Art_Achievements.T_DefaultIcons_Unlock',U=0,V=0,UL=0,VL=0)
	ChatIconUVs=(X=43,Y=25)

	DesiredAwardIconSize=(X=64.0f,Y=64.0f)

	NemesisIconCOG=Texture2D'Warfare_HUD.HUD.T_HUD_Nemesis_IsCOG'
	NemesisIconLocust=Texture2D'Warfare_HUD.HUD.T_HUD_Nemesis_IsLocust'
}
