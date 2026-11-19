class ZombieMessage extends LocalMessage
	native;

var font Font;
var float TextSize;
var float Kern;
//var BasicHud.ETextJustify Justify;
var Canvas.EJustifyHorz hJust;
var bool bHasMarkup;
var int xWrap;
var int xReset;
var bool UseBasePos;

static function float GetZLifetime(int switch, Object optionalObject)
{
	return default.Lifetime;
}

static event string GetStringPC(
	PlayerController pc,
	optional int SwitchVal,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	return "";
}


// Decompiled with UE Explorer.
defaultproperties
{
    Font=Font'CBT_DYN_Fonts.Verdana24CT'
    xWrap=592
    xReset=48
    bIsConsoleMessage=false
}