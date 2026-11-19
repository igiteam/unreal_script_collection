class AdvAI_SteinArctic extends AdvAI_GermanSoldier
    config(AI)
    hidecategories(Navigation);

function bool ShouldBlindFire(Actor ChkTarget)
{
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    EnemyDistance_HearFootSteps=300.0000000
    // Reference: EvilAIReactManager'Default__AdvAI_SteinArctic.ReactionManager0'
    begin object name=ReactionManager0
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=/* Array type was not detected. */
    MaxTimeBetweenFireBurst=0.5000000
    MinTimeBetweenFireBurst=0.2000000
    BurstFireTimeout=6.0000000
    BurstFireSpreadTime=0.1000000
}