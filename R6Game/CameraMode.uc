class CameraMode extends Object
    native;

// Export UCameraMode::execProcessViewRotation(FFrame&, void* const)
native simulated function ProcessViewRotation(float fDeltaTime, Actor ViewTarget, out Rotator rViewRotation, out Rotator rDeltaRot);
