class ZombieScoreBoard extends ScoreBoard;

const SCORE_HEIGHT = 22;
const WINNER_HEIGHT = 40;
const KILLEDBY_HEIGHT = 32;
const ZSB_CONTINUE_HEIGHT = 28;
const HELPTEXT_HEIGHT = 18;
const HELPTEXT_ICON_SIZE = 20;
const XBLIVE_SCALE = 0.7;

var int PRIStart;

//Pulsing
var bool PulseUp;
var float TimeOfNextPulse;
var float PulseLength;
var string Winner;

function bool GameNeedsScore()
{
	if( GRI.GameClass ~= "ZombieGame.GTCTF" )
		return true;
	if( GRI.GameClass ~= "ZombieGame.GTKOH" )
		return true;
	if( GRI.GameClass ~= "ZombieGame.GTTeamKOH" )
		return true;

	return false;
}

function bool GameNeedsTeamScore()
{
	return GRI.bTeamGame && !(GRI.GameClass ~= "ZombieGame.GTTeamLastManStanding");
}

simulated event UpdateScoreBoard( Canvas c )
{
	local bool drawScore;
	local int i, t;
	local float tmp, x, y, xl, yl, glow;
	local float nameX, scoreX, killsX, deathsX;
	local float nameXL, scoreXL, killsXL, deathsXL;
	local string format, formatted;
	local array<string> args;
	local SFRMMultiplayer game;
	local SFRMPlayerController PC;

	PC = SFRMPlayerController(Owner);

	c.Style = ERenderStyle.STY_Normal;
	c.Font = HUDClass.static.GetMediumFontFor( c );
	c.SetDropShadow( true );
	c.DropShadowOffsetX = 0.1;
	c.DropShadowOffsetY = 0.1;
	c.TextWidth = 0;
	c.ForceAlpha = 1;

	// determine how many players we can cram onto half the screen
	x  = c.SafeFrame.Left;
	xl = c.SafeFrame.Right - c.SafeFrame.Left;
	y  = c.SafeFrame.Top;
	yl = (c.SafeFrame.Bottom - c.SafeFrame.Top) / 2;

	// draw title
	if( GRI.bGameEnded )
	{
		// draw the winner
		if( GRI.Winner == none )
		{
			format = "Draw";
		}
		else if( GRI.bTeamGame )
		{
			format = class'Strings'.default.TeamWin;
			args[0] = PlayerReplicationInfo(GRI.Winner).Team.TeamName;
			if( Len(args[0]) == 0 )
				args[0] = Winner;
			else
				Winner = args[0];
		}
		else
		{
			format = class'Strings'.default.PlayerWin;
			args[0] = PlayerReplicationInfo(GRI.Winner).PlayerName;
			if( Len(args[0]) == 0 )
				args[0] = Winner;
			else
				Winner = args[0];
		}
		c.TextHeight = WINNER_HEIGHT;
		c.SetDrawColor( 0xff, 0xd7, 0x00 ); // Gold
		formatted = self.Format(format,args);
		c.DrawText2( formatted, x, y, xl, , JH_CENTER );
		y += c.CalcTextHeight( formatted, xl );
	}
	else if( PC.IsDead() )
	{
		c.SetDrawColor( 255, 255, 255 );
		c.TextHeight = KILLEDBY_HEIGHT;
        formatted = MPHUD(PC.myHUD).KilledByString;
		c.DrawText2( formatted, x, y, xl, , JH_CENTER );
		y += c.CalcTextHeight( formatted, xl );

		if( PC.bAutoRespawn && !PC.PlayerReplicationInfo.bOutOfLives )
		{
			c.TextHeight = SCORE_HEIGHT;
			args[0] = string( Max( 0, int(PC.WaitDelay - PC.Level.TimeSeconds) ) );
			formatted = self.Format( "Respawning in %0...", args );
			c.DrawText2( formatted, x, y, xl, , JH_CENTER );
			y += c.CalcTextHeight( formatted, xl );
		}
	}

	// put enough space to fill 20 W's
	c.TextHeight = SCORE_HEIGHT;
	c.CalcTextExtents( "W", nameXL, tmp );
	nameXL   *= 20;
	c.CalcTextExtents( class'Strings'.default.Score @ "  ", scoreXL, tmp );
	c.CalcTextExtents( class'Strings'.default.Kills @ "  ", killsXL, tmp );
	c.CalcTextExtents( class'Strings'.default.Deaths @ "  ", deathsXL, tmp );

	nameX   = (c.SafeFrame.Right - (nameXL+scoreXL+killsXL+deathsXL))/2.0;
	scoreX  = x+nameXL;
	killsX  = scoreX+scoreXL;
	deathsX = killsX+killsXL;

	c.SetDrawColor( 255,255,255 );

	// for talking indicators
	if( IsXbox() )
	{
		nameX += c.TextHeight;
		nameXL -= c.TextHeight;
	}

	// draw team scores if this is a team game
	if( GameNeedsTeamScore() )
	{
		// draw the winning team on top
		i = int( GRI.Teams[1].Score > GRI.Teams[0].Score );

		args[0] = GRI.Teams[i].TeamName;
		args[1] = string(int(GRI.Teams[i].Score));
		if( GRI.GameClass ~= "ZombieGame.GTVIP" )
			args[2] = string(GRI.GoalScore/2+1);
		else
			args[2] = string(GRI.GoalScore);

		c.DrawColor = GRI.Teams[i].TeamColor;
		c.DrawText2( 
			self.Format( class'Strings'.default.TeamScore, args ),
			c.SafeFrame.Left, y, c.SafeFrame.Right - c.SafeFrame.Left, 0, JH_LEFT );
		y += c.TextHeight;

		i = int(i == 0);

		args[0] = GRI.Teams[i].TeamName;
		args[1] = string(int(GRI.Teams[i].Score));
		if( GRI.GameClass ~= "ZombieGame.GTVIP" )
			args[2] = string(GRI.GoalScore/2+1);
		else
			args[2] = string(GRI.GoalScore);

		c.DrawColor = GRI.Teams[i].TeamColor;
		c.DrawText2(
			self.Format( class'Strings'.default.TeamScore, args ),
			c.SafeFrame.Left, y, c.SafeFrame.Right - c.SafeFrame.Left, 0, JH_LEFT );
		y += c.TextHeight;
	}

	// draw header
	c.SetDrawColor( 255, 255, 255 );

	if( PRIStart < 0 )
		PRIStart = 0;
	else if( PRIStart > GRI.PRIArray.Length-1 )
		PRIStart = GRI.PRIArray.Length-1;

	// if this isn't the top of the list...
	if( PRIStart > 0 )
	{
		c.DrawText2( "...", nameX, y, nameXL, c.TextHeight, ,, true );
	}

	drawScore = GameNeedsScore();
	if( drawScore )
	{
		c.DrawText2( class'Strings'.default.Score,  scoreX,  y, scoreXL,  c.TextHeight, JH_RIGHT );
	}
	c.DrawText2( class'Strings'.default.Kills,  killsX,  y, killsXL,  c.TextHeight, JH_RIGHT );
	c.DrawText2( class'Strings'.default.Deaths, deathsX, y, deathsXL, c.TextHeight, JH_RIGHT );
	y += c.TextHeight;

	for( i = PRIStart; i < GRI.PRIArray.Length; ++i )
	{
		if( GRI.PRIArray[i] == none || !GRI.PRIArray[i].bReadyToPlay )
		{
			continue;
		}

		// if i only have room for one more and this isn't the last one...
		if( y+2*c.TextHeight > c.SafeFrame.Bottom - c.TextHeight && i < GRI.PRIArray.Length-1 )
		{
			c.SetDrawColor(255,255,255);
			c.DrawText2( "...", nameX, y, nameXL, c.TextHeight, ,, true );
			break;
		}

		if( GRI.bTeamGame ) c.DrawColor = GRI.PRIArray[i].Team.TeamColor;
		else                c.SetDrawColor( 255, 255, 255 );

		if( GRI.PRIArray[i].bOutOfLives || GRI.PRIArray[i].bIsSpectator )
		{
			c.DrawColor.A = 128;
		}

		if( GRI.PRIArray[i] == PC.PlayerReplicationInfo )
			glow = 0.5;
		else
			glow = 0.0;

		c.DrawText2( GRI.PRIArray[i].PlayerName, nameX, y, nameXL, c.TextHeight, ,, true, glow );

		// draw player score
		if( drawScore )
		{
			c.DrawText2( int(GRI.PRIArray[i].Score),  scoreX,  y, scoreXL,  c.TextHeight, JH_RIGHT );
		}
		c.DrawText2(    (GRI.PRIArray[i].Kills),  killsX,  y, killsXL,  c.TextHeight, JH_RIGHT );
		c.DrawText2( int(GRI.PRIArray[i].Deaths), deathsX, y, deathsXL, c.TextHeight, JH_RIGHT );

		// draw the "talking" icon
		if( PC.IsTalking( GRI.PRIArray[i] ) )
		{
			c.SetDrawColor( 255, 255, 255 );
			class'HUDIconMgr'.static.DrawImageHW( c, 14, x, y, c.TextHeight, c.TextHeight );
		}

		y += c.TextHeight;
	}

	// draw time remaining
	if( !GRI.bGameEnded )
	{
		if( Owner.Level.NetMode == NM_Client )
		{
			// client
			t = GRI.RemainingTime;
		}
		else
		{
			// server
			game = SFRMMultiPlayer( Owner.Level.Game );
			t = game.GameLength - game.CurGameLength;
		}

		c.SetDrawColor( 255, 255, 255 );
		c.DrawText2( 
			FormatTime(t),
			c.SafeFrame.Left, c.SafeFrame.Top,
			c.SafeFrame.Right-c.SafeFrame.Left, c.SafeFrame.Bottom-c.SafeFrame.Top-c.TextHeight,
			JH_CENTER, JV_BOTTOM, true
		);
	}
	else //if the game is over
	{
		DrawEndGame( c, xl, yl );
	}

	// draw scroll help
	c.SetDrawColor( 255, 255, 255 );
	c.TextHeight = HELPTEXT_HEIGHT;

	// poach format and formatted for use a temporaries
	format = PC.ConsoleCommand( "BINDINGTOKEY ShowScoreMessages" );
	format = PC.ConsoleCommand( "KEYNUMBER" @ format );
	format = PC.ConsoleCommand( "LOCALIZEDKEYNAME" @ format );
	c.DrawText2( 
		format $ ": Show/Hide Messages",
		c.SafeFrame.Left, c.SafeFrame.Top,
		c.SafeFrame.Right-c.SafeFrame.Left, c.SafeFrame.Bottom-c.SafeFrame.Top-c.TextHeight,
		JH_LEFT, JV_BOTTOM, true
	);

	format = PC.ConsoleCommand( "BINDINGTOKEY ScrollScoresUp" );
	format = PC.ConsoleCommand( "KEYNUMBER" @ format );
	format = PC.ConsoleCommand( "LOCALIZEDKEYNAME" @ format );
	formatted = PC.ConsoleCommand( "BINDINGTOKEY ScrollScoresDown" );
	formatted = PC.ConsoleCommand( "KEYNUMBER" @ formatted );
	formatted = PC.ConsoleCommand( "LOCALIZEDKEYNAME" @ formatted );
	c.DrawText2( 
		format $ "/" $ formatted $ ": Scroll",
		c.SafeFrame.Left, c.SafeFrame.Top,
		c.SafeFrame.Right-c.SafeFrame.Left, c.SafeFrame.Bottom-c.SafeFrame.Top-c.TextHeight,
		JH_RIGHT, JV_BOTTOM, true
	);
}

function DrawEndGame( Canvas c, float xl, float yl )
{
	local float x, y, PulsePct;
	local string format;

	if(Owner.Level.NetMode != NM_Client)
	{
		//Calculate Pulse.
		if(Level.TimeSeconds >= TimeOfNextPulse)
		{
			PulseUp = !PulseUp;
			TimeOfNextPulse = Level.TimeSeconds + PulseLength;
		}

		PulsePct =  (TimeOfNextPulse - Level.TimeSeconds) / PulseLength;

		if(PulseUp)
		{
			PulsePct = 1.0f - PulsePct;
		}

		PulsePct = FClamp(PulsePct,0.1f,1.0f);

		c.SetDrawColor( 255,255,255, 255*PulsePct);

		format = class'Strings'.default.PressEsc;

		c.TextWidth = 0;
		c.TextHeight = ZSB_CONTINUE_HEIGHT;
		c.Font = class'ZombieFontDescriptor'.default.Normal;

		c.CalcTextExtents( format, xl, yl );

		x = c.SafeFrame.Left + (c.SafeFrame.Right - c.SafeFrame.Left - xl) / 2;
		y = c.SafeFrame.Top + (c.SafeFrame.Bottom - c.SafeFrame.Top - ZSB_CONTINUE_HEIGHT) / 2;

		c.DrawText2( format, x, y );

		y += ZSB_CONTINUE_HEIGHT;
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    PulseUp=true
    PulseLength=2.0000000
    HudClass=Class'MPHUD'
}