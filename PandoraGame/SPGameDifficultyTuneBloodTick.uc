class SPGameDifficultyTuneBloodTick extends SPGameDifficultyTune
    native
    editinlinenew;

/** INCLUDES MACROS struct DECLARATIONS VARIABLE DECLARATIONS */
var(Movement) const FloatDifficulty MovementSpeed;
var(Attack) const FloatDifficulty DamageVSPlayer;
var(Attack) const FloatDifficulty DamageVSAI;
var(Attack) const float AttackDistance;
var(Attack) const float ImpulseRange;
var(Attack) const float FireSpreadRange;
var(Attack) const float ImpulseStrength;
var(Attack) const float JumpAttackPercentage;
var(Attack) const float JumpAttackDistance;
var(Attack) const float SacInflateDistance;
var(Attack) const float StingDistance;
var(Attack) const FloatDifficulty StingDamageVSAI;
var(Attack) const FloatDifficulty StingDamageVSPlayer;
var(BloodTick) const float GlobalExplodeTime;
var(BloodTick) const bool UseRandomInitialSpeed;
var(BloodTick) const float InitialSpeedRange;
