class MPJoinInteraction extends Interaction
	native;

const MPJI_TEXT_HEIGHT = 40;

function PostRender( Canvas c )
{
	local HUDRenderInfo btn;
	local string text;
	local float x, y, iconW, iconH, xl, yl;

	c.SetDrawColor( 0,0,0 );
	c.DrawTile2( c.WhiteSquare, 0, 0, c.LogSizeX, c.LogSizeY, 0, 0, 1, 1 );

	c.SetDrawColor( 255,255,255 );

	btn = class'HUDIconMgr'.default.ris[66];
	text = " " $ class'Strings'.default.JoinGame;

	c.TextWidth = 0;
	c.TextHeight = MPJI_TEXT_HEIGHT;
	c.Font = class'ZombieFontDescriptor'.default.Normal;

	c.CalcTextExtents( text, xl, yl );
	xl += btn.W * (MPJI_TEXT_HEIGHT) / btn.H;

	x = c.SafeFrame.Left + (c.SafeFrame.Right - c.SafeFrame.Left - xl) / 2;
	y = c.SafeFrame.Top + (c.SafeFrame.Bottom - c.SafeFrame.Top - MPJI_TEXT_HEIGHT) / 2;

	iconW = btn.W * (MPJI_TEXT_HEIGHT) / btn.H;
	iconH = btn.H * (MPJI_TEXT_HEIGHT) / btn.H;

	c.DrawTile2(
		btn.mat,
		x,
		y,
		iconW,
		iconH,
		btn.U,
		btn.V,
		btn.UL,
		btn.VL );

	// TODO: This would be easier if we did it with ZML:
	// DrawText2( "<A> Join Game", 0, 0, ,, JH_CENTER, JV_CENTER );
	c.DrawText2( text, x+iconW, y );

	y += MPJI_TEXT_HEIGHT;
}

function bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
{
	// TODO: We don't handle START
	// it can cause this screen to be skipped on release of the button
	if( Action != IST_Release )
		return true;

	if( Key == IK_Joy1 || Key == IK_Enter )
	{
		ViewportOwner.bActive = true;
		Master.RemoveInteraction( self );
	}

	return true;
}

event Initialized()
{
	ViewportOwner.bActive = false;
}


// Decompiled with UE Explorer.
defaultproperties
{
    bVisible=true
}