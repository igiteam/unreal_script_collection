class SkyMusicManager extends Actor
    native
    notplaceable;

var export editinline AudioComponent MusicAC[2];
var int ActiveCompIndex;
var SkySeqAct_InteractiveMusic ActiveKismetAction;
var transient bool bPlayedDeathStinger;

// Export USkyMusicManager::execGetNextAudioComp(FFrame&, void* const)
native function AudioComponent GetNextAudioComp();

// Export USkyMusicManager::execGetActiveAudioComp(FFrame&, void* const)
native function AudioComponent GetActiveAudioComp();
