/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearHUDSP_Arcade extends GearHUDSP_Base
	abstract;

/** color for drawing the score of players other than our owner */
var color OtherPlayerScoreColor;
var color GrayColor;

/** colors to use for the multiplier bar, depending on how high it is */
var array<color> MultiplierBarColors;

/** render info for drawing multiplier (includes glow values used when pulsing at the end of event animation) */
var FontRenderInfo MultiplierRenderInfo;

/** integer part of last frame's multiplier, for triggering effects */
var int LastMultiplier;
/** time we started displaying a multiplier change event (for timing font effects) */
var float LastMultiplierEventTime;

/** sounds for multiplier change */
var SoundCue MultiplierIncreasedSound, MultiplierDecreasedSound;


function DrawHUD()
{
	local GearPRI_SP PRI;
	local int i, MultiplierLoop, MultiplierValue, DrawX, DrawY;
	local float XL, YL, TimeSinceEvent, TextScale;
	local GearGRI_SP_Arcade GRI;

	// clamp maximum HUD messages in splitscreen to fit amongst the Arcade elements
	MaxHUDMessages = (class'Engine'.static.GetEngine().GamePlayers.length > 1) ? 1 : default.MaxHUDMessages;

	Super.DrawHUD();

	GRI = GearGRI_SP_Arcade(WorldInfo.GRI);
	if (bShowHud && !HideHUDFromScenes() && PlayerOwner.PlayerReplicationInfo != None && GRI != None)
	{
		DrawX = Canvas.ClipX - SafeZoneRight - 100.0;
		DrawY = Canvas.ClipY - SafeZoneBottom - 400.0;
		DrawScore(GearPRI_SP(PlayerOwner.PlayerReplicationInfo), DrawX, DrawY);
		for (i = 0; i < GRI.PRIArray.length; i++)
		{
			PRI = GearPRI_SP(GRI.PRIArray[i]);
			if (PRI != None && PRI != PlayerOwner.PlayerReplicationInfo && !PRI.bBot && PRI.GetTeamNum() == 0)
			{
				DrawY += 80.0;
				DrawScore(PRI, DrawX, DrawY);
			}
		}

		MultiplierLoop = (int(GearGRI_SP_Arcade(WorldInfo.GRI).TeamMultiplier) - 1) / 3;

		// draw multiplier bar
		Canvas.DrawColor = (MultiplierLoop > 0) ? MultiplierBarColors[(MultiplierLoop - 1) % MultiplierBarColors.length] : HudColors[eWARHUDCOLOR_BLACK];
		Canvas.SetPos(SafeZoneLeft + 5, Canvas.ClipY * 0.2);
		Canvas.DrawRect(16.0, Canvas.ClipY * 0.45);
		Canvas.DrawColor = MultiplierBarColors[MultiplierLoop % MultiplierBarColors.length];
		YL = Canvas.ClipY * 0.45 * ((GRI.TeamMultiplier - 1.0) % 3.0) / 3.0;
		Canvas.SetPos(SafeZoneLeft + 5, Canvas.ClipY * 0.65 - YL);
		Canvas.DrawRect(16.0, YL);
		Canvas.DrawColor = HudColors[eWARHUDCOLOR_WHITE];
		Canvas.SetPos(SafeZoneLeft + 3, Canvas.ClipY * 0.2 - 2);
		Canvas.DrawBox(20.0, Canvas.ClipY * 0.45 + 4);
		// draw multiplier text
		if (LastMultiplier != int(GRI.TeamMultiplier))
		{
			if (GRI.TeamMultiplier > LastMultiplier)
			{
				LastMultiplierEventTime = WorldInfo.TimeSeconds;
				PlayerOwner.ClientPlaySound(MultiplierIncreasedSound);
			}
			else
			{
				// cancel any effect because the team lost it
				LastMultiplierEventTime = -10000.0;
				PlayerOwner.ClientPlaySound(MultiplierDecreasedSound);
			}
			LastMultiplier = int(GRI.TeamMultiplier);
		}
		TimeSinceEvent = WorldInfo.TimeSeconds - LastMultiplierEventTime;
		Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
		Canvas.TextSize("3x", XL, YL);
		for (i = 0; i < 4; i++)
		{
			Canvas.SetPos(SafeZoneLeft + 25.0, Canvas.ClipY * 0.65 - Canvas.ClipY * 0.15 * i - YL / 2.0);
			MultiplierValue = 1 + MultiplierLoop * 3 + i;
			Canvas.DrawColor = (GRI.TeamMultiplier >= MultiplierValue) ? HudColors[eWARHUDCOLOR_WHITE] : GrayColor;
			TextScale = 1.0;
			MultiplierRenderInfo.GlowInfo.bEnableGlow = (MultiplierValue == LastMultiplier && TimeSinceEvent < 1.0);
			if (MultiplierRenderInfo.GlowInfo.bEnableGlow)
			{
				MultiplierRenderInfo.GlowInfo.GlowColor.A = (TimeSinceEvent < 0.5) ? (TimeSinceEvent * 2.0) : (1.0 - (TimeSinceEvent - 0.5) * 2.0);
				if (TimeSinceEvent < 0.25)
				{
					TextScale += (TimeSinceEvent * 2.0);
				}
				else if (TimeSinceEvent > 0.75)
				{
					TextScale += (1.0 - TimeSinceEvent) * 2.0;
				}
				else
				{
					TextScale = 1.5;
				}
			}

			Canvas.DrawText(string(MultiplierValue) $ "x",, TextScale, TextScale, MultiplierRenderInfo);
		}
	}
}

/** draws the score and multiplier for the specified player */
function DrawScore(GearPRI_SP PRI, int DrawX, int DrawY)
{
	Canvas.SetPos(DrawX, DrawY);
	Canvas.Font = class'Engine'.static.GetSmallFont();
	Canvas.DrawColor = (PRI != PlayerOwner.PlayerReplicationInfo) ? OtherPlayerScoreColor : WhiteColor;
	Canvas.DrawText(PRI.PlayerName);
	Canvas.SetPos(DrawX, DrawY + 12.0);
	Canvas.DrawText("Score:" @ int(PRI.Score));
}

function AddDeathMessageData(PlayerReplicationInfo Killer, PlayerReplicationInfo Victim, class<GearDamageType> GearDamage, EGearDeathType DeathType, bool bIsKnockdown, optional int PointsAwarded, optional bool bSkipBlood)
{
	// don't show suicides on the Arcade HUD unless it's a human
	if (PointsAwarded > 0 || (Killer != Victim && Killer != None) || (Victim != None && !Victim.bBot))
	{
		Super.AddDeathMessageData(Killer, Victim, GearDamage, DeathType, bIsKnockdown, PointsAwarded, bSkipBlood);
	}
}

defaultproperties
{
	bDrawKillPoints=true
	bAlwaysDrawDeathMessages=true
	OtherPlayerScoreColor=(R=170,G=192,B=205,A=255)
	GrayColor=(R=150,G=150,B=150,A=255)
	KillPointsDest=(X=0.1,Y=0.7)
	KillPointsFadeTime=1.0
	MaxHUDMessages=4

	MultiplierRenderInfo=(bEnableShadow=true,GlowInfo=(GlowColor=(G=1.0,B=1.0,A=1.0),GlowOuterRadius=(X=0.3,Y=0.45),GlowInnerRadius=(X=0.45,Y=0.5)))
	MultiplierBarColors[0]=(R=170,G=0,B=0,A=255)
	MultiplierBarColors[1]=(R=180,G=125,B=0,A=255)
	MultiplierBarColors[2]=(R=210,G=210,B=0,A=255)

	LastMultiplierEventTime=-100000.0
}
