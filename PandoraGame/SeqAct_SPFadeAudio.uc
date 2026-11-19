class SeqAct_SPFadeAudio extends SeqAct_Latent
    native;

var float TotalTime;
/** The FName of the audio groups to process the fade on */
var() array<string> AudioGroupNames;
/** The value you want all the audio groups to be at once the fade is done */
var() float EndFadeVolume;
/** The amount of time the fade should take. 0 is instantaneous */
var() float FadeTime;
