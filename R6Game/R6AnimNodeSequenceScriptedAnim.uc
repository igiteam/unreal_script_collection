class R6AnimNodeSequenceScriptedAnim extends AnimNodeSequence
    native
    hidecategories(Object,Object,Object);

var() bool m_bIsFacialAnim;

// Export UR6AnimNodeSequenceScriptedAnim::execSetAnim(FFrame&, void* const)
native function SetAnim(name Sequence, optional bool bIsScripted);
