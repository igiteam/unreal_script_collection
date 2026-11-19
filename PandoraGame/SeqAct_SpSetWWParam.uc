class SeqAct_SpSetWWParam extends SequenceAction
    native;

/** VARIABLE DECLARATIONS */
var() bool bSetNewDistTargetingWeight;
var() bool bSetNewLocalDistTargetingWeight;
/** New weighting amount that gets multiplied against actual path distance for determining distance score */
var() float NewDistTargetingWeight;
/** New weighting amount that gets multiplied against direct linear path distance for determining distance score if actual path dist is zero CPP Text */
var() float NewLocalDistTargetingWeight;
