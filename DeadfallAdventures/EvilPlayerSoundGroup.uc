class EvilPlayerSoundGroup extends EvilPawnSoundGroup_Base;

var array<FootstepSoundInfo> ClothSounds;
var SoundCue DefaultClothSound;
var SoundCue HitSoundAlwaysPlayed;

static function SoundCue GetClothSound(name MaterialType)
{
    local int I;

    I = default.ClothSounds.Find('MaterialType', MaterialType);    
    return (((I == -1) || MaterialType == 'None') ? default.DefaultClothSound : default.ClothSounds[I].Sound);
    //return ReturnValue;    
}

defaultproperties
{
    SoundGroupParamArchetype=SoundGroupParams'ar_SoundSetup.ar_Hero'
}