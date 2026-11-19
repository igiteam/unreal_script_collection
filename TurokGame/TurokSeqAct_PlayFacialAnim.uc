class TurokSeqAct_PlayFacialAnim extends SeqAct_PlaySound
    native
    hidecategories(Object);

var float mBlendIn;
var float mBlendOut;
var() array mCustomAnimSets;
var() name mCustomAnimName;
var const array mGenericAnimSets;
var const name mGenericAnimName;

defaultproperties
{
    mBlendIn=0.1500000
    mBlendOut=0.3300000
    mGenericAnimSets=/* Array type was not detected. */
    mGenericAnimName="genericshouting"
    ObjName="Play Sound and Facial Anim"
}