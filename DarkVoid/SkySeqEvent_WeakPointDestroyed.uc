class SkySeqEvent_WeakPointDestroyed extends SequenceEvent
    native;

var int Index;

// Export USkySeqEvent_WeakPointDestroyed::execWeakPointDestroyed(FFrame&, void* const)
native function WeakPointDestroyed(SkyPawn InOriginator, Actor InInstigator, int InIndex);
