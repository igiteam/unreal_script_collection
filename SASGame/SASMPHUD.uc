// common code between different MP HUD types.

class SASMPHUD extends SASHUD
	config;
#exec TEXTURE IMPORT NAME=MessageWindow  FILE=..\HUD\Textures\TalkBorder.PCX GROUP="Icons" MIPS=OFF ALPHATEXTURE=1
/*
#exec Font Import File=..\botpack\Textures\TinyFon2.pcx Name=TinyRedFont
*/
#exec TEXTURE IMPORT NAME=HudElements1 FILE=..\HUD\TEXTURES\HudComp4.pcx GROUP="Icons" MIPS=OFF
/*
#exec OBJ LOAD FILE=..\Textures\LadrStatic.utx PACKAGE=SASDMGame.LadrStatic
#exec OBJ LOAD FILE=..\Textures\TempHud.utx PACKAGE=TempHud
//#exec OBJ LOAD FILE=..\Textures\sg_Hud.utx PACKAGE=SG_Hud

var() int SizeY,Count;
*/

var float						IdentifyFadeTime;
var Pawn						IdentifyTarget;
var Pawn						PawnOwner;	// pawn currently managing this HUD (may be the viewtarget of the owner rather than the owner)
var PlayerController			PlayerOwner;
var PlayerReplicationInfo		ViewedInfo;

var float						StartupMessageEnd;
var int							StartupHeight;	// half of height in text lines of startup window
var byte						StartupStage;

// Localized Messages
var HUDLocalizedMessage			LocalMessages[10];
var int							PlayerCount;

var float						TalkTime;
var PlayerReplicationInfo		TalkPRI;
var int							LastReportedTime;

var int							OldClipX;
var bool						bStartUpMessage;
var bool						bTimeValid;

// configuration options
var bool						bAlwaysHideFrags;
var byte						Style;
/*
var color FaceColor;
*/
var color						WhiteColor;

// Identify Strings
//var localized string			IdentifyName,
//								IdentifyHealth;
var localized string			LiveFeed;

/*
var float PickupTime;
*/
var float						WeaponFadeTime;
//var float MessageFadeTime;
/*
var bool bDrawFaceArea;
var float FaceAreaOffset, MinFaceAreaOffset;
*/
var class<CriticalEventPlus>	TimeMessageClass;

var int							EdgeOffsetX,
								EdgeOffsetY;
var float						LastTime,
								CurrentDeltaTime;
var float						Scale;

var localized string			gamegoal;
var localized string			TourneyMessage;
var localized string			WaitingMessage1;
var localized string			WaitingMessage2;
var localized string			ReadyMessage;
var localized string			NotReadyMessage;
var localized string			StartMessage;
var localized string			LoadoutMessage,LoadoutCycle;


function PlayStartupMessage(byte Stage)
{
	StartupStage = Stage;
	StartupMessageEnd = Level.TimeSeconds + 6;
}

//::function DrawTextAt(Canvas Canvas, string Text, out int offset, float YL)
//::{
//::	Canvas.SetPos(0, Canvas.ClipY*0.5 + YL*(offset-StartupHeight));
//::	offset++;
//::	Canvas.DrawText(Text);
//::}

simulated function PostBeginPlay()
{
//	FaceAreaOffset = -64;
	Super.PostBeginPlay();
	SetTimer(1.0, True);
	PlayerOwner = PlayerController(Owner);

	if ( (PlayerOwner.GameReplicationInfo != None) && (PlayerOwner.GameReplicationInfo.RemainingTime > 0) )
	{
		TimeMessageClass = class<CriticalEventPlus>(DynamicLoadObject("SASMPGame.TimeMessage", class'Class'));
	}
}

simulated function HUDSetup(canvas canvas)
{
	OldClipX = Canvas.ClipX;

	CurrentDeltaTime = Level.TimeSeconds - LastTime;
	LastTime = Level.TimeSeconds;

	if (PlayerOwner.ViewTarget == PlayerOwner)
	{
		PawnOwner = PlayerOwner.Pawn;
	}
	else if (PlayerOwner.ViewTarget.IsA('Pawn') && Pawn(PlayerOwner.ViewTarget).Controller != None)
	{
		PawnOwner = Pawn(PlayerOwner.ViewTarget);
	}
	else if ( PlayerOwner.Pawn != None )
	{
		PawnOwner = PlayerOwner.Pawn;
	}
	else
	{
		PawnOwner = None;
	}

	if ( (PawnOwner != None) && (PawnOwner.Controller != None) )
	{
		ViewedInfo = PawnOwner.PlayerReplicationInfo;
	}
	else
	{
		ViewedInfo = PlayerOwner.PlayerReplicationInfo;
	}

	// Setup the way we want to draw all HUD elements
	Canvas.Reset();
	Canvas.SpaceX=0;
	Canvas.bNoSmooth = True;

	Canvas.DrawColor = WhiteColor;
	Canvas.Style = Style;
//	Scale = Canvas.ClipX/640.0;
	Scale = Canvas.ClipX / 1024.0;
	Canvas.Font = Canvas.SmallFont;
}
/*
simulated function DrawFragCount ( Canvas aCanvas )
{
	local int	X, Y;
	local float	XL, YL;
	local int	Score;

	if ( ViewedInfo == None )
	{
		return;
	}

	// draw frag count border in team colour
	Y = aCanvas.ClipY - 32 * Scale - EdgeOffsetY;
	X = EdgeOffsetX;
	if ( ViewedInfo.Team != None )
	{
		aCanvas.DrawColor = ViewedInfo.Team.TeamColor;
	}
	else
	{
		aCanvas.DrawColor = WhiteColor;
	}
	aCanvas.SetPos ( X, Y );
	aCanvas.DrawTile ( Texture'HudElements1', 105 * Scale, 35 * Scale, 0, 93, 105, 35 );

	// draw frag count
	aCanvas.DrawColor = WhiteColor;
	aCanvas.Font = aCanvas.SmallFont;
	Score = Clamp ( ViewedInfo.ScoreDaggers, -99, 999 );
	aCanvas.StrLen ( Score, XL, YL );
	aCanvas.SetPos ( X + 88 * Scale - XL, Y + 3 );
	aCanvas.DrawText ( Score, false );
}
*/
simulated function DrawGameSynopsis(Canvas Canvas);


auto state InGame
{
	///////////////////////////////////////////////////////////////////////////////
	// PostRender
	//
	simulated event PostRender (
		Canvas		aCanvas)	// Rendering canvas
	{
		// Draw scoreboard background if its on.
		if ( !bHideHud && !IsMoviePlaying() && !bRenderWeaponsOnly && bShowScores && Scoreboard != None )
		{
			SASMPScoreboard( Scoreboard ).DrawBackground( aCanvas );

			// And draw the MP hud items before the actual score data.
			DrawMPHUD ( aCanvas );
		}

		// Draw the normal hud items.
		Super.PostRender ( aCanvas );

		// If the scoreboard not drawn then need to draw the MP hud items now
		if ( !bHideHud && !IsMoviePlaying() && !bRenderWeaponsOnly && !(bShowScores && Scoreboard != None) )
		{
			DrawMPHUD ( aCanvas );
		}
	}
}

//========================================
// Master HUD render function.
simulated function DrawMPHUD ( Canvas aCanvas )
{
	local float		XL,
					YL,
					OldOriginX,
					FadeValue,
					YPos;
	local int		i,
					FaceNum;
	local vector	tgtIDPos,
					screenPos,
					camLoc,
					camDir,
					vecToPawn;
	local Rotator	camRot;
	local SASPlayerController PC;
	local SASPawn	tPawn;
	local Actor		viewActor;
	local Font		oldFont;
	local bool		bFadeMessages;

	HUDSetup ( aCanvas );

	if ( bHideHUD || ( ViewedInfo == None ) )
	{
		return;
	}

	OldOriginX = aCanvas.OrgX;
	// Master message short queue control loop.
	FaceNum = -1;
	aCanvas.DrawColor = WhiteColor;
	aCanvas.SetClip ( OldClipX, aCanvas.ClipY );

	aCanvas.Style = Style;


	// Master localized message control loop.

	aCanvas.StrLen("X", XL, YL);
	YPos = YL * 0.5;

	// set message font size.
	oldFont = aCanvas.Font;
	if ( aCanvas.ClipY <= 800 )
	{
		aCanvas.Font = aCanvas.TinyFont;
		YPos = YL * 0.25;
	}
	else
	{
		aCanvas.Font = aCanvas.SmallFont;
		YPos = YL * 0.5;
	}

	bFadeMessages = bShowScores && Scoreboard != None;
	
	for ( i = 0; i < 10; i++ )
	{
		if ( LocalMessages[i].Message != None )
		{
			if ( LocalMessages[i].Message.Default.bFadeMessage  )
			{
				aCanvas.Style = ERenderStyle.STY_Normal;
				FadeValue = (LocalMessages[i].EndOfLife - Level.TimeSeconds);
				if ( FadeValue > 0.0 )
				{
					aCanvas.DrawColor = LocalMessages[i].DrawColor;
					aCanvas.DrawColor.A = 255 * (FadeValue/LocalMessages[i].LifeTime);
					if ( bFadeMessages && i > 0 )
					{
						if ( aCanvas.DrawColor.A > 128 )
						{
							aCanvas.DrawColor.A = 128;
						}
					}
					
					aCanvas.StrLen(LocalMessages[i].StringMessage, XL, YL);
					LocalMessages[i].YPos = LocalMessages[i].Message.Static.GetOffset(LocalMessages[i].Switch, YL, aCanvas.ClipY);
					if ( (WeaponFadeTime < Level.TimeSeconds) || (LocalMessages[i].YPos != aCanvas.ClipY - YL - (64.0/768)*aCanvas.ClipY) )
					{
						aCanvas.SetPos( 0.5 * (aCanvas.ClipX - XL), YPos);//LocalMessages[i].YPos );
						aCanvas.DrawText( LocalMessages[i].StringMessage, False );
						YPos += YL;
					}
					else
					{
						LocalMessages[i].EndOfLife = Level.TimeSeconds;
					}
				}
			}
			else
			{
				aCanvas.Style = ERenderStyle.STY_Normal;
				aCanvas.DrawColor = LocalMessages[i].DrawColor;
				if ( bFadeMessages && i > 0 )
				{
					if ( aCanvas.DrawColor.A > 128 )
					{
						aCanvas.DrawColor.A = 128;
					}
				}
				aCanvas.StrLen ( LocalMessages[i].StringMessage, XL, YL );
				LocalMessages[i].YPos = LocalMessages[i].Message.Static.GetOffset ( LocalMessages[i].Switch, YL, aCanvas.ClipY );
				aCanvas.SetPos ( 0.5 * ( aCanvas.ClipX - XL ), YPos);//LocalMessages[i].YPos );
				aCanvas.DrawText ( LocalMessages[i].StringMessage, False );
				YPos += YL;
			}
		}
	}

	aCanvas.Style = Style;
	aCanvas.Font = oldFont;

	if ( PawnOwner != None )
	{
		if ( ( PawnOwner != PlayerOwner.Pawn ) && ( ViewedInfo != None ) )
		{
			aCanvas.Font = aCanvas.MedFont;
			aCanvas.bCenter = true;
			aCanvas.Style = Style;
			aCanvas.SetDrawColor ( 0, 255, 255 );
			aCanvas.SetPos ( 4, aCanvas.ClipY - 48 );
			aCanvas.DrawText ( LiveFeed$ViewedInfo.PlayerName, true );
			aCanvas.bCenter = false;
			aCanvas.DrawColor = WhiteColor;
			aCanvas.Style = Style;
		}
	}

	if ( bStartUpMessage && (Level.TimeSeconds < 5) )
	{
		bStartUpMessage = false;
		PlayerOwner.SetProgressTime ( 7 );
	}

/*
	// some useful test code, player controller states often go out of sync
	i = 0;
	foreach AllActors(class'SASPlayerController', PC)
	{
		aCanvas.Font = aCanvas.TinyFont;
		aCanvas.Style = ERenderStyle.STY_Normal;
		aCanvas.SetDrawColor ( 0, 255, 255 );
		aCanvas.SetPos ( 0, 200 + i * 20 );
		aCanvas.DrawText ( PC $" "$PC.GetStateName());
		i++;
	}
*/
		
	if ( !ViewedInfo.bIsSpectator )
	{
		aCanvas.Style = ERenderStyle.STY_Normal;

		// Display Frag count
		//if ( !bAlwaysHideFrags && !bShowScores )
		//{
		//	DrawFragCount ( aCanvas );
		//}

		// Team Game Synopsis
		DrawGameSynopsis ( aCanvas );
	}

	PC = SASPlayerController( Level.GetLocalPlayerController() );
	
	// Display Identification Info. When playing only show name of target, when spectating draw 
	// names of all players on screen.
	if ( !PlayerOwner.PlayerReplicationInfo.bLatecomer && !PlayerOwner.PlayerReplicationInfo.bIsSpectator )
	{
		if ( TraceIdentify( aCanvas ) && ( IdentifyTarget != None ) )
		{
			aCanvas.Font = aCanvas.SmallFont;
	//		DrawTwoColorID ( aCanvas, IdentifyName, IdentifyTarget.PlayerReplicationInfo.PlayerName, aCanvas.ClipY - 144 );
		
			// Get screen location of point above players head.
			tgtIDPos = IdentifyTarget.Location;
			tgtIDPos.Z += IdentifyTarget.CollisionHeight+10;
			screenPos = PC.Player.Console.WorldToScreen( tgtIDPos );

			if ( screenPos.Z >= 1.0 )
			{
				DrawColorID ( aCanvas, IdentifyTarget.PlayerReplicationInfo.PlayerName, screenPos.X, screenPos.Y );
			}
		}
	}
	else
	{
		// Show names of all players on screen. 

		// Get camera location/rotation.
		viewActor = None;
		camLoc = PC.Location;
		camRot = PC.Rotation;
		PC.PlayerCalcView( viewActor, camLoc, camRot );
		camDir = Vector(camRot);

		aCanvas.Style = ERenderStyle.STY_Alpha;

		// Hmm - on clients dont have access to the pawn list (stored in SASGameInfo) so have
		// to go through the entire dynamic actor list to find them. 
		foreach DynamicActors( class'SASPawn', tPawn )
		{
			if (	(tPawn.mPawnType == PAWN_Soldier) && 
					(tPawn.PlayerReplicationInfo != None) && 
					(tPawn.Health > 0) )
			{
				tgtIDPos = tPawn.Location;
				tgtIDPos.Z += tPawn.CollisionHeight + 10;

				// First check pawn is in front of owner player controllers view direction.
				vecToPawn = tgtIDPos - camLoc;
				if ( vecToPawn Dot camDir > 0.0 )
				{
					screenPos = PC.Player.Console.WorldToScreen( tgtIDPos );

					if ( screenPos.Z >= 1.0 )
					{
						// Now is other actually visible?
						tgtIDPos.Z -= 10;
						if ( tPawn.FastTrace( tgtIDPos, camLoc ) )
						{
							aCanvas.StrLen( tPawn.PlayerReplicationInfo.PlayerName, XL, YL );
							aCanvas.SetPos( screenPos.X - (XL / 2), screenPos.Y - YL );
							aCanvas.DrawColor = tPawn.PlayerReplicationInfo.Team.TeamColor;
							aCanvas.DrawTextClipped( tPawn.PlayerReplicationInfo.PlayerName );
						}
					}
				}
			}
		}
		
		// Restore canvas draw colour to default.
		aCanvas.DrawColor = WhiteColor;
	}

	if ( ( PlayerOwner.GameReplicationInfo != None )
		&& ( PlayerOwner.GameReplicationInfo.RemainingTime > 0 )
		&& PlayerOwner.GameReplicationInfo.bMatchHasBegun )
	{
		if ( (PlayerOwner.GameReplicationInfo.RemainingTime <= 300)
				&& (PlayerOwner.GameReplicationInfo.RemainingTime != LastReportedTime) )
		{
			LastReportedTime = PlayerOwner.GameReplicationInfo.RemainingTime;
			if ( PlayerOwner.GameReplicationInfo.RemainingTime <= 30 )
			{
				bTimeValid = ( bTimeValid || (PlayerOwner.GameReplicationInfo.RemainingTime > 0) );
				if ( PlayerOwner.GameReplicationInfo.RemainingTime == 30 )
				{
					TellTime ( 30 );
				}
				else if ( bTimeValid && PlayerOwner.GameReplicationInfo.RemainingTime <= 10 )
				{
					TellTime ( PlayerOwner.GameReplicationInfo.RemainingTime );
				}
			}
			else if ( PlayerOwner.GameReplicationInfo.RemainingTime % 60 == 0 )
			{
				TellTime ( PlayerOwner.GameReplicationInfo.RemainingTime );
			}
		}
	}
}

function Timer ()
{
	local int i;

	// Age all localized messages.
	for ( i = 0; i < 10; i++ )
	{
		// Purge expired messages.
		if ( ( LocalMessages[i].Message != None ) && ( Level.TimeSeconds >= LocalMessages[i].EndOfLife ) )
		{
			ClearMessage ( LocalMessages[i] );
		}
	}

	// Clean empty slots.
	for ( i = 0; i < 9; i++ )
	{
		if ( LocalMessages[i].Message == None )
		{
			CopyMessage ( LocalMessages[i], LocalMessages[i + 1] );
			ClearMessage ( LocalMessages[i + 1] );
		}
	}

	if (
		( PlayerOwner == None) ||
		( PawnOwner == None ) ||
		( PlayerOwner.GameReplicationInfo == None ) ||
		( ViewedInfo == None )
		)
	{
		return;
	}
}

simulated function TellTime(int num)
{
	PlayerOwner.ReceiveLocalizedMessage( TimeMessageClass, Num );
}

simulated function Tick ( float aDeltaTime )
{
	Super.Tick ( aDeltaTime );

	IdentifyFadeTime = FMax ( 0.0, IdentifyFadeTime - aDeltaTime );
}

// Entry point for string messages.
simulated function Message( PlayerReplicationInfo PRI, coerce string Msg, name MsgType )
{
	local Class<LocalMessage> MessageClass;

	if ( bMessageBeep )
	{
		PlayerOwner.PlayBeepSound();
	}
	switch (MsgType)
	{
	case 'Say':
		Msg = PRI.PlayerName$": "$Msg;
		MessageClass = class'SayMessagePlus';
		break;
	case 'TeamSay':
		Msg = PRI.PlayerName$": "$Msg;
		MessageClass = class'TeamSayMessagePlus';
		break;
	case 'CriticalEvent':
		MessageClass = class'CriticalStringPlus';
		//LocalizedMessage( MessageClass, 0, None, None, None, Msg );
		return;
	case 'DeathMessage':
		MessageClass = class'RedSayMessagePlus';
		break;
//	case 'Pickup':
//		PickupTime = Level.TimeSeconds;
	default:
		MessageClass = class'StringMessagePlus';
		break;
	}

	if ( ClassIsChildOf(MessageClass, class'SayMessagePlus') ||
				     ClassIsChildOf(MessageClass, class'TeamSayMessagePlus') )
	{
		TalkTime = MessageClass.Default.Lifetime + Level.TimeSeconds;
		TalkPRI = PRI;
	}

	LocalizedMessage( MessageClass, 0, None, None, None, Msg ); 
	//AddTextMessage(Msg,MessageClass,PRI);
}

//================================================================================
// Identify Info
//
simulated function bool TraceIdentify ( canvas Canvas )
{
	local SASPawn	p;
	local SASPlayerController	localPC;
	local Actor					reticuleTarget;

	localPC = SASPlayerController( Level.GetLocalPlayerController() );
	if ( localPC == None )
	{
		return false;
	}

	if ( ( PawnOwner == None ) || ( PawnOwner != PlayerOwner.Pawn ) )
	{
		return false;
	}

	if ( IdentifyFadeTime == 0.0 )
	{
		IdentifyTarget = None;
	}

	reticuleTarget = localPC.mReticuleTarget;
	if ( reticuleTarget != None )
	{
		p = SASPawn ( reticuleTarget );
		if ( p != None )
		{
			// In multiplayer sabre squad - all pawns are PAWN_Soldiers. In cooperative its only the squad.
			if (	(p.mPawnType == PAWN_Soldier) && 
					(p.PlayerReplicationInfo != None) && 
					!p.bHidden )
			{
				IdentifyTarget = p;
				IdentifyFadeTime = 1.5;
			}
		}
	}

	if (	( IdentifyFadeTime == 0.0 ) || 
			( IdentifyTarget == None ) || 
			( IdentifyTarget.PlayerReplicationInfo == None ) || 
			( IdentifyTarget.PlayerReplicationInfo.PlayerName == "" ) )
	{
		return false;
	}

	return true;
}

//::simulated function bool SpecialIdentify(Canvas Canvas, Actor Other )
//::{
//::	return false;
//::}

/*simulated function SetIDColor ( Canvas aCanvas, int type )
{
	if ( type == 0 )
	{
		aCanvas.SetDrawColor ( 0, 160 * ( IdentifyFadeTime / 3.0 ), 0 );
	}
	else
	{
		aCanvas.SetDrawColor ( 0, 255 * ( IdentifyFadeTime / 3.0 ), 0 );
	}
}
*/
simulated function byte SetIDComponentColour ( byte aRGB )
{
	if ( aRGB != 0 )
	{
		return aRGB * ( IdentifyFadeTime / 1.5 );
	}
	return 0;
}

simulated function SetIDColor ( Canvas aCanvas, int type )
{
	local Color	newCol;

	/*if ( type == 0 )
	{
		newCol = IdentifyTarget.PlayerReplicationInfo.Team.AltTeamColor;
	}
	else
	{
		newCol = IdentifyTarget.PlayerReplicationInfo.Team.TeamColor;
	}*/
	//newCol = WhiteColor;

	newCol = IdentifyTarget.PlayerReplicationInfo.Team.TeamColor;
	newCol.A = SetIDComponentColour ( newCol.A );

	aCanvas.DrawColor = newCol;
}

//::simulated function DrawTwoColorID( Canvas aCanvas, string TitleString, string ValueString, int YStart )
//::{
//::	local float XL, YL, XOffset, X1;
//::
//::	aCanvas.Style = Style;
//::	aCanvas.StrLen( TitleString$": ", XL, YL );
//::	X1 = XL;
//::	aCanvas.StrLen( ValueString, XL, YL );
//::	XOffset = aCanvas.ClipX / 2 - ( X1 + XL ) / 2;
//::	aCanvas.SetPos( XOffset, YStart );
//::	SetIDColor( aCanvas, 0 );
//::	XOffset += X1;
//::	aCanvas.DrawText( TitleString );
//::	aCanvas.SetPos( XOffset, YStart );
//::	SetIDColor( aCanvas, 1 );
//::	aCanvas.DrawText( ValueString );
//::	aCanvas.DrawColor = WhiteColor;
//::}

simulated function DrawColorID( Canvas aCanvas, string ValueString, int XPos, int YPos )
{
	local float XL, YL, XOffset;

	aCanvas.Style = ERenderStyle.STY_Alpha;
	aCanvas.StrLen( ValueString, XL, YL );
	XOffset = XL / 2;
	aCanvas.SetPos( XPos - XOffset, YPos - YL );
	SetIDColor( aCanvas, 1 );
	aCanvas.DrawTextClipped( ValueString );
	aCanvas.DrawColor = WhiteColor;
}

//=====================================================================
// Deal with a localized message.

simulated function LocalizedMessage( class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject, optional String CriticalString )
{
	local int i;

	if ( bMessageBeep && Message.Default.bBeep )
	{
		PlayerOwner.PlayBeepSound();
	}

	if ( CriticalString == "" )
	{
		CriticalString = Message.Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	}
	if ( Message.Default.bIsUnique )
	{
		for (i=0; i<10; i++)
		{
			if (LocalMessages[i].Message != None)
			{
				if ((LocalMessages[i].Message == Message)
					|| (LocalMessages[i].Message.Static.GetOffset(LocalMessages[i].Switch, 24, 640)
							== Message.Static.GetOffset(Switch, 24, 640)) )
				{
					LocalMessages[ i ].Message = Message;
					LocalMessages[ i ].Switch = Switch;
					LocalMessages[ i ].RelatedPRI = RelatedPRI_1;
					LocalMessages[ i ].OptionalObject = OptionalObject;
					LocalMessages[ i ].LifeTime = Message.Default.Lifetime;
					LocalMessages[ i ].EndOfLife = Message.Default.Lifetime + Level.TimeSeconds;
					LocalMessages[ i ].StringMessage = CriticalString;
					LocalMessages[ i ].DrawColor = Message.Static.GetColor ( Switch, RelatedPRI_1, RelatedPRI_2 );
					return;
				}
			}
		}
	}
	
	for ( i = 0; i < 10; i++ )
	{
		if ( LocalMessages[i].Message == None )
		{
			LocalMessages[i].Message = Message;
			LocalMessages[i].Switch = Switch;
			LocalMessages[i].RelatedPRI = RelatedPRI_1;
			LocalMessages[i].OptionalObject = OptionalObject;
			LocalMessages[i].EndOfLife = Message.Default.Lifetime + Level.TimeSeconds;
			LocalMessages[i].StringMessage = CriticalString;
			LocalMessages[i].DrawColor = Message.Static.GetColor ( Switch, RelatedPRI_1, RelatedPRI_2 );
			LocalMessages[i].LifeTime = Message.Default.Lifetime;
			return;
		}
	}

	// No empty slots.  Force a message out.
	for (i=0; i<9; i++)
	{
		CopyMessage ( LocalMessages[ i ], LocalMessages[ i + 1 ] );
	}

	LocalMessages[9].Message = Message;
	LocalMessages[9].Switch = Switch;
	LocalMessages[9].RelatedPRI = RelatedPRI_1;
	LocalMessages[9].OptionalObject = OptionalObject;
	LocalMessages[9].EndOfLife = Message.Default.Lifetime + Level.TimeSeconds;
	LocalMessages[9].StringMessage = CriticalString;
	LocalMessages[9].DrawColor = Message.Static.GetColor ( Switch, RelatedPRI_1, RelatedPRI_2 );
	LocalMessages[9].LifeTime = Message.Default.Lifetime;
}

function DisplayMessages ( Canvas aCanvas )
{
	local float XPos, XClip, oOX, oOY, oCX, oCY;

	XPos = 0.25 * aCanvas.ClipX;
	oOX = aCanvas.OrgX;
	oOY = aCanvas.OrgY;
	oCX = aCanvas.ClipX;
	oCY = aCanvas.ClipY;

	// @@@Hack for bad ammo drawing stuff since it's so small
	if ( Scale < 1 )
	{
		XPos = 195;
	}
	else
	{
		XPos = 195 * Scale;
	}

	XClip = aCanvas.ClipX - ( 235 * Scale ) - XPos;

	aCanvas.SetOrigin ( XPos, 5 );
	aCanvas.SetClip ( XClip, aCanvas.ClipY );

	Super.DisplayMessages ( aCanvas );

	aCanvas.OrgX  = oOX;
	aCanvas.OrgY  = oOY;
	aCanvas.ClipX = oCX;
	aCanvas.ClipY = oCY;

	aCanvas.Reset ();
}

state StatsScreen
{
	event PostRender (
		Canvas aCanvas )	// Rendering canvas
	{
		Super.PostRender ( aCanvas );
	}
}

state PlayerDeathFade
{
	event PostRender (
		Canvas aCanvas )	// Rendering canvas
	{
		Super.PostRender ( aCanvas );
	}
}

// Decompiled with UE Explorer.
defaultproperties
{
    StartupHeight=3
    bStartUpMessage=true
    WhiteColor=(R=255,G=255,B=255,A=255)
    LiveFeed="Live Feed from "
    TimeMessageClass=Class'TimeMessage'
    EdgeOffsetX=160
    EdgeOffsetY=16
    gamegoal="frags wins the match."
    TourneyMessage="Waiting for other players tourney."
    WaitingMessage1="Waiting for ready signals."
    WaitingMessage2="(Use your fire button to toggle ready!)"
    ReadyMessage="You are READY!"
    NotReadyMessage="You are NOT READY!"
    StartMessage="The match has begun!"
    LoadoutMessage="Loadout:"
    LoadoutCycle=" (F7 cycles)."
}