/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearHUDSiege extends GearHUDInvasion_Base
	abstract;

/** number of wave points we rendered for local player last tick (for animated updates when changes happen) */
var int LastWavePoints;
/** last amount of wave point progress we rendered for local player last tick (for animated updates when changes happen) */
var float LastWavePointProgress;
/** how fast we show wave point gain, in points/sec */
var float WavePointUpdateRate;
/** last time the local player earned a bonus wave point (due to kills, fortification damage, etc) */
var float LastWavePointBonusTime;
/** used to draw the bonus progress text */
var FontRenderInfo WavePointRenderInfo;
/** token/wave point progress bar */
var CanvasIcon TokenProgressBar;
/** color to draw progress bar */
var LinearColor TokenProgressBarColor;

//Content reference to the char select screen
var class<UIScene_SiegeCharSelect> CharSelectSceneClass;

var MaterialEffect SerapedePPEffect;
var MaterialInstanceConstant SerapedeEffectMIC;

exec function ToggleSerapedeEffects(bool bVal)
{
	// cache the reference if needed
	if (SerapedePPEffect == None)
	{
		SerapedePPEffect = MaterialEffect(LocalPlayer(PlayerOwner.Player).PlayerPostProcess.FindPostProcessEffect('Serapede'));
		if (SerapedePPEffect.Material.GetPackageName() != 'Transient')
		{
			// Create a MIC for this viewport
			SerapedeEffectMIC = new(SerapedePPEffect) class'MaterialInstanceConstant';
			SerapedeEffectMIC.SetParent(SerapedePPEffect.Material);
			SerapedePPEffect.Material = SerapedeEffectMIC;
		}
		else
		{
			SerapedeEffectMIC = MaterialInstanceConstant(SerapedePPEffect.Material);
		}
	}

	if (SerapedePPEffect != None)
	{
		SerapedePPEffect.bShowInGame = bVal;
	}
}

function DrawHUD()
{
	local GearPRI_Siege PRI;
	local GearWeap_GrenadeBase Grenade;
	local GearPawn P;

	// Set the GRI and PRI
	GetGRI();
	PRI = GearPRI_Siege(PlayerOwner.PlayerReplicationInfo);

	// handle smooth interpolation of wave point gain
	if (PRI != None)
	{
		// if we have lost points/progress, or it's a large gain (due to new round, late replication, etc), snap to the new value
		if ( PRI.WavePointsRemaining < LastWavePoints || PRI.WavePointsRemaining > LastWavePoints + 4 ||
			(PRI.WavePointsRemaining == LastWavePoints && PRI.WavePointBonusProgress < LastWavePointProgress) )
		{
			LastWavePoints = PRI.WavePointsRemaining;
			LastWavePointProgress = PRI.WavePointBonusProgress;
			LastWavePointBonusTime = -10000.0;
		}
		else if (PRI.WavePointsRemaining > LastWavePoints || PRI.WavePointBonusProgress > LastWavePointProgress)
		{
			// if we haven't gained a full point, just move the bar along
			if (PRI.WavePointsRemaining == LastWavePoints)
			{
				LastWavePointProgress = FMin(LastWavePointProgress + WavePointUpdateRate * RenderDelta, PRI.WavePointBonusProgress);
			}
			else
			{
				// progress the bar, triggering glow anim and sound when it fills
				LastWavePointProgress += RenderDelta * WavePointUpdateRate;
				if (LastWavePointProgress >= 1.0)
				{
					LastWavePointProgress = FMin(LastWavePointProgress - 1.0, PRI.WavePointBonusProgress);
					LastWavePoints++;
					LastWavePointBonusTime = WorldInfo.TimeSeconds;
					PlayerOwner.ClientPlaySound(CashAcquiredSound);
				}
			}
		}
	}

	// Draw the scoreboard
	if (!DrawScoreboard() && !HideHUDFromScenes() && bShowHUD)
	{
		// If we didn't draw the scoreboard then draw the enemy count
		DrawStatusDisplay();

		// if our pawn class can hold grenades and we have enough ammo, draw an icon
		if (PlayerOwner.Pawn != None && PlayerOwner.Pawn.InvManager != None && !GearPC(PlayerOwner).bAssessMode)
		{
			Grenade = GearWeap_GrenadeBase(PlayerOwner.Pawn.InvManager.FindInventoryType(class'GearWeap_GrenadeBase', true));
			if (Grenade != None && Grenade != PlayerOwner.Pawn.Weapon && Grenade.HasAnyAmmo())
			{
				`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], 255);
				Canvas.DrawIcon(Grenade.WeaponIcon, Canvas.ClipX - SafeZoneRight - Grenade.WeaponIcon.UL / 1.2, SafeZoneTop + WeaponInfoFrame.VL * 1.8, 0.5);
			}
		}
	}

	/** add health indicators when playing a healing character */
	if (GearPawn(PlayerOwner.Pawn) != None && GearPawn(PlayerOwner.Pawn).SpecialMoveClasses[GSM_Kantus_ReviveScream] != None)
	{
		foreach WorldInfo.AllPawns(class'GearPawn', P)
		{
			if (P.bCanBeHealed && P != PlayerOwner.Pawn && P.Health > 0 && WorldInfo.GRI.OnSameTeam(P, PlayerOwner))
			{
				AddHUDLocator(class'GearHUDLocator_TeammateHealth', P);
			}
		}
	}

	DrawGameInfo();

	Super(GearHUDMP_Base).DrawHUD();
}

simulated function DrawCash(float BackgroundX, float BackgroundY, float BackgroundWidth, byte OverallAlpha)
{
	local GearPRI_Siege PRI;
	local float TimeSinceStart, DrawX, DrawY, TextSizeX, TextSizeY;
	local int ActualProgressBarSize;
	local string StringToDraw;
	local LinearColor LC;

	// override to draw tokens and token progress
	PRI = GearPRI_Siege(PlayerOwner.PlayerReplicationInfo);
	if (PRI != None)
	{
		// draw the tokens background
		DrawX = SafeZoneLeft;
		DrawY = SafeZoneTop + WaveBG.VL + ScoreBG.VL;
		LC = MakeLinearColor(0.94, 0.94, 0.94, float(OverallAlpha) / 255.0);
		Canvas.SetPos(DrawX, DrawY);
		Canvas.DrawTileStretched(CashBG.Texture, BackGroundWidth, CashBG.VL, CashBG.U, CashBG.V, CashBG.UL, CashBG.VL, LC);

		// draw progress towards more wave points
		TokenProgressBarColor.A = default.TokenProgressBarColor.A * float(OverallAlpha) / 255.0;
		Canvas.SetPos(DrawX, DrawY);
		ActualProgressBarSize = TokenProgressBar.UL * LastWavePointProgress;
		Canvas.DrawTile(TokenProgressBar.Texture, ActualProgressBarSize, TokenProgressBar.VL, TokenProgressBar.U, TokenProgressBar.V, ActualProgressBarSize, TokenProgressBar.VL, TokenProgressBarColor);

		// draw tokens
		`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], OverallAlpha);
		Canvas.SetPos(BackgroundX + BGPaddingLeft, BackgroundY + CashPositionV);
		TimeSinceStart = WorldInfo.TimeSeconds - LastWavePointBonusTime;
		WavePointRenderInfo.GlowInfo.bEnableGlow = (TimeSinceStart < 1.0);
		if (WavePointRenderInfo.GlowInfo.bEnableGlow)
		{
			WavePointRenderInfo.GlowInfo.GlowColor.A = (TimeSinceStart < 0.5) ? (TimeSinceStart * 2.0) : (1.0 - (TimeSinceStart - 0.5) * 2.0);
		}
		StringToDraw = CashString;
		Canvas.DrawText(StringToDraw,,,, WavePointRenderInfo);
		StringToDraw = string(LastWavePoints);
		Canvas.TextSize(StringToDraw, TextSizeX, TextSizeY);
		Canvas.SetPos(BackgroundX + BackGroundWidth - BGPaddingRight - TextSizeX, BackgroundY + CashPositionV);
		Canvas.DrawText(StringToDraw,,,, WavePointRenderInfo);

		// draw +number for tokens still be counted by the anim
		if (PRI.WavePointsRemaining > LastWavePoints)
		{
			Canvas.DrawColor.R = byte(TokenProgressBarColor.R * 255.0);
			Canvas.DrawColor.G = byte(TokenProgressBarColor.G * 255.0);
			Canvas.DrawColor.B = byte(TokenProgressBarColor.B * 255.0);
			Canvas.DrawColor.A = OverallAlpha;
			Canvas.SetPos(BackgroundX + BackGroundWidth, BackgroundY + CashPositionV);
			Canvas.DrawText("+" $ (PRI.WavePointsRemaining - LastWavePoints));
		}
	}
}

simulated function color GetCountdownColor()
{
	return (GearGRI(WorldInfo.GRI).RoundTime < 60) ? HudColors[eWARHUDCOLOR_RED] : Super.GetCountdownColor();
}

simulated function bool UpdateCountdown()
{
	local GearGRI_MP GGRI;

	GGRI = GearGRI_MP(WorldInfo.GRI);
	if (GGRI.GameStatus == GS_RoundInProgress)
	{
		// always show countdown in Siege
		if (!CountdownTimerIsShowing())
		{
			GearPC(PlayerOwner).StartCountdownTime(GGRI.RoundTime);
		}

		bDrewCountdownLastFrame = true;

		CountdownTimeToDraw = Max(GGRI.RoundTime, 0);
		return DrawCountdown();
	}
	else
	{
		return false;
	}
}

// no bonus objectives in Siege
function DrawObjectives(float Alpha, bool bUseUpdateCheck);
// Siege players can't purchase/repair anything
function DrawFortificationInfo();

/** Whether the show the hud or not based on screens showing in front of it */
function bool HideHUDFromScenes()
{
	local GearPC_Siege GPCS;

	GPCS = GearPC_Siege(PlayerOwner);
	return (Super.HideHUDFromScenes() || GPCS == none || GPCS.CharSelectMovie != none || EndRoundUIScenePlayerInstance != none);
}

function SignalStartofRoundOrMatch(GearGRI CurGRI)
{
	local GearPC_Siege PCS;

	Super.SignalStartofRoundOrMatch(CurGRI);
	PCS = GearPC_Siege(PlayerOwner);
	if (PCS != none)
	{
		PCS.ClientOpenClassSelector();
	}

}

/** Draws info regarding the map and game type before the overhead map appears */
final function DrawGameInfo()
{
	local GearGameInfoSummary GameSummary;
	local GearGameMapSummary MapSummary;

	if (GRI != None)
	{
		if( !IsDramaticTextDrawing() )
		{
			if( GRI.GameStatus == GS_WaitingForHost )
			{
				GameSummary = class'GearUIDataStore_GameResource'.static.GetGameTypeProvider(eGEARMP_Siege);
				MapSummary = class'GearUIDataStore_GameResource'.static.GetMapSummaryFromMapName( WorldInfo.GetMapName() );
				if( (GameSummary != None) && (MapSummary != None) )
				{
					StartDrawingDramaticText(GameSummary.GameName, MapSummary.DisplayName, 60.0f, 2.0f, 0.5f, GetCountdownYPosition() + CountdownSize.Y + GearPC(PlayerOwner).NumPixelsToMoveDownForDramaText(), 2.0, 2.0);
				}
			}
		}
		else if( bDrawOverheadMPMap || (GRI.GameStatus != GS_WaitingForHost) )
		{
			StopDrawingDramaticText();
		}
	}
}

/** @see AddTeamMessageData **/
function AddDeathMessageData(PlayerReplicationInfo Killer, PlayerReplicationInfo Victim, class<GearDamageType> GearDamage, EGearDeathType DeathType, bool bIsKnockdown, optional int PointsAwarded, optional bool bSkipBlood)
{
	if (Killer == PlayerOwner.PlayerReplicationInfo &&
		Victim == PlayerOwner.PlayerReplicationInfo &&
		ClassIsChildOf(GearDamage,class'GDT_TickerExplosion'))
	{
		AddKillPoints(PointsAwarded);
	}
	else
	{
		Super.AddDeathMessageData(Killer,Victim,GearDamage,DeathType,bIsKnockdown,PointsAwarded,bSkipBlood);
	}
}

/** GearHordeEnemyList not used in Siege */
function GetCurrentEnemyLists(out array<GearHordeEnemyList> EnemyLists);

/** can't choose default weapons in Beast */
function bool ShowDefaultWeaponSelector();

defaultproperties
{
	KillPointsDest=(X=0.2,Y=0.2)
	KillPointsFadeTime=0.9
	WavePointRenderInfo=(bEnableShadow=true,GlowInfo=(GlowColor=(R=1.0,G=0.2,A=1.0),GlowOuterRadius=(X=0.3,Y=0.45),GlowInnerRadius=(X=0.45,Y=0.5)))
	TokenProgressBar=(Texture=Texture2D'Warfare_HUD.HUD.Siege_Horde_TimerTokens',U=0,V=63,UL=192,VL=18)
	TokenProgressBarColor=(R=1.0,G=0.2,A=0.7)
	WavePointUpdateRate=0.75
}
