class SkySeqAct_SquadProperties extends SequenceAction
    native;

var() array<SkySquadInfo> Squads;
var() array<Object> AreasOfOperation;
var int NumAlive;
var() float MaxEnemyProximityToLeader;
var bool bTriggeredLeaderProximity;
var bool bTriggeredVitalityThreshold;
var private bool bStarted;
var private bool bCancel;
var() float TotalVitalityThreshold;
var() SkySquadInfo.SquadAssignment NewSquadAssigment;
var int PendingDeathActivates;

// Export USkySeqAct_SquadProperties::execReset(FFrame&, void* const)
native function Reset();

// Export USkySeqAct_SquadProperties::execTriggerDeath(FFrame&, void* const)
native function TriggerDeath(Controller Killed, Pawn KilledPawn, bool bLeader);

static event int GetObjClassVersion()
{
    return 3;
    //return ReturnValue;    
}
