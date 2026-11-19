class R6SoundPriorityConfig extends R6Config
    native
    hidecategories(Object);

var(CommonSoundPriorities) editconst int m_iNoPriority;
var(CommonSoundPriorities) int m_iAmmunitionProblem;
var(CommonSoundPriorities) int m_iScriptedEvent;
var(CommonSoundPriorities) int m_iBlinded;
var(CommonSoundPriorities) int m_iStruggling;
var(CommonSoundPriorities) int m_iChocking;
var(CommonSoundPriorities) int m_iWoundedBurnedExplo;
var(CommonSoundPriorities) int m_iDeathCry;
var(CommonSoundPriorities) int m_iMaxPriority;
var(RainbowSoundPriorities) int m_iOrdersGiven;
var(RainbowSoundPriorities) int m_iOrderAcknowledgement;
var(RainbowSoundPriorities) int m_iOrderStarting;
var(RainbowSoundPriorities) int m_iOrderCompleted;
var(RainbowSoundPriorities) int m_iReactingToEnemySpotting;
var(RainbowSoundPriorities) int m_iReactingToEnemyTactics;
var(RainbowSoundPriorities) int m_iReactingToEnemyRetreating;
var(RainbowSoundPriorities) int m_iReactingToEnemyKilled;
var(RainbowSoundPriorities) int m_iPlayerIdle;
var(RainbowSoundPriorities) int m_iPlayerWeirdBehavior;
var(RainbowSoundPriorities) int m_iRainbowSwitchingStates;
var(RainbowSoundPriorities) int m_iFiredAt;
var(RainbowSoundPriorities) int m_iFFTeamateShot;
var(RainbowSoundPriorities) int m_iFFCivilianShot;
var(RainbowSoundPriorities) int m_iFFCivilianShotStrikeThree;
var(RainbowSoundPriorities) int m_iFFHostageShot;
var(RainbowSoundPriorities) int m_iNeutralSpotted;
var(RainbowSoundPriorities) int m_iPraise;
var(RainbowSoundPriorities) int m_iTeamKill;
var(RainbowSoundPriorities) int m_iRainbowAllyDown;
var(RainbowSoundPriorities) int m_iHealingRequest;
var(RainbowSoundPriorities) int m_iTalkingToCivilian;
var(RainbowSoundPriorities) int m_iPlayerHurt;
var(RainbowSoundPriorities) int m_iPlayerStatusAffected;
var(TerroristSoundPriorities) int m_iReactionToNonThreateningNoises;
var(TerroristSoundPriorities) int m_iReactionToThreatNoisesReacting;
var(TerroristSoundPriorities) int m_iReactionToThreatNoisesContactBroken;
var(TerroristSoundPriorities) int m_iReactionToThreatNoisesNothing;
var(TerroristSoundPriorities) int m_iReactionToThreatNoisesIncoming;
var(TerroristSoundPriorities) int m_iFiringAction;
var(TerroristSoundPriorities) int m_iTerroristSwitchingStates;
var(TerroristSoundPriorities) int m_iThrowGrenade;
var(TerroristSoundPriorities) int m_iCoordinationInitiate;
var(TerroristSoundPriorities) int m_iCoordinationActions;
var(TerroristSoundPriorities) int m_iTeamCombat;
var(TerroristSoundPriorities) int m_iTeamCombatGoCode;
var(TerroristSoundPriorities) int m_iTeamCombatInPosition;
var(TerroristSoundPriorities) int m_iCombatCoordinated;
var(TerroristSoundPriorities) int m_iGenericCombatLines;
var(TerroristSoundPriorities) int m_iTauntPlayer;
var(TerroristSoundPriorities) int m_iSpecialAction;
var(TerroristSoundPriorities) int m_iSpecialMove;
var(TerroristSoundPriorities) int m_iShootSteamPipes;
var(TerroristSoundPriorities) int m_iTerroristAllyDown;
var(TerroristSoundPriorities) int m_iTerroristAllyKilled;
var(TerroristSoundPriorities) int m_iEnemyContact;
var(TerroristSoundPriorities) int m_iEnemyLost;
var(TerroristSoundPriorities) int m_iExecuteRainbow;
var(TerroristSoundPriorities) int m_iIdleChatter;
var(TerroristSoundPriorities) int m_iEnemyContactReportToLeader;
var(CivilianSoundPriorities) int m_iRespondToRainbows;
var(CivilianSoundPriorities) int m_iSpotRainbows;
var(CivilianSoundPriorities) int m_iPanic;
var(CivilianSoundPriorities) int m_iSeesTerroristDied;

defaultproperties
{
    m_iAmmunitionProblem=40
    m_iScriptedEvent=77
    m_iBlinded=80
    m_iStruggling=93
    m_iChocking=95
    m_iWoundedBurnedExplo=96
    m_iDeathCry=99
    m_iMaxPriority=100
    m_iOrdersGiven=88
    m_iOrderAcknowledgement=82
    m_iOrderStarting=82
    m_iOrderCompleted=82
    m_iReactingToEnemySpotting=70
    m_iReactingToEnemyTactics=70
    m_iReactingToEnemyRetreating=70
    m_iReactingToEnemyKilled=70
    m_iPlayerIdle=1
    m_iPlayerWeirdBehavior=10
    m_iRainbowSwitchingStates=20
    m_iFiredAt=65
    m_iFFTeamateShot=97
    m_iFFCivilianShot=86
    m_iFFCivilianShotStrikeThree=90
    m_iFFHostageShot=80
    m_iNeutralSpotted=71
    m_iPraise=15
    m_iTeamKill=98
    m_iRainbowAllyDown=74
    m_iHealingRequest=75
    m_iTalkingToCivilian=50
    m_iPlayerHurt=49
    m_iPlayerStatusAffected=49
    m_iReactionToNonThreateningNoises=58
    m_iReactionToThreatNoisesReacting=63
    m_iReactionToThreatNoisesContactBroken=65
    m_iReactionToThreatNoisesNothing=60
    m_iReactionToThreatNoisesIncoming=68
    m_iFiringAction=50
    m_iTerroristSwitchingStates=55
    m_iThrowGrenade=53
    m_iCoordinationInitiate=76
    m_iCoordinationActions=75
    m_iTeamCombat=75
    m_iTeamCombatGoCode=74
    m_iTeamCombatInPosition=73
    m_iCombatCoordinated=75
    m_iGenericCombatLines=5
    m_iTauntPlayer=5
    m_iSpecialAction=20
    m_iSpecialMove=20
    m_iShootSteamPipes=20
    m_iTerroristAllyDown=74
    m_iTerroristAllyKilled=74
    m_iEnemyContact=56
    m_iEnemyLost=58
    m_iExecuteRainbow=85
    m_iIdleChatter=1
    m_iEnemyContactReportToLeader=97
    m_iRespondToRainbows=50
    m_iSpotRainbows=45
    m_iPanic=40
    m_iSeesTerroristDied=42
    m_szDescription="Sound Priority"
}