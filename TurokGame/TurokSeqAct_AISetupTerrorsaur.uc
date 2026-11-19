class TurokSeqAct_AISetupTerrorsaur extends SequenceAction
    hidecategories(Object);

var() string mPathName;
var() float mMoveHeight;
var() bool mbAlwaysStayOnPath;
var() bool mbAllowAttackSwoopDown;
var() bool mbAutoFaceDirectionOfMovement;
var() float mMinSwoopStartHeightAboveEnemy;
var() float mMaxSwoopStartHeightAboveEnemy;
var() float mMinSwoopTime;
var() float mMaxSwoopTime;
var() float mSightRadius;
var() float mPeripheralVision;

defaultproperties
{
    mPathName="None"
    mMoveHeight=400.0000000
    mbAutoFaceDirectionOfMovement=true
    mMinSwoopStartHeightAboveEnemy=200.0000000
    mMaxSwoopStartHeightAboveEnemy=800.0000000
    mMinSwoopTime=2.0000000
    mMaxSwoopTime=5.0000000
    mSightRadius=800.0000000
    mPeripheralVision=0.9850000
    ObjName="AI Setup Terrorsaur"
    ObjCategory="Turok AI"
}