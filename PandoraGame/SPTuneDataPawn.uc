class SPTuneDataPawn extends Object
    native
    editinlinenew;

struct native SPFloatRange
{
    /**  
     *struct native DamageTypeConditionMatch
     *{
     *var()constintCondition;
     *var()class<DamageType>DamageTypeClass;
     *
     *structdefaultproperties
     *{
     *Condition = 0;
     *}
     *};
     */
    var() float Min;
    /**  
     *struct native DamageTypeConditionMatch
     *{
     *var()constintCondition;
     *var()class<DamageType>DamageTypeClass;
     *
     *structdefaultproperties
     *{
     *Condition = 0;
     *}
     *};
     */
    var() float Max;

    structdefaultproperties
    {
        Min=0.0000000
        Max=0.0000000
    }
};

struct native SPIntRange
{
    var() int Min;
    var() int Max;

    structdefaultproperties
    {
        Min=0
        Max=0
    }
};

var(Common) const int HitPoints;
/** Just change this to run the validation routine. */
var(Common) const bool changeToValidate;
/** poking may get culled out at distance factors LESS than this (distance factor is a % of screen size) */
var(LOD) const float MinDistanceFactorForPoking;
/** poking may get culled out at distance factors GREATER than this (it represents horizontal distance from the center of the screen) */
var(LOD) const float MaxHorizontalDistanceFactorForPoking;
/** poking may get culled out at distance factors GREATER than this (it represents vertical distance from the center of the screen) a structure that is used in conjuction with SPDeathDamageTypeEvaluator.  This structure matches damage types to indices used by the evaluator Damage Levels:  if you have questions about these settings ask Brad */
var(LOD) const float MaxVerticalDistanceFactorForPoking;
var(EvaluatorDamageLevel) const array<DamageTypeConditionMatch> DamageTypeToDamageLevel;
