class TurokSeqAct_SetMusicSlider extends SequenceAction
    hidecategories(Object);

struct SliderChange
{
    var() int Slider;
    var() float Volume;
    var() float Time;

    structdefaultproperties
    {
        Slider=0
        Volume=0.0000000
        Time=0.0000000
    }
};

var() int TuneNumber;
var() array SliderChanges;

defaultproperties
{
    SliderChanges=/* Array type was not detected. */
    ObjName="Set Music Slider"
    ObjCategory="Turok Audio"
}