class SeqAct_R6SetPIPSpecialTexture extends SequenceAction
    native
    hidecategories(Object);

var() Texture m_pTexture;
var() bool m_bControlMovie;
var() float m_fTimeBeforeMovieEndToClosePIP;

defaultproperties
{
    m_fTimeBeforeMovieEndToClosePIP=0.5000000
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Player",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjClassVersion=2
    ObjName="Set PIP Movie/Texture"
    ObjCategory="PIP"
}