
class SeqAct_AIModifyMeleeData extends SeqAct_Latent;


//***********************************************************************
// Variables
//***********************************************************************
/** keeps the focus on the target actor or clears it */
var() bool	 m_bAbleToMeleeAttacks;
var() bool	m_bNotAllowedToEverNoMatterWhatDoMeleeAttack;
var() float	 m_AdditionalMeleeRangeOfAttack;
var() int	 m_AdditionalMeleeAttackDamage;
var() float	 m_AdditionalMeleeHitForce;
var() float	 m_RangeToStartCQB_State;
var() float	 m_SpeedToChargeScale;
var() float	 m_MeleeWaitToFailTime;
var() float	 m_DelayBetweenStartOfMeleeStateAndTheAttackStart;
var() float	 m_OverridePercentOfMagToBlowThroughBeforeCharge;
var() float	 m_MinDistanceToPlayerInCover;

//***********************************************************************
// Default Properties
//***********************************************************************
