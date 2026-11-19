class TurokParticleModuleTypeDataLight extends ParticleModuleTypeDataBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

struct native EditorSettings
{
    var() @NULL Colour;
    var() float Brightness;
    var() float Radius;

    structdefaultproperties
    {
        Colour=(R=0,G=0,B=0,A=0)
        Brightness=0.0000000
        Radius=0.0000000
    }
};

struct native ShadowSettings
{
    var() bool CastShadows;
    var() bool CastDynamicShadows;
    var() bool CastStaticShadows;
    var() float ShadowFalloffExponent;

    structdefaultproperties
    {
        CastShadows=false
        CastDynamicShadows=false
        CastStaticShadows=false
        ShadowFalloffExponent=0.0000000
    }
};

var() const @NULL Editor;
var() const @NULL Shadows;
var() float FalloffExponent;

defaultproperties
{
    Editor=(Colour=(R=255,G=255,B=255,A=0),Brightness=1.0000000,Radius=250.0000000)
    Shadows=(CastShadows=false,CastDynamicShadows=false,CastStaticShadows=false,ShadowFalloffExponent=1.0000000)
    FalloffExponent=2.0000000
}