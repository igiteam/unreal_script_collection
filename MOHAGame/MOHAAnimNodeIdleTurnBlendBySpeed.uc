class MOHAAnimNodeIdleTurnBlendBySpeed extends AnimNodeBlendBase
    native
    hidecategories(Object,Object);

var int LastRotation;
var() float MediumSpeed;
var() float MaxSpeed;
var() float RotationCheckInterval;
var float DeltaCountdown;
var float StoredYawRate;
var float fAnimTreeYawRate;
var float fBiggestYawRateSeenRecently;
var float fStartPercentSlow;
var float fStartPercentMedium;
var float fStartPercentFast;
var float fDesiredPercentSlow;
var float fDesiredPercentMedium;
var float fDesiredPercentFast;

defaultproperties
{
    MediumSpeed=100.0000000
    MaxSpeed=200.0000000
    RotationCheckInterval=0.2500000
    fAnimTreeYawRate=100.0000000
    fStartPercentSlow=1.0000000
    fDesiredPercentSlow=1.0000000
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}