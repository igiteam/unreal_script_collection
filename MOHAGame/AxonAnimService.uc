class AxonAnimService extends AxonEventService;

function RegisterAnimationEvent(coerce name activity, delegate<AxonDelegate> callback, Object oirOwner, optional bool bUseFallbackCallback, optional bool bForceUseOIR, optional float TransitionRateScale = 1.0000000, optional name forcePose)
{
    local name activityPose;

    // End:0xA7
    if(oirOwner != none)
    {
        activityPose = AxonControllerBrainState(owningBrainState).Controller.SetNextOIRData(oirOwner, activity, bForceUseOIR, TransitionRateScale, forcePose, NotEqual_InterfaceInterface(OIROwnerInterface(oirOwner), OIROwnerInterface(none)));
        // End:0x88
        if(!bUseFallbackCallback)
        {
            SetFallbackCallback(callback);
        }
        RegisterAxonSubstateAnimation(activity, activityPose, callback, TransitionRateScale);
    }
    //return;    
}

function SetFallbackCallback(delegate<AxonDelegate> fallback_callback)
{
    owningBrainState.PushEventParamDelegate('fallback_callback', fallback_callback);
    //return;    
}

function SetActivityStartCallback(delegate<AxonDelegate> started_callback)
{
    owningBrainState.PushEventParamDelegate('started_callback', started_callback);
    //return;    
}

function name GetRegisteredActivityName()
{
    local name activity;

    owningBrainState.GetCallbackParamName('invoked_activity', activity);
    return activity;
    //return ReturnValue;    
}

function RegisterAxonSubstateAnimation(name activity, name activityPose, delegate<AxonDelegate> callback, optional float TransitionRateScale = 1.0000000, optional name Key = 'stack')
{
    owningBrainState.PushEventParamName('activity_name', activity);
    owningBrainState.PushEventParamName('activity_pose', activityPose);
    owningBrainState.PushEventParamFloat('activity_transitionratescale', TransitionRateScale);
    owningBrainState.PushEventParamDelegate('activity_callback', callback);
    owningBrainState.RegisterSubstateEvent('RegisterAnimationEvent', Key);
    //return;    
}
