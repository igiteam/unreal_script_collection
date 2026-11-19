class SkyCamera extends Camera
    native;

enum ECameraMode
{
    ECM_Normal,                     // 0
    ECM_Matinee,                    // 1
    ECM_FreeCam,                    // 2
    ECM_FixedCam,                   // 3
    ECM_OrbitCam,                   // 4
    ECM_MAX                         // 5
};

enum ECamCollisionState
{
    ECCS_NotColliding,              // 0
    ECCS_SmoothingIn,               // 1
    ECCS_SmoothingOut,              // 2
    ECCS_DoneSmoothingIn,           // 3
    ECCS_MAX                        // 4
};

enum ECollSmoothingState
{
    ECSS_None,                      // 0
    ECSS_MovingIn,                  // 1
    ECSS_MovingOut,                 // 2
    ECSS_MAX                        // 3
};

enum EOrbitCamState
{
    EOCS_None,                      // 0
    EOCS_MovingOut,                 // 1
    EOCS_MovingIn,                  // 2
    EOCS_MAX                        // 3
};

struct native s_CameraTransformInfo
{
    var Vector CamPos;
    var Rotator CamRot;
    var Vector CamFocus;
    var Vector CamPivot;
    var Vector CamUpVect;
    var float CamFOVAngle;
    var float CamPitchMin;
    var float CamPitchMax;
    var bool bDisableCollision;
    var bool bDisableCollisionPrediction;
    var Vector CamSafeLoc;
    var Vector ConstraintPos;
    var Vector FocusConstraintPos;
    var Vector PivotConstraintPos;
    var Vector SafeLocConstraintPos;
    var Rotator ConstraintRot;
    var Rotator FocusConstraintRot;
    var Rotator PivotConstraintRot;
    var Rotator SafeLocConstraintRot;
    var float CollSmoothInSpeed;
    var float CollSmoothOutSpeed;
    var float CollWaitForSmoothOutTime;
    var float AutoPitchWaitTime;
    var float AutoPitchSpeed;
    var float AutoPitchMinAngle;
    var float AutoPitchDesiredAngle;

    structdefaultproperties
    {
        CamPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        CamRot=(Pitch=0,Yaw=0,Roll=0)
        CamFocus=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        CamPivot=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        CamUpVect=(X=0.0000000,Y=0.0000000,Z=1.0000000)
        CamFOVAngle=0.0000000
        CamPitchMin=0.0000000
        CamPitchMax=0.0000000
        bDisableCollision=false
        bDisableCollisionPrediction=false
        CamSafeLoc=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        ConstraintPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        FocusConstraintPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        PivotConstraintPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        SafeLocConstraintPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        ConstraintRot=(Pitch=0,Yaw=0,Roll=0)
        FocusConstraintRot=(Pitch=0,Yaw=0,Roll=0)
        PivotConstraintRot=(Pitch=0,Yaw=0,Roll=0)
        SafeLocConstraintRot=(Pitch=0,Yaw=0,Roll=0)
        CollSmoothInSpeed=0.0000000
        CollSmoothOutSpeed=0.0000000
        CollWaitForSmoothOutTime=0.0000000
        AutoPitchWaitTime=0.0000000
        AutoPitchSpeed=0.0000000
        AutoPitchMinAngle=0.0000000
        AutoPitchDesiredAngle=0.0000000
    }
};

struct native SPawnTrace
{
    var Pawn pPawn;
    var bool bTraceAllowed;

    structdefaultproperties
    {
        pPawn=none
        bTraceAllowed=false
    }
};

struct native SCameraSpeeds
{
    var float Linear;
    var float Angular;
    var float Time;

    structdefaultproperties
    {
        Linear=0.0000000
        Angular=0.0000000
        Time=0.0000000
    }
};

struct native SSwayParameters
{
    var() float RotationRateMin;
    var() float RotationRateMax;
    var() float GrowTimeMin;
    var() float GrowTimeMax;
    var() float MaxOffset;
    var() int NumSwayVectors;
    var() float SmoothPercent;

    structdefaultproperties
    {
        RotationRateMin=0.0000000
        RotationRateMax=0.0000000
        GrowTimeMin=0.0000000
        GrowTimeMax=0.0000000
        MaxOffset=0.0000000
        NumSwayVectors=0
        SmoothPercent=0.0000000
    }
};

struct native SSwayVectorData
{
    var float CurrOffsetLength;
    var float RotationRate;
    var float CurrAngle;
    var float GrowTimer;
    var float GrowTime;
    var bool bGrowing;

    structdefaultproperties
    {
        CurrOffsetLength=0.0000000
        RotationRate=0.0000000
        CurrAngle=0.0000000
        GrowTimer=0.0000000
        GrowTime=0.0000000
        bGrowing=false
    }
};

var const transient SkyCameraTree CamTreeRoot;
var transient bool bInitialized;
var private transient bool bTickStatus;
var transient bool bCollInitialized;
var transient bool bDeathCamOn;
var transient bool bFadingToBlack;
var transient bool bUseDebugFOV;
var transient bool bDisableCollisionAllActors;
var transient bool bFullMatineeMode;
var() bool bShowCollisionPrediction;
var transient bool bAdjustRotWhenAvoidingCollision;
var transient bool bSmoothBlendDisable;
var transient bool bVehicleCollisionOccurred;
var transient bool bAimValueUpdated;
var float MatineeBlendTime;
var() Vector CollisionExtents;
var() Vector CollisionExtentsVert;
var transient SkyCamera.ECollSmoothingState CollSmoothState;
var SkyCamera.EOrbitCamState OrbitCamState;
var transient SkyCamera.ECameraMode CameraMode;
var transient SkyCamera.ECameraMode PrevCameraMode;
var() float CollMinLookAheadAngle;
var() float CollMaxLookAheadAngle;
var() float CollMaxLookAheadDist;
var transient float CollWaitForSmoothOutTimer;
var transient float CollCurrentDist;
var transient Vector FreeCamCurrVelocity;
var() float FreeCamAccelSlow;
var() float FreeCamAccelNormal;
var() float FreeCamAccelFast;
var() float FreeCamSpeedDecay;
var() float FreeCamMaxSpeedSlow;
var() float FreeCamMaxSpeedNormal;
var() float FreeCamMaxSpeedFast;
var() float FreeCamFOV;
var() float FreeCamPitchMin;
var() float FreeCamPitchMax;
var float FadeToBlackDeathDelayTime;
var transient float FadeToBlackDeathDelayTimer;
var float FadeToBlackTime;
var float FadeFromBlackTime;
var transient float CurFadeToBlackTime;
var transient float FadeToBlackTimer;
var transient array<Actor> IgnoreCollisionActors;
var transient array<bool> SavedTraceAllowedIgnoreCollisionActors;
var transient int IgnoreCollisionsBookendCounter;
var transient Vector CachedRightVector;
var() export editinline StaticMeshComponent CameraMesh;
var() float SkyBotDebugCameraDistance;
var transient float OrbitCamDist;
var transient Vector OrbitCamOffsetLoc;
var transient Rotator OrbitCamOffsetRot;
var() float SafeLocationDistToHidePawn;
var transient Rotator LastCamMeshRot;
var transient Rotator LastOrbitCamRot;
var transient Rotator LastFreeCamRot;
var s_CameraTransformInfo CameraInfo;
var s_CameraTransformInfo PrevCameraInfo;
var Vector PrevDesiredPos;
var Vector PrevLocation;
var transient array<SCameraSpeeds> SmoothSpeeds;
var transient int SmoothArraySize;
var(Smoothing) float SmoothBlendLocPercentStart;
var(Smoothing) float SmoothBlendLocPercentRate;
var transient float SmoothBlendLocPercentCurr;
var(Smoothing) float SmoothBlendLocMinSpeed;
var(Smoothing) float SmoothBlendLocAllowedAccelDiff;
var deprecated int SmoothLastIdx;
var(Smoothing) float SmoothPercentInCover;
var(Smoothing) float SmoothPercentForLedgeLeap;
var(Smoothing) float SmoothPercentForVerticalMantle;
var transient float SmoothPercentForVerticalMantleCurr;
var(Smoothing) float SmoothPercentIncreaseTime;
var transient float SmoothPercentIncreaseTimer;
var transient Vector SwayOffset;
var transient Vector2D AimValue;
var transient Vector2D PrevAimVel;
var transient Vector2D PrevAimPos;
var() SSwayParameters SwayParams;
var array<SSwayVectorData> SwayVectors;
var transient float LastDangleTime;

// Export USkyCamera::execSkipMatinee(FFrame&, void* const)
native function SkipMatinee();

// Export USkyCamera::execSetCamTreeTemplate(FFrame&, void* const)
native final function SetCamTreeTemplate(SkyCameraTree NewTemplate);

// Export USkyCamera::execCallTick(FFrame&, void* const)
native final function CallTick(float DeltaTime);

// Export USkyCamera::execProcessViewRotationNative(FFrame&, void* const)
native final function ProcessViewRotationNative(float fDeltaTime, out Rotator rOutViewRot, out Rotator rOutDeltaRot);

// Export USkyCamera::execSetViewTarget(FFrame&, void* const)
native function SetViewTarget(Actor NewViewTarget, optional ViewTargetTransitionParams TransitionParams);

// Export USkyCamera::execLimitViewRotationNative(FFrame&, void* const)
native function Rotator LimitViewRotationNative(Rotator rViewRotation, float fViewPitchMin, float fViewPitchMax);

// Export USkyCamera::execUpdateCameraNative(FFrame&, void* const)
native simulated function UpdateCameraNative(float fDeltaTime);

// Export USkyCamera::execGetCameraCollisions(FFrame&, void* const)
native simulated function ImpactInfo GetCameraCollisions(Vector vStartTrace, Vector vEndTrace, Vector vExtents);

// Export USkyCamera::execGetCameraCollisionsOld(FFrame&, void* const)
native simulated function ImpactInfo GetCameraCollisionsOld(Vector vStartTrace, Vector vEndTrace, Vector vExtents);

// Export USkyCamera::execIsFreeCamWithPlayerMovement(FFrame&, void* const)
native function bool IsFreeCamWithPlayerMovement();

// Export USkyCamera::execIsFreeCamWithNoPlayerMovement(FFrame&, void* const)
native function bool IsFreeCamWithNoPlayerMovement();

// Export USkyCamera::execInitCameraTree(FFrame&, void* const)
native function InitCameraTree();

simulated event PreBeginPlay()
{
    super(Actor).PreBeginPlay();
    //return;    
}

simulated event UpdateCamera(float DeltaTime)
{
    UpdateCameraNative(DeltaTime);
    //return;    
}

function InitializeFor(PlayerController PC)
{
    super.InitializeFor(PC);
    SetRotation(PC.Rotation);
    //return;    
}

event SetFadeToBlack(Color InFadeColor, float InFadeToBlackDelayTime, float InFadeToBlackTime, bool bInDisableToggleFading, bool bInFadeToBlack)
{
    local float CurPercent;

    // End:0xCF
    if(!bDisableToggleFading || !bInDisableToggleFading)
    {
        // End:0xB6
        if(bEnableFading)
        {
            // End:0x3E
            if(CurFadeToBlackTime == 0.0000000)
            {
                CurPercent = 1.0000000;                
            }
            else
            {
                CurPercent = FMin(1.0000000, FadeToBlackTimer / CurFadeToBlackTime);
            }
            // End:0xA1
            if((bFadingToBlack && !bInFadeToBlack) || !bFadingToBlack && bInFadeToBlack)
            {
                FadeToBlackTimer = (1.0000000 - CurPercent) * InFadeToBlackTime;                
            }
            else
            {
                FadeToBlackTimer = CurPercent * InFadeToBlackTime;
            }            
        }
        else
        {
            // End:0xCD
            if(bInFadeToBlack)
            {
                FadeToBlackTimer = 0.0000000;                
            }
            else
            {
                return;
            }
        }
    }
    CurFadeColor = InFadeColor;
    FadeToBlackDeathDelayTimer = InFadeToBlackDelayTime;
    bEnableFading = true;
    bFadingToBlack = bInFadeToBlack;
    bDisableToggleFading = bInDisableToggleFading;
    CurFadeToBlackTime = InFadeToBlackTime;
    //return;    
}

event ToggleFadeToBlack()
{
    // End:0x0E
    if(bDisableToggleFading)
    {
        return;        
    }
    else
    {
        // End:0x38
        if(bEnableFading)
        {
            bFadingToBlack = false;
            CurFadeToBlackTime = FadeFromBlackTime;
            FadeToBlackTimer = 0.0000000;            
        }
        else
        {
            FadeAmount = 0.0000000;
            FadeToBlackDeathDelayTimer = FadeToBlackDeathDelayTime;
            bEnableFading = true;
            bFadingToBlack = true;
            CurFadeToBlackTime = FadeToBlackTime;
            FadeToBlackTimer = 0.0000000;
            CurFadeColor.R = 0;
            CurFadeColor.G = 0;
            CurFadeColor.B = 0;
        }
    }
    //return;    
}

function Tick(float DeltaTime)
{
    local float T;

    // End:0x76
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        // End:0x4F
        if(PCOwner.Pawn == none)
        {
            bDeathCamOn = true;
            // End:0x4C
            if(!bEnableFading)
            {
                ToggleFadeToBlack();
            }            
        }
        else
        {
            // End:0x76
            if(bDeathCamOn == true)
            {
                bDeathCamOn = false;
                // End:0x76
                if(bEnableFading)
                {
                    ToggleFadeToBlack();
                }
            }
        }
    }
    // End:0x1DA
    if(bEnableFading)
    {
        // End:0x117
        if(bFadingToBlack)
        {
            FadeToBlackDeathDelayTimer -= DeltaTime;
            // End:0x114
            if(FadeToBlackDeathDelayTimer <= 0.0000000)
            {
                FadeToBlackTimer += DeltaTime;
                T = FadeToBlackTimer / FMax(0.0100000, CurFadeToBlackTime);
                T = FMin(T, 1.0000000);
                FadeAmount = (((3.0000000 * T) * T) * (float(1) - T)) + ((T * T) * T);
            }            
        }
        else
        {
            // End:0x1DA
            if(!bFadingToBlack)
            {
                FadeToBlackTimer += DeltaTime;
                T = FadeToBlackTimer / FMax(0.0100000, CurFadeToBlackTime);
                T = FMin(T, 1.0000000);
                FadeAmount = 1.0000000 - ((((float(3) * T) * T) * (float(1) - T)) + ((T * T) * T));
                // End:0x1DA
                if(FadeAmount <= float(0))
                {
                    FadeAmount = 0.0000000;
                    bEnableFading = false;
                    FadeToBlackTimer = 0.0000000;
                    FadeToBlackDeathDelayTimer = 0.0000000;
                    CurFadeToBlackTime = FadeToBlackTime;
                }
            }
        }
    }
    // End:0x206
    if((FadeAmount >= float(1)) && PCOwner.Pawn == none)
    {
        bDisableToggleFading = false;
    }
    CallTick(DeltaTime);
    super(Actor).Tick(DeltaTime);
    //return;    
}

simulated function AlphaFadeCameraPawns()
{
    local SkyPlayerController pSPC;
    local Vector vSafeLoc;
    local float distToSafeLoc;

    pSPC = SkyPlayerController(PCOwner);
    // End:0x143
    if((pSPC != none) && SkyPawn(pSPC.Pawn) != none)
    {
        // End:0xE2
        if((int(CameraMode) == int(0)) || int(CameraMode) == int(3))
        {
            vSafeLoc = SkyPawn(pSPC.Pawn).GetCameraCollisionOffset();
            distToSafeLoc = VSize(vSafeLoc - Location);
            // End:0xE2
            if(distToSafeLoc < SafeLocationDistToHidePawn)
            {
                // End:0xE0
                if(pSPC.Pawn.bHidden != true)
                {
                    pSPC.Pawn.SetHidden(true);
                }
                return;
            }
        }
        // End:0x143
        if((pSPC.Pawn.bHidden != false) && pSPC.Pawn.IsInvisible() != true)
        {
            pSPC.Pawn.SetHidden(false);
        }
    }
    //return;    
}

// Export USkyCamera::execGetCameraView(FFrame&, void* const)
native final function GetCameraView(out Vector POVLocation, out Rotator POVRotation, float DeltaTime);

simulated function ProcessViewRotation(float fDeltaTime, out Rotator rOutViewRot, out Rotator rOutDeltaRot)
{
    ProcessViewRotationNative(fDeltaTime, rOutViewRot, rOutDeltaRot);
    //return;    
}

function SetFadeToBlackBasedOnPawn(float newFadeToBlackDeathDelayTime, float newFadeToBlackTime)
{
    // End:0x2C
    if(!bEnableFading)
    {
        FadeToBlackDeathDelayTime = newFadeToBlackDeathDelayTime;
        FadeToBlackTime = newFadeToBlackTime;
        CurFadeToBlackTime = newFadeToBlackTime;
    }
    //return;    
}
