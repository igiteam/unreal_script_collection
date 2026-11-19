class R6SkelControlRecoil extends SkelControlBase
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
var int m_iPitchMod;

defaultproperties
{
    n1=1.0000000
    n2=2.0000000
    n3=3.0000000
    n4=1.5000000
    n5=2.3000000
    BMaxBreath=45.0000000
    BVel[0]=1300.0000000
    BVel[1]=1300.0000000
    BVel[2]=1300.0000000
    BVel[3]=1300.0000000
    BVel[4]=1300.0000000
    BVel[5]=1300.0000000
    BVel[6]=1300.0000000
    BVel[7]=1300.0000000
    BVel[8]=1300.0000000
    BVel[9]=1300.0000000
    m_fOriginalMaster=0.7000000
    fMasterControl=1.0000000
    m_iDisableLOD=2
}