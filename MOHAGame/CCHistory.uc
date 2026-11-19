class CCHistory extends Object
    native
    hidecategories(Object);

enum EAgeAttenuationFunction
{
    CC_AGEFUNC_ALWAYS_REPEAT,       // 0
    CC_AGEFUNC_NEVER_REPEAT,        // 1
    CC_AGEFUNC_LINEAR,              // 2
    CC_AGEFUNC_MAX                  // 3
};

var init array<init CCHistoryEvent> HistoricalEvents;
var CCDirectorNative Director;
var int HighWater;

// Export UCCHistory::execClearHistory(FFrame&, void* const)
native function ClearHistory();

// Export UCCHistory::execPurgeStaleEvents(FFrame&, void* const)
native function PurgeStaleEvents(float CurrentTime_sec);

// Export UCCHistory::execRecordEvent(FFrame&, void* const)
native function RecordEvent(CCHistoryEvent Event, float CurrentTime_sec);

// Export UCCHistory::execFindEventIndex(FFrame&, void* const)
native function int FindEventIndex(CCHistoryEvent Event);

// Export UCCHistory::execFindEventTime_sec(FFrame&, void* const)
native function bool FindEventTime_sec(CCHistoryEvent Event, out float Time_sec);

private static final function float CalculateAgeAttenuationFactor_Linear(float Age_sec, float AttenuationMin_sec, float AttenuationMax_sec)
{
    local float Slope_invsec, Delta_sec, Factor;

    // End:0x18
    if(Age_sec <= AttenuationMin_sec)
    {
        return 0.0000000;        
    }
    else
    {
        // End:0x30
        if(Age_sec >= AttenuationMax_sec)
        {
            return 1.0000000;            
        }
        else
        {
            Slope_invsec = 1.0000000 / (AttenuationMax_sec - AttenuationMin_sec);
            Delta_sec = Age_sec - AttenuationMin_sec;
            Factor = Delta_sec * Slope_invsec;
            return Factor;
        }
    }
    //return ReturnValue;    
}

static event float CalculateAgeAttenuationFactor(float Age_sec, CCHistory.EAgeAttenuationFunction AttenuationFunc, float AttenuationMin_sec, float AttenuationMax_sec)
{
    switch(AttenuationFunc)
    {
        // End:0x12
        case 0:
            return 1.0000000;
        // End:0x1D
        case 1:
            return 0.0000000;
        // End:0x38
        case 2:
            return CalculateAgeAttenuationFactor_Linear(Age_sec, AttenuationMin_sec, AttenuationMax_sec);
        // End:0xFFFF
        default:
            return 1.0000000;
            break;
    }
    //return ReturnValue;    
}

function PrintHistory(float CurrentTime_sec, Canvas Canvas)
{
    local int EIndex;
    local float MaxAge_sec, Age_sec;
    local CCHistoryEvent E;
    local string printMe;
    local CCHistoryEventStimulus stimEvent;

    // End:0x1CF
    if(HistoricalEvents.Length > 0)
    {
        MaxAge_sec = HistoricalEvents[0].GetMaxAge_sec();
        Canvas.__NFUN_465__((("Current time: " $ string(CurrentTime_sec)) $ " Max age: ") $ string(MaxAge_sec));
        EIndex = 0;
        J0x6C:

        // End:0x1CF [Loop If]
        if(EIndex < HistoricalEvents.Length)
        {
            E = HistoricalEvents[EIndex];
            Age_sec = CurrentTime_sec - E.Time_sec;
            printMe = "" $ string(E.Class);
            printMe = (printMe @ "Age: ") $ string(Age_sec);
            stimEvent = CCHistoryEventStimulus(E);
            // End:0x1B2
            if(stimEvent != none)
            {
                printMe = printMe @ string(stimEvent.StimulusType);
                printMe = (printMe @ "From: ") $ string(stimEvent.SourceActor);
                printMe = (printMe @ "Probability: ") $ string(CalculateAgeAttenuationFactor(Age_sec, stimEvent.StimulusType.AgeAttenuationFunc, stimEvent.StimulusType.AgeAttenuationMin_sec, stimEvent.StimulusType.AgeAttenuationMax_sec));
            }
            Canvas.__NFUN_465__(printMe);
            ++EIndex;
            // [Loop Continue]
            goto J0x6C;
        }
    }
    //return;    
}
