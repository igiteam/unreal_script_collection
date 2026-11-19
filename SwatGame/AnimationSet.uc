///////////////////////////////////////////////////////////////////////////////
//
// Contains the animation name data for a pawn or animation set.
//

class AnimationSet extends Core.Object
    native
    perobjectconfig
    config(SwatPawnAnimationSets);

///////////////////////////////////////////////////////////////////////////////

var config name  AnimIdle;

var config name  AnimTurnLeft;
var config name  AnimTurnRight;

var config name  AnimMoveForward;
var config name  AnimMoveBackward;
var config name  AnimMoveLeft;
var config name  AnimMoveRight;

var config name  AnimAimCenter;
var config name  AnimAimLeft;
var config name  AnimAimRight;
var config name  AnimAimHigh;
var config name  AnimAimLow;

var config name  AnimLeanLeft;
var config name  AnimLeanRight;
var config name  AnimUnleanLeft;
var config name  AnimUnleanRight;

var config name  AnimCrouchedLeanLeft;
var config name  AnimCrouchedLeanRight;
var config name  AnimCrouchedUnleanLeft;
var config name  AnimCrouchedUnleanRight;

var config name  AnimLeanLeftAimCenter;
var config name  AnimLeanLeftAimLeft;
var config name  AnimLeanLeftAimRight;
var config name  AnimLeanLeftAimHigh;
var config name  AnimLeanLeftAimLow;

var config name  AnimLeanRightAimCenter;
var config name  AnimLeanRightAimLeft;
var config name  AnimLeanRightAimRight;
var config name  AnimLeanRightAimHigh;
var config name  AnimLeanRightAimLow;

var config name  AnimMouthOpen;

var config float AnimSpeedForward;
var config float AnimSpeedBackward;
var config float AnimSpeedSidestep;

///////////////////////////////////////////////////////////////////////////////

#if !IG_THIS_IS_SHIPPING_VERSION
// This should only be used for debugging
simulated function bool IsSetNull()
{
    return
       (AnimIdle                == ''
     && AnimTurnLeft            == ''
     && AnimTurnRight           == ''
     && AnimMoveForward         == ''
     && AnimMoveBackward        == ''
     && AnimMoveLeft            == ''
     && AnimMoveRight           == ''
     && AnimAimCenter           == ''
     && AnimAimLeft             == ''
     && AnimAimRight            == ''
     && AnimAimHigh             == ''
     && AnimAimLow              == ''
     && AnimLeanLeft            == ''
     && AnimLeanRight           == ''
     && AnimUnleanLeft          == ''
     && AnimUnleanRight         == ''
     && AnimCrouchedLeanLeft    == ''
     && AnimCrouchedLeanRight   == ''
     && AnimCrouchedUnleanLeft  == ''
     && AnimCrouchedUnleanRight == ''
     && AnimLeanLeftAimCenter   == ''
     && AnimLeanLeftAimLeft     == ''
     && AnimLeanLeftAimRight    == ''
     && AnimLeanLeftAimHigh     == ''
     && AnimLeanLeftAimLow      == ''
     && AnimLeanRightAimCenter  == ''
     && AnimLeanRightAimLeft    == ''
     && AnimLeanRightAimRight   == ''
     && AnimLeanRightAimHigh    == ''
     && AnimLeanRightAimLow     == ''
     && AnimMouthOpen           == ''
     && AnimSpeedForward        == 0.0
     && AnimSpeedBackward       == 0.0
     && AnimSpeedSidestep       == 0.0);
}
#endif

///////////////////////////////////////////////////////////////////////////////

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

///////////////////////////////////////////////////////////////////////////////
