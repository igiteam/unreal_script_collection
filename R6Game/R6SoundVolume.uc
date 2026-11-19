class R6SoundVolume extends Volume
    native
    hidecategories(lighting,Movement,Display);

var(R6Sound) /*0x04000000-0x00000000*/ export editinline R6SoundZoneInfo m_SoundZoneInfo;

defaultproperties
{
    BrushColor=(R=0,G=255,B=0,A=255)
    bColored=true
    bStatic=false
    TickGroup=1
    // Reference: R6VolumetricSound'Default__R6SoundVolume.VolumetricSound'
    begin object name="VolumetricSound" class=Class'Engine.R6VolumetricSound'
    end object
    m_R6Sound=VolumetricSound
}