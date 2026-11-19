class AnimNotify_SoundByType extends AnimNotify_Scripted
    editinlinenew
    collapsecategories
    hidecategories(Object);

struct PawnSoundType
{
    var() array<SoundCue> SoundCueByType;
    var() int Type;

    structdefaultproperties
    {
        SoundCueByType=none
        Type=0
    }
};

var() array<PawnSoundType> SoundCuesByTypes;
var() array<SoundCue> DefaultSoundCue;
var() float PercentToPlay;
var() float VolumeMultiplier;
var() float PitchMultiplier;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local int I, Size;

    super.Notify(Owner, AnimSeqInstigator);
    // End:0x36
    if(EvilPawn(Owner) == none)
    {
        return;
    }
    Size = SoundCuesByTypes.Length;
    I = 0;
    J0x55:

    // End:0x16F [Loop If]
    if(I < Size)
    {
        // End:0x161
        if(EvilPawn(Owner).PawnAIType == SoundCuesByTypes[I].Type)
        {
            // End:0x15F
            if(SoundCuesByTypes[I].SoundCueByType.Length > 0)
            {
                Owner.PlaySound(SoundCuesByTypes[I].SoundCueByType[Rand(SoundCuesByTypes[I].SoundCueByType.Length)]);
            }
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x55;
    }
    // End:0x1B9
    if(DefaultSoundCue.Length > 0)
    {
        Owner.PlaySound(DefaultSoundCue[Rand(DefaultSoundCue.Length)]);
    }
    //return;    
}

defaultproperties
{
    PercentToPlay=1.0000000
    VolumeMultiplier=1.0000000
    PitchMultiplier=1.0000000
}