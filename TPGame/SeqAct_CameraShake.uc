class SeqAct_CameraShake extends SequenceAction
    dependson(TPPawn);

var() TPPawn.ShakeInfo CameraShake;
var() bool bStopCameraShake;

