class R6VolumetricSound extends R6SoundComponent
    native
    editinlinenew;

enum VS_ActivationShape
{
    SHAPE_Sphere,                   // 0
    SHAPE_Box,                      // 1
    SHAPE_None,                     // 2
    SHAPE_MAX                       // 3
};

struct SoundActivationInfo
{
    var() /*0x04000000-0x00000000*/ float m_fActivationFadeDuration;
    var() /*0x04000000-0x00000000*/ R6EngineEnums.EFadeCurve m_eActivationFadeCurve;
    var() /*0x04000000-0x00000000*/ float m_fActivationRadius;
    var() /*0x04000000-0x00000000*/ float m_fActivationWidth;
    var() /*0x04000000-0x00000000*/ float m_fActivationDepth;
    var() /*0x04000000-0x00000000*/ float m_fActivationHeight;
    var() /*0x04000000-0x00000000*/ float m_fDesactivationFadeDuration;
    var() /*0x04000000-0x00000000*/ R6EngineEnums.EFadeCurve m_eDesactivationFadeCurve;
    var() /*0x04000000-0x00000000*/ float m_fDesactivationRadius;
    var() /*0x04000000-0x00000000*/ float m_fDesactivationWidth;
    var() /*0x04000000-0x00000000*/ float m_fDesactivationDepth;
    var() /*0x04000000-0x00000000*/ float m_fDesactivationHeight;

    structdefaultproperties
    {
        m_fActivationFadeDuration=3.0000000
        m_eActivationFadeCurve=0
        m_fActivationRadius=400.0000000
        m_fActivationWidth=400.0000000
        m_fActivationDepth=400.0000000
        m_fActivationHeight=400.0000000
        m_fDesactivationFadeDuration=3.0000000
        m_eDesactivationFadeCurve=0
        m_fDesactivationRadius=450.0000000
        m_fDesactivationWidth=450.0000000
        m_fDesactivationDepth=450.0000000
        m_fDesactivationHeight=450.0000000
    }
};

struct SoundFollowers extends SoundActivationInfo
{
    var() /*0x04000000-0x00000000*/ array<SoundCue> m_Cues;
    var /*0x04000000-0x00000000*/ array<Vector2D> m_aVertices;
    var() /*0x04000000-0x00000000*/ float m_fSpeed;
    var() /*0x04000000-0x00000000*/ float m_fTheta;
    var() /*0x04000000-0x00000000*/ bool m_bIs3DMTT;
    var() /*0x04000000-0x00000000*/ bool m_bLinkFollowersToMicro;
    var() /*0x04000000-0x00000000*/ array<float> m_Angles;

    structdefaultproperties
    {
        m_fSpeed=0.5000000
        m_fTheta=10.0000000
        m_fActivationFadeDuration=0.0000000
        m_fActivationRadius=0.0000000
        m_fActivationWidth=0.0000000
        m_fActivationDepth=0.0000000
        m_fActivationHeight=0.0000000
        m_fDesactivationFadeDuration=0.0000000
        m_fDesactivationRadius=0.0000000
        m_fDesactivationWidth=0.0000000
        m_fDesactivationDepth=0.0000000
        m_fDesactivationHeight=0.0000000
    }
};

struct SoundRandomFX extends SoundActivationInfo
{
    var() /*0x04000000-0x00000000*/ SoundCue m_Cue;
    var() /*0x04000000-0x00000000*/ int m_iPolyphony;
    var() /*0x04000000-0x00000000*/ float m_fMinRadius;
    var() /*0x04000000-0x00000000*/ float m_fMaxRadius;
    var() /*0x04000000-0x00000000*/ float m_fLaunchFreq;

    structdefaultproperties
    {
        m_fMinRadius=25.0000000
        m_fMaxRadius=200.0000000
        m_fLaunchFreq=1.0000000
        m_fActivationFadeDuration=0.0000000
        m_fActivationRadius=0.0000000
        m_fActivationWidth=0.0000000
        m_fActivationDepth=0.0000000
        m_fActivationHeight=0.0000000
        m_fDesactivationFadeDuration=0.0000000
        m_fDesactivationRadius=0.0000000
        m_fDesactivationWidth=0.0000000
        m_fDesactivationDepth=0.0000000
        m_fDesactivationHeight=0.0000000
    }
};

var() /*0x04000000-0x00000000*/ float m_fVolumeSoundRadius;
var bool m_bHasSoundVolume;
var() /*0x04000000-0x00000000*/ bool m_bActivateDPSP;
var() /*0x04000000-0x00000000*/ R6VolumetricSound.VS_ActivationShape m_eActivationShape;
var float m_fThickness;
var float m_fMinZ;
var() /*0x04000000-0x00000000*/ float m_fListenerMinRadius;
var(R6Sound) /*0x04000000-0x00000000*/ SoundFollowers m_Followers;
var(R6Sound) /*0x04000000-0x00000000*/ SoundRandomFX m_RandomFX;
