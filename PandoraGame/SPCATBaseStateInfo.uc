class SPCATBaseStateInfo extends Object
    abstract
    native;

var float AttackTimeStamp;
var float DefenseTimeStamp;
/** ATTACK STATE VARIABLES: 1.  add an editable variable that can be modified in AttackProperty in the editor 2.  add an internal bool variable to track the runtime state that corresponds to whether the value in #1 passes our state test.   (This is only required if the value is cacheable...Cacheable values will not be recomputed in the same frame) 3.  add code to either UpdateCacheableAttackState or UpdateNonCacheableAttackState, depending upon if your value was cacheable 4.  add code to either CheckCachedAttackState or CheckNonCachedAttackState, depending upon if your value was cacheable Note:  to distinguish if a property can be cacheable or not, you need to ask yourself "Can I compute this value without access to the AttackProperty on the Animation?"  If no, then the value is not cacheable.  For example, consider health.  Each property may have a different health value, so we can't cache whether we have more or less than a variable value.  However, if the value is costly to compute, you probably need to find a way to make it cacheable.  Boolean values tend to be cacheable */
var(Attack) bool bRequiresDirectReachability;
var bool bIsDirectlyReachable;
/** number of hit points remaining in order for the state test to pass CPP TEXT                             NATIVE FUNCTION DECLARATIONS FUNCTION DECLARATIONS FUNCTIONS/STATES----------------------------------------------------------------------- Function: Description:----------------------------------------------------------------------- Default Properties */
var(Defense) int HealthRemaining;
