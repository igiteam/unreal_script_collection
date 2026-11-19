class R6HelicopterBase extends Actor
    abstract
    native
    notplaceable
    hidecategories(lighting);

var(HelicopterMovement) bool m_bApplyMovementDynamics;
var(HelicopterIdleNoise) bool m_bApplyIdleNoise;
var(HelicopterMovement) float m_fMaxPitchVelocity;
var(HelicopterMovement) /*0x20000000-0x00000000*/ int m_iMaxVelocityPitchAngle;
var(HelicopterMovement) float m_fMaxPitchAccel;
var(HelicopterMovement) /*0x20000000-0x00000000*/ int m_iMaxAccelPitchAngle;
var(HelicopterMovement) float m_fPitchInterpSpeed;
var(HelicopterMovement) /*0x20000000-0x00000000*/ int m_iMaxPitchModifier;
var(HelicopterMovement) float m_fMaxRollVelocity;
var(HelicopterMovement) /*0x20000000-0x00000000*/ int m_iMaxVelocityRollAngle;
var(HelicopterMovement) float m_fMaxRollAccel;
var(HelicopterMovement) /*0x20000000-0x00000000*/ int m_iMaxAccelRollAngle;
var(HelicopterMovement) float m_fRollInterpSpeed;
var(HelicopterMovement) /*0x20000000-0x00000000*/ int m_iMaxRollModifier;
var(HelicopterIdleNoise) float m_fMaxIdleNoiseSpeed;
var(HelicopterIdleNoise) float m_fPitchNoiseScale;
var(HelicopterIdleNoise) /*0x20000000-0x00000000*/ int m_iPitchNoiseAmplitude;
var(HelicopterIdleNoise) float m_fYawNoiseScale;
var(HelicopterIdleNoise) /*0x20000000-0x00000000*/ int m_iYawNoiseAmplitude;
var(HelicopterIdleNoise) float m_fRollNoiseScale;
var(HelicopterIdleNoise) /*0x20000000-0x00000000*/ int m_iRollNoiseAmplitude;
var(HelicopterIdleNoise) float m_fLocXNoiseScale;
var(HelicopterIdleNoise) float m_fLocXNoiseAmplitude;
var(HelicopterIdleNoise) float m_fLocYNoiseScale;
var(HelicopterIdleNoise) float m_fLocYNoiseAmplitude;
var(HelicopterIdleNoise) float m_fLocZNoiseScale;
var(HelicopterIdleNoise) float m_fLocZNoiseAmplitude;
var(R6Sound) /*0x04000000-0x00000000*/ float m_fNearestPitchDistance;
var(R6Sound) /*0x04000000-0x00000000*/ float m_fFarestPitchDistance;
var(MotionBlur) float m_fMotionBlurScale;
var Vector sm_Location;
var Rotator sm_Rotation;
var transient SeqAct_Interp m_pLastMatinee;
var transient bool m_bDeactivated;
var Rotator m_rOldRotation;
var Vector m_vOldLocation;
var int m_iCurrentPitchModifier;
var int m_iCurrentRollModifier;
var float m_iPitchModifier;
var float m_iYawModifier;
var float m_iRollModifier;
var Vector m_vLocationModifier;
var float m_fPitchNoiseOffset;
var float m_fYawNoiseOffset;
var float m_fRollNoiseOffset;
var float m_fLocXNoiseOffset;
var float m_fLocYNoiseOffset;
var float m_fLocZNoiseOffset;
var float m_fIdleNoiseStrength;
var export editinline MeshComponent m_ChopperMesh;
var transient float m_fDebugCurPitchAccel;
var transient float m_fDebugCurPitchVel;
var transient float m_fDebugCurRollAccel;
var transient float m_fDebugCurRollVel;
var transient float m_fDebugMaxPitchAccel;
var transient float m_fDebugMaxPitchVel;
var transient float m_fDebugMaxRollAccel;
var transient float m_fDebugMaxRollVel;
var(HelicopterLighting) float fShadowDepthOffset;

// Export UR6HelicopterBase::execInit(FFrame&, void* const)
native function Init();

// Export UR6HelicopterBase::execDoEnableLights(FFrame&, void* const)
native final function DoEnableLights();

// Export UR6HelicopterBase::execDoRepChopperToggle(FFrame&, void* const)
native final function DoRepChopperToggle();

simulated function PostBeginPlay()
{
    Init();
    return;
}

simulated function OnToggle(SeqAct_Toggle pAction)
{
    local bool bOldHidden;

    bOldHidden = bHidden;
    // End:0x39
    if(pAction.InputLinks[0].bHasImpulse)
    {
        bHidden = false;
        m_bDeactivated = false;        
    }
    else
    {
        // End:0x65
        if(pAction.InputLinks[1].bHasImpulse)
        {
            bHidden = true;
            m_bDeactivated = true;            
        }
        else
        {
            // End:0x9B
            if(pAction.InputLinks[2].bHasImpulse)
            {
                m_bDeactivated = !m_bDeactivated;
                bHidden = m_bDeactivated;
            }
        }
    }
    // End:0xB2
    if(bOldHidden != bHidden)
    {
        DoRepChopperToggle();
    }
    DoEnableLights();
    return;
}

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
    local bool bOldHidden;

    bOldHidden = bHidden;
    // End:0x39
    if(Action.InputLinks[0].bHasImpulse)
    {
        bHidden = true;
        m_bDeactivated = true;        
    }
    else
    {
        // End:0x65
        if(Action.InputLinks[1].bHasImpulse)
        {
            bHidden = false;
            m_bDeactivated = false;            
        }
        else
        {
            bHidden = !bHidden;
            m_bDeactivated = !m_bDeactivated;
        }
    }
    // End:0x9A
    if(bOldHidden != bHidden)
    {
        DoRepChopperToggle();
    }
    DoEnableLights();
    return;
}

simulated event InterpolationStarted(SeqAct_Interp InterpAction)
{
    m_bDeactivated = false;
    bHidden = false;
    DoEnableLights();
    return;
}

defaultproperties
{
    m_bApplyMovementDynamics=true
    m_bApplyIdleNoise=true
    m_fMaxPitchVelocity=500.0000000
    m_iMaxVelocityPitchAngle=2000
    m_fMaxPitchAccel=500.0000000
    m_iMaxAccelPitchAngle=8000
    m_fPitchInterpSpeed=0.3000000
    m_iMaxPitchModifier=8000
    m_fMaxRollVelocity=500.0000000
    m_iMaxVelocityRollAngle=2000
    m_fMaxRollAccel=500.0000000
    m_iMaxAccelRollAngle=8000
    m_fRollInterpSpeed=0.3000000
    m_iMaxRollModifier=8000
    m_fMaxIdleNoiseSpeed=800.0000000
    m_fPitchNoiseScale=0.2000000
    m_iPitchNoiseAmplitude=500
    m_fYawNoiseScale=0.2000000
    m_iYawNoiseAmplitude=500
    m_fRollNoiseScale=0.2000000
    m_iRollNoiseAmplitude=500
    m_fLocXNoiseScale=0.2000000
    m_fLocXNoiseAmplitude=100.0000000
    m_fLocYNoiseScale=0.2000000
    m_fLocYNoiseAmplitude=100.0000000
    m_fLocZNoiseScale=0.2000000
    m_fLocZNoiseAmplitude=100.0000000
    m_fMotionBlurScale=1.0000000
    m_fIdleNoiseStrength=1.0000000
    fShadowDepthOffset=0.0500000
    bNoDelete=true
    bIgnoreEncroachers=true
    bAlwaysRelevant=true
    bSkipActorPropertyReplication=true
    UseCharacterLights=true
    bGameRelevant=true
    bCollideActors=true
    bNoEncroachCheck=true
    Components=none
    Physics=7
    TickGroup=1
}