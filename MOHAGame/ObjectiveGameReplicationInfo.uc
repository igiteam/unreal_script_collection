class ObjectiveGameReplicationInfo extends AirborneModeGameReplicationInfo
    native
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var repnotify MPObjective_FLAG.EMPObjectiveFlagState FlagObjectiveState[8];
var repnotify float FlagCaptureTimers[8];
var repnotify int FlagActiveMembers[8];
var array<MPObjective_FLAG> FlagObjectiveArray;

replication
{
    // Pos:0x000
    if(bNetDirty && int(Role) == int(ROLE_Authority)
        FlagActiveMembers, FlagCaptureTimers, 
        FlagObjectiveState;
}

// Export UObjectiveGameReplicationInfo::execSortFlagObjectiveArray(FFrame&, void* const)
native final function SortFlagObjectiveArray();

simulated function PostBeginPlay()
{
    local MPObjective_FLAG mpFObj;

    super.PostBeginPlay();
    // End:0x26
    foreach DynamicActors(Class'MPObjective_FLAG', mpFObj)
    {
        AddFlagObjective(mpFObj);        
    }    
    //return;    
}

simulated function Timer()
{
    super(MOHAGameReplicationInfo).Timer();
    //return;    
}

function UpdateFlagObjective(MPObjective_FLAG mpObj)
{
    // End:0xA6
    if((mpObj.m_iGRIIndex >= 0) && mpObj.m_iGRIIndex < 8)
    {
        FlagObjectiveState[mpObj.m_iGRIIndex] = mpObj.m_State;
        FlagCaptureTimers[mpObj.m_iGRIIndex] = mpObj.captureTimer;
        FlagActiveMembers[mpObj.m_iGRIIndex] = mpObj.AlliedActivaterArray.Length + mpObj.AxisActivaterArray.Length;
    }
    //return;    
}

simulated function AddFlagObjective(MPObjective_FLAG mpObj)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x5C [Loop If]
    if(I < FlagObjectiveArray.Length)
    {
        // End:0x2E
        if(FlagObjectiveArray[I] == mpObj)
        {
            return;
        }
        // End:0x52
        if(FlagObjectiveArray[I] == none)
        {
            FlagObjectiveArray.Remove(I, 1);
            I--;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    I = FlagObjectiveArray.Length;
    FlagObjectiveArray[I] = mpObj;
    FlagObjectiveState[I] = mpObj.m_State;
    mpObj.m_iGRIIndex = I;
    SortFlagObjectiveArray();
    return;
    //return;    
}

simulated function RemoveFlagObjective(MPObjective_FLAG mpObj)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x4A [Loop If]
    if(I < FlagObjectiveArray.Length)
    {
        // End:0x40
        if(FlagObjectiveArray[I] == mpObj)
        {
            FlagObjectiveArray.Remove(I, 1);
            SortFlagObjectiveArray();
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    local array<SequenceObject> AllRWREvents;
    local SeqEvent_RoundWinnerReplicated RWREvent;
    local Sequence GameSeq;
    local array<int> RWREventImpulses;
    local int idx;

    super.ReplicatedEvent(VarName);
    // End:0xB3
    if(VarName == 'LastRoundWinningTeam')
    {
        GameSeq = WorldInfo.GetGameSequence();
        // End:0xB0
        if(GameSeq != none)
        {
            RWREventImpulses[0] = 0;
            GameSeq.FindSeqObjectsByClass(Class'SeqEvent_RoundWinnerReplicated', true, AllRWREvents);
            idx = 0;
            J0x68:

            // End:0xB0 [Loop If]
            if(idx < AllRWREvents.Length)
            {
                RWREvent = SeqEvent_RoundWinnerReplicated(AllRWREvents[idx]);
                RWREvent.CheckActivate(self, self, false, RWREventImpulses);
                idx++;
                // [Loop Continue]
                goto J0x68;
            }
        }        
    }
    else
    {
        // End:0x165
        if(VarName == 'FlagObjectiveState')
        {
            idx = 8;
            // End:0xEA
            if(idx > FlagObjectiveArray.Length)
            {
                idx = FlagObjectiveArray.Length;
            }
            idx = idx - 1;
            J0xF8:

            // End:0x160 [Loop If]
            if(idx >= 0)
            {
                FlagObjectiveArray[idx].ChangeState(FlagObjectiveState[idx]);
                FlagObjectiveArray[idx].MakeRopeSoundDecision(FlagActiveMembers[idx], FlagObjectiveState[idx]);
                idx--;
                // [Loop Continue]
                goto J0xF8;
            }
            return;            
        }
        else
        {
            // End:0x20D
            if(VarName == 'FlagCaptureTimers')
            {
                idx = 8;
                // End:0x19C
                if(idx > FlagObjectiveArray.Length)
                {
                    idx = FlagObjectiveArray.Length;
                }
                idx = idx - 1;
                J0x1AA:

                // End:0x208 [Loop If]
                if(idx >= 0)
                {
                    FlagObjectiveArray[idx].captureTimer = FlagObjectiveArray[idx].inProgressToCaptureTimer;
                    FlagObjectiveArray[idx].inProgressToCaptureTimer = FlagCaptureTimers[idx];
                    idx--;
                    // [Loop Continue]
                    goto J0x1AA;
                }
                return;                
            }
            else
            {
                // End:0x298
                if(VarName == 'FlagActiveMembers')
                {
                    idx = 8;
                    // End:0x244
                    if(idx > FlagObjectiveArray.Length)
                    {
                        idx = FlagObjectiveArray.Length;
                    }
                    idx = idx - 1;
                    J0x252:

                    // End:0x296 [Loop If]
                    if(idx >= 0)
                    {
                        FlagObjectiveArray[idx].MakeRopeSoundDecision(FlagActiveMembers[idx], FlagObjectiveState[idx]);
                        idx--;
                        // [Loop Continue]
                        goto J0x252;
                    }
                    return;
                }
            }
        }
    }
    //return;    
}

defaultproperties
{
    GameClass=Class'ObjectiveGameInfo'
}