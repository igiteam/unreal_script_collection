class SkySeqEvent_Used extends SequenceEvent
    native;

var() int UsesBeforeTrigger;
var int NumTimesUsed;

// Export USkySeqEvent_Used::execUsed(FFrame&, void* const)
native function Used(SkyLimitedUseInteractor InOriginator, SkyInteractor InInstigator);

function Reset()
{
    super.Reset();
    NumTimesUsed = 0;
    //return;    
}
