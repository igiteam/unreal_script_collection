class ZombieFontDescriptor extends object
	native
	abstract;



var font Normal;
//var font Normal2;
var font Big;
var float KernAdjust;

static event ResetFont(Canvas c)
{
	c.TextHeight = 0;
	c.TextWidth = 0;
	//c.TextKern = 0;	
	c.SpaceX = 0;
}

static event SetHUDFont(Canvas c, float size)
{
	c.Font = default.big;
	c.TextHeight = size;
	c.TextWidth = 0;
}

static function SetRadarFont(Canvas c, float size)
{
	c.Font = default.normal;
	c.TextHeight = size;
	c.TextWidth = size*0.8;
	c.SpaceX = size/default.KernAdjust;
}

static function SetMenuHeaderFont(Canvas c, float size, bool selected, optional float kern)
{
	c.Font = default.big;
	c.TextHeight = size;
	c.TextWidth = size*0.8;

	if (kern == 0)
	{
		//c.TextKern = size/default.KernAdjust;
	}
	else
	{
		c.SpaceX = kern;
	}
}

static function SetMenuFont(Canvas c, float size, bool selected, optional float kern)
{
	c.Font = default.big;
	c.TextHeight = size;
	c.TextWidth = size*0.8;
	if (kern == 0)
	{
		//c.TextKern = size/default.KernAdjust;
	}
	else
	{
		c.SpaceX = kern;
	}
}

static function SetTTFont(Canvas c, float size)
{
	c.Font = default.normal;
	c.TextHeight = size;
	c.TextWidth = size;
	c.SpaceX = size/default.KernAdjust;
}

static function SetSubtitleFont(Canvas c, float size)
{
	c.Font = default.normal;
	c.TextHeight = size;
	c.TextWidth = size;
	c.SpaceX = size/default.KernAdjust;
}

static function SetMessageFont(Canvas c, float size)
{
	c.Font = default.normal;
	c.TextHeight = size;
	c.TextWidth = size;
	c.SpaceX = size/default.KernAdjust;
}

static function SetScopeFont(Canvas c, float size)
{
	c.Font = default.normal;
	c.TextHeight = size;
	c.TextWidth = size;
	c.SpaceX = size/default.KernAdjust;
}

static function SetNormalFont(Canvas c)
{
	c.Font = default.normal;
}


// Decompiled with UE Explorer.
defaultproperties
{
    Normal=Font'CBT_DYN_Fonts.Verdana24CT'
    Big=Font'CBT_DYN_Fonts.Verdana24CT'
    KernAdjust=10.0000000
}