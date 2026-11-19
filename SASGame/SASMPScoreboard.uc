//------------------------------------------------------------------------------
//
//
//------------------------------------------------------------------------------

class SASMPScoreboard extends Scoreboard
	abstract;

const MAX_PLAYERS = 20;

var PlayerReplicationInfo	PRIArray[MAX_PLAYERS];

var localized string		PlayerHeaderText;
var localized string		TeamHeaderText;
var localized string		DaggersHeaderText;
var localized string		KillsHeaderText;
var localized string		TimeText;
var localized string		PingText;
var localized string		PlayerJoiningText;
var localized string		AdminText;
var localized string		StatusText;
var localized string		FooterText;
var localized string		MatchIDText;
var localized string		OutText;
var localized string		ReadyText;
var localized string		NotReadyText;
var localized string		IsServerText;
var localized string		SpectatingText;	
var localized string		KilledText;
var localized string		AliveText;
var localized string		SkillLevel[8];		// all accesses are clamped (0,7)
var localized string		YouveLostTheMatch;
var localized string		YouveWonTheMatch;
var localized String		FragLimit;
var localized String		FPH;
var localized String		GameType;
var localized String		MapName;
var localized String		Restart;
var localized String		Continue;
var localized String		Ended;
var localized String		TimeLimit;
var localized String		Spacer;
							
var Color					WhiteColor;
var Color					LightGreyColour;
var Material				BoxMaterial;
var Texture					BackgroundTex;

var Font					mTitleFont;
var Font					mEntryFont;
var int						mDisplayedPlayerCount;
var float					mFontHeight;
var float					mPlayerBoxXPos;
var float					mPlayerBoxHeight;
var float					mPlayerBoxWidth;
var float					mPlayerBoxSpacing;
var float					mPlayerBoxTextOffsetY;
var float					mTitleOffsetY;
var float					mHeaderOffsetY;
var float					mPlayerBoxOffsetY;

// Text offsets on the scoreboard. Kept here so we don't haveto pass
// them all around as function params.
var float					mPlayerNameXPos;
var float					mTeamNameXPos;
var float					mDaggersScoreXPos;
var float					mKillsScoreXPos;
var float					mNetInfoXPos;
		

simulated function UpdatePrecacheMaterials()
{
    UpdatePrecacheFonts();
}

function UpdatePrecacheFonts();

simulated function DrawBackground(
	Canvas aCanvas )
{
	if ( BackgroundTex == None )
	{
		return;
	}

	aCanvas.bNoSmooth = false;
	aCanvas.Style = ERenderStyle.STY_Alpha;
	aCanvas.SetPos( 0, 0 );
	aCanvas.SetDrawColor( 255, 255, 255, 255 );
	aCanvas.DrawTile( BackgroundTex, aCanvas.SizeX, aCanvas.SizeY, 0, 0, BackgroundTex.VSize, BackgroundTex.USize);
}

simulated function DrawTitle(Canvas Canvas)
{
	local class<GameInfo> G;
	local string titlestring;
	local float TitleXL,YL;

	G = Level.GetGameClass();
	if ( G == None )
	{
		return;
	}

	titlestring = G.Default.GameName;
	Canvas.Font = mTitleFont;
	Canvas.DrawColor = LightGreyColour;
	Canvas.StrLen(TitleString,TitleXL,YL);
	Canvas.SetPos(0.5*(Canvas.ClipX-TitleXL), mTitleOffsetY);
	Canvas.DrawText(TitleString,true);
}


simulated function DrawHeaders(
	Canvas	aCanvas )
{
	aCanvas.DrawColor = LightGreyColour;
	
	// Player name header.
	aCanvas.SetPos( mPlayerNameXPos, mHeaderOffsetY );
	aCanvas.DrawText( PlayerHeaderText, true );

	// Draw net info header if is really an MP game.
	if ( Level.NetMode != NM_Standalone )
	{
		aCanvas.SetPos( mNetInfoXPos, mHeaderOffsetY );
		aCanvas.DrawText( StatusText, true );
	}
}


function DrawMatchID(Canvas Canvas,int FontReduction)
{
	local float XL,YL;

	if ( GRI != None && GRI.MatchID != 0 )
	{
		Canvas.Font = GetSmallFontFor(1.5*Canvas.ClipX, FontReduction+1);
		Canvas.StrLen(MatchIDText@GRI.MatchID, XL, YL);
		Canvas.SetPos(Canvas.ClipX - XL - 4, 4);
		Canvas.DrawText(MatchIDText@GRI.MatchID,true);
	}
}

//::function DrawNetInfo(
//::	Canvas	Canvas,
//::	int		FontReduction,
//::	int		HeaderOffsetY,
//::	int		PlayerBoxSizeY,
//::	int		BoxSpaceY,
//::	int		BoxTextOffsetY,
//::	int		OwnerOffset,
//::	int		PlayerCount )
//::{
//::	local float XL,YL;
//::	local int i;
//::	local bool bHaveHalfFont;
//::
//::	// draw admins
//::	if ( GRI.bMatchHasBegun )
//::	{
//::		Canvas.DrawColor = class'Canvas'.static.MakeColor(255,0,0);
//::		for ( i=0; i<PlayerCount; i++ )
//::		{
//::			if ( PRIArray[i].bAdmin )
//::			{
//::				Canvas.SetPos(mNetInfoXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY);
//::				Canvas.DrawText(AdminText,true);
//::			}
//::		}
//::		if ( (OwnerOffset >= PlayerCount) && PRIArray[OwnerOffset].bAdmin )
//::		{
//::			Canvas.SetPos(mNetInfoXPos, (PlayerBoxSizeY + BoxSpaceY)*PlayerCount + BoxTextOffsetY);
//::			Canvas.DrawText(AdminText,true);
//::		}
//::	}
//::
//::	Canvas.DrawColor = class'Canvas'.static.MakeColor(0,255,255);
//::	Canvas.Font = GetSmallFontFor(1.5*Canvas.ClipX, FontReduction);
//::	Canvas.StrLen("Test", XL, YL);
//::	BoxTextOffsetY = HeaderOffsetY + 0.5*PlayerBoxSizeY;
//::	bHaveHalfFont = ( YL < 0.5 * PlayerBoxSizeY);
//::
//::	// if game hasn't begun, draw ready or not ready
//::	if ( !GRI.bMatchHasBegun )
//::	{
//::		for ( i=0; i<PlayerCount; i++ )
//::		{
//::			if ( bHaveHalfFont )
//::			{
//::				Canvas.SetPos(mNetInfoXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY - YL);
//::				Canvas.DrawText(PingText@Min(999,PRIArray[i].Ping),true);
//::				Canvas.SetPos(mNetInfoXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY);
//::			}
//::			else
//::			{
//::				Canvas.SetPos(mNetInfoXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY - 0.5*YL);
//::			}
//::			
//::			// shared code for status line
//::			if ( PRIArray[i].bIsServer )
//::			{
//::				Canvas.DrawText(IsServerText,true);
//::			}
//::			else
//::			if ( PRIArray[i].bReadyToPlay )
//::			{
//::				Canvas.DrawText(ReadyText,true);
//::			}
//::			else
//::			{
//::				Canvas.DrawText(NotReadyText,true);
//::			}
//::		}
//::		return;
//::	}
//::
//::	// draw time and ping
//::	if ( Canvas.ClipX < 512 )
//::	{
//::		PingText = "";
//::	}
//::	else
//::	{
//::		PingText = Default.PingText;
//::	}
//::	for ( i=0; i<PlayerCount; i++ )
//::	{
//::		if ( !PRIArray[i].bAdmin && !PRIArray[i].bOutOfLives )
//:: 		{
//::			if ( bHaveHalfFont )
//::			{
//::				Canvas.SetPos(mNetInfoXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY - YL);
//::				Canvas.DrawText(PingText@Min(999,PRIArray[i].Ping),true);
//::				Canvas.SetPos(mNetInfoXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY);
//::				Canvas.DrawText(FormatTime(Max(0,GRI.ElapsedTime - PRIArray[i].StartTime)),true);
//::			}
//::			else
//::			{
//::				Canvas.SetPos(mNetInfoXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY - 0.5*YL);
//::				Canvas.DrawText(PingText@Min(999,PRIArray[i].Ping),true);
//::			}
//::		}
//::	}
//::	if ( (OwnerOffset >= PlayerCount) && !PRIArray[OwnerOffset].bAdmin && !PRIArray[OwnerOffset].bOutOfLives )
//::	{
//::		if ( bHaveHalfFont )
//::		{
//::			Canvas.SetPos(mNetInfoXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY - YL);
//::			Canvas.DrawText(PingText@Min(999,PRIArray[OwnerOffset].Ping),true);
//::			Canvas.SetPos(mNetInfoXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY);
//::			Canvas.DrawText(FormatTime(Max(0,GRI.ElapsedTime - PRIArray[OwnerOffset].StartTime)),true);
//::		}
//::		else
//::		{
//::			Canvas.SetPos(mNetInfoXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY - 0.5*YL);
//::			Canvas.DrawText(PingText@Min(999,PRIArray[OwnerOffset].Ping),true);
//::		}
//::	}
//::}
	

simulated function String CalcKillsScoreData(
	PlayerReplicationInfo which)
{
	return which.ScoreKills@"";
}


//well this is for all multiplayer games apart from sabre squad 
simulated event UpdateScoreBoard(
	Canvas aCanvas )
{
	local int	i, 
				k,
				teamIdx,
				OwnerOffset,
				IncludingJoiningPlayerCount; // a list of players in the joining process shown too
	local float	EntryYPos;
	local PlayerReplicationInfo			PRI,
										OwnerPRI;
	local Array<PlayerReplicationInfo>	PRIList;

	if ( GRI == None )
	{
		return;
	}
	
	// Filter out bots, establish owner's line and sort teams
	OwnerPRI = PlayerController(Owner).PlayerReplicationInfo;
	k = 0;
	for ( teamIdx = 0; teamIdx < 2; teamIdx++ )
	{
		for ( i = 0; i < GRI.PRIArray.Length; i++ )
		{
			PRI = GRI.PRIArray[i];
			
			if (PRI == None || PRI.Team == None)
				continue;
				
			if ( PRI.Team.TeamIndex == teamIdx )
			{
				if ( !PRI.bBot )
				{
					if ( PRI == OwnerPRI )
					{
						OwnerOffset = k;
					}
					PRIList[k++] = PRI;
				}
			}
		}
	}

	IncludingJoiningPlayerCount = PRIList.Length;
	if ( Level.Game != None )
	{	
		IncludingJoiningPlayerCount += Level.Game.JoiningPlayers.Length;
	}

	// Do any scaling required to try to fit all players on screen.
	SetupScoreBoardLayoutData(
		aCanvas, 
		IncludingJoiningPlayerCount,
		OwnerOffset );

	// Draw background vignette.
	//DrawBackground( aCanvas );

	// Draw background boxes

	aCanvas.Style = ERenderStyle.STY_Alpha;
	aCanvas.DrawColor = WhiteColor;
	for ( i = 0; i < mDisplayedPlayerCount; i++ )
	{
		aCanvas.SetPos( mPlayerBoxXPos, mPlayerBoxOffsetY + (mPlayerBoxHeight + mPlayerBoxSpacing) * i );
		aCanvas.DrawTileStretched( BoxMaterial, mPlayerBoxWidth, mPlayerBoxHeight );
	}

	// Draw title.
	DrawTitle( aCanvas);

	// Set default font size.
	aCanvas.Font = mEntryFont;

	// Draw headers.
	DrawHeaders( aCanvas );

	// Draw the box text for each joined player.
	aCanvas.Style = ERenderStyle.STY_Normal;
	for ( i = 0; i < Min( PRIList.Length, mDisplayedPlayerCount ); i++ )
	{
		if ( PRIList[i] != None )
		{
			// Set the text Y pos for this line.
			EntryYPos = ((mPlayerBoxHeight + mPlayerBoxSpacing) * i) + mPlayerBoxTextOffsetY;
			
			// Draw it.
			DrawPlayerEntry( 
				aCanvas, 
				EntryYPos,
				PRIList[i],
				PRIList[i].Team.TeamIndex);
		}
	}
	
	// Draw the box text for each joining player.
	for ( i = PRIList.Length; i < mDisplayedPlayerCount; i++ )
	{
		// Set the text Y pos for this line.
		EntryYPos = ((mPlayerBoxHeight + mPlayerBoxSpacing) * i) + mPlayerBoxTextOffsetY;

		// Draw it.
		DrawJoiningPlayerEntry(
			aCanvas,
			EntryYPos,
			(i - PRIList.Length) );
	}	
}

simulated function DrawPlayerEntry(
	Canvas					aCanvas,
	float					aTextYPos,
	PlayerReplicationInfo	aEntryPRI,
	int						aTeam,
	optional float			aTeamDisplayAlpha )
{
	local String	columnText;
	local float		TextWidth,
					TextHeight;

	if ( aEntryPRI == None )
	{
		return;
	}

	// Clamp player name if it overruns.
	columnText = aEntryPRI.PlayerName;
	aCanvas.StrLen( columnText, TextWidth, TextHeight );
	if ( TextWidth > 0.9 * (mNetInfoXPos - mPlayerNameXPos) )
	{
		columnText = left(columnText, 0.9 * (mNetInfoXPos - mPlayerNameXPos) / TextWidth * len(columnText));
	}
	
	// Player name.
	aCanvas.DrawColor = PlayerController(Owner).myHUD.OrangeColour;
	aCanvas.SetPos( mPlayerNameXPos, aTextYPos );
	aCanvas.DrawText( columnText, true );

	DrawStatus( aCanvas, aTextYPos, aEntryPRI );
}


simulated function DrawStatus(
	Canvas					aCanvas,
	float					aTextYPos,
	PlayerReplicationInfo	aEntryPRI )	
{
	// Draw status: In game we draw dead/alive/spectating text, 
	// In game wait screnn draw ready or not ready.
	aCanvas.DrawColor = PlayerController(Owner).myHUD.OrangeColour;
	aCanvas.SetPos( mNetInfoXPos, aTextYPos );
	if ( GRI == None || !GRI.bMatchHasBegun )
	{
		if ( aEntryPRI.bIsServer )
		{
			aCanvas.DrawText( IsServerText, true );
		}
		else if ( aEntryPRI.bReadyToPlay )
		{
			aCanvas.DrawText( ReadyText, true );
		}
		else
		{
			aCanvas.DrawText( NotReadyText,true );
		}
	}
	else
	{
		// In game - draw alive, dead or spectating.
		if ( aEntryPRI.bLatecomer )
		{
			// Spectating
			aCanvas.DrawText( SpectatingText, true );
		}
		else if ( aEntryPRI.bOutOfLives )
		{
			// Dead
			aCanvas.DrawText( KilledText, true );
		}
		else
		{
			// Alive
			aCanvas.DrawText( AliveText, true );
		}
	}
}


function DrawJoiningPlayerEntry(
	Canvas	aCanvas,
	float	aTextYPos,
	int		aJoiningPlayerIdx )
{
	local String	columnText;
	local float		TextWidth,
					TextHeight;

	aCanvas.DrawColor = LightGreyColour;

	// Clamp player name if it overruns.
	columnText = Level.Game.JoiningPlayers[aJoiningPlayerIdx].Name;
	aCanvas.StrLen( columnText, TextWidth, TextHeight );
	if ( TextWidth > 0.9 * (mNetInfoXPos - mPlayerNameXPos) )
	{
		columnText = left(columnText, 0.9 * (mNetInfoXPos - mPlayerNameXPos) / TextWidth * len(columnText));
	}

	aCanvas.SetPos( mPlayerNameXPos, aTextYPos );
	aCanvas.DrawText( columnText, true );

	aCanvas.SetPos( mNetInfoXPos, aTextYPos );
	aCanvas.DrawText( PlayerJoiningText, true );
}


//-------------------------------------------------------------------------------------------------
// SetupScoreBoardLayoutData
// 
// Select best font size and box size to fit as many players as possible on screen.
simulated function SetupScoreBoardLayoutData(
	Canvas		aCanvas, 
	int			aPlayerCount,
	int			aOwnerOffset )
{
	local float	XL,
				YL,
				headFoot;
	local int	rowCount;

	// Cap number of players we try to display.
	mDisplayedPlayerCount = Min( aPlayerCount, MAX_PLAYERS );
	rowCount = mDisplayedPlayerCount+1;		// playercount+header row

	// Get title Y offset.
	aCanvas.Font = PlayerController(Owner).myHud.static.GetConsoleFont( aCanvas );
	aCanvas.StrLen("A", XL, YL );
	mTitleOffsetY = YL * 2.0;
	
	// Get title font size.
	if ( aCanvas.ClipY <= 600 )
	{
		if ( aCanvas.ClipX < 1024 )
		{
			mTitleFont = aCanvas.FontSmall12;
		}
		else
		{
			mTitleFont = aCanvas.SmallFont;
		}
	}
	else
	{
		mTitleFont = aCanvas.MedFont;
	}

	// Get column headers Y offset.
	aCanvas.Font = mTitleFont;
	aCanvas.StrLen("A", XL, YL );
	mHeaderOffsetY = mTitleOffsetY + (YL * 1.5);

	// Set default font size.
	if ( aCanvas.ClipX < 1024 )
	{
		aCanvas.Font = aCanvas.TinyFont;
	}
	else
	{
		aCanvas.Font = aCanvas.SmallFont;
	}

	// Get the font height.
	aCanvas.StrLen("A", XL, mFontHeight );
	
	// Set default box spacing and height from the font height.
	mPlayerBoxSpacing	= 0.25 * mFontHeight;
	mPlayerBoxHeight	= 1.5 * mFontHeight;

	headFoot = mHeaderOffsetY + (2 * mFontHeight);

	// Do all displayed players fit onto screen with this font size?
	if ( rowCount > ( aCanvas.ClipY - headFoot) / (mPlayerBoxHeight + mPlayerBoxSpacing) )
	{
		// Need to scale down.

		// Try reducing the box size and spacing without reducing the font.
		mPlayerBoxSpacing	= 0.125 * mFontHeight;
		mPlayerBoxHeight	= 1.25 * mFontHeight;
		if ( rowCount > ( aCanvas.ClipY - headFoot) / (mPlayerBoxHeight + mPlayerBoxSpacing) )
		{
			// Still can't fit everyone on screen, further reduce the box height but not the spacing 
			// and try again.
			mPlayerBoxHeight = 1.125 * mFontHeight;
			if ( rowCount > ( aCanvas.ClipY - headFoot) / (mPlayerBoxHeight + mPlayerBoxSpacing) )
			{
				// No good - going to have to select a smaller font.

				aCanvas.Font = aCanvas.TinyFont;
				aCanvas.StrLen( "A", XL, mFontHeight );

				// Adjust box spacing/height for new font size.
				mPlayerBoxSpacing	= 0.125 * mFontHeight;
				mPlayerBoxHeight	= 1.125 * mFontHeight;
				
				headFoot = mHeaderOffsetY + (2 * mFontHeight);

				// If still can't fit, need to clamp row count to whatever can fit.
				if ( rowCount > ( aCanvas.ClipY - headFoot) / (mPlayerBoxHeight + mPlayerBoxSpacing) )
				{
					rowCount = int( (aCanvas.ClipY - headFoot) / (mPlayerBoxHeight + mPlayerBoxSpacing) );
					mDisplayedPlayerCount = rowCount-1;
				}
			}
		}
	}

	// If owner player is off the end of the displayed list then reduce the displayed players by
	// one and we can then tack the owner on the end.
	if ( aOwnerOffset >= mDisplayedPlayerCount )
	{
		mDisplayedPlayerCount -= 1;
	}

	mPlayerBoxOffsetY = mHeaderOffsetY + (mPlayerBoxHeight + mPlayerBoxSpacing);
	mPlayerBoxTextOffsetY	= mPlayerBoxOffsetY + (0.5 * (mPlayerBoxHeight - mFontHeight));
			
	
	SetupScoreboardLayoutXDimensions( aCanvas );
	
	// Can messages fit on screen?
	//bDisplayMessages = (mDisplayedPlayerCount <= (aCanvas.ClipY - MessageFoot) / (mPlayerBoxHeight + mPlayerBoxSpacing));

	mEntryFont = aCanvas.Font;
}


simulated function SetupScoreboardLayoutXDimensions( Canvas aCanvas )
{
	mPlayerBoxWidth		= 0.5 * aCanvas.ClipX;
	mPlayerBoxXPos		= 0.5 * (aCanvas.ClipX - mPlayerBoxWidth);
	mPlayerBoxWidth		= aCanvas.ClipX - 2 * mPlayerBoxXPos;
	
	// Column X positions.
	mPlayerNameXPos		= mPlayerBoxXPos + 0.1 * mPlayerBoxWidth;
	mNetInfoXPos		= mPlayerBoxXPos + 0.7 * mPlayerBoxWidth;
}



// Decompiled with UE Explorer.
defaultproperties
{
    PlayerHeaderText="Player"
    TeamHeaderText="Team"
    DaggersHeaderText="Daggers"
    KillsHeaderText="Kills"
    TimeText="TIME:"
    PingText="PING:"
    PlayerJoiningText="JOINING..."
    AdminText="ADMIN"
    StatusText="Status"
    FooterText="Elapsed Time:"
    MatchIDText="SAS Stats Match ID"
    OutText="OUT"
    ReadyText="READY"
    NotReadyText="NOT READY"
    IsServerText="SERVER"
    SpectatingText="Spectating"
    KilledText="Killed"
    AliveText="Alive"
    SkillLevel[0]="NOVICE"
    SkillLevel[1]="AVERAGE"
    SkillLevel[2]="EXPERIENCED"
    SkillLevel[3]="SKILLED"
    SkillLevel[4]="ADEPT"
    SkillLevel[5]="MASTERFUL"
    SkillLevel[6]="INHUMAN"
    SkillLevel[7]="GODLIKE"
    YouveLostTheMatch="You've lost the match"
    YouveWonTheMatch="You've won the match"
    FragLimit="FRAG LIMIT:"
    FPH="FPH"
    GameType="GAME"
    MapName=" in "
    Continue=" Press [Fire] to continue!"
    Ended="The match has ended."
    TimeLimit="REMAINING TIME:"
    Spacer=" "
    WhiteColor=(R=255,G=255,B=255,A=255)
    LightGreyColour=(R=195,G=212,B=214,A=255)
    BoxMaterial=Texture'HUDTx.Elements.HUD_MPSS-Score'
    BackgroundTex=Texture'SFXTx.Explosion.FxEx_flash_vignetteBK'
    HudClass=Class'SASDMHUD'
}