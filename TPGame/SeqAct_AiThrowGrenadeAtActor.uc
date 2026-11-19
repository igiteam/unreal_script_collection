class SeqAct_AiThrowGrenadeAtActor extends SequenceAction;

//var() float  CookTime;
var() float  m_TimeToSmoke;
var() bool   m_bUseSmokeGrenade;

var () float m_FuesTime;


var () bool	m_bUseAgainstCurrentEnemy;
var () bool	m_bCalcUpperArcForTask;


var () bool	m_bCheckMinDistToTarget;
var () bool	m_bCheckMaxDistToTarget;
var () bool	m_bCheckMinDistToFriendly;
var () bool m_bUseDynamicTacticalThrowing;

var () bool m_bThrowGrenadeEvenIfNoGoodArc;

var () float	m_MinDistToTarget;
var () float	m_MaxDistToTarget;
var () float	m_MinDistToFriendly;

var () int	m_NumberOfTimesToTryIfFailureToThrow;

