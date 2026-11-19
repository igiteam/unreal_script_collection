class MOHAPlayerCamera extends Camera
    hidecategories(Navigation);

var(Camera) editinline MOHACamMod_ScreenShake MOHACamMod_ScreenShake;

function PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    // End:0x25
    if(MOHACamMod_ScreenShake == none)
    {
        MOHACamMod_ScreenShake = new (Outer) Class'MOHACamMod_ScreenShake';
    }
    MOHACamMod_ScreenShake.Init();
    MOHACamMod_ScreenShake.AddCameraModifier(self);
    DOFSetup();
    //return;    
}

function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime)
{
    super.UpdateViewTarget(OutVT, DeltaTime);
    // End:0xE6
    if(((Controller(OutVT.Target) != none) && MOHAPlayerController(OutVT.Target) == none) && Controller(OutVT.Target).Pawn != none)
    {
        Controller(OutVT.Target).Pawn.CalcCamera(DeltaTime, OutVT.POV.Location, OutVT.POV.Rotation, OutVT.POV.FOV);
    }
    //return;    
}

function DOFSetup()
{
    WorldInfo.GameModified_DOF_FalloffExponent = 2.0000000;
    WorldInfo.GameModified_DOF_BlurKernelSize = 8.0000000;
    WorldInfo.GameModified_DOF_MaxNearBlurAmount = 0.7000000;
    WorldInfo.GameModified_DOF_MaxFarBlurAmount = 0.5000000;
    WorldInfo.GameModified_DOF_ModulateBlurColor.R = byte(255);
    WorldInfo.GameModified_DOF_ModulateBlurColor.G = byte(255);
    WorldInfo.GameModified_DOF_ModulateBlurColor.B = byte(255);
    WorldInfo.GameModified_DOF_ModulateBlurColor.A = byte(255);
    WorldInfo.GameModified_DOF_FocusInnerRadius = 1300.0000000;
    WorldInfo.GameModified_DOF_InterpolationDuration = 0.1000000;
    //return;    
}

defaultproperties
{
    DefaultFOV=80.0000000
}