class TurokSeqAct_SetColorCube extends SequenceAction
    native
    hidecategories(Object);

enum EColorCubeSlot
{
    CCS_Slot0,                      // 0
    CCS_Slot1,                      // 1
    CCS_MAX                         // 2
};

var() byte mSlot;
var() @NULL mCubeTexture;
var() float mBlendValue;

defaultproperties
{
    VariableLinks=none
    ObjName="Set Color Cube"
    ObjCategory="Turok Rendering"
}