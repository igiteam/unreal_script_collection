class EvilUtilBasedAICmdMetaDataPacket extends Object;

var float LastActivationTime;
var float LastDeactivationTime;
var int NumberOfActivations;
var float ActualPriority;
var(PKAI) float DelayBetweenActivations;
var bool bActive;
var class<EvilAICmd_Base_UtilitySelectedCmd> CommandClass;
