class CCHistoryEvent extends Object
    native
    hidecategories(Object);

var float Time_sec;

// Export UCCHistoryEvent::execIsEquivalentTo(FFrame&, void* const)
native function bool IsEquivalentTo(CCHistoryEvent OtherEvent);

// Export UCCHistoryEvent::execGetMaxHistoryLength(FFrame&, void* const)
native function int GetMaxHistoryLength();

// Export UCCHistoryEvent::execGetMaxAge_sec(FFrame&, void* const)
native function float GetMaxAge_sec();

function string GetDebugString()
{
    return "Time_sec=" $ string(Time_sec);
    //return ReturnValue;    
}
