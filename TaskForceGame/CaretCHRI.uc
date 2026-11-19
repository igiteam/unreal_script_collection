class CaretCHRI extends SimpleCrosshairRenderInfo
	abstract;

static function InnerDrawCrosshair(Canvas c, BasicHUD hud, float X, float Y, float scale)
{
	c.SetPos(X+(10*scale),Y-(1*scale));
	c.DrawTile(class'HUDIconMgr'.default.WhiteSquare, -10*scale, 2*scale, 0, 0, 2, 2);
	
	c.SetPos(X-(1*scale),Y+(10*scale));
	c.DrawTile(class'HUDIconMgr'.default.WhiteSquare, 2*scale, -10*scale, 0, 0, 2, 2);
}
