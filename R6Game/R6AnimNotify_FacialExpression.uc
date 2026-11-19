class R6AnimNotify_FacialExpression extends AnimNotify
    native
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() AnimSet AnimSet;
var() /*0x10000000-0x00000000*/ name Expression;
var() float m_fEndPosition;
var() float m_fBlendIn;
var() float m_fBlendOut;
var() float m_fBlendValue;
var() bool m_bOverrideDefault;

defaultproperties
{
    AnimSet=AnimSet'Anims_Facial_Generic.Poses'
    m_fBlendIn=0.1000000
    m_fBlendOut=0.2000000
    m_fBlendValue=1.0000000
    m_bOverrideDefault=true
}