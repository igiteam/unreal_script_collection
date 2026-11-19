class TurokStealthZoom extends TurokCameraModifier
    native
    hidecategories(Object);

var bool mbBlendIn;
var float mZoomedFOVMod;

event bool IsZoomed()
{
    return mbBlendIn;
    //return ReturnValue;    
}

function ResetZoomLevel()
{
    mbBlendIn = false;
    TotalTimeAlive = 0.0000000;
    //return;    
}

simulated function ForceExitZoom()
{
    ResetZoomLevel();
    //return;    
}

simulated function SetZoomPcnt(float zoom_pcnt)
{
    TotalTimeAlive = FClamp(mLifeTime * zoom_pcnt, 0.0000000, mLifeTime);
    //return;    
}

// Export UTurokStealthZoom::execUpdateTime(FFrame&, void* const)
native function UpdateTime(float DeltaTime);

// Export UTurokStealthZoom::execModifyCamera(FFrame&, void* const)
native function bool ModifyCamera(@NULL Camera, float DeltaTime, out @NULL OutPOV);

defaultproperties
{
    mZoomedFOVMod=5.0000000
    mLifeTime=1.0000000
    mbDamper=false
    mbTranslationNoise=false
    mbRotationNoise=false
    mPlayMode=2
    // Reference: TurokSmoothNoise'Default__TurokStealthZoom.RotNoise'
    begin object name=RotNoise
    end object
    mRotationNoise=RotNoise
    // Reference: TurokSmoothNoise'Default__TurokStealthZoom.TranNoise'
    begin object name=TranNoise
    end object
    mTranslationNoise=TranNoise
}