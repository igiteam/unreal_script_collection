class MOHAAnimNodeIdleBlend extends MOHAMultiplayerAnimNodeBlendList
    native
    hidecategories(Object,Object,Object);

enum eIdleState
{
    IS_IDLE,                        // 0
    IS_IDLELEFT,                    // 1
    IS_IDLERIGHT,                   // 2
    IS_MAX                          // 3
};

var MOHAAnimNodeIdleBlend.eIdleState IdleState;
var() int MinimumDegreesRotationPerSec;
var() float RotationCheckInterval;
var() float PlaybackLength;
var() float BlendTime;
var float DeltaCountdown;
var int LastRotation;

defaultproperties
{
    MinimumDegreesRotationPerSec=15
    RotationCheckInterval=0.2500000
    PlaybackLength=1.0000000
    BlendTime=0.3000000
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}