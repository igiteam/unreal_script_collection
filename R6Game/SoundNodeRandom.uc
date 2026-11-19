class SoundNodeRandom extends SoundNode
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

var() editconstarray array<float> Weights;
var() bool bRandomizeWithoutReplacement;
var transient array<bool> HasBeenUsed;
var transient int NumRandomUsed;

defaultproperties
{
    bRandomizeWithoutReplacement=true
}