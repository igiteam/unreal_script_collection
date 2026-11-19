class CCPerformerForAI extends CCPerformer
    hidecategories(Object,Object,Object);

function int Owner_GetDesiredLocomotionPosture()
{
    return CCPerformerPawn(Owner).DesiredPosture;
    //return ReturnValue;    
}

event int Owner_GetHealth()
{
    return CCPerformerPawn(Owner).Health;
    //return ReturnValue;    
}

function SkeletalMeshComponent Owner_GetSkeletalMeshComponent()
{
    return CCPerformerPawn(Owner).Mesh;
    //return ReturnValue;    
}

function bool Owner_IsAIPauseable(int PauseImportance)
{
    return CCPerformerPawn(Owner).IsAIPauseable(PauseImportance);
    //return ReturnValue;    
}

function bool Owner_IsAIPaused()
{
    return CCPerformerPawn(Owner).IsAIPaused();
    //return ReturnValue;    
}

function bool Owner_PauseAI(int PauseImportance)
{
    return CCPerformerPawn(Owner).PauseAI(PauseImportance);
    //return ReturnValue;    
}

event Owner_OnCCPerformanceStarted(CCPerformance2 Performance, float performanceDuration)
{
    CCPerformerPawn(Owner).OnCCPerformanceStarted(Performance, performanceDuration);
    //return;    
}

function CCChannelAudio.ENationality Owner_GetNationality()
{
    return CCPerformerPawn(Owner).GetNationality();
    //return ReturnValue;    
}

function Owner_DrawDebugCoordinateSystem(Vector AxisLoc, Rotator AxisRot, float Scale, CCPerformerPawn.EDebugDepthPriorityGroup DepthPriGroup, optional bool bPersistentLines)
{
    CCPerformerPawn(Owner).DrawDebugCoordinateSystemEx(AxisLoc, AxisRot, Scale, DepthPriGroup, bPersistentLines);
    //return;    
}

function Owner_DrawDebugSphere(Vector Center, float Radius, int Segments, byte R, byte G, byte B, CCPerformerPawn.EDebugDepthPriorityGroup DepthPriGroup, optional bool bPersistentLines)
{
    CCPerformerPawn(Owner).DrawDebugSphereEx(Center, Radius, Segments, R, G, B, DepthPriGroup, bPersistentLines);
    //return;    
}

defaultproperties
{
    // Reference: CCHistory'Default__CCPerformerForAI.StimHist'
    begin object name=StimHist
    end object
    StimulusHistory=StimHist
    // Reference: CCPerformanceState'Default__CCPerformerForAI.PerfState'
    begin object name=PerfState
    end object
    PerformanceState=PerfState
    // Reference: CCHistoryEventStimulus'Default__CCPerformerForAI.HistEvent'
    begin object name=HistEvent
    end object
    TestStimulusHistoryEvent=HistEvent
}