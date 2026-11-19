class TurokPlayerCamera extends Camera
    native
    hidecategories(Navigation);

struct native TurokCameraParameters
{
    var @NULL RelatedActor;
    var @NULL RelatedActor2;
    var @NULL RelatedController;
    var float blendTime;
    var float DelayTime;
    var @NULL Position;
    var bool CancelAnimatedCamUpdateCtrl;

    structdefaultproperties
    {
        RelatedActor=none
        RelatedActor2=none
        RelatedController=none
        blendTime=0.0000000
        DelayTime=0.0000000
        Position=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        CancelAnimatedCamUpdateCtrl=false
    }
};

var @NULL mCinematicVT;
var @NULL mOutVT;
var @NULL mCameraAnimated;
var @NULL mCameraRoot;
var @NULL mCameraBow;
var @NULL mCameraCinematic;
var @NULL mCameraDeath;
var @NULL mCameraDeathLookEnemy;
var @NULL mCameraDebug;
var @NULL mCameraDriver;
var @NULL mCameraFirstPerson;
var @NULL mCameraFixed;
var @NULL mCameraFree;
var @NULL mCameraPassenger;
var @NULL mCameraSpectator;
var @NULL mCameraThirdPerson;
var @NULL mCameraTurretVehicle;
var @NULL mCameraManual;
var @NULL mCameraMPViewpoint;
var @NULL mMovementShake;
var @NULL mShakeModifier;
var @NULL mParameters;
var bool mCameraCollisionTest;
var bool mUsingFirstPersonCamera;

// Export UTurokPlayerCamera::execPlayTransitionGraph(FFrame&, void* const)
native function PlayTransitionGraph(@NULL graph, @NULL attachTo, @NULL camAttachment, @NULL aiInterface);

// Export UTurokPlayerCamera::execAddCamera(FFrame&, void* const)
native function AddCamera(name camstyle, float blendintimeOld);

// Export UTurokPlayerCamera::execUpdateViewTarget(FFrame&, void* const)
native simulated function UpdateViewTarget(out @NULL OutVT, float DeltaTime);

// Export UTurokPlayerCamera::execDoCameraCollisionTrace(FFrame&, void* const)
native function DoCameraCollisionTrace(out @NULL OutVT);

// Export UTurokPlayerCamera::execApplyCameraModifiers(FFrame&, void* const)
native function ApplyCameraModifiers(float DeltaTime, out @NULL OutPOV);

simulated function PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    mCameraRoot = new Class'TurokCameraBlender';
    mCameraBow = new Class'TurokCameraBow';
    mCameraCinematic = new Class'TurokCameraCinematic';
    mCameraDeath = new Class'TurokCameraDeath';
    mCameraDebug = new Class'TurokCameraDebug';
    mCameraDeathLookEnemy = new Class'TurokCameraDeathLookEnemy';
    mCameraDriver = new Class'TurokCameraDriver';
    mCameraFirstPerson = new Class'TurokCameraFirstPerson';
    mCameraFixed = new Class'TurokCameraFixed';
    mCameraFree = new Class'TurokCameraFree';
    mCameraPassenger = new Class'TurokCameraPassenger';
    mCameraSpectator = new Class'TurokCameraSpectator';
    mCameraThirdPerson = new Class'TurokCameraThirdPerson';
    mCameraTurretVehicle = new Class'TurokCameraTurretVehicle';
    mCameraManual = new Class'TurokCameraManual';
    mCameraMPViewpoint = new Class'TurokCameraMPViewpoint';
    mCameraAnimated = new Class'TurokCameraAnimated';
    mCameraAnimated.Init();
    mMovementShake = new (Owner) Class'TurokMovementShake';
    mMovementShake.AddCameraModifier(self);
    mShakeModifier = new (Owner) Class'TurokRadialParametricShake';
    mShakeModifier.AddCameraModifier(self);
    mShakeModifier.mPlayMode = 2;
    mShakeModifier.DisableModifier();
    mShakeModifier.Init();
    mParameters.blendTime = 0.0000000;
    //return;    
}

simulated function InitializeFor(@NULL PC)
{
    local @NULL player_controller;

    super.InitializeFor(PC);
    player_controller = TurokPlayerController(PC);
    // End:0xE4
    if(player_controller != none)
    {
        player_controller.mZoomer = new (player_controller.Player) Class'TurokWeaponZoom';
        player_controller.mZoomer.Init();
        player_controller.mZoomer.AddCameraModifier(self);
        player_controller.mStealthZoomer = new (player_controller.Player) Class'TurokStealthZoom';
        player_controller.mStealthZoomer.Init();
        player_controller.mStealthZoomer.AddCameraModifier(self);
    }
    //return;    
}

simulated function DisplayDebug(@NULL HUD, out float out_YL, out float out_YPos)
{
    local @NULL EyesLoc, EyesRot, Canvas;

    Canvas = HUD.Canvas;
    Canvas.SetDrawColor(byte(255), byte(255), byte(255));
    Canvas.__NFUN_465__((("Camera Style:" $ string(CameraStyle)) @ "main ViewTarget:") $ string(ViewTarget.Target));
    out_YPos += out_YL;
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.__NFUN_465__("mCameraCollisionTest:" $ string(mCameraCollisionTest));
    // End:0x168
    if(ViewTarget.Target != none)
    {
        ViewTarget.Target.GetActorEyesViewPoint(EyesLoc, EyesRot);
        Canvas.__NFUN_465__((("   EyesLoc:" $ string(EyesLoc)) @ "EyesRot:") $ string(EyesRot));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
    }
    //return;    
}

defaultproperties
{
    mCinematicVT=(Target=none,Controller=none,POV=(Location=(X=0.0000000,Y=0.0000000,Z=0.0000000),Rotation=(Pitch=0,Yaw=0,Roll=0),FOV=90.0000000),AspectRatio=0.0000000,PRI=none)
    mOutVT=(Target=none,Controller=none,POV=(Location=(X=0.0000000,Y=0.0000000,Z=0.0000000),Rotation=(Pitch=0,Yaw=0,Roll=0),FOV=90.0000000),AspectRatio=0.0000000,PRI=none)
    mUsingFirstPersonCamera=true
    DefaultFOV=65.0000000
    FreeCamDistance=0.0000000
}