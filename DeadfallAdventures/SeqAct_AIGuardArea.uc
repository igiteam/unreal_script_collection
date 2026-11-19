class SeqAct_AIGuardArea extends SeqAct_AIMoveToActor
    forcescriptorder(true)
    hidecategories(Object);

var() float GuardAreaRadius;
var() float GuardAttackThreshold;
var() float DistanceAttackRangeBonus;

defaultproperties
{
    DistanceAttackRangeBonus=500.0000000
    ObjName="Guard Area"
}