class R6AnimNodeBlendInteraction extends AnimNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

var() R6GameEnums.EAnimTreeType m_eType;
var transient bool m_bBlendingToNormal;
var transient bool m_bFixRoot;
var transient bool m_bApplyRootOffset;
var transient float m_fBlendOutTime;
var transient Vector m_vRootOffset;

defaultproperties
{
    Children=/* Array type was not detected. */
}