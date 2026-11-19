
class SeqAct_FollowActor extends SeqAct_Latent;

var Actor FollowTarget;
var() bool bStopFollowing;

var ()float m_FollowBandMaxRange;	// The Distance to let my target move away before I start to follow again.	
var ()float m_FollowBandMinRange;	// the distance away to be when I have stopped moving towards my follow target

var ()bool			m_bAllowWaitingForPathToTargetToClear;
var ()bool			m_bAllowWanderingWhileWaiting;
var	()float			m_TimeToWaitBetweenPathChecks;

var ()int			m_NoOfTimesToCheckForPathToTarget;
var ()int			m_NoOfTimesPathHasBeenTried;

var ()bool			m_bAllowAttackWhileWaitingForPathToClear;

var ()bool			m_bTaskFailedWhenPathCanNotBeFound;


