class InterpTrackMove extends InterpTrack
    native
    collapsecategories
    hidecategories(Object);

enum EInterpTrackMoveFrame
{
    IMF_World,                      // 0
    IMF_RelativeToInitial,          // 1
    IMF_MAX                         // 2
};

enum EInterpTrackMoveRotMode
{
    IMR_Keyframed,                  // 0
    IMR_LookAtGroup,                // 1
    IMR_MAX                         // 2
};

var InterpCurveVector PosTrack;
var InterpCurveQuat RotTrack;
var InterpCurveVector EulerTrack;
var() name LookAtGroupName;
var() float LinCurveTension;
var() float AngCurveTension;
var() bool bUseQuatInterpolation;
var() bool bShowArrowAtKeys;
var() bool bDisableMovement;
var() bool bShowTranslationOnCurveEd;
var() bool bShowRotationOnCurveEd;
var() bool bHide3DTrack;
var() editconst InterpTrackMove.EInterpTrackMoveFrame MoveFrame;
var() InterpTrackMove.EInterpTrackMoveRotMode RotMode;

defaultproperties
{
    bShowTranslationOnCurveEd=true
    TrackInstClass=Class'InterpTrackInstMove'
    TrackTitle="Movement"
    bOnePerGroup=true
}