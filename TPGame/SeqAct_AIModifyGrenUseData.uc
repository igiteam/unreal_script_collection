
class SeqAct_AIModifyGrenUseData extends SeqAct_Latent;


//***********************************************************************
// Variables
//***********************************************************************
/** keeps the focus on the target actor or clears it */
var ()  bool			m_bCanUseGrenades;
var ()  bool			m_bCalcUpperArcForAuto;

var ()  bool			m_bAlwaysThrowAgainstPlayerCamper;

var ()  float			m_ChanceToUseGrenadeByOwnWill;
var ()  float			m_HowOfftenInSecsToCheckChanceToUseGrenade;
var ()  float			m_TimeToWaitAfterThrownGrenadeToTryAgain;

var ()  int				m_MaxNumberOfGrenadesToThrow;

var() float				m_TossSpeed;
var() float				m_BaseTossZ;
var() float				m_DesiredZPct;
//***********************************************************************
// Default Properties
//***********************************************************************
