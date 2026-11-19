class TurokAnimTransitionGraphTagMaul extends TurokAnimTransitionGraphTag
    native
    config(Maul)
    editinlinenew
    hidecategories(Object,Name);

const NUM_MAUL_DIFFICULTY_LEVELS = 3;

enum MaulDifficultyValues
{
    MaulValue_Easy,                 // 0
    MaulValue_Medium,               // 1
    MaulValue_Hard,                 // 2
    MaulValue_MAX                   // 3
};

var() float mSuccessPercent;
var() float mFailurePercent;
var() bool mbUseInverseScrubPercent;
var() private float mDecreaseRates[3];
var() private float mIncreaseRates[3];
var() private float mEachPressAdds[3];
var() private float mInitialValues[3];
var() private float mTimeAtFailure[3];
var() private float mTimeAtSuccess[3];
var() private float mDamageRates[3];
var() private float mDamageToEnemy[3];
var() float mMinTimeBetweenStabs;
var() float mRandomHitVariancePercent;
var() name mScrubGraph;
var() name mSuccessGraph;
var() name mFailureGraph;
var() name mLosingGraph;
var() name mSuccessEnemyDeathGraph;
var() name mAttackerLostInterest;
var() array mHitGraphs;
var float mAllowableTimeAtFull;
var config float mMaulIsHardPercentHealth;

private final simulated function float GetScaledValue(float Values[3], @NULL TP)
{
    local float percentHealth;

    percentHealth = float(TP.Health) / float(TP.mDefaultHealth);
    // End:0x45
    if(mMaulIsHardPercentHealth <= 0.0000000)
    {
        mMaulIsHardPercentHealth = 0.0100000;        
    }
    else
    {
        // End:0x5F
        if(mMaulIsHardPercentHealth >= 1.0000000)
        {
            mMaulIsHardPercentHealth = 0.9900000;
        }
    }
    // End:0x9E
    if(percentHealth <= mMaulIsHardPercentHealth)
    {
        return ((1.0000000 - (percentHealth / mMaulIsHardPercentHealth)) * (Values[2] - Values[1])) + Values[1];
    }
    return (((1.0000000 - percentHealth) / (1.0000000 - mMaulIsHardPercentHealth)) * (Values[1] - Values[0])) + Values[0];
    //return ReturnValue;    
}

simulated function float GetDecreaseRate(@NULL TP)
{
    return GetScaledValue(mDecreaseRates, TP);
    //return ReturnValue;    
}

simulated function float GetIncreaseRate(@NULL TP)
{
    return GetScaledValue(mIncreaseRates, TP);
    //return ReturnValue;    
}

simulated function float GetEachPressAdds(@NULL TP)
{
    return GetScaledValue(mEachPressAdds, TP);
    //return ReturnValue;    
}

simulated function float GetInitialValue(@NULL TP)
{
    return GetScaledValue(mInitialValues, TP);
    //return ReturnValue;    
}

simulated function float GetTimeAtFailure(@NULL TP)
{
    return GetScaledValue(mTimeAtFailure, TP);
    //return ReturnValue;    
}

simulated function float GetTimeAtSuccess(@NULL TP)
{
    return GetScaledValue(mTimeAtSuccess, TP);
    //return ReturnValue;    
}

simulated function float GetDamageRate(@NULL TP)
{
    return GetScaledValue(mDamageRates, TP);
    //return ReturnValue;    
}

simulated function float GetDamageToEnemy(@NULL TP)
{
    return GetScaledValue(mDamageToEnemy, TP);
    //return ReturnValue;    
}

defaultproperties
{
    mSuccessPercent=1.0000000
    mDecreaseRates[0]=0.3000000
    mDecreaseRates[1]=0.3000000
    mDecreaseRates[2]=0.3000000
    mIncreaseRates[0]=0.2500000
    mIncreaseRates[1]=0.2500000
    mIncreaseRates[2]=0.2500000
    mEachPressAdds[0]=0.0300000
    mEachPressAdds[1]=0.0300000
    mEachPressAdds[2]=0.0300000
    mInitialValues[0]=0.1000000
    mInitialValues[1]=0.1000000
    mInitialValues[2]=0.1000000
    mTimeAtFailure[0]=1.5000000
    mTimeAtFailure[1]=1.5000000
    mTimeAtFailure[2]=1.5000000
    mDamageRates[0]=40.0000000
    mDamageRates[1]=40.0000000
    mDamageRates[2]=40.0000000
    mDamageToEnemy[0]=150.0000000
    mDamageToEnemy[1]=150.0000000
    mDamageToEnemy[2]=150.0000000
    mMinTimeBetweenStabs=0.2000000
    mRandomHitVariancePercent=0.2000000
    mAllowableTimeAtFull=0.1000000
}