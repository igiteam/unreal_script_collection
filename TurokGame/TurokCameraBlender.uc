class TurokCameraBlender extends TurokCameraBase
    native;

var private transient @NULL mInCam;
var private transient @NULL mOutCam;
var private transient @NULL mNewCam;
var private transient float mBlendTime;
var private transient float mDelayTime;

// Export UTurokCameraBlender::execAddCamera(FFrame&, void* const)
native function AddCamera(@NULL NewCam, float blendTime, float DelayTime);

// Export UTurokCameraBlender::execStartBlend(FFrame&, void* const)
native function StartBlend();

// Export UTurokCameraBlender::execUpdateViewTarget(FFrame&, void* const)
native function UpdateViewTarget(@NULL TurokCam, float DeltaTime);

// Export UTurokCameraBlender::execBlendCompleted(FFrame&, void* const)
private native final function BlendCompleted();
