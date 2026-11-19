class CCDirectorNative extends Actor
    native
    notplaceable
    hidecategories(Navigation,Object);

enum EEnabledState
{
    CC_ENABLED_AID_ONLY,            // 0
    CC_ENABLED_ALL,                 // 1
    CC_ENABLED_NONE,                // 2
    CC_ENABLED_AID_EXCLUDED,        // 3
    CC_ENABLED_INVALID,             // 4
    CC_ENABLED_MAX                  // 5
};

struct native CCPerformanceRequest
{
    var export editinline CCPerformerNative CCP;
    var CCAudioPerformanceRequest APR;

    structdefaultproperties
    {
        CCP=none
        APR=(bEnabled=false,NIndex=0,VIndex=0,OIndex=0,AIndex=0,Dist2=0.0000000)
    }
};

struct native CCRequestedStimulus
{
    var CCStimulus Stimulus;
    var init array<init CCPerformanceRequest> PerformanceRequests;

    structdefaultproperties
    {
        Stimulus=(StimulusType=none,SourceActor=none,SourceLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000),bUseSourceLocation=false,bIsIdle=false)
        PerformanceRequests=none
    }
};

var protected CCPerformanceSet2 GlobalPerformanceSet;
var protected transient CCLevelInfo CurrentCCLevelInfo;
var protected transient bool bSearchedForCCLevelInfo;
var array<CCRequestedStimulus> RequestedStimuli;
var export editinline CCDirectorAudio AudioDirector;
var(Debug) protected CCDirectorNative.EEnabledState EnabledState;
var protected CCDirectorNative.EEnabledState EnabledStateRaw;
var protected bool bLogToCSVRequest;
var protected bool bChannelEnabled_Audio;
var protected bool bChannelEnabled_PALookAt;
var protected bool bChannelEnabled_Expression;
var protected bool bChannelEnabled_OutputStim;
var(Debug) bool bLogToCSV;
var private native const Pointer CSVFileHandle;

// Export UCCDirectorNative::execIsEnabled(FFrame&, void* const)
native final function bool IsEnabled();

// Export UCCDirectorNative::execIsEnabled_Audio(FFrame&, void* const)
native final function bool IsEnabled_Audio();

// Export UCCDirectorNative::execIsEnabled_PALookAt(FFrame&, void* const)
native final function bool IsEnabled_PALookAt();

// Export UCCDirectorNative::execIsEnabled_Expression(FFrame&, void* const)
native final function bool IsEnabled_Expression();

// Export UCCDirectorNative::execIsEnabled_OutputStim(FFrame&, void* const)
native final function bool IsEnabled_OutputStim();

// Export UCCDirectorNative::execIsPerformanceEmpty(FFrame&, void* const)
protected native final function bool IsPerformanceEmpty(CCPerformance2 Performance, CCAudioPerformanceRequest APR);

// Export UCCDirectorNative::execProcessPerformanceRequests(FFrame&, void* const)
protected native final function ProcessPerformanceRequests();

// Export UCCDirectorNative::execSetEnabledState(FFrame&, void* const)
native final function SetEnabledState(CCDirectorNative.EEnabledState InEnabledState);

// Export UCCDirectorNative::execGetEnabledState(FFrame&, void* const)
native final function CCDirectorNative.EEnabledState GetEnabledState();

// Export UCCDirectorNative::execFindRequestedStimulusIndex(FFrame&, void* const)
protected native final function int FindRequestedStimulusIndex(CCStimulus Stimulus, bool bAddIfNotFound);

// Export UCCDirectorNative::execFindPerformance(FFrame&, void* const)
native final function CCPerformance2 FindPerformance(CCStimulusType StimulusType, optional out int PIndex);

// Export UCCDirectorNative::execGetCCLevelInfo(FFrame&, void* const)
native final function CCLevelInfo GetCCLevelInfo();

event BroadcastStimulus(CCStimulus Stimulus, float Radius, optional CCChannelAudio.ENationality OnlyNationality = 0, optional bool bAllowGhostAudio = true, optional array<name> FilterFunctions)
{
    //return;    
}

event BroadcastStimulusWithinVolume(CCStimulus Stimulus, Volume ActorVolume, optional CCChannelAudio.ENationality OnlyNationality = 0, optional array<name> FilterFunctions)
{
    //return;    
}

event PlayerController FindPlayerController()
{
    return Class'MOHAPlayerController'.static.GetMOHAPlayerController();
    //return ReturnValue;    
}

event Pawn FindPlayerPawn()
{
    local PlayerController PC;

    PC = FindPlayerController();
    // End:0x2A
    if(none != PC)
    {
        return PC.Pawn;
    }
    return none;
    //return ReturnValue;    
}

event RequestPerformance(CCPerformerNative CCP, CCStimulus Stimulus)
{
    //return;    
}

event CCPerformanceSet2 GetEffectivePerformanceSet()
{
    local CCLevelInfo LI;

    LI = GetCCLevelInfo();
    // End:0x3C
    if((none != LI) && none != LI.PerformanceSet)
    {
        return LI.PerformanceSet;
    }
    return GlobalPerformanceSet;
    //return ReturnValue;    
}

function CCPerformanceSet2 GetGlobalPerformanceSet()
{
    return GlobalPerformanceSet;
    //return ReturnValue;    
}

event array<int> GetValidVoiceIDs(CCChannelAudio.ENationality Nationality)
{
    local array<int> ValidVoiceIDs;
    local CCLevelInfo LI;
    local int Index, Count;

    LI = GetCCLevelInfo();
    // End:0xAE
    if((none != LI) && LI.NationalitySettings.Length > 0)
    {
        Count = LI.NationalitySettings.Length;
        Index = 0;
        J0x4A:

        // End:0xAE [Loop If]
        if(Index < Count)
        {
            // End:0xA4
            if(int(LI.NationalitySettings[Index].Nationality) == int(Nationality))
            {
                return LI.NationalitySettings[Index].ValidVoiceIDs;
            }
            ++Index;
            // [Loop Continue]
            goto J0x4A;
        }
    }
    ValidVoiceIDs.Length = 0;
    return ValidVoiceIDs;
    //return ReturnValue;    
}

function CCIdleStimulus FindIdleStimulus(name oir, name activity, name Pose, bool bFiring, CCIdleStimulus HintPrevIdleStim)
{
    return GlobalPerformanceSet.FindIdleStimulus(oir, activity, Pose, bFiring, HintPrevIdleStim);
    //return ReturnValue;    
}

event Tick(float DeltaTime)
{
    SetEnabledState(EnabledState);
    ProcessPerformanceRequests();
    RequestedStimuli.Length = 0;
    AudioDirector.Tick(DeltaTime);
    //return;    
}

// Export UCCDirectorNative::execCCOpenCSVLog(FFrame&, void* const)
native final function CCOpenCSVLog();

// Export UCCDirectorNative::execCCCloseCSVLog(FFrame&, void* const)
native final function CCCloseCSVLog();

// Export UCCDirectorNative::execCCWriteCSVLog(FFrame&, void* const)
native final function CCWriteCSVLog(string Line);

// Export UCCDirectorNative::execBroadcastStimulusGeneral(FFrame&, void* const)
native final function BroadcastStimulusGeneral(CCStimulus Stimulus, float Radius, array<Volume> Volumes, optional bool bAllActorsInMap, optional CCChannelAudio.ENationality OnlyNationality, optional array<name> FilterFunctions);

event ToggleCCLogToCSV()
{
    local PlayerController PC;
    local string EnabledString;

    bLogToCSVRequest = !bLogToCSV;
    // End:0x2A
    if(bLogToCSVRequest)
    {
        EnabledString = "ENABLED";        
    }
    else
    {
        EnabledString = "DISABLED";
    }
    PC = FindPlayerController();
    // End:0x97
    if(none != PC)
    {
        PC.ClientMessage("Character Consciousness CSV Logging " $ EnabledString);
    }
    //return;    
}

protected event CheckCSVLogging()
{
    local string Line;

    // End:0x285
    if(bLogToCSV != bLogToCSVRequest)
    {
        bLogToCSV = bLogToCSVRequest;
        // End:0x27F
        if(bLogToCSV)
        {
            CCOpenCSVLog();
            Line = ",Time (sec)";            
            Line $= ",CC Stimulus";            
            Line $= ",Priority";            
            Line $= ",Probability";            
            Line $= ",Pawn";            
            Line $= ",Nationality";            
            Line $= ",Voice ID";            
            Line $= ",Vocal State";            
            Line $= ",N";            
            Line $= ",V";            
            Line $= ",O";            
            Line $= ",A";            
            Line $= ",Perf Duration (sec)";            
            Line $= ",Sound Cue(s)";            
            Line $= ",Audio Duration (sec)";            
            Line $= ",Look-At Rule";            
            Line $= ",Attitude";            
            Line $= ",Expression";            
            Line $= ",Annotations";            
            Line $= ",Function";            
            Line $= ",In OIR?";            
            Line $= ",OIR";            
            Line $= ",Activity";            
            Line $= ",Firing?";
            CCWriteCSVLog(Line);            
        }
        else
        {
            CCCloseCSVLog();
        }
    }
    //return;    
}

protected event DebugLogToCSV(CCPerformerNative CCP, CCPerformance2 Performance, CCStimulus Stimulus, CCAudioPerformanceRequest APR)
{
    local string Line, StimulusName, CCPName, AudioPerformanceID, LookAtRuleName, AttitudeName,
	    ExpressionName;

    local CCStimulusType.ECCPriority StimulusPriority;
    local float ResponseProbability;
    local CCKeyPALookAt LookAtKey;
    local CCAttitude Attitude;
    local CCKeyExpression ExpressionKey;
    local float PerformanceDuration_sec, AudioDuration_sec;

    // End:0x74
    if(none != Stimulus.StimulusType)
    {
        StimulusName = string(Stimulus.StimulusType.Name);
        StimulusPriority = Stimulus.StimulusType.PriorityLevel;
        ResponseProbability = Stimulus.StimulusType.ResponseProbability;        
    }
    else
    {
        StimulusName = "";
        StimulusPriority = Class'CCStimulusType'.default.PriorityLevel;
        ResponseProbability = 0.0000000;
    }
    // End:0xDE
    if((none != CCP) && none != CCP.Owner)
    {
        CCPName = string(CCP.Owner.Name);        
    }
    else
    {
        CCPName = "";
    }
    AudioPerformanceID = "";
    LookAtRuleName = "";
    AttitudeName = "";
    ExpressionName = "";
    PerformanceDuration_sec = CCP.PerformanceState.PerformanceDuration_sec;
    AudioDuration_sec = CCP.PerformanceState.ChannelDuration_sec[0];
    // End:0x4B4
    if(none != Performance)
    {
        // End:0x36C
        if(none != Performance.AudioChannel)
        {
            // End:0x35A
            if(APR.bEnabled)
            {
                // End:0x357
                if((APR.NIndex >= 0) && APR.NIndex < Performance.AudioChannel.Nationalities.Length)
                {
                    // End:0x357
                    if((APR.VIndex >= 0) && APR.VIndex < Performance.AudioChannel.Nationalities[APR.NIndex].VocalStates.Length)
                    {
                        // End:0x357
                        if((APR.OIndex >= 0) && APR.OIndex < 9)
                        {
                            // End:0x357
                            if((APR.AIndex >= 0) && APR.AIndex < Performance.AudioChannel.Nationalities[APR.NIndex].VocalStates[APR.VIndex].VoiceID[APR.OIndex].Alternates.Length)
                            {
                                AudioPerformanceID = Performance.AudioChannel.Nationalities[APR.NIndex].VocalStates[APR.VIndex].VoiceID[APR.OIndex].Alternates[APR.AIndex].AudioPerformanceID;
                            }
                        }
                    }
                }                
            }
            else
            {
                AudioPerformanceID = "<disabled>";
            }
        }
        // End:0x442
        if((none != Performance.PALookAtChannel) && Performance.PALookAtChannel.keys.Length > 0)
        {
            LookAtKey = Performance.PALookAtChannel.keys[0];
            // End:0x442
            if((none != LookAtKey) && none != LookAtKey.LookAtRule)
            {
                LookAtRuleName = string(LookAtKey.LookAtRule.Name);
                Attitude = LookAtKey.LookAtRule.GetEffectiveAttitude();
                // End:0x442
                if(none != Attitude)
                {
                    AttitudeName = string(Attitude.Name);
                }
            }
        }
        // End:0x4B4
        if((none != Performance.ExpressionChannel) && Performance.ExpressionChannel.keys.Length > 0)
        {
            ExpressionKey = Performance.ExpressionChannel.keys[0];
            // End:0x4B4
            if(none != ExpressionKey)
            {
                ExpressionName = ExpressionKey.ExpressionName;
            }
        }
    }
    Line = "," $ string(WorldInfo.TimeSeconds);    
    Line $= ("," $ StimulusName);    
    Line $= ("," $ string(StimulusPriority));    
    Line $= ("," $ string(ResponseProbability));    
    Line $= ("," $ CCPName);    
    Line $= ("," $ string(CCP.Nationality));    
    Line $= ("," $ string(CCP.GetVoiceID()));    
    Line $= ("," $ string(CCP.VocalState));    
    Line $= ("," $ string(APR.NIndex));    
    Line $= ("," $ string(APR.VIndex));    
    Line $= ("," $ string(APR.OIndex));    
    Line $= ("," $ string(APR.AIndex));    
    Line $= ("," $ string(PerformanceDuration_sec));    
    Line $= ("," $ AudioPerformanceID);    
    Line $= ("," $ string(AudioDuration_sec));    
    Line $= ("," $ LookAtRuleName);    
    Line $= ("," $ AttitudeName);    
    Line $= ("," $ ExpressionName);
    CCWriteCSVLog(Line);
    //return;    
}

event AnnotateCSVLog(string StimulusName, string Text, optional string CCPName = "")
{
    local string Line;

    // End:0x91
    if(bLogToCSV)
    {
        Line = "," $ string(WorldInfo.TimeSeconds);        
        Line $= (("," $ StimulusName) $ ",,");        
        Line $= (("," $ CCPName) $ ",,,,,,,,,,,,,");        
        Line $= ("," $ Text);
        CCWriteCSVLog(Line);
    }
    //return;    
}

function DisableAID()
{
    //return;    
}

function EnableAID()
{
    //return;    
}

defaultproperties
{
    // Reference: CCDirectorAudio'Default__CCDirectorNative.AudioDir'
    begin object name=AudioDir class=Class'CCDirectorAudio'
    end object
    AudioDirector=AudioDir
    EnabledStateRaw=4
    TickGroup=2
    CollisionType=0
}