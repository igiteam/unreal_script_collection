class TurokSeqAct_VehicleBrakeControl extends SeqAct_Latent
    native
    hidecategories(Object);

var() float mTargetSpeed;
var() float mSpeedTolerance;
var() bool mApplyHandBrake;

defaultproperties
{
    mSpeedTolerance=3.0000000
    ObjName="Vehicle Brake Control"
    ObjCategory="Turok Vehicle"
}