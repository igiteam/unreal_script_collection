class TurokAnimTransitionGraphTagPryDoor extends TurokAnimTransitionGraphTag
    native
    editinlinenew
    hidecategories(Object,Name);

var(Scrub) float mDecreaseRate;
var(Scrub) float mIncreaseRate;
var(Scrub) float mAmountEachPressAdds;
var(Scrub) float mInitialValue;
var(Scrub) float mSuccessPercent;
var(Scrub) float mFailurePercent;
var(Exit) name mSuccessGraph;
var(Exit) name mFailureGraph;

defaultproperties
{
    mDecreaseRate=0.4000000
    mIncreaseRate=0.4000000
    mAmountEachPressAdds=0.1000000
    mSuccessPercent=1.0000000
}