class AdvAI_GermanRifleSoldier extends AdvAI_GermanSoldier
    config(AI)
    hidecategories(Navigation);

defaultproperties
{
    SightRadius=10000.0000000
    // Reference: EvilAIReactManager'Default__AdvAI_GermanRifleSoldier.ReactionManager0'
    begin object name=ReactionManager0
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=/* Array type was not detected. */
    MaxTimeBetweenFireBurst=0.1000000
    MinTimeBetweenFireBurst=0.0000000
    BurstFireTimeout=1.5000000
    BurstFireSpreadTime=0.2000000
    BurstFireLag=0.1000000
    DefaultAggressionLevel=EAggressionLevel.AL_Covered
}