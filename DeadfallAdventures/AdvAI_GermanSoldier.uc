class AdvAI_GermanSoldier extends AdvAI_Covering
    config(AI)
    hidecategories(Navigation);

defaultproperties
{
    EnemyDistance_Shoot=10000.0000000
    EnemyDistance_Throw=2000.0000000
    EnemyDistance_Melee=200.0000000
    EnemyDistance_MeleeCharge=250.0000000
    SightRadius=6000.0000000
    // Reference: EvilAIReactManager'Default__AdvAI_GermanSoldier.ReactionManager0'
    begin object name=ReactionManager0
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=/* Array type was not detected. */
    MaxTimeBetweenFireBurst=0.2000000
    MinTimeBetweenFireBurst=0.1000000
    TimeBetweenThrows=8.0000000
}