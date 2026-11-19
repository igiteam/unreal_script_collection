/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearHUDLocator_CoopBuddy extends GearHUDLocator;

/** offset from top left of locator to the center of the chat icon */
var vector2D ChatIconOffset;

/** Whether or not this locator should be removed from the HUD */
function bool ShouldDeleteLocator()
{
	local Pawn SubjectPawn;

	SubjectPawn = Pawn(LocatorSubject);
	return ( SubjectPawn == None || SubjectPawn.bDeleteMe || SubjectPawn.PlayerReplicationInfo == None ||
		SubjectPawn.PlayerReplicationInfo.bBot || SubjectPawn == OwningHUD.PlayerOwner.ViewTarget );
}

/** Sets the icon values up (textures, colors, alphas, etc.) */
function SetIconValues()
{
	//SquareIconAlpha = 1.0f;
	//SquareIconColor = NormalWhite;
}

function DrawLocator()
{
	local GearPawn ComradeGP;
	local GearPRI PRI;
	local float DrawX, DrawY;
	local float ChatIconOpacity;

	ComradeGP = GearPawn(LocatorSubject);
	if (ComradeGP == None || !ComradeGP.IsDBNO())
	{
		Super.DrawLocator();
		PRI = GearPRI(Pawn(LocatorSubject).PlayerReplicationInfo);
		if (PRI != None)
		{
			ChatIconOpacity = class'GearUIManager'.static.GetChatIconOpacity(PRI);
			if (ChatIconOpacity > 0.0)
			{
				DrawX = LocatorCoord.X + ChatIconOffset.X - (OwningHUD.VoiceTaccomIcon.UL + OwningHUD.VoiceTaccomIconPos[0]) * 0.5;
				DrawY = LocatorCoord.Y + ChatIconOffset.Y - (OwningHUD.VoiceTaccomIcon.VL + OwningHUD.VoiceTaccomIconPos[1]) * 0.5;

				// Color the chat bubble depending on the team the player is on
				if (PRI.Team.TeamIndex == 0)
				{
					`SetHUDDrawColorExt(OwningHUD,OwningHUD.HudColors[eWARHUDCOLOR_CHATICONBLUE], 255 * ChatIconOpacity);
				}
				else
				{
					`SetHUDDrawColorExt(OwningHUD,OwningHUD.HudColors[eWARHUDCOLOR_CHATICONRED], 255 * ChatIconOpacity);
				}

				OwningHUD.Canvas.SetPos(DrawX, DrawY);
				OwningHUD.Canvas.DrawIcon(OwningHUD.VoiceTaccomIcon, DrawX, DrawY);
			}
		}
	}
}

defaultproperties
{
	bLocatorIsSubjectAndTypeUnique=true
	ChatIconOffset=(X=118,Y=108)
	Priority=100
}
