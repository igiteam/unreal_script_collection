class TurokDebugCam extends TurokCameraModifier
    native
    hidecategories(Object);

var float mTurn;
var float mLookUp;
var float mForward;
var float mStrafe;
var @NULL OldRotation;
var @NULL OldLocation;
var bool mbInitRotationAndLocation;

// Export UTurokDebugCam::execModifyCamera(FFrame&, void* const)
native function bool ModifyCamera(@NULL Camera, float DeltaTime, out @NULL OutPOV);

function EnableModifier()
{
    super.EnableModifier();
    mbInitRotationAndLocation = true;
    //return;    
}

defaultproperties
{
    // Reference: TurokSmoothNoise'Default__TurokDebugCam.RotNoise'
    begin object name=RotNoise
    end object
    mRotationNoise=RotNoise
    // Reference: TurokSmoothNoise'Default__TurokDebugCam.TranNoise'
    begin object name=TranNoise
    end object
    mTranslationNoise=TranNoise
}