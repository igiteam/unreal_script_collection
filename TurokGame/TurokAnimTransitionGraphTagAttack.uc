class TurokAnimTransitionGraphTagAttack extends TurokAnimTransitionGraphTag
    native
    editinlinenew
    hidecategories(Object);

var(Attack) float mAttackDamage;
var(Attack) float mAttackDamageTimeStart;
var(Attack) float mAttackDamageTimeEnd;
var(Attack) float mAttackImpulseZ;
var(Attack) float mAttackImpulseScale;
var(Attack) float mAttackImpulseDuration;
var(Attack) bool mAttackCausesKnockdown;
var(Attack) bool mAttackCausesScreenShake;
var(Attack) byte mHurtType;
var(Attack) float mHurtRadius;
var(Attack) export editinline @NULL mAttackScreenShakeParams;
var(Attack) float mAttackScreenShakeDuration;
var(Attack) float mAttackScreenShakeRadius;

defaultproperties
{
    mAttackDamage=10.0000000
    mAttackDamageTimeStart=0.3500000
    mAttackDamageTimeEnd=0.3500000
    mAttackImpulseZ=20.0000000
    mAttackImpulseScale=300.0000000
    mAttackImpulseDuration=0.4000000
    mHurtType=1
    mHurtRadius=70.0000000
    // Reference: TurokParametricShakeComponent'Default__TurokAnimTransitionGraphTagAttack.TurokAttackTag'
    begin object name=TurokAttackTag class=Class'TurokParametricShakeComponent'
    end object
    mAttackScreenShakeParams=TurokAttackTag
    mAttackScreenShakeDuration=1.0000000
    mAttackScreenShakeRadius=500.0000000
}