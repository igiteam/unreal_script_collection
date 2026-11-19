/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMTeamHUD extends TMHUD;

var bool bShowDirectional;
var int LastScores[2];
var int ScoreTransitionTime[2];
var vector2D TeamIconCenterPoints[2];
var float LeftTeamPulseTime, RightTeamPulseTime;
var float OldLeftScore, OldRightScore;

/** The scaling modifier will be applied to the widget that coorsponds to the player's team */
var() float TeamScaleModifier;

function DisplayScoring()
{
	Super.DisplayScoring();

	if ( !bIsSplitScreen || bIsFirstPlayer )
	{
		DisplayTeamScore();
	}
}

function DisplayTeamScore()
{
	local float DestScale, W, H, POSX;
	local vector2d Logo;
	local byte TeamIndex;
	local LinearColor TeamLC;
	local color TextC;
	local int NewScore;

	Canvas.DrawColor = WhiteColor;
    W = 214 * ResolutionScaleX;
    H = 87 * ResolutionScale;

	// Draw the Left Team Indicator
	DestScale = 1.0;
	TeamIndex = TMPlayerOwner.GetTeamNum();
	if ( (TeamIndex == 255) || bIsSplitScreen )
	{
		// spectator
		TeamIndex = 0;
		DestScale = TeamScaleModifier;
	}
	GetTeamColor(TeamIndex, TeamLC, TextC);
	POSX = Canvas.ClipX * 0.49 - W;

	Canvas.SetPos(POSX, 0);
	Canvas.DrawTile(IconHudTexture, W * DestScale, H * DestScale, 0, 491, 214, 87, TeamLC);

	NewScore = GetTeamScore(TeamIndex);
	if ( NewScore != OldLeftScore )
	{
		LeftTeamPulseTime = WorldInfo.TimeSeconds;
	}
	OldLeftScore = NewScore;

	if (DestScale < 1.0)
	{
		DrawGlowText(string(NewScore), POSX + 97 * ResolutionScaleX, -2 * ResolutionScale, 50 * ResolutionScale, LeftTeamPulseTime, true);
	}
	else
	{
		DrawGlowText(string(NewScore), POSX + 124 * ResolutionScaleX, -2 * ResolutionScale, 60 * ResolutionScale, LeftTeamPulseTime, true);
	}

	Logo.X = POSX + ((TeamIconCenterPoints[0].X) * DestScale * ResolutionScaleX) + (30 * ResolutionScaleX);
	Logo.Y = ((TeamIconCenterPoints[0].Y) * DestScale * ResolutionScale) + (27.5 * ResolutionScale);


   	DisplayTeamLogos(TeamIndex,Logo, 1.5);

	// Draw the Right Team Indicator
	DestScale = TeamScaleModifier;
	TeamIndex = 1 - TeamIndex;
	GetTeamColor(TeamIndex, TeamLC, TextC);
	POSX = Canvas.ClipX * 0.51;

	NewScore = GetTeamScore(TeamIndex);
	if ( NewScore != OldRightScore )
	{
		RightTeamPulseTime = WorldInfo.TimeSeconds;
	}
	OldRightScore = NewScore;

	Canvas.SetPos(POSX,0);
	Canvas.DrawTile(IconHudTexture, W * DestScale, H * DestScale, 0, 582, 214, 87, TeamLC);
	Canvas.DrawColor = WhiteColor;
	DrawGlowText(string(NewScore), POSX + 0.66*W, -4 * ResolutionScaleX, 50 * ResolutionScale, RightTeamPulseTime, true);

	Logo.X = (POSX + (TeamIconCenterPoints[1].X) * DestScale * ResolutionScaleX) + (30 * ResolutionScaleX);
	Logo.Y = ((TeamIconCenterPoints[1].Y) * DestScale * ResolutionScale) + (27.5 * ResolutionScale);
   	DisplayTeamLogos(TeamIndex,Logo, 1.0);
}

function int GetTeamScore(byte TeamIndex)
{
	if( (TeamIndex == 0 || TeamIndex == 1) && (TMGRI != None) && (TMGRI.Teams[TeamIndex] != None) )
	{
		return TMGRI.Teams[TeamIndex].Score;
	}
	else
	{
		return 0;
	}

}

function Actor GetDirectionalDest(byte TeamIndex)
{
	return none;
}

function DisplayTeamLogos(byte TeamIndex, vector2d POS, optional float DestScale=1.0)
{
	if ( bShowDirectional )
	{
		DisplayDirectionIndicator(TeamIndex, POS, GetDirectionalDest(TeamIndex), DestScale );
	}
}

function DisplayDirectionIndicator(byte TeamIndex, vector2D POS, Actor DestActor, float DestScale)
{
	local rotator Dir,Angle;
	local vector start;

	if ( DestActor != none )
	{
		Start = (PawnOwner != none) ? PawnOwner.Location : TMPlayerOwner.Location;
		Dir  = Rotator(DestActor.Location - Start);
		Angle.Yaw = (Dir.Yaw - PlayerOwner.Rotation.Yaw) & 65535;


		// Boost the colors a bit to make them stand out
		Canvas.DrawColor = WhiteColor;
		Canvas.SetPos(POS.X - (28.5 * DestScale * ResolutionScaleX), POS.Y - (26 * DestScale * ResolutionScale));
		Canvas.DrawRotatedTile( AltHudTexture, Angle, 57 * DestScale * ResolutionScaleX, 52 * DestScale * ResolutionScale, 897, 452, 43, 43);
	}
}

/**
 * This function is called to draw the hud while the game is still in progress.  You should only draw items here
 * that are always displayed.  If you want to draw something that is displayed only when the player is alive
 * use DrawLivingHud().
 */
function DrawGameHud()
{
    local float xl, yl;
    local Pawn P;
    local int i, len;
    local UniqueNetId OtherPlayerNetId;

	Super.DrawGameHud();

    // Draw any spectator information
    if (TMOwnerPRI != None)
    {
        if (TMOwnerPRI.bOnlySpectator || TMPlayerOwner.IsInState('Spectating'))
        {
            P = Pawn(TMPlayerOwner.ViewTarget);
            if (P != None && P.PlayerReplicationInfo != None && P.PlayerReplicationInfo != TMOwnerPRI)
            {
                if (  TMPlayerOwner.bBehindView )
                {
                DisplayHUDMessage(SpectatorMessage @ "-" @ P.PlayerReplicationInfo.PlayerName, 0.05, 0.15);
            }
            }
            else
            {
                DisplayHUDMessage(SpectatorMessage, 0.05, 0.15);
            }
        }
        else if ( TMOwnerPRI.bIsSpectator )
        {
            if (TMGRI != None && TMGRI.bMatchHasBegun)
            {
                DisplayHUDMessage(PressFireToBegin);
            }
            else
            {
                DisplayHUDMessage(WaitingForMatch);
            }

        }
        else if ( TMPlayerOwner.IsDead() )
        {
            DisplayHUDMessage( DeadMessage );
        }
    }

    // Draw the Warmup if needed
    if (TMGRI != None && TMGRI.bWarmupRound)
    {
        Canvas.Font = GetFontSizeIndex(2);
        Canvas.DrawColor = WhiteColor;
        Canvas.StrLen(WarmupString, XL, YL);
        Canvas.SetPos((Canvas.ClipX - XL) * 0.5, Canvas.ClipY * 0.175);
        Canvas.DrawText(WarmupString);
    }


    Canvas.Font = GetFontSizeIndex(1);

    // Check if any remote players are using VOIP
    if ( (CharPRI == None) && (PlayerOwner.VoiceInterface != None) && (WorldInfo.NetMode != NM_Standalone)
        && (WorldInfo.GRI != None) )
    {
        len = WorldInfo.GRI.PRIArray.Length;
        for ( i=0; i<len; i++ )
        {
            OtherPlayerNetId = WorldInfo.GRI.PRIArray[i].UniqueID;
            if ( PlayerOwner.VoiceInterface.IsRemotePlayerTalking(OtherPlayerNetId)
                && (WorldInfo.GRI.PRIArray[i] != PlayerOwner.PlayerReplicationInfo)
                && (TMPlayerReplicationInfo(WorldInfo.GRI.PRIArray[i]) != None)
                && (PlayerOwner.GameplayVoiceMuteList.Find('Uid', OtherPlayerNetId.Uid) == INDEX_NONE) )
            {
                ShowPortrait(TMPlayerReplicationInfo(WorldInfo.GRI.PRIArray[i]));
                break;
            }
        }
    }
}

