class SPWeakWerewolfAIController extends SPWerewolfAIController
    native;

simulated event SPGameDifficultyTune GetMyGDData()
{
    return Class'SPTuneManager'.static.GetGameDifficultyTuneWeakWerewolf();
    //return ReturnValue;    
}
