class SimpleCrosshairRenderInfo extends Info
	native
	abstract;

static event DrawCrosshair(Canvas c, BasicHUD hud)
{
	local float scale;
	local float offset;
		
	scale = c.ScaleY;
	
	if (c.ScaleY != c.ScaleX)
	{
		offset = 320;
	}
	else
	{
		offset = 0;
	}

	//draw crosshairs
	InnerDrawCrosshair(c, hud, (c.LogSizeX/2)*scale, (c.LogSizeY/2)*scale, scale);
}

static function InnerDrawCrosshair(Canvas c, BasicHUD hud, float X, float Y, float scale);
