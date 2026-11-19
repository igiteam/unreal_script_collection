class CCHistoryEventAudioPerformance extends CCHistoryEvent
    native
    hidecategories(Object,Object);

var string AudioPerformanceID;

// Export UCCHistoryEventAudioPerformance::execIsEquivalentTo(FFrame&, void* const)
native function bool IsEquivalentTo(CCHistoryEvent OtherEvent);

function string GetDebugString()
{
    return (super.GetDebugString() $ ", AudioPerformanceID=") $ AudioPerformanceID;
    //return ReturnValue;    
}
