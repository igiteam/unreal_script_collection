class R6Camera extends Camera
    native
    hidecategories(lighting);

struct SR6CameraCache
{
    var Vector m_vLocation;
    var Vector m_vAnchorLocation;
    var Rotator m_rRotation;
    var Rotator m_rModifiersDeltaRotation;
    var float m_fFOV;
    var bool m_bLimitPitch;
    var bool m_bAllowBlendPitchLimit;
    var bool m_bAllowBlendYawLimit;
    var int m_iMinPitch;
    var int m_iMaxPitch;
    var bool m_bLimitYaw;
    var int m_iMinYaw;
    var int m_iMaxYaw;
    var bool m_bDisplayReticle;
    var float m_fLastTimeStamp;
    var bool m_bDisablePenetration;
    var bool m_bHidePenetratingRainbow;

    structdefaultproperties
    {
        m_vLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vAnchorLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_rRotation=(Pitch=0,Yaw=0,Roll=0)
        m_rModifiersDeltaRotation=(Pitch=0,Yaw=0,Roll=0)
        m_fFOV=0.0000000
        m_bLimitPitch=false
        m_bAllowBlendPitchLimit=false
        m_bAllowBlendYawLimit=false
        m_iMinPitch=0
        m_iMaxPitch=0
        m_bLimitYaw=false
        m_iMinYaw=0
        m_iMaxYaw=0
        m_bDisplayReticle=false
        m_fLastTimeStamp=0.0000000
        m_bDisablePenetration=false
        m_bHidePenetratingRainbow=false
    }
};

var R6PlayerController m_R6PCOwner;
var R6Pawn m_TargetPawn;
var Rotator m_rBaseRotation;
var R6GameEnums.ECameraMode m_eCameraMode;
var R6GameEnums.EDebugCameraModes m_eForceCameraMode;
var R6CameraTree m_pTree;
var R6CameraTree m_pTreeTemplate;
var array<R6CameraMode> m_aCameraModes;
var float m_fPrevDistanceFromAnchor;
var bool m_bUseOverride;
var bool m_bOverrideConstrainAspectRatio;
var bool m_bDisableEffects;
var bool m_bCycleMode;
var bool m_bCamPenetrated;
var float m_fOverrideConstrainedAspectRatio;
var SR6CameraCache m_R6CameraCache;
var Vector m_vDebugCamOffset;
var array<R6CameraModifier> m_CameraModifiers;
var R6CameraRecoilModifier m_RecoilModifier;
var R6CameraShakeModifier m_ShakeModifier;
var R6CameraHelicopterShakeModifier m_HelicopterShakeModifier;
var R6CameraFastRopeShakeModifier m_FastRopeShakeModifier;
var Vector m_vCamLocFromPenetration;
var Vector m_vPrevCamLoc;
var float m_fPenetratedTime;
var array<R6Pawn> m_aCollidingPawns;

// Export UR6Camera::execUpdateCameraNative(FFrame&, void* const)
native final function UpdateCameraNative(float fDeltaTime);

// Export UR6Camera::execGetViewportResolution(FFrame&, void* const)
native final function Vector2D GetViewportResolution();

// Export UR6Camera::execInitTree(FFrame&, void* const)
native final function InitTree();

// Export UR6Camera::execReReadTree(FFrame&, void* const)
native final function ReReadTree();

// Export UR6Camera::execAddRecoil(FFrame&, void* const)
native final function AddRecoil();

// Export UR6Camera::execSetRecoilWeapon(FFrame&, void* const)
native final function SetRecoilWeapon(R6Weapon recoilWeapon);

// Export UR6Camera::execResetCameraMode(FFrame&, void* const)
native function ResetCameraMode();

// Export UR6Camera::execSetCameraMode(FFrame&, void* const)
native function SetCameraMode(R6GameEnums.ECameraMode eDesiredMode);

// Export UR6Camera::execSetBaseRotation(FFrame&, void* const)
native function SetBaseRotation(Rotator rNewBaseRotation);

// Export UR6Camera::execShake(FFrame&, void* const)
native function Shake(class<DamageType> DamageType, float fStrengthRatio);

// Export UR6Camera::execCustomShake(FFrame&, void* const)
native function CustomShake(float fCustomShakeDuration, float fCustomShakeRollFreq, float fCustomShakePitchFreq, float fCustomShakeYawFreq, int iCustomShakeRollAmp, int iCustomShakePitchAmp, int iCustomShakeYawAmp, SInterpParams CustomShakeInterpParams, bool bCustomShakeInverted);

// Export UR6Camera::execPerlinNoiseShake(FFrame&, void* const)
native function PerlinNoiseShake(float fShakeDuration, float fPitchShakeScale, int iPitchShakeAmplitude, float fYawShakeScale, int iYawShakeAmplitude, float fRollShakeScale, int iRollShakeAmplitude, float fLocXShakeScale, float fLocXShakeAmplitude, float fLocYShakeScale, float fLocYShakeAmplitude, float fLocZShakeScale, float fLocZShakeAmplitude, SInterpParams ShakeInterpParams, bool bShakeInverted);

simulated function PostBeginPlay()
{
    // End:0x1F
    if(m_RecoilModifier == none)
    {
        m_RecoilModifier = new (Outer) Class'R6CameraRecoilModifier';        
    }
    m_RecoilModifier.Init();
    m_CameraModifiers[m_CameraModifiers.Length] = m_RecoilModifier;
    // End:0x60
    if(m_ShakeModifier == none)
    {
        m_ShakeModifier = new (Outer) Class'R6CameraShakeModifier';        
    }
    m_ShakeModifier.Init();
    m_CameraModifiers[m_CameraModifiers.Length] = m_ShakeModifier;
    // End:0xA1
    if(m_HelicopterShakeModifier == none)
    {
        m_HelicopterShakeModifier = new (Outer) Class'R6CameraHelicopterShakeModifier';        
    }
    m_HelicopterShakeModifier.Init();
    m_CameraModifiers[m_CameraModifiers.Length] = m_HelicopterShakeModifier;
    // End:0xE2
    if(m_FastRopeShakeModifier == none)
    {
        m_FastRopeShakeModifier = new (Outer) Class'R6CameraFastRopeShakeModifier';        
    }
    m_FastRopeShakeModifier.Init();
    m_CameraModifiers[m_CameraModifiers.Length] = m_FastRopeShakeModifier;
    return;
}

// Export UR6Camera::execGetRotationLimit(FFrame&, void* const)
native function bool GetRotationLimit(out int iMin, out int iMax, R6EngineEnums.EAimAxis eRotAxis);

event PreResetCleanup()
{
    SetRecoilWeapon(none);
    return;
}

function ResetOriginalData()
{
    ResetOriginalData();
    m_R6CameraCache.m_fLastTimeStamp = WorldInfo.TimeSeconds;
    ResetCameraMode();
    return;
}

function ForceCameraMode(R6GameEnums.EDebugCameraModes eNewMode)
{
    // End:0x31
    if(int(eNewMode) != int(m_eForceCameraMode))
    {
        m_eForceCameraMode = eNewMode;
        m_vDebugCamOffset = vect(-175.0000000, 0.0000000, 65.0000000);
    }
    return;
}

// Export UR6Camera::execIsFirstPerson(FFrame&, void* const)
native final function bool IsFirstPerson();

simulated function DrawAnimDebug(Canvas Canvas, name StartingPoint, int iOffsetX, int iOffsetY, bool m_bAnimDebugRelevantOnly)
{
    // End:0x34
    if(m_pTree != none)
    {
        m_pTree.super(R6CameraTree).DrawAnimDebug(Canvas, StartingPoint, iOffsetX, iOffsetY, m_bAnimDebugRelevantOnly);
    }
    return;
}

defaultproperties
{
    m_pTreeTemplate=R6CameraTree'RS5CameraTrees.PlayerCameraTree'
    TickGroup=1
}