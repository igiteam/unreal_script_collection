class LevelLoadHUD extends HUD
	native;

const MESSAGE_ON_TIME = 0.12;
const MESSAGE_OFF_TIME = 0.12;

var bool ForceLoadScreen;
var bool LoadDone;
var bool bMsgOn;

var float Offset;
var float TimeOfNextFlash;

var Texture WhiteSquareMat;
var Texture LoadScreen;
var Texture ProgressBar;

event InitHUD(optional String changeTo)
{
	ForceLoadScreen=true;
	LoadDone=false;
}

native simulated static event float DrawTextJustify(Canvas c, coerce string s, float x, float y, ETextJustify just, optional bool blur, optional int xWrap, optional int xReset, optional float LeftEdge, optional float RightEdge);

simulated function DrawMsgHighlight(Canvas c, float centerX, float centerY, float width, float height)
{
	c.Style = ERenderStyle.STY_Normal;
	DrawBox(c, centerX-width/2+height/2, centerY+1-height/2, width-height, height-2);
}

simulated event  DrawBox(Canvas c, float x, float y, float w, float h)
{
	c.SetPos(x*c.Scale, y*c.Scale);
	c.DrawTile(class'HUDIconMgr'.default.WhiteSquare, w*c.Scale, h*c.Scale, 0, 0, 1, 1);
}

simulated event DrawOpenBox(Canvas c, float x, float y, float w, float h,optional float lineThickness)
{
	local float tX, tY;

	if( lineThickness == 0 )
	{
		lineThickness = 2;
	}

	tX = lineThickness * c.Scale;
	tY = lineThickness * c.Scale;

	c.SetPos( x * c.Scale, y * c.Scale );
	c.DrawRect( class'HUDIconMgr'.default.WhiteSquare, tX, h * c.Scale );
	
	c.SetPos( x * c.Scale + tX, y * c.Scale );
	c.DrawRect( class'HUDIconMgr'.default.WhiteSquare, w * c.Scale - tX, tY );
	
	c.SetPos( (X + w) * c.Scale - tX, Y * c.Scale + tY );
	c.DrawRect( class'HUDIconMgr'.default.WhiteSquare, tX, h * c.Scale - tY );

	c.SetPos( X * c.Scale + tX, (Y + h) * c.Scale - tY );
	c.DrawRect( class'HUDIconMgr'.default.WhiteSquare, w * c.Scale - 2 * tX, tY );
}

simulated function HUDSetup(canvas canvas)
{
	Offset = 640.0f*(canvas.Scale/canvas.Scale);
}

event Tick( float delta )
{
	if( Fading )
	{
		FadeTime += delta;
	}
}

native function bool IsLoadingLevel();

simulated event PostRender( canvas Canvas )
{
	local float XPos,YPos;
	local Pawn P;
	local float alpha;
	local float VolumeScale;

	if( Canvas.Viewport.Actor.Level.DoneLoading )
	{
		// kkm: signal the engine that we're done loading... for reals this time
		Canvas.Viewport.Actor.Level.DoneLoading = false;
	}

	if( ForceLoadScreen )
	{
		HUDSetup(canvas);
		DrawLoadScreen(Canvas);
		return;
	}

	if ( !PlayerOwner.bBehindView )
	{
		P = Pawn(PlayerOwner.ViewTarget);
	}

	//DisplayMessages(Canvas);

	bHideCenterMessages = DrawLevelAction(Canvas);

	if ( !bHideCenterMessages && (PlayerOwner.ProgressTimeOut > Level.TimeSeconds) )
		DisplayProgressMessage(Canvas);

	if ( bBadConnectionAlert )
		DisplayBadConnectionAlert();

	if ( P != None && P.bSpecialHUD )
		P.DrawHud(Canvas);
    if ( bShowDebugInfo )
    {
        Canvas.Font = GetConsoleFont(Canvas);
        Canvas.Style = ERenderStyle.STY_Alpha;
        Canvas.DrawColor = ConsoleColor;

        PlayerOwner.ViewTarget.DisplayDebug (Canvas, XPos, YPos);
    }
	else if( !bHideHud )
    {
        if ( bShowScores )
        {
            if (ScoreBoard != None)
            {
                ScoreBoard.DrawScoreboard(Canvas);
				if ( Scoreboard.bDisplayMessages )
					DisplayMessages(Canvas);
			}
        }
        else
        {
            if ( (PlayerOwner == None) || (P == None) || (P.PlayerReplicationInfo == None) || PlayerOwner.IsSpectating() )
                DrawSpectatingHud(Canvas);
            else if( !P.bHideRegularHUD )
                DrawHud(Canvas);

            if ( !DrawLevelAction(Canvas) )
            {
                if ((PlayerOwner != None) && (PlayerOwner.ProgressTimeOut > Level.TimeSeconds))
                    DisplayProgressMessage(Canvas);
            }

            //DisplayMessages(Canvas);
        }
    }

    PlayerOwner.RenderOverlays (Canvas);

	if( Fading && !PlayerOwner.ShowingFMV )
	{
		if( ((UnFade && FadeTime >= FADE_IN_TIME) ||
			(!UnFade && FadeTime >= FADE_OUT_TIME)) &&
			!DoneFading )
		{
			DoneFading = true;
			
			// kkm--unpause here?

//			log( "CALLING FADEDONE DELEGATE" );	
			OnFadeDone();
		}
		
		if( UnFade )
		{
			alpha = 255 - 255 * ( FadeTime / FADE_IN_TIME );
//			log( "UNFADE:"$alpha );

			// the corresponding fade out is in the PlayerFrozen state of the PC for some reason
			VolumeScale = FClamp( FadeTime / FADE_IN_TIME,0.0f,1.0f);
			SetVolumeScale(VolumeScale);
		}
		else
		{
			alpha = 255 * ( FadeTime / FADE_OUT_TIME );
//			log( "FADE:"$alpha );
		}
		
		if( alpha < 0 ) alpha = 0;
		else if( alpha > 255 ) alpha = 255;

		if( alpha >= 1 )
		{
			Canvas.SetDrawColor( 0, 0, 0, alpha );
			Canvas.SetPos( 0, 0 );
			Canvas.DrawTile( class'HUDIconMgr'.default.WhiteSquare, Canvas.SizeX, Canvas.SizeY, 0, 0, 1, 1 );
		}
		
		if( DoneFading )
		{
			if( UnFade )
			{
				UnFade = false;
				Fading = false;
				DoneFading = false; // just in case we run into a teleporter or something
			}
			else
			{
				// don't need to unfade so pause the game while we wait for the level change
//				PlayerOwner.SetPause( true );
			}
		}
	}
}

simulated function DisplayProgressMessage(Canvas C)
{
}

function DrawLoadScreen(canvas C)
{
	DrawNormalLoadScreen(C);
}

function DrawNormalLoadScreen(canvas C)
{
	local float stretch, fudge, x, y, w, h, maxW;

	C.Style = ERenderStyle.STY_Normal;
	C.SetPos(0, 0);

	//draw black bkg
	if( LoadDone || LoadScreen == none )
	{
		C.SetDrawColor(0,0,0);
		C.DrawTile(WhiteSquareMat, C.ClipX, C.ClipY, 0, 0, 1, 1);
	}
	else
	{
		C.SetDrawColor(255,255,255);
		C.DrawTile(LoadScreen, C.ClipX, C.ClipY, 0, 0, LoadScreen.USize, LoadScreen.VSize);

		maxW = 512;
		stretch = maxW / ProgressBar.USize;
		fudge = FMin( Level.TimeSeconds * 0.85, 1.0 );
		x = (C.SafeFrame.Right - C.SafeFrame.Left - stretch * ProgressBar.USize) / 2;
		y = 320;
		w = stretch * ProgressBar.USize * fudge;
		h = ProgressBar.VSize;

		C.DrawTile2( ProgressBar, x, y, w, h, 0, 0, fudge, 1 );
		DrawOpenBox( C, x - 2, y - 2, maxW + 4, h + 4 );
	}

	class'ZombieFontDescriptor'.static.ResetFont(c);
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

// Decompiled with UE Explorer.
defaultproperties
{
    ForceLoadScreen=true
    WhiteSquareMat=Texture'Engine.WhiteSquareTexture'
    LoadScreen=Texture'CBT_DYN_Interface.Menu.Loading'
    ProgressBar=Texture'CBT_DYN_Interface.Menu.ProgressBar'
}