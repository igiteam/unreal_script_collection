class TurokAnimTransitionController extends AnimNode
    native
    hidecategories(Object,Object);

enum ELocoState
{
    ELS_Moving,                     // 0
    ELS_Standing,                   // 1
    ELS_InAir,                      // 2
    ELS_MAX                         // 3
};

var native const @NULL mController;

// Export UTurokAnimTransitionController::execIsTransientPlaying(FFrame&, void* const)
native final function bool IsTransientPlaying();

// Export UTurokAnimTransitionController::execIsLocomoting(FFrame&, void* const)
native final function bool IsLocomoting();

// Export UTurokAnimTransitionController::execIsCanned(FFrame&, void* const)
native final function bool IsCanned();

// Export UTurokAnimTransitionController::execIsTransitionGraph(FFrame&, void* const)
native final function bool IsTransitionGraph();

// Export UTurokAnimTransitionController::execReset(FFrame&, void* const)
native final function Reset();

// Export UTurokAnimTransitionController::execPlayCannedTransient(FFrame&, void* const)
native final function PlayCannedTransient(name Anim, float StartTime, float Duration, float Rate, float blendIn, float blendOut, float Amplitude, name startBone, float increasePerBone, bool transformLocal, optional bool mirrored);

// Export UTurokAnimTransitionController::execPlayCannedTransientWithAnimSet(FFrame&, void* const)
native final function PlayCannedTransientWithAnimSet(name Anim, array AnimSet, float StartTime, float Duration, float Rate, float blendIn, float blendOut, float Amplitude, name startBone, float increasePerBone, bool transformLocal, optional bool mirrored);

// Export UTurokAnimTransitionController::execPlayFacialTransient(FFrame&, void* const)
native final function PlayFacialTransient(name Anim, array AnimSet, float Duration, float blendIn, float blendOut, name startBone);

// Export UTurokAnimTransitionController::execPlayCanned(FFrame&, void* const)
native final function PlayCanned(name Anim, float blendTime, bool bLoop, bool bMirror, optional float Rate);

// Export UTurokAnimTransitionController::execPlayCannedWithAnimSet(FFrame&, void* const)
native final function PlayCannedWithAnimSet(name Anim, array AnimSet, float blendTime, bool bLoop, bool bMirror, optional float Rate);

// Export UTurokAnimTransitionController::execPlayLocomotion(FFrame&, void* const)
native final function PlayLocomotion(@NULL asset, float blendTime, @NULL Params);

// Export UTurokAnimTransitionController::execPlayTransitionGraph(FFrame&, void* const)
native final function PlayTransitionGraph(@NULL graph, @NULL aiInterface, byte actorType);

// Export UTurokAnimTransitionController::execPlayTransitionGraphAttachment(FFrame&, void* const)
native final function PlayTransitionGraphAttachment(@NULL graph, @NULL aiInterface, @NULL Attachment);

// Export UTurokAnimTransitionController::execSetSecondaryTarget(FFrame&, void* const)
native final function SetSecondaryTarget(name Node, float blendTarget, float blendTime);

// Export UTurokAnimTransitionController::execSetSecondaryTransient(FFrame&, void* const)
native final function SetSecondaryTransient(name Node, float Duration, float blendIn, float blendOut, float Amplitude);
