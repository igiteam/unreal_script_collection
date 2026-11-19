class SafeFrameInteraction extends Interaction
	;

function PostRender( Canvas c )
{
	c.SetDrawColor( 255, 0, 0, 128 );
	c.DrawTile2( c.WhiteSquare, 0, 0, c.LogSizeX, c.SafeFrame.Top, 0, 0, 1, 1 );
	c.DrawTile2( c.WhiteSquare, 0, c.SafeFrame.Top, c.SafeFrame.Left, c.LogSizeY - c.SafeFrame.Top, 0, 0, 1, 1 );
	c.DrawTile2( c.WhiteSquare, c.SafeFrame.Right, c.SafeFrame.Top, c.LogSizeX - c.SafeFrame.Right, c.LogSizeY - c.SafeFrame.Top, 0, 0, 1, 1 );
	c.DrawTile2( c.WhiteSquare, c.SafeFrame.Left, c.SafeFrame.Bottom, c.SafeFrame.Right - c.SafeFrame.Left, c.LogSizeY - c.SafeFrame.Bottom, 0, 0, 1, 1 );
}


// Decompiled with UE Explorer.
defaultproperties
{
    bActive=false
    bVisible=true
}