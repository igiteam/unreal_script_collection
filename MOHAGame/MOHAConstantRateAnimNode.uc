class MOHAConstantRateAnimNode extends AnimNodeSequence
    native
    hidecategories(Object,Object);

// Export UMOHAConstantRateAnimNode::execPlayAnim(FFrame&, void* const)
native function PlayAnim(optional bool bLoop, optional float InRate, optional float StartTime);
