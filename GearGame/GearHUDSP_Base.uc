/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearHUDSP_Base extends GearHUD_Base
	abstract;

/** used on the spectator overlay when the player is spectating because their player slot is empty or their character has not been spawned */
var localized string SpectateWaitingForPlayerSlot;
/** used on the spectator overlay when the player has just joined and can press RT to take over control */
var localized string SpectateTakeControl;

/** Icon to use for the tower health */
var CanvasIcon TowerHealthIcon;

function CheckSpectatorScene()
{
	local GearPRI PRI;
	local float YPos;
	local float ButtonXL, XL, YL;

	PRI = GearPRI(PlayerOwner.PlayerReplicationInfo);
	if (PlayerOwner.IsInState('PlayerWaiting'))
	{
		if (PRI != None && !PlayerOwner.bCinematicMode)
		{
			`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], 255);
			Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);

			YPos = Canvas.ClipY - (PlayerOwner.IsSplitscreenPlayer() ? 36.0 : 72.0) - 31.0;

			Canvas.SetPos(0, YPos - 24.0);
			Canvas.DrawTile(SpectateBackgroundIcon.Texture, Canvas.ClipX, Canvas.ClipY * 0.5, SpectateBackgroundIcon.U, SpectateBackgroundIcon.V, SpectateBackgroundIcon.UL, SpectateBackgroundIcon.VL);

			if (PlayerOwner.ViewTarget.Class != PRI.PawnClass)
			{
				Canvas.StrLen(SpectateWaitingForPlayerSlot, XL, YL);
				Canvas.SetPos((Canvas.ClipX - XL) * 0.5, YPos);
				Canvas.DrawText(SpectateWaitingForPlayerSlot);
			}
			else
			{
				// get size of button icon
				Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Xbox360_18pt);
				Canvas.StrLen("^", ButtonXL, YL);

				Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
				Canvas.StrLen(SpectateTakeControl, XL, YL);
				Canvas.SetPos((Canvas.ClipX - (XL + ButtonXL * 2.0)) * 0.5, YPos);
				Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Xbox360_18pt);
				Canvas.DrawText("^ ", false);
				Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
				Canvas.DrawText(SpectateTakeControl);
			}
		}
	}
	else
	{
		Super.CheckSpectatorScene();
	}
}

/** Draws the tower health in the tempest fight */
function UpdateTowerHealth(GearGRI_SP GRISP)
{
	local float Alpha;

	if (GRISP.TotalTowerHealth > 0)
	{
		Alpha = 255;
		DrawTowerHealth(GRISP.TotalTowerHealth, GRISP.CurrTowerHealth, Canvas.SizeX / 2, Canvas.SizeY - 100.0f * WeaponInfoScale, Alpha, 3.0f);
	}
}

/**
 * A very rough health bar for the tower in the tempest fight
 *
 * @param TotalTowerHealth - total amount of health the tower had
 *
 * @param CurrTowerHealth - current amount of health the tower has
 *
 * @param DrawX - the horizontal center to start drawing the bar
 *
 * @param DrawY - the Y coord to start starting the bar
 *
 * @param Alpha - the opacity of the health bar between 0 and 255
 *
 * @param Scale - how big should the bar be drawn
 */
function DrawTowerHealth(int TotalTowerHealth, int CurrTowerHealth, float DrawX, float DrawY, float Alpha, float Scale)
{
	local CanvasIcon HealthIcon;
	local float HealthPercent, DamagePercent;

	HealthIcon = TowerHealthIcon;

	if (HealthIcon.Texture != None)
	{
		DrawX -= HealthIcon.UL * Scale * 0.5;

		Canvas.SetPos(DrawX - 1, DrawY - 1);
		Canvas.SetDrawColor(47, 47, 47, Alpha);
		Canvas.DrawTileStretched(HealthIcon.Texture, HealthIcon.UL * Scale + 2, HealthIcon.VL + 2, HealthIcon.U, HealthIcon.V, HealthIcon.UL, HealthIcon.VL);

		// Determine the color to draw
		HealthPercent = float(CurrTowerHealth) / float(TotalTowerHealth);
		DamagePercent = 1.0 - HealthPercent;
		if (DamagePercent >= 0.5)
		{
			Canvas.SetDrawColor(255 - (18 * DamagePercent), 255 - (227 * DamagePercent), 255 - (219 * DamagePercent), Alpha);
		}
		else
		{
			`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], Alpha);
		}

		Canvas.SetPos(DrawX, DrawY);
		Canvas.DrawTileStretched(HealthIcon.Texture, HealthIcon.UL * Scale * HealthPercent, HealthIcon.VL, HealthIcon.U, HealthIcon.V, HealthIcon.UL * HealthPercent, HealthIcon.VL);
	}
}

defaultproperties
{
	TowerHealthIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=0,V=494,UL=106,VL=7)
}

