class CCKeyAudio extends CCKey
    native
    editinlinenew
    hidecategories(Object,Object);

var(AudioAndFaceFX) bool bSilent;
var(AudioAndFaceFX) bool bShouting;
var(Subtitle) bool bDisplaySubtitle;
var(AudioAndFaceFX) SoundCue PrimaryCue;
var(Subtitle) const localized string SubtitleText;
var(Subtitle) float SubtitleDisplayDuration_sec;

// Export UCCKeyAudio::execGetDuration_sec(FFrame&, void* const)
native function float GetDuration_sec();

function string GetDebugString()
{
    // End:0x6A
    if(none != PrimaryCue)
    {
        return (((((super.GetDebugString() $ ", PrimaryCue=") $ string(PrimaryCue.Name)) $ ", bShouting=") $ string(bShouting)) $ ", bSilent=") $ string(bSilent);        
    }
    else
    {
        return (((super.GetDebugString() $ ", PrimaryCue=none, bShouting=") $ string(bShouting)) $ ", bSilent=") $ string(bSilent);
    }
    //return ReturnValue;    
}

defaultproperties
{
    bShouting=true
    SubtitleDisplayDuration_sec=2.0000000
}