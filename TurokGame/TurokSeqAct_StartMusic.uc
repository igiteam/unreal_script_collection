class TurokSeqAct_StartMusic extends SequenceAction
    hidecategories(Object);

var() int TuneNumber;
var() array MusicSoundCues;
var() float BPM;
var() int NoteType;
var() int BarLength;
var() bool bSilentStart;

defaultproperties
{
    MusicSoundCues=/* Array type was not detected. */
    bSilentStart=true
    ObjName="Start Music"
    ObjCategory="Turok Audio"
}