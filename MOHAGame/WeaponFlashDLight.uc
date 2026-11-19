class WeaponFlashDLight extends PointLightComponent
    editinlinenew
    collapsecategories
    hidecategories(Object);

var(Tuning_DynamicLight) float MuzzleFlashDLightLifeTime;
var(Tuning_DynamicLight) float MuzzleFlashDLightSize;
var(Tuning_DynamicLight) float MuzzleFlashDLightSizeVariability;

defaultproperties
{
    MuzzleFlashDLightLifeTime=0.0700000
    MuzzleFlashDLightSize=200.0000000
    MuzzleFlashDLightSizeVariability=0.3300000
    Radius=300.0000000
    FalloffExponent=4.2000000
    Brightness=5.0000000
    LightColor=(R=0,G=0,B=0,A=255)
    CastShadows=false
    CastStaticShadows=false
    CastDynamicShadows=false
}