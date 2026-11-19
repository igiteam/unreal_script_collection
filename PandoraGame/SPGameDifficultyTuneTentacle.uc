class SPGameDifficultyTuneTentacle extends SPGameDifficultyTune
    native
    editinlinenew;

/** INCLUDES MACROS struct DECLARATIONS VARIABLE DECLARATIONS */
var(Attack) const float ThrowImpulse;
var(Attack) const float ThrowProbability;
var(Attack) const float ThrowForwardPercentage;
var(Attack) const bool TryForceThrow;
var(Attack) const float CollisionOffset;
var(Design) const float GooScalerLocation;
var(Design) const float NonGroundGooScalerLocation;
var(ForceFeedback) editinline ForceFeedbackWaveform Hit_ForceFeedbackWaveform;
