class R6SkelControlBreathing extends SkelControlBase
    native
    hidecategories(Object);

var float n1;
var float n2;
var float n3;
var float n4;
var float n5;
var float BDelta;
var float BScared;
var float BHanged;
var float BMaxBreath;
var float BVel_timer;
var byte BVel_ind;
var float BVel[10];
var bool BInspire;
var float m_fOriginalMaster;
var() float fMasterControl;
var() float m_fTakeCoverAimModifier;

defaultproperties
{
    n1=1.0000000
    n2=2.0000000
    n3=3.0000000
    n4=1.5000000
    n5=2.3000000
    BMaxBreath=645.0000000
    m_fOriginalMaster=0.7000000
    fMasterControl=1.0000000
    m_fTakeCoverAimModifier=0.1500000
    m_iDisableLOD=2
}