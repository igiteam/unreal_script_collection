class SkyVariableMaterial extends Object
    native;

struct native VarMatParameters
{
    var bool Active;
    var name ParameterName;
    var float StartTime;
    var float EndTime;
    var float StartValue;
    var float EndValue;
    var bool DisableStartValueClamp;
    var bool DisableEndValueClamp;

    structdefaultproperties
    {
        Active=false
        ParameterName="None"
        StartTime=0.0000000
        EndTime=0.0000000
        StartValue=0.0000000
        EndValue=0.0000000
        DisableStartValueClamp=false
        DisableEndValueClamp=false
    }
};

var float LocX;
var float LocY;
var float mWidth;
var float mHeight;
var bool bFullScreenSizeOverride;
var float StartTime;
var MaterialInstanceConstant MaterialInstance;
var() array<VarMatParameters> Params;
