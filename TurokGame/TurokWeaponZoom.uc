class TurokWeaponZoom extends TurokCameraModifier
    native
    hidecategories(Object);

var bool mbBlendIn;
var bool mbDisableSlideZoom;
var bool mbInToggledZoomState;
var export editinline @NULL Owner;
var export editinline @NULL mDefaults;
var int mCurToggle;
var float mLerpedTotalTimeAlive;
var() float mLerpVelocity;

// Export UTurokWeaponZoom::execIsZoomed(FFrame&, void* const)
native function bool IsZoomed();

// Export UTurokWeaponZoom::execToggleZoom(FFrame&, void* const)
native function ToggleZoom();

function ResetZoomLevel()
{
    mbBlendIn = false;
    mCurToggle = 0;
    TotalTimeAlive = 0.0000000;
    mLerpedTotalTimeAlive = 0.0000000;
    //return;    
}

function EnableSlideZoom(bool mbEnable)
{
    mbDisableSlideZoom = !mbEnable;
    //return;    
}

function EnableToggleZoom(bool mbEnable)
{
    mbInToggledZoomState = mbEnable;
    //return;    
}

simulated function ForceExitZoom()
{
    mbBlendIn = false;
    // End:0x26
    if(mbInToggledZoomState || mbDisableSlideZoom)
    {
        ResetZoomLevel();
    }
    mbInToggledZoomState = false;
    mbDisableSlideZoom = false;
    //return;    
}

// Export UTurokWeaponZoom::execComputeNewRotation(FFrame&, void* const)
native function ComputeNewRotation(out @NULL RotationDelta);

// Export UTurokWeaponZoom::execComputeNewTranslation(FFrame&, void* const)
native function ComputeNewTranslation(out @NULL TranslationDelta);

// Export UTurokWeaponZoom::execPercentageComplete(FFrame&, void* const)
native function float PercentageComplete();

// Export UTurokWeaponZoom::execUpdateLerpedTime(FFrame&, void* const)
native function UpdateLerpedTime(float DeltaTime);

// Export UTurokWeaponZoom::execUpdateTime(FFrame&, void* const)
native function UpdateTime(float DeltaTime);

// Export UTurokWeaponZoom::execModifyAccuracy(FFrame&, void* const)
native function float ModifyAccuracy(float Accuracy);

simulated event float GetMovementPenalty()
{
    // End:0x34
    if(mbBlendIn || mbInToggledZoomState)
    {
        return Lerp(1.0000000, Owner.mSpeedDemerit, PercentageComplete());
    }
    return 1.0000000;
    //return ReturnValue;    
}

// Export UTurokWeaponZoom::execUpdatePOVOffset(FFrame&, void* const)
native function @NULL UpdatePOVOffset(@NULL inOffset);

event UpdateInput(out float aTurn, out float aLookUp)
{
    // End:0x57
    if(Owner != none)
    {
        aTurn *= Lerp(1.0000000, Owner.mLookSpeedDemerit, PercentageComplete());
        aLookUp *= Lerp(1.0000000, Owner.mLookSpeedDemerit, PercentageComplete());
    }
    //return;    
}

// Export UTurokWeaponZoom::execModifyCamera(FFrame&, void* const)
native function bool ModifyCamera(@NULL Camera, float DeltaTime, out @NULL OutPOV);

function Init()
{
    super.Init();
    Owner = mDefaults;
    //return;    
}

defaultproperties
{
    // Reference: TurokZoomComponent'Default__TurokWeaponZoom.Zoom'
    begin object name=Zoom class=Class'TurokZoomComponent'
    end object
    mDefaults=Zoom
    mLerpVelocity=0.8000000
    mLifeTime=0.2500000
    mbDamper=false
    mbTranslationNoise=false
    mbRotationNoise=false
    mPlayMode=2
    // Reference: TurokSmoothNoise'Default__TurokWeaponZoom.RotNoise'
    begin object name=RotNoise
    end object
    mRotationNoise=RotNoise
    // Reference: TurokSmoothNoise'Default__TurokWeaponZoom.TranNoise'
    begin object name=TranNoise
    end object
    mTranslationNoise=TranNoise
}