class SkyPawnSoundGroup_IH_Grunt extends SkyPawnSoundGroup;

var SoundCue VocalizationSound;

static function PlayVocalization(Pawn P)
{
    // End:0x25
    if(default.VocalizationSound != none)
    {
        P.PlaySound(default.VocalizationSound);
    }
    //return;    
}
