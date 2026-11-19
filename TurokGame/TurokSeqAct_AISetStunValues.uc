class TurokSeqAct_AISetStunValues extends SequenceAction
    hidecategories(Object);

var() float mStunMultiplier;
var() float mMaxStunMovementFactor;
var() float mStunDamageTime;
var() int mStunDamageThreshold;
var() float mReactionAnimDamageTime;
var() int mReactionAnimDamageThreshold;
var() float mResetTime;

defaultproperties
{
    mStunMultiplier=5.0000000
    mMaxStunMovementFactor=0.3000000
    mReactionAnimDamageTime=1.0000000
    mReactionAnimDamageThreshold=500
    mResetTime=-1.0000000
    ObjName="AI Set Stun Values"
    ObjCategory="Turok AI"
}