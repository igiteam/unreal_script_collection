class SeqAct_SetMatInstTexParam extends SequenceAction
    native
    hidecategories(Object);

var() MaterialInstanceConstant MatInst;
var() Texture NewTexture;
var() name ParamName;

defaultproperties
{
    VariableLinks=none
    ObjName="Set TextureParam"
    ObjCategory="Material Instance"
}