class SeqAct_ModifyAIProperties extends SequenceAction
    native;

/** class of object to modify */
var() class<SPPawn> SPPawnClass;
var class<SPPawn> PrevSPPawnClass;
var() editinline array<editinline PropertyInfo> SPPawnProperties;
var() editinline array<editinline PropertyInfo> SPAIControllerProperties;
