class SkySkelControl_CoverLimbPlacement extends SkySkelControl_LimbPlacement
    native;

struct native CoverLimbAxisAlignment
{
    var() bool Yaw;
    var() bool Pitch;
    var() bool Roll;

    structdefaultproperties
    {
        Yaw=true
        Pitch=true
        Roll=true
    }
};

var(CoverLimbPlacement) Vector AlignOffset;
var(CoverLimbPlacement) Object.EAxis AlignAxis;
var(CoverLimbPlacement) float AlignDistance;
var(CoverLimbPlacement) bool bFlipAlignAxis;
var(Debug) bool bShowDebug;
var(CoverLimbPlacement) CoverLimbAxisAlignment MatchAlignRotation;
