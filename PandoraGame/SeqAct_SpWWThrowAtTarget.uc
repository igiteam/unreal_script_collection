class SeqAct_SpWWThrowAtTarget extends SequenceAction
    native;

/** VARIABLE DECLARATIONS */
var() float ThrowTime;
var() bool PreventEatingFoodUntilComplete;
/** Only applicable for defined throw lists */
var() bool ExitWhenDefThrowablesExhausted;
/** Is more restrictive in preventing the werewolf from changing from defined target CPP Text */
var() bool EnforceEnemyTarget;
