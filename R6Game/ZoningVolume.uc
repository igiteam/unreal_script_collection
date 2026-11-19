class ZoningVolume extends Volume
    native
    notplaceable
    hidecategories(lighting,Object,Movement,Display);

var() ZoneInfo m_pUseOtherZone;
var() bool m_bUseVolumeZone;

defaultproperties
{
    BrushColor=(R=255,G=0,B=255,A=255)
    bColored=true
    SupportedEvents=none
}