class SkySquadInfo extends Info
    native;

enum SquadAssignment
{
    SA_Default,                     // 0
    SA_Assaulting,                  // 1
    SA_Flanking,                    // 2
    SA_Retreating,                  // 3
    SA_MAX                          // 4
};

var name SquadName;
var SkyBot SquadLeader;
var array<SkyBot> SquadMembers;
var array<int> AreasOfOperation;
var array<SkyAreaOfOperationVolume> AOVolumes;
var transient SkySquadInfo NextSquad;
var array<SkySeqAct_SquadProperties> KismetEvents;
var SkySquadInfo.SquadAssignment CurrentAssignment;

event bool IsMemberOf(SkyBot C)
{
    local int Idx;

    Idx = 0;
    J0x07:

    // End:0x38 [Loop If]
    if(Idx < SquadMembers.Length)
    {
        // End:0x2E
        if(SquadMembers[Idx] == C)
        {
            return true;
        }
        ++Idx;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    //return ReturnValue;    
}

event NotifyKilled(Controller Killed, Pawn KilledPawn)
{
    local int Idx;

    Idx = 0;
    J0x07:

    // End:0x44 [Loop If]
    if(Idx < SquadMembers.Length)
    {
        // End:0x3A
        if(SquadMembers[Idx] == Killed)
        {
            SquadMembers.Remove(Idx--, 1);
        }
        ++Idx;
        // [Loop Continue]
        goto J0x07;
    }
    // End:0xAA
    if(!KilledPawn.bDestroyedByAIFactory)
    {
        Idx = 0;
        J0x60:

        // End:0xAA [Loop If]
        if(Idx < KismetEvents.Length)
        {
            KismetEvents[Idx].TriggerDeath(Killed, KilledPawn, Killed == SquadLeader);
            ++Idx;
            // [Loop Continue]
            goto J0x60;
        }
    }
    // End:0xC0
    if(SquadLeader == Killed)
    {
        SquadLeader = none;
    }
    //return;    
}

// Export USkySquadInfo::execAddToSquad(FFrame&, void* const)
native final function bool AddToSquad(SkyBot ControllerToAdd, optional bool bIsLeader);

// Export USkySquadInfo::execRemoveFromSquad(FFrame&, void* const)
native final function bool RemoveFromSquad(SkyBot ControllerToRemove);

// Export USkySquadInfo::execIsInSquad(FFrame&, void* const)
native final function bool IsInSquad(SkyBot ControllerToCheck);

// Export USkySquadInfo::execSubsumeSquad(FFrame&, void* const)
native final function bool SubsumeSquad(SkySquadInfo OtherSquad);

// Export USkySquadInfo::execDisbandSquad(FFrame&, void* const)
native final function bool DisbandSquad();

// Export USkySquadInfo::execModifyAreaOfOperation(FFrame&, void* const)
native final function bool ModifyAreaOfOperation(array<int> NewAreaOfOperation, array<SkyAreaOfOperationVolume> NewVolumes);

// Export USkySquadInfo::execIsInAreaOfOperation(FFrame&, void* const)
native final function bool IsInAreaOfOperation(NavigationPoint NavPt);

// Export USkySquadInfo::execIsVolumeInAreaOfOperation(FFrame&, void* const)
native final function bool IsVolumeInAreaOfOperation(SkyAreaOfOperationVolume Vol);

// Export USkySquadInfo::execIsPointInAreaOfOperation(FFrame&, void* const)
native final function bool IsPointInAreaOfOperation(const out Vector Loc);

// Export USkySquadInfo::execGetClosestPointInAO(FFrame&, void* const)
native final function NavigationPoint GetClosestPointInAO(Actor GoalActor, optional Vector GoalLocation);
