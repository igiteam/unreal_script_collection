class CCHistoryEventStimulus extends CCHistoryEvent
    native
    hidecategories(Object,Object);

var CCStimulusType StimulusType;
var Actor SourceActor;

// Export UCCHistoryEventStimulus::execIsEquivalentTo(FFrame&, void* const)
native function bool IsEquivalentTo(CCHistoryEvent OtherEvent);

// Export UCCHistoryEventStimulus::execGetMaxHistoryLength(FFrame&, void* const)
native function int GetMaxHistoryLength();

function string GetDebugString()
{
    local string DebugString;

    DebugString = super.GetDebugString();
    // End:0x4A
    if(none != StimulusType)
    {
        DebugString = (DebugString $ ", StimulusType=") $ string(StimulusType.Name);        
    }
    else
    {
        DebugString = DebugString $ ", StimulusType=none";
    }
    // End:0xA9
    if(none != SourceActor)
    {
        DebugString = (DebugString $ ", SourceActor=") $ string(SourceActor.Name);        
    }
    else
    {
        DebugString = DebugString $ ", SourceActor=none";
    }
    return DebugString;
    //return ReturnValue;    
}
