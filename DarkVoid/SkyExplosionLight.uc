class SkyExplosionLight extends PointLightComponent
    native
    editinlinenew
    collapsecategories;

struct native LightValues
{
    var() float StartTime;
    var() float Radius;
    var() float Brightness;
    var() Color LightColor;

    structdefaultproperties
    {
        StartTime=0.0000000
        Radius=0.0000000
        Brightness=0.0000000
        LightColor=(R=0,G=0,B=0,A=0)
    }
};

var bool bCheckFrameRate;
var() bool bLoop;
var float HighDetailFrameTime;
var float Lifetime;
var int TimeShiftIndex;
var() array<LightValues> TimeShift;

// Export USkyExplosionLight::execResetLight(FFrame&, void* const)
native function ResetLight();
