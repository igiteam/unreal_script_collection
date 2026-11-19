class VIPScoreboard extends ZombieScoreboard
	;

const SCORE_HEIGHT = 28;
const WINNER_HEIGHT = 40;

function int GetTeamWinner( int winReason )
{
	switch( WinReason )
	{
	case 0:
	case 2:
	case 6:
	case 7:
	case 8: // TODO: Nobody should win if VIP leaves
	case 10:
	case 11:
		return 1;
	case 1:
	case 9:
		return 0;
	default:
		log( "UH OH! SF WINS BY DEFAULT!" @ winReason );
		return 0;
	}
}

function string FormatRoundResult( int winReason, string playerName )
{
	local string format;
	local array<string> args;

	args[0] = playerName;

	switch( WinReason )
	{
	case 0:
		format = class'Strings'.default.TimeUp;
		break;
	case 1:
	case 2:
		format = class'Strings'.default.TeamWin;
		break;
	case 6:
		format = class'Strings'.default.KilledVIP;
		break;
	case 7:
		format = class'Strings'.default.TeamKilledVIP;
		break;
	case 8:
		format = class'Strings'.default.VIPLeft;
		break;
	case 9:
		format = class'Strings'.default.VIPEscaped;
		break;
	case 10:
		format = class'Strings'.default.VIPCommittedSuicide;
		break;
	case 11:
		format = class'Strings'.default.VIPDied;
		break;
	default:
		log( "UH OH!" );
		break;
	}

	return self.Format( format, args );
}

simulated event UpdateScoreBoard( Canvas c )
{
	local int i;
	local float x, y, xl, yl, tmp;
	local string format, formatted, winText;
	local array<string> args;
	local PlayerController PC;

	PC = PlayerController(Owner);

	c.Style = ERenderStyle.STY_Normal;
	c.Font = HUDClass.static.GetMediumFontFor( c );
	c.SetDropShadow( true );
	c.TextWidth = 0;
	c.ForceAlpha = 1;

	// determine how many players we can cram onto half the screen
	x  = c.SafeFrame.Left;
	xl = c.SafeFrame.Right - c.SafeFrame.Left;
	y  = c.SafeFrame.Top;
	yl = (c.SafeFrame.Bottom - c.SafeFrame.Top) / 2;

	// draw the win text
	if( PC.IsInState('RoundEnded') || GRI.bGameEnded )
	{
		format = class'Strings'.default.TeamWin;
		args[0] = GRI.Teams[GetTeamWinner(GRI.WinReason)].TeamName;
		if( Len(args[0]) == 0 )
			args[0] = Winner;
		else
			Winner = args[0];
		winText = self.Format( format, args );

		c.TextHeight = WINNER_HEIGHT;
		c.SetDrawColor( 0xff, 0xd7, 0x00 ); // Gold
		c.DrawText2( winText, x, y, xl, , JH_CENTER, , true );
		y += 2*c.TextHeight;

		if( !GRI.bGameEnded )
		{
			args[0] = string(GRI.VIPRoundNum);
			args[1] = string(GRI.CountDown);
			winText = self.Format( class'Strings'.default.VIPRoundStart, args );

			c.SetDrawColor( 255, 255, 255 );
			c.DrawText2( winText, x, y, xl, c.SafeFrame.Bottom-y, JH_CENTER, JV_BOTTOM, true );
		}
	}
	else if( Len(Winner) > 0 )
	{
		Winner = "";
	}

	c.TextHeight = SCORE_HEIGHT;
	c.SetDrawColor( 255,255,255 );

	if( PC.IsInState('RoundEnded') || GRI.bGameEnded )
	{
		for( i = 0; i < GRI.RoundsPlayed; ++i )
		{
			/*
			if( !GRI.bGameEnded && i == GRI.RoundsPlayed-1 ) // just make another local var you lazy sob
				break;
			*/

			c.DrawColor = GRI.Teams[GetTeamWinner( GRI.RoundResults[i] )].TeamColor;

			// TODO: clean this up too
			c.DrawText2( string(i+1) $ ": ", x, y, 4*c.TextHeight, c.TextHeight, JH_RIGHT );
			formatted = FormatRoundResult( GRI.RoundResults[i], GRI.RoundWinners[i] );
			c.DrawText2( formatted, x + 4*c.TextHeight, y, xl - x - 4*c.TextHeight, 2*c.TextHeight, JH_LEFT, , true );
			tmp = c.TextHeight;//c.CalcTextHeight( formatted, xl - x - 4*c.TextHeight );
			y += tmp;

			if( y+tmp > c.SafeFrame.Bottom )
				break;
		}

		if( GRI.bGameEnded )
		{
			DrawEndGame( c, xl, yl );
		}
	}
	else
	{
		super.UpdateScoreboard( c );
	}
}

