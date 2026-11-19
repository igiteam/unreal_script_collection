class DotCHRI extends SimpleCrosshairRenderInfo
	abstract;

static function InnerDrawCrosshair(Canvas c, BasicHUD hud, float X, float Y, float scale)
{
	c.SetPos(X-(2*scale),Y-(2*scale));
	c.DrawTile(class'HUDIconMgr'.default.WhiteSquare, 4*scale, 4*scale, 0, 0, 2, 2);
}
