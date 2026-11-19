class CCPerformerPawn extends MOHAPawn
    native
    config(Game)
    hidecategories(Navigation);

enum EDebugDepthPriorityGroup
{
    DDPG_Background,                // 0
    DDPG_World,                     // 1
    DDPG_Foreground,                // 2
    DDPG_UnrealEd,                  // 3
    DDPG_PostProcess,               // 4
    DDPG_MAX                        // 5
};

var(CC) export editinline CCPerformer CCP;
var private export editinline AudioComponent FaceFXAudioComponent;
var int TeamIndex;
var private bool bAIPaused;
var int PauseLevel;
var CCChannelAudio.ENationality CCNationality;

// Export UCCPerformerPawn::execDrawDebugLineEx(FFrame&, void* const)
native static final function DrawDebugLineEx(Vector LineStart, Vector LineEnd, byte R, byte G, byte B, CCPerformerPawn.EDebugDepthPriorityGroup DepthPriGroup, optional bool bPersistentLines);

// Export UCCPerformerPawn::execDrawDebugBoxEx(FFrame&, void* const)
native static final function DrawDebugBoxEx(Vector Center, Vector Extent, byte R, byte G, byte B, CCPerformerPawn.EDebugDepthPriorityGroup DepthPriGroup, optional bool bPersistentLines);

// Export UCCPerformerPawn::execDrawDebugCoordinateSystemEx(FFrame&, void* const)
native static final function DrawDebugCoordinateSystemEx(Vector AxisLoc, Rotator AxisRot, float Scale, CCPerformerPawn.EDebugDepthPriorityGroup DepthPriGroup, optional bool bPersistentLines);

// Export UCCPerformerPawn::execDrawDebugSphereEx(FFrame&, void* const)
native static final function DrawDebugSphereEx(Vector Center, float Radius, int Segments, byte R, byte G, byte B, CCPerformerPawn.EDebugDepthPriorityGroup DepthPriGroup, optional bool bPersistentLines);

// Export UCCPerformerPawn::execDrawDebugCircleEx(FFrame&, void* const)
native static final function DrawDebugCircleEx(Vector Center, Vector Direction, float Radius, int Segments, byte R, byte G, byte B, CCPerformerPawn.EDebugDepthPriorityGroup DepthPriGroup, optional bool bPersistentLines);

// Export UCCPerformerPawn::execDrawDebugCylinderEx(FFrame&, void* const)
native static final function DrawDebugCylinderEx(Vector Start, Vector End, float Radius, int Segments, byte R, byte G, byte B, CCPerformerPawn.EDebugDepthPriorityGroup DepthPriGroup, optional bool bPersistentLines);

// Export UCCPerformerPawn::execDrawDebugConeEx(FFrame&, void* const)
native static final function DrawDebugConeEx(Vector Origin, Vector Direction, float Length, float AngleWidth, float AngleHeight, int NumSides, Color DrawColor, CCPerformerPawn.EDebugDepthPriorityGroup DepthPriGroup, optional bool bPersistentLines);

simulated event AudioComponent GetFaceFXAudioComponent()
{
    return FaceFXAudioComponent;
    //return ReturnValue;    
}

simulated function PostBeginPlay()
{
    Mesh.FaceFXBlendMode = 0;
    CCP.PostBeginPlay(TeamIndex);
    super.PostBeginPlay();
    //return;    
}

function CCPerformerPawn_PostBeginPlay()
{
    CCP.PostBeginPlay(TeamIndex);
    PostBeginPlay();
    //return;    
}

simulated function OnEnqueueCCStimulus(SeqAct_EnqueueCCStimulus Action)
{
    CCP.OnStimulus(Action.Stimulus);
    //return;    
}

function OnCCStimulus(string StimulusTypeName, Actor SourceActor)
{
    local CCStimulus CCS;

    // End:0x5E
    if(none != CCP)
    {
        CCS.StimulusType = CCStimulusType(DynamicLoadObject(StimulusTypeName, Class'CCStimulusType', false));
        CCS.SourceActor = SourceActor;
        CCP.OnStimulus(CCS);
    }
    //return;    
}

function OnCCStimulusByType(CCStimulusType StimulusType, Actor SourceActor)
{
    local CCStimulus CCS;

    // End:0x4D
    if(none != CCP)
    {
        CCS.StimulusType = StimulusType;
        CCS.SourceActor = SourceActor;
        CCP.OnStimulus(CCS);
    }
    //return;    
}

function BroadcastStimulus(string StimulusTypeName, Actor SourceActor, float Radius, optional CCChannelAudio.ENationality OnlyNationality = 0)
{
    local CCStimulus CCS;

    // End:0x7A
    if(none != CCP)
    {
        CCS.StimulusType = CCStimulusType(DynamicLoadObject(StimulusTypeName, Class'CCStimulusType', false));
        CCS.SourceActor = SourceActor;
        CCP.GetCCDirector().BroadcastStimulus(CCS, Radius, OnlyNationality);
    }
    //return;    
}

function BroadcastStimulusByType(CCStimulusType StimulusType, Actor SourceActor, float Radius, optional CCChannelAudio.ENationality OnlyNationality = 0)
{
    local CCStimulus CCS;

    // End:0x69
    if(none != CCP)
    {
        CCS.StimulusType = StimulusType;
        CCS.SourceActor = SourceActor;
        CCP.GetCCDirector().BroadcastStimulus(CCS, Radius, OnlyNationality);
    }
    //return;    
}

function bool IsAIPauseable(int PauseImportance)
{
    return (PauseLevel != default.PauseLevel) && PauseImportance > PauseLevel;
    //return ReturnValue;    
}

function bool IsAIPaused()
{
    return bAIPaused;
    //return ReturnValue;    
}

function bool PauseAI(int PauseImportance)
{
    local bool bSuccess;

    bSuccess = false;
    // End:0x5D
    if(PauseImportance > 0)
    {
        // End:0x5A
        if(!bAIPaused && IsAIPauseable(PauseImportance))
        {
            bAIPaused = true;
            bSuccess = true;
            AxonObserver.NotifyObservers('RequestBlockingPerformance');
        }        
    }
    else
    {
        // End:0x8E
        if(bAIPaused)
        {
            bAIPaused = false;
            bSuccess = true;
            AxonObserver.NotifyObservers('FinishBlockingPerformance');
        }
    }
    return bSuccess;
    //return ReturnValue;    
}

simulated function PostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir)
{
    // End:0x32
    if(CCP != none)
    {
        CCP.PostRenderFor(PC, Canvas, CameraPosition, CameraDir);
    }
    //return;    
}

function SetCCEnabled(bool bEnabled)
{
    // End:0x24
    if(CCP != none)
    {
        CCP.SetEnabled(bEnabled);
    }
    //return;    
}

function ResetPauseLevel()
{
    PauseLevel = default.PauseLevel;
    //return;    
}

function SetPauseLevel(int newPauseLevel)
{
    PauseLevel = newPauseLevel;
    //return;    
}

function OnCCPerformanceStarted(CCPerformance2 Performance, float performanceDuration)
{
    //return;    
}

function CCChannelAudio.ENationality GetNationality()
{
    return CCNationality;
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: CCPerformerForAI'Default__CCPerformerPawn.MyCCP'
    begin object name=MyCCP class=Class'CCPerformerForAI'
    end object
    CCP=MyCCP
    // Reference: AudioComponent'Default__CCPerformerPawn.MyFaceFXAudioComponent'
    begin object name=MyFaceFXAudioComponent class=Class'Engine.AudioComponent'
    end object
    FaceFXAudioComponent=MyFaceFXAudioComponent
    PauseLevel=-1
    CCNationality=1
    // Reference: AxonScriptEventObserverComponent'Default__CCPerformerPawn.AxonObserver0'
    begin object name=AxonObserver0
    end object
    AxonObserver=AxonObserver0
    // Reference: DynamicLightEnvironmentComponent'Default__CCPerformerPawn.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    // Reference: CylinderComponent'Default__CCPerformerPawn.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__CCPerformerPawn.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    // Reference: ArrowComponent'Default__CCPerformerPawn.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=MyLightEnvironment
    Components[4]=AxonObserver0
    Components[5]=MyFaceFXAudioComponent
    Components[6]=MyCCP
    CollisionComponent=CollisionCylinder
    CollisionType=0
}