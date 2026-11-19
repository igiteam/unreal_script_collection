class SPAnimNodeSequence extends AnimNodeSequence
    native;

/** [X, Y, Z] axes */
var() AnimNodeSequence.ERootBoneAxis AnimSeqRootBoneOption[3];
var() AnimNodeSequence.ERootBoneAxis AnimSeqRootBoneRotationOption;
var float m_accumulatedTranslationScale;
var Quat m_accumulatedRotation;
var Vector m_accumulatedTranslation;
var Quat m_externalTrackedRotation;
var() bool m_EnableFootsteps;
/** When set to true will set bPlaying in TickAnim to false to not playthe current anim.  This is necessary for Matinee in order for it tohave controlled playback of animation through the SetPosition()function call */
var() bool m_bForceNoPlaying;
var bool m_bAbsoluteExtraction;
var bool m_bIgnoreRootExtractionModeDiscard;

// Export USPAnimNodeSequence::execResetRootBoneExtraction(FFrame&, void* const)
native function ResetRootBoneExtraction();

function bool GetFootstepsEnabled()
{
    return m_EnableFootsteps;
    //return ReturnValue;    
}
