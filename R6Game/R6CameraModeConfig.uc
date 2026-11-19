class R6CameraModeConfig extends R6Config
    native
    hidecategories(Object);

enum EAnchorTypeCamMode
{
    ANCHORTYPECAMMODE_NONE,         // 0
    ANCHORTYPECAMMODE_BONE,         // 1
    ANCHORTYPECAMMODE_ROPE,         // 2
    ANCHORTYPECAMMODE_LADDER,       // 3
    ANCHORTYPECAMMODE_INTERACTACTOR,// 4
    ANCHORTYPECAMMODE_KILLCAM_LOOKATME,// 5
    ANCHORTYPECAMMODE_KILLCAM_LOOKATKILLER,// 6
    ANCHORTYPECAMMODE_DEADCAM,      // 7
    ANCHORTYPECAMMODE_MAX           // 8
};

var(Anchor) Vector m_vAnchorOffset;
var(Anchor) Rotator m_rRotationOffset;
var(Anchor) R6EngineEnums.ECameraOffsetRotation m_eRotateAnchorOffsetXWithPitch;
var(Anchor) R6EngineEnums.ECameraOffsetRotation m_eRotateAnchorOffsetXWithYaw;
var(Anchor) R6EngineEnums.ECameraOffsetRotation m_eRotateAnchorOffsetYWithYaw;
var(Anchor) R6EngineEnums.ECameraOffsetRotation m_eRotateAnchorOffsetYWithRoll;
var(Anchor) R6EngineEnums.ECameraOffsetRotation m_eRotateAnchorOffsetZWithPitch;
var(Anchor) R6EngineEnums.ECameraOffsetRotation m_eRotateAnchorOffsetZWithRoll;
var(Anchor) R6CameraModeConfig.EAnchorTypeCamMode m_eAnchorTypeLoc;
var(Anchor) R6CameraModeConfig.EAnchorTypeCamMode m_eAnchorTypeRot;
var(Anchor) float m_fCameraOffset;
var(Anchor) name m_AnchorBone;
var(Anchor) name m_AnchorBoneRotation;
var(Anchor) int m_iAxisAnchorBoneRotation;
var(Anchor) bool m_bInvert;
var(Anchor) bool m_bInvertingFlip;
var(Anchor) bool m_bDisablePenetration;
var(Anchor) bool m_bHidePenetratingRainbow;
var(Anchor) bool m_bUseFirstPersonMesh;
var(Anchor) bool m_bInterpolateBoneHeightWCylinder;
var(Anchor16x9) bool m_bUse16x9Override;
var(AnchorPitchMod) bool m_bUseAnchorPitchMod;
var(FOV) bool m_bOverrideFOV;
var(LimitPitchAngle) bool m_bAllowBlendPitchLimit;
var(LimitPitchAngle) bool m_bLimitPitchAngle;
var(LimitPitchAngle) bool m_bGetLimitPitchAngleFromPawn;
var(LimitYawAngle) bool m_bAllowBlendYawLimit;
var(LimitYawAngle) bool m_bLimitYawAngle;
var(LimitYawAngle) bool m_bGetLimitYawAngleFromPawn;
var(Reticle) bool m_bDisplayReticle;
var(Anchor) float m_fSpringFactor;
var(Anchor) float m_fSpringDamping;
var(Anchor16x9) Vector m_vAnchorOffset16x9;
var(Anchor16x9) float m_fCameraOffset16x9;
var(AnchorPitchMod) SInterpParams m_AnchorPitchModInterpParams;
var(AnchorPitchMod) float m_fMaxAnchorDeltaX;
var(AnchorPitchMod) float m_fMinAnchorDeltaX;
var(PitchOffset) /*0x20000000-0x00000000*/ int m_iPitchOffset;
var(FOV) float m_fFOV;
var(LimitPitchAngle) /*0x20000000-0x00000000*/ int m_iMinPitchAngle;
var(LimitPitchAngle) /*0x20000000-0x00000000*/ int m_iMaxPitchAngle;
var(LimitYawAngle) /*0x20000000-0x00000000*/ int m_iMinYawAngle;
var(LimitYawAngle) /*0x20000000-0x00000000*/ int m_iMaxYawAngle;

defaultproperties
{
    m_bLimitPitchAngle=true
    m_bDisplayReticle=true
    m_AnchorPitchModInterpParams=(m_eMode=1,m_fModifierA=1.0000000,m_fModifierB=4.0000000)
    m_fFOV=90.0000000
    m_iMinPitchAngle=-16384
    m_iMaxPitchAngle=16384
    m_szThumbnailTexture="KellerEditorMaterials.Camera"
    m_szDescription="Camera mode configuration"
}