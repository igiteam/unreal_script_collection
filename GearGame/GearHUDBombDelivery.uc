/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearHUDBombDelivery extends GearHUDMP_Base
	abstract;

/** reference to the bomb */
var GearTrackBomb Bomb;

/** Materials for drawing the Command Point Indicator */
var Material CPIndicatorMaterialBG;
var Material CPIndicatorMaterialCOG;
var Material CPIndicatorMaterialLOC;
var Material CPIndicatorGlow;

/** Material Instances for drawing the Command Point Indicator */
var MaterialInstanceConstant CPIndicatorMatInstanceBG;
var MaterialInstanceConstant CPIndicatorMatInstanceCOG;
var MaterialInstanceConstant CPIndicatorMatInstanceLOC;
var MaterialInstanceConstant CPIndicatorGlowMatInstance;

/** Variables for controlling the pulsing effect in the Command Point Indicator */
var float PulseStartTime;
var float TotalPulseTime;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	// initialize the CP indicator background
	CPIndicatorMatInstanceBG = new(self) class'MaterialInstanceConstant';
	CPIndicatorMatInstanceBG.SetParent(CPIndicatorMaterialBG);

	// initialize the CP indicator COG material
	CPIndicatorMatInstanceCOG = new(self) class'MaterialInstanceConstant';
	CPIndicatorMatInstanceCOG.SetParent(CPIndicatorMaterialCOG);

	// initialize the CP indicator Locust material
	CPIndicatorMatInstanceLOC = new(self) class'MaterialInstanceConstant';
	CPIndicatorMatInstanceLOC.SetParent(CPIndicatorMaterialLOC);

	// initialize the CP indicator weapons material
	CPIndicatorGlowMatInstance = new(self) class'MaterialInstanceConstant';
	CPIndicatorGlowMatInstance.SetParent(CPIndicatorGlow);
}

function DrawHUD()
{
	local float Pct, CheckpointPct, CompleteAmt;
	local int i;
//	local MaterialInstanceConstant CPControllerMIC;
// 	local float DrawX, DrawY, LocalDrawX, LocalDrawY, CPIWidth, CPIHeight, Scale, GlowOpacity, PulseScale, XL, YL;
// 	local byte Alpha;

	Super.DrawHUD();

	if ( bShowHud &&
		!HideHUDFromScenes() &&
		(GRI.GameStatus == GS_RoundInProgress) )
	{
		if (Bomb == None || Bomb.bDeleteMe)
		{
			foreach DynamicActors(class'GearTrackBomb', Bomb)
			{
				break;
			}
		}
		if (Bomb != None && Bomb.TrackMatinee != None && Bomb.TrackMatinee.InterpData != None)
		{
			AddHUDLocator(class'GearHUDLocator_Bomb', Bomb);

			// draw bomb progress bar
			Pct = Bomb.TrackMatinee.Position / Bomb.TrackMatinee.InterpData.InterpLength;
			// complete part
			Canvas.SetPos(SafeZoneLeft, SafeZoneTop);
			CompleteAmt = Canvas.SizeX * 0.25 * Pct;
			if (CompleteAmt >= 1.0)
			{
				Canvas.DrawColor = Bomb.bExploding ? RedColor : WhiteColor;
				Canvas.DrawBox(CompleteAmt, 4.0);
			}
			// incomplete part
			Canvas.DrawColor = WhiteColor * 0.5;
			Canvas.CurX += FFloor(Canvas.SizeX * 0.25 * Pct);
			Canvas.DrawBox(SafeZoneLeft + Canvas.SizeX * 0.25 - Canvas.CurX, 4.0);
			// draw ticks for the checkpoints
			Canvas.CurY -= 6.0;
			for (i = 0; i <= Bomb.NumCheckpoints; i++)
			{
				CheckpointPct = float(i) / Bomb.NumCheckpoints;
				Canvas.DrawColor = (CheckpointPct <= Pct) ? WhiteColor : (WhiteColor * 0.5);
				Canvas.CurX = FFloor(SafeZoneLeft + Canvas.SizeX * 0.25 * CheckpointPct) - 1.0;
				Canvas.DrawBox(3, 16.0);
			}
			// draw lives remaining
			Canvas.SetPos(SafeZoneLeft, SafeZoneTop + 12.0);
			Canvas.Font = class'Engine'.static.GetSmallFont();
			Canvas.DrawColor = WhiteColor;
			Canvas.DrawText(GearBombDeliveryGRI(WorldInfo.GRI).BombLivesRemaining @ "Bombs Remaining");

			// draw the directional indicator

// 			Alpha = 255 * (1.0f - TaccomFadeOpacity);
// 			SetHUDDrawColor( eWARHUDCOLOR_WHITE, Alpha );
// 			Scale = 0.65f;
// 			CPIWidth = 128.f * Scale;
// 			CPIHeight = 128.f * Scale;
//
// 			// Original Y Position + Height of the Scoreboard texture + an additional spacing offset.
// 			DrawY = SafeZoneTop + (CPIHeight/2) + 16.f;
// 			DrawX = SafeZoneLeft + (CPIWidth/2) + 16.f;
//
// 			// Draw the background
// 			LocalDrawX = DrawX - CPIWidth/2;
// 			LocalDrawY = DrawY - CPIHeight/2;
// 			Canvas.SetPos( LocalDrawX, LocalDrawY );
// 			CPIndicatorMatInstanceBG.SetScalarParameterValue( 'Opacity', 1.f - TaccomFadeOpacity );
// 			Canvas.DrawMaterialTile( CPIndicatorMatInstanceBG, CPIWidth, CPIHeight );
//
// 			// Draw the CP's controlling team's material
// 			CPControllerMIC = (Bomb.TeamNum == 0) ? CPIndicatorMatInstanceCOG : CPIndicatorMatInstanceLOC;
// 			Canvas.SetPos( LocalDrawX, LocalDrawY );
// 			CPControllerMIC.SetScalarParameterValue( 'SymbolMasking', 2.f - (2.f * (float(Bomb.Health) / float(Bomb.DefaultHealth))) );
// 			if (Bomb.TeamNum == 0)
// 			{
// 				CPControllerMIC.SetVectorParameterValue( 'SymbolColorCOG', MakeLinearColor(139.f/255.f, 255.f/255.f, 255.f/255.f, 0.4f) );
// 			}
// 			else
// 			{
// 				CPControllerMIC.SetVectorParameterValue( 'SymbolColorLOC', MakeLinearColor(205.f/255.f, 22.f/255.f, 22.f/255.f, 0.4f) );
// 			}
// 			CPControllerMIC.SetScalarParameterValue( 'Opacity', 1.f - TaccomFadeOpacity );
// 			Canvas.DrawMaterialTile( CPControllerMIC, CPIWidth, CPIHeight );
//
// 			// Draw the location pointer
// 			DrawSquadLocator(Bomb, LocalDrawX + CPIWidth/2, LocalDrawY + CPIHeight/2, Scale, Alpha);
//
// 			// Draw the glow if the goal is close
// 			if (Pct > 0.9)
// 			{
// 				// See if we just finished a pulse
// 				if ( (PulseStartTime + TotalPulseTime) < WorldInfo.TimeSeconds )
// 				{
// 					PulseStartTime = WorldInfo.TimeSeconds;
// 				}
// 				// else draw the pulse
// 				else
// 				{
// 					PulseScale = 1.2f;
//
// 					if ( (WorldInfo.TimeSeconds - PulseStartTime) < (TotalPulseTime / 2) )
// 					{
// 						GlowOpacity = (WorldInfo.TimeSeconds - PulseStartTime) / (TotalPulseTime / 2);
// 					}
// 					else
// 					{
// 						GlowOpacity = 1.f - ((WorldInfo.TimeSeconds - PulseStartTime - (TotalPulseTime / 2)) / (TotalPulseTime / 2));
// 					}
// 					CPIndicatorGlowMatInstance.SetScalarParameterValue( 'GlowOpacity', GlowOpacity );
// 					LocalDrawX = DrawX - CPIWidth*PulseScale/2;
// 					LocalDrawY = DrawY - CPIHeight*PulseScale/2;
// 					Canvas.SetPos( LocalDrawX, LocalDrawY );
// 					CPIndicatorGlowMatInstance.SetScalarParameterValue( 'Opacity', 1.f - TaccomFadeOpacity );
// 					Canvas.DrawMaterialTile( CPIndicatorGlowMatInstance, CPIWidth*PulseScale, CPIHeight*PulseScale );
// 				}
// 			}
//
// 			// if the bomb is counting down, draw the countdown timer
// 			if (Bomb.CountdownRemaining > 0)
// 			{
// 				Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
// 				Canvas.StrLen(string(Bomb.CountdownRemaining), XL, YL);
// 				Canvas.SetPos(DrawX - XL * 0.5, DrawY - YL * 0.5);
// 				Canvas.DrawText(string(Bomb.CountdownRemaining));
// 			}
		}
	}
}

defaultproperties
{
	TotalPulseTime=1.0
}
