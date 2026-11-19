class CCPerformanceState extends Object
    native
    editinlinenew
    hidecategories(Object);

const _CC_CHANNEL_COUNT = 4;

enum EChannel
{
    CC_CHANNEL_AUDIO,               // 0
    CC_CHANNEL_PA_LOOK_AT,          // 1
    CC_CHANNEL_EXPRESSION,          // 2
    CC_CHANNEL_OUTPUT_STIM,         // 3
    CC_CHANNEL_COUNT,               // 4
    CC_CHANNEL_MAX                  // 5
};

var export editinline CCPerformerNative CCP;
var bool bInProgress;
var CCPerformance2 Performance;
var CCAudioPerformanceRequest APR;
var float StartTime_sec;
var float PerformanceDuration_sec;
var float ChannelDuration_sec[4];
var CCStimulus Stimulus;
var int CurrentPriority;
var export editinline CCChannelState ChannelState[4];

// Export UCCPerformanceState::execIsNonIdlePerformanceInProgress(FFrame&, void* const)
native function bool IsNonIdlePerformanceInProgress();

// Export UCCPerformanceState::execIsIdlePerformanceInProgress(FFrame&, void* const)
native function bool IsIdlePerformanceInProgress();

// Export UCCPerformanceState::execTick(FFrame&, void* const)
native function Tick(float DeltaTime_sec_UNUSED);

// Export UCCPerformanceState::execIsPerformanceFinished(FFrame&, void* const)
native function bool IsPerformanceFinished(float PerformanceLocalTime_sec);

// Export UCCPerformanceState::execGetPerformanceLocalTime_sec(FFrame&, void* const)
native function float GetPerformanceLocalTime_sec();

// Export UCCPerformanceState::execIsAudioChannelInProgress(FFrame&, void* const)
native function bool IsAudioChannelInProgress();

// Export UCCPerformanceState::execClearCurrentPriority(FFrame&, void* const)
native function ClearCurrentPriority();

function PostBeginPlay(CCPerformer InCCP, int TeamIndex)
{
    local int ChIndex;

    CCP = InCCP;
    ChIndex = 0;
    J0x12:

    // End:0x47 [Loop If]
    if(ChIndex < 4)
    {
        ChannelState[ChIndex].PostBeginPlay(self, TeamIndex);
        ++ChIndex;
        // [Loop Continue]
        goto J0x12;
    }
    //return;    
}

event StopPerformance(optional bool bStartingNewPerformance = false)
{
    local float PerformanceLocalTime_sec;
    local int ChIndex;

    // End:0xCA
    if(bInProgress)
    {
        PerformanceLocalTime_sec = GetPerformanceLocalTime_sec();
        ChIndex = 0;
        J0x25:

        // End:0x59 [Loop If]
        if(ChIndex < 4)
        {
            ChannelState[ChIndex].StopChannel(PerformanceLocalTime_sec);
            ++ChIndex;
            // [Loop Continue]
            goto J0x25;
        }
        bInProgress = false;
        ClearCurrentPriority();
        // End:0xA2
        if((none != CCP) && CCP.Owner_IsAIPaused())
        {
            CCP.Owner_PauseAI(0);
        }
        CCP.OnPerformanceComplete(Stimulus.StimulusType, bStartingNewPerformance);
    }
    //return;    
}

// Export UCCPerformanceState::execStartPerformance(FFrame&, void* const)
native function StartPerformance(CCPerformance2 InPerformance, CCStimulus InResponseToStimulus, CCAudioPerformanceRequest InAPR);

defaultproperties
{
    APR=(bEnabled=false,NIndex=-1,VIndex=-1,OIndex=-1,AIndex=-1,Dist2=0.0000000)
    CurrentPriority=-1
    // Reference[0]: CCChannelStateAudio'Default__CCPerformanceState.AudioState'
    begin object name=AudioState class=Class'CCChannelStateAudio'
    end object
    ChannelState=AudioState
    // Reference: CCChannelStatePALookAt'Default__CCPerformanceState.PALookAtState'
    begin object name=PALookAtState class=Class'CCChannelStatePALookAt'
    end object
    ChannelState=PALookAtState
    // Reference: CCChannelStateExpression'Default__CCPerformanceState.ExpressionState'
    begin object name=ExpressionState class=Class'CCChannelStateExpression'
    end object
    ChannelState=ExpressionState
    // Reference: CCChannelStateOutputStim'Default__CCPerformanceState.OutputStimState'
    begin object name=OutputStimState class=Class'CCChannelStateOutputStim'
    end object
    ChannelState=OutputStimState
}