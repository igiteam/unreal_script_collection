class R6PlayerInput extends PlayerInput within PlayerController
    transient
    native
    config(Input);

var input float m_aFire;
var input float m_aTakeCover;
var input float m_aRun;
var float m_fCurYawVelocity;
var float m_fCurPitchVelocity;
var float m_fLastYaw;
var float m_fLastPitch;
var float m_fRealGamePadForward;
var float m_fRealGamePadStrafe;
var float m_fRealGamePadTurn;
var float m_fRealGamePadLookUp;
var float m_fRealGamePadFire;
var float m_fRealGamePadTakeCover;
var float m_fRun;
var float m_fPawnForward;
var float m_fPawnStrafe;
var bool m_bPushPawnLeft;
var bool m_bPushPawnRight;
var bool m_bPushPawnForward;
var bool m_bPushPawnBackward;
var bool m_bTakeCoverMoveInvert;
var bool m_bTakeCoverPushPeekUp;
var bool m_bTakeCoverPushPeekRight;
var bool m_bTakeCoverPushPeekLeft;

// Export UR6PlayerInput::execIsForwardAtFullTilt(FFrame&, void* const)
native final function bool IsForwardAtFullTilt();

// Export UR6PlayerInput::execIsStrafeAtFullTilt(FFrame&, void* const)
native final function bool IsStrafeAtFullTilt();

// Export UR6PlayerInput::execIsTurnAtFullTilt(FFrame&, void* const)
native final function bool IsTurnAtFullTilt();

// Export UR6PlayerInput::execIsLookUpAtFullTilt(FFrame&, void* const)
native final function bool IsLookUpAtFullTilt();

// Export UR6PlayerInput::execIsLeftAnalogStickFullyTilted(FFrame&, void* const)
native final function bool IsLeftAnalogStickFullyTilted();

// Export UR6PlayerInput::execIsRightAnalogStickFullyTilted(FFrame&, void* const)
native final function bool IsRightAnalogStickFullyTilted();

// Export UR6PlayerInput::execGetMoveVelocity(FFrame&, void* const)
native final function float GetMoveVelocity(float fMaxVelocity);

// Export UR6PlayerInput::execGetMoveAcceleration(FFrame&, void* const)
native final function Vector GetMoveAcceleration(Rotator rPawnRot, float fMaxAccel);

// Export UR6PlayerInput::execGetCameraDeltaRotation(FFrame&, void* const)
native final function Rotator GetCameraDeltaRotation(float fDeltaTime, float fYawVelModifier);

// Export UR6PlayerInput::execGetCameraDeltaRotationFixed(FFrame&, void* const)
native final function Rotator GetCameraDeltaRotationFixed(float fDeltaTime, int iMinPitch, int iMaxPitch, int iMinYaw, int iMaxYaw);

// Export UR6PlayerInput::execIsTakeCoverPushLeft(FFrame&, void* const)
native final function bool IsTakeCoverPushLeft();

// Export UR6PlayerInput::execIsTakeCoverPushRight(FFrame&, void* const)
native final function bool IsTakeCoverPushRight();

// Export UR6PlayerInput::execIsTakeCoverPushUp(FFrame&, void* const)
native final function bool IsTakeCoverPushUp();

// Export UR6PlayerInput::execGetTakeCoverMoveVelocity(FFrame&, void* const)
native final function float GetTakeCoverMoveVelocity(float fMaxVelocity);

// Export UR6PlayerInput::execGetTakeCoverMoveAcceleration(FFrame&, void* const)
native final function Vector GetTakeCoverMoveAcceleration(Vector vPawnDir, float fMaxAccel);

// Export UR6PlayerInput::execPlayerInput(FFrame&, void* const)
native function PlayerInput(float fDeltaTime);

defaultproperties
{
    m_bEnableUseGamePadOption=true
}