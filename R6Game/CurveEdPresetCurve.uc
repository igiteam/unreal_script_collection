class CurveEdPresetCurve extends Object
    native
    editinlinenew
    hidecategories(Object);

struct PresetGeneratedPoint
{
    var float KeyIn;
    var float KeyOut;
    var bool TangentsValid;
    var float TangentIn;
    var float TangentOut;
    var Object.EInterpCurveMode IntepMode;

    structdefaultproperties
    {
        KeyIn=0.0000000
        KeyOut=0.0000000
        TangentsValid=false
        TangentIn=0.0000000
        TangentOut=0.0000000
        IntepMode=0
    }
};

var() const localized string CurveName;
var array<PresetGeneratedPoint> Points;
