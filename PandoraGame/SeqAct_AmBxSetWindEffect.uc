class SeqAct_AmBxSetWindEffect extends SequenceAction;

var() float Speed;
var() float DurationSeconds;
var() PlayerPawn.eAmBxCompassDir DirectionFrom;
var PlayerPawn.eAmBxCompassDir m_PrimaryRelativeWindDir;
var PlayerPawn.eAmBxCompassDir m_LastRelativeWindDir;
var PlayerPawn.eAmBxCompassDir m_2ndryRightRelativeWindDir;
var PlayerPawn.eAmBxCompassDir m_2ndryLeftRelativeWindDir;
var float m_TimeStarted;
var float m_LastTimeUpdate;
var int m_RelativeWindYaw;
