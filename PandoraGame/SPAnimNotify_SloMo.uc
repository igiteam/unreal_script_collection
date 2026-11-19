class SPAnimNotify_SloMo extends AnimNotify
    native
    editinlinenew
    collapsecategories;

var float InitSpeed;
/** The speed that we want to set the game to */
var() float GameSpeed;
/** How long it takes to ramp to the given speed. */
var() float RampTime;
/** True if first key in sequence (get lock) */
var() bool SeqBegin;
/** True if last key in sequence (drop lock) */
var() bool SeqEnd;

defaultproperties
{
    InitSpeed=1.0000000
    GameSpeed=1.0000000
}