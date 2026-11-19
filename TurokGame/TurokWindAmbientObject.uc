class TurokWindAmbientObject extends Object
    native
    editinlinenew;

struct native AmbientWindSettings
{
    var() @NULL Direction;
    var() int numWindGusts;
    var() float windGridWidth;
    var() float windGridHeight;
    var() float forceMax;
    var() float forceMin;
    var() float gustSpeedMax;
    var() float gustSpeedMin;
    var() float gustOverlapMax;
    var() float gustOverlapMin;

    structdefaultproperties
    {
        Direction=(X=0.0000000,Y=1.0000000,Z=0.0000000)
        numWindGusts=10
        windGridWidth=1000.0000000
        windGridHeight=1000.0000000
        forceMax=800.0000000
        forceMin=400.0000000
        gustSpeedMax=400.0000000
        gustSpeedMin=200.0000000
        gustOverlapMax=100.0000000
        gustOverlapMin=0.0000000
    }
};

struct native AmbientWindGust
{
    var @NULL Point;
    var float Strength;
    var float GustSize;
    var float Speed;

    structdefaultproperties
    {
        Point=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Strength=0.0000000
        GustSize=0.0000000
        Speed=0.0000000
    }
};

var() private @NULL mSettings;
var private array mWindPoints;

defaultproperties
{
    mSettings=(Direction=(X=0.0000000,Y=1.0000000,Z=0.0000000),numWindGusts=10,windGridWidth=1000.0000000,windGridHeight=1000.0000000,forceMax=800.0000000,forceMin=400.0000000,gustSpeedMax=400.0000000,gustSpeedMin=200.0000000,gustOverlapMax=100.0000000,gustOverlapMin=0.0000000)
}