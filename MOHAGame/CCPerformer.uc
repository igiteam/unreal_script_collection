class CCPerformer extends CCPerformerNative
    hidecategories(Object,Object);

var(Debug) bool bDebugDraw;
var(Debug) bool bVerbosePA;
var(Debug) bool bDebugDrawLastStimulus;
var(Debug) bool bDebugDrawPerformance;
var(Debug) float DebugDrawLastStimulusDuration_sec;
var(Debug) float DebugDrawPerformanceDuration_sec;
var const Color WhiteColor;
var const Color GreenColor;
var const Color RedColor;
var const Color YellowColor;
var const Font DebugFont;
var transient float DebugHeightScaleZ;
var const CCStimulusType Def_FiringCrouchCover;
var const CCStimulusType Def_IdleCrouchCover;
var const CCStimulusType Def_FiringStanding;
var const CCStimulusType Def_IdleStanding;
var const CCStimulusType Def_FiringRunning;
var const CCStimulusType Def_IdleRunning;

event int Owner_GetHealth()
{
    return 100;
    //return ReturnValue;    
}

function Owner_DrawDebugCoordinateSystem(Vector AxisLoc, Rotator AxisRot, float Scale, CCPerformerPawn.EDebugDepthPriorityGroup DepthPriGroup, optional bool bPersistentLines)
{
    Owner.DrawDebugCoordinateSystem(AxisLoc, AxisRot, Scale, bPersistentLines);
    //return;    
}

function Owner_DrawDebugSphere(Vector Center, float Radius, int Segments, byte R, byte G, byte B, CCPerformerPawn.EDebugDepthPriorityGroup DepthPriGroup, optional bool bPersistentLines)
{
    Owner.DrawDebugSphere(Center, Radius, Segments, R, G, B, bPersistentLines);
    //return;    
}

function HACK_GenerateStimuli()
{
    //return;    
}

function PostBeginPlay(int TeamIndex)
{
    StimulusHistory.Director = GetCCDirector();
    PerformanceState.PostBeginPlay(self, TeamIndex);
    DeathState = 0;
    TimeOfDeath_sec = -1.0000000;
    //return;    
}

function SetEnabled(bool bShouldEnable)
{
    bDisabled = !bShouldEnable;
    //return;    
}

private final function SetPARestrictionLevel(CCPerformanceSet2.ERestrictionLevel RestrictionLevel)
{
    local CCChannelStatePALookAt PALookAtState;
    local SkelControlPA PAControl;

    PALookAtState = CCChannelStatePALookAt(PerformanceState.ChannelState[1]);
    // End:0x5D
    if(none != PALookAtState)
    {
        PAControl = PALookAtState.PAControl;
        // End:0x5D
        if(none != PAControl)
        {
            PAControl.SetRestrictionLevel(RestrictionLevel);
        }
    }
    //return;    
}

private final function OnBodyStateChanged()
{
    local CCDirector Director;
    local CCStimulus CCS;

    Director = CCDirector(GetCCDirector());
    BodyState.IdleStim = Director.FindIdleStimulus(BodyState.oir, BodyState.activity, BodyState.Pose, BodyState.bFiring, BodyState.IdleStim);
    // End:0xFE
    if(none != BodyState.IdleStim.OptionalOneShotStimulusType)
    {
        CCS.StimulusType = BodyState.IdleStim.OptionalOneShotStimulusType;
        CCS.SourceActor = Owner;
        CCS.bIsIdle = false;
        OnStimulus(CCS);
    }
    SetIdleStimulusByType(BodyState.IdleStim.StimulusType, Owner);
    // End:0x161
    if(none == BodyState.IdleStim.StimulusType)
    {
        BodyState.IdleStim.RestrictionLevel = 0;
    }
    SetPARestrictionLevel(BodyState.IdleStim.RestrictionLevel);
    //return;    
}

function SetBodyState_InOIR(bool bInOIR)
{
    // End:0xF4
    if(BodyState.bInOIR != bInOIR)
    {
        BodyState.bInOIR = bInOIR;
        // End:0xF4
        if(!bInOIR)
        {
            BodyState.oir = Name_Human;
            switch(Owner_GetDesiredLocomotionPosture())
            {
                // End:0x7A
                case 0:
                    BodyState.activity = Name_Locomotion_Active;
                    // End:0xEB
                    break;
                // End:0x96
                case 1:
                    BodyState.activity = Name_Locomotion_Hip;
                    // End:0xEB
                    break;
                // End:0xB3
                case 2:
                    BodyState.activity = Name_Locomotion_Passive;
                    // End:0xEB
                    break;
                // End:0xD0
                case 3:
                    BodyState.activity = Name_Locomotion_Retreat;
                    // End:0xEB
                    break;
                // End:0xFFFF
                default:
                    BodyState.activity = Name_Locomotion_Active;
                    // End:0xEB
                    break;
                    break;
            }
            OnBodyStateChanged();            
        }
    }
    //return;    
}

function SetBodyState_Activity(name oir, name activity, name Pose)
{
    local CCStimulus CCS;

    // End:0x127
    if(BodyState.bInOIR && ((BodyState.oir != oir) || BodyState.activity != activity) || BodyState.Pose != Pose)
    {
        BodyState.oir = oir;
        BodyState.activity = activity;
        BodyState.Pose = Pose;
        // End:0x121
        if(activity == Class'EAKynapse.AnimActivities'.default.ActivityNames[6])
        {
            CCS.StimulusType = CCStimulusType(DynamicLoadObject("MOHA_CC.Stimuli.GrenadeThrow", Class'CCStimulusType', false));
            CCS.SourceActor = Owner;
            OnStimulus(CCS);
        }
        OnBodyStateChanged();
    }
    //return;    
}

function SetBodyState_Firing(bool bFiring)
{
    // End:0x38
    if(BodyState.bFiring != bFiring)
    {
        BodyState.bFiring = bFiring;
        OnBodyStateChanged();
    }
    //return;    
}

function bool GetBodyState_InOIR()
{
    return BodyState.bInOIR;
    //return ReturnValue;    
}

function bool GetBodyState_Firing()
{
    return BodyState.bFiring;
    //return ReturnValue;    
}

function bool OnStimulus(CCStimulus Stimulus)
{
    local bool bCanRespond;
    local float CurrentTime_sec;
    local int Index;

    // End:0x160
    if(none != Stimulus.StimulusType)
    {
        CurrentTime_sec = Owner.WorldInfo.TimeSeconds;
        bCanRespond = true;
        // End:0xC7
        if((((int(DeathState) == int(0)) || int(DeathState) == int(1)) || int(Stimulus.StimulusType.PriorityLevel) == int(0)) && Stimulus.StimulusType.bIsDeath)
        {
            DeathState = 1;
            TimeOfDeath_sec = Owner.WorldInfo.TimeSeconds;            
        }
        else
        {
            // End:0xDF
            if(int(DeathState) != int(0))
            {
                bCanRespond = false;
            }
        }
        // End:0x160
        if(IsEnabled())
        {
            // End:0x160
            if(bCanRespond && ShouldRespondToStimulus(Stimulus, CurrentTime_sec))
            {
                Index = StimulusQueue.Length;
                StimulusQueue[Index] = Stimulus;
                LastStimulusName = Stimulus.StimulusType.Name;
                LastStimulusTime_sec = Owner.WorldInfo.TimeSeconds;
                return true;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function bool OnStimulusConditional(CCStimulus Stimulus, CCChannelAudio.ENationality OnlyNationality, CCChannelAudio.EVoicePolicy VoicePolicy, optional array<name> FilterFunctions)
{
    local bool bVoicePolicyOK;
    local int I;

    bVoicePolicyOK = IsVoicePolicyAdheredTo(VoicePolicy);
    // End:0x96
    if(((int(OnlyNationality) == int(0)) || int(Nationality) == int(OnlyNationality)) && bVoicePolicyOK)
    {
        I = 0;
        J0x4E:

        // End:0x86 [Loop If]
        if(I < FilterFunctions.Length)
        {
            // End:0x7C
            if(CallFunctionOnPerformer(Owner, FilterFunctions[I]) == false)
            {
                return false;
            }
            I++;
            // [Loop Continue]
            goto J0x4E;
        }
        return OnStimulus(Stimulus);
    }
    return false;
    //return ReturnValue;    
}

private final function bool ShouldRespondToStimulus(CCStimulus Stimulus, float CurrentTime_sec)
{
    local float StartTime_sec, Age_sec, Variate, Probability, ProbabilityMult;

    // End:0x1A0
    if(none != Stimulus.StimulusType)
    {
        Probability = Stimulus.StimulusType.ResponseProbability * CCDirector(GetCCDirector()).GetEffectivePerformanceSet().GetGlobalResponseProbability();
        // End:0x76
        if(Probability > 1.0000000)
        {
            Probability = 1.0000000;
        }
        StimulusHistory.PurgeStaleEvents(CurrentTime_sec);
        TestStimulusHistoryEvent.StimulusType = Stimulus.StimulusType;
        TestStimulusHistoryEvent.SourceActor = Stimulus.SourceActor;
        // End:0x16E
        if(StimulusHistory.FindEventTime_sec(TestStimulusHistoryEvent, StartTime_sec))
        {
            Age_sec = CurrentTime_sec - StartTime_sec;
            ProbabilityMult = Class'CCHistory'.static.CalculateAgeAttenuationFactor(Age_sec, Stimulus.StimulusType.AgeAttenuationFunc, Stimulus.StimulusType.AgeAttenuationMin_sec, Stimulus.StimulusType.AgeAttenuationMax_sec);
            Probability *= ProbabilityMult;
        }
        Variate = FRand();
        // End:0x19B
        if((Probability > 0.0000000) && Variate <= Probability)
        {
            return true;            
        }
        else
        {
            return false;
        }        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

private final function SendIdleStimulus()
{
    local CCStimulus CCS;

    // End:0x56
    if(none != IdlePerformanceStimulusType)
    {
        CCS.StimulusType = IdlePerformanceStimulusType;
        CCS.SourceActor = IdlePerformanceActor;
        CCS.bIsIdle = true;
        OnStimulus(CCS);
    }
    //return;    
}

function SetIdleStimulus(string StimulusTypeName, Actor SourceActor)
{
    local CCStimulusType StimulusType;

    StimulusType = CCStimulusType(DynamicLoadObject(StimulusTypeName, Class'CCStimulusType', false));
    SetIdleStimulusByType(StimulusType, SourceActor);
    //return;    
}

function SetIdleStimulusByType(CCStimulusType StimulusType, Actor SourceActor)
{
    IdlePerformanceActor = SourceActor;
    // End:0x55
    if(((none != StimulusType) && IdlePerformanceStimulusType != StimulusType) && !PerformanceState.IsNonIdlePerformanceInProgress())
    {
        IdlePerformanceStimulusType = StimulusType;
        SendIdleStimulus();        
    }
    else
    {
        IdlePerformanceStimulusType = StimulusType;
    }
    //return;    
}

event OnPerformanceComplete(CCStimulusType StimulusType, bool bStartingNewPerformance)
{
    // End:0x27
    if((none != StimulusType) && StimulusType.bIsDeath)
    {
        DeathState = 3;
    }
    // End:0x57
    if((!bStartingNewPerformance && none != IdlePerformanceStimulusType) && int(DeathState) != int(3))
    {
        SendIdleStimulus();
    }
    //return;    
}

function DebugCCState()
{
    bDebugDraw = !bDebugDraw;
    //return;    
}

function TogglePALogToCSV()
{
    local CCChannelStatePALookAt PALookAtState;
    local SkelControlLookAtRules LAControl;
    local PlayerController PC;
    local string EnabledString;

    PALookAtState = CCChannelStatePALookAt(PerformanceState.ChannelState[1]);
    // End:0xE2
    if(none != PALookAtState)
    {
        LAControl = PALookAtState.LAControl;
        // End:0xE2
        if(none != LAControl)
        {
            LAControl.bLogToCSV = !LAControl.bLogToCSV;
            // End:0x8A
            if(LAControl.bLogToCSV)
            {
                EnabledString = "ENABLED";                
            }
            else
            {
                EnabledString = "DISABLED";
            }
            PC = FindPlayerController();
            // End:0xE2
            if(none != PC)
            {
                PC.ClientMessage("PA CSV Logging " $ EnabledString);
            }
        }
    }
    //return;    
}

simulated function PostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir)
{
    local CCChannelStateAudio AudioState;
    local CCChannelStatePALookAt PALookAtState;
    local CCChannelStateExpression ExpressionState;
    local CCChannelStateOutputStim OutputStimState;
    local CCKeyPALookAt PALookAtKey;
    local CCKeyExpression ExpressionKey;
    local CCKeyOutputStim OutputStimKey;
    local CCAttitude Attitude;
    local string AudioPerformanceID;
    local float CurrentTime_sec, LastStimulusAge_sec, PerformanceAge_sec;
    local array<string> Lines;
    local array<Color> LineColors;
    local float maxXL, XL, YL;
    local int LineIndex, LineCount;
    local Vector HeightScales, BasePos, pos;
    local Font oldFont;
    local float Factor;
    local Color StimulusColor, PerformanceColor, PAColor;
    local SkelControlPA PAControl;
    local SkelControlLookAtRules LAControl;
    local int TargetIndex, CurrentTargetIndex;
    local Vector CameraLocation, CameraI, CameraJ, CameraK;
    local Rotator CameraRotation;
    local string PAText;
    local Vector PAPos, PAPosToCamera;
    local bool bBehindCamera, bCloseToCamera;
    local float PACloseToCameraThresh;
    local CCLevelInfo LI;
    local CCDirector Director;
    local int PATextLineIndex, Index;

    Director = CCDirector(GetCCDirector());
    // End:0x1E
    if(Director == none)
    {
        return;
    }
    LI = Director.GetCCLevelInfo();
    // End:0x55
    if(none != LI)
    {
        PACloseToCameraThresh = LI.PACloseToCameraThresh;        
    }
    else
    {
        PACloseToCameraThresh = Class'CCLevelInfo'.default.PACloseToCameraThresh;
    }
    AudioState = CCChannelStateAudio(PerformanceState.ChannelState[0]);
    PALookAtState = CCChannelStatePALookAt(PerformanceState.ChannelState[1]);
    ExpressionState = CCChannelStateExpression(PerformanceState.ChannelState[2]);
    OutputStimState = CCChannelStateOutputStim(PerformanceState.ChannelState[3]);
    LAControl = PALookAtState.LAControl;
    // End:0x10C
    if(none != LAControl)
    {
        LAControl.bVerbose = bVerbosePA;
    }
    PAControl = PALookAtState.PAControl;
    // End:0x141
    if(none != PAControl)
    {
        PAControl.bVerbose = bVerbosePA;
    }
    // End:0x11B2
    if(bDebugDraw || Director.bDebugDrawAll)
    {
        LineCount = 0;
        CurrentTime_sec = Owner.WorldInfo.TimeSeconds;
        Lines[LineCount] = ((((string(Owner.Name) $ " (V") $ string(VoiceID)) $ ", ") $ string(Nationality)) $ ")";
        LineColors[LineCount] = WhiteColor;
        ++LineCount;
        // End:0x2BF
        if(bDebugDrawLastStimulus)
        {
            LastStimulusAge_sec = CurrentTime_sec - LastStimulusTime_sec;
            // End:0x286
            if(LastStimulusAge_sec < DebugDrawLastStimulusDuration_sec)
            {
                StimulusColor = GreenColor;
                Factor = 255.0000000 * (LastStimulusAge_sec / DebugDrawLastStimulusDuration_sec);
                StimulusColor.A = byte(255 - int(Factor));
                Lines[LineCount] = "Last stimulus: " $ string(LastStimulusName);
                LineColors[LineCount] = StimulusColor;
                ++LineCount;                
            }
            else
            {
                Lines[LineCount] = "Last stimulus: NONE";
                LineColors[LineCount] = WhiteColor;
                ++LineCount;
            }
        }
        // End:0xB62
        if(bDebugDrawPerformance)
        {
            // End:0x2FA
            if(Class'CCKey'.static.IsDurationInfinite(PerformanceState.PerformanceDuration_sec))
            {
                PerformanceAge_sec = 0.0000000;                
            }
            else
            {
                PerformanceAge_sec = CurrentTime_sec - (PerformanceState.StartTime_sec + PerformanceState.PerformanceDuration_sec);
                // End:0x33F
                if(PerformanceAge_sec < 0.0000000)
                {
                    PerformanceAge_sec = 0.0000000;
                }
            }
            // End:0xA99
            if(PerformanceState.bInProgress && PerformanceAge_sec < DebugDrawPerformanceDuration_sec)
            {
                PerformanceColor = YellowColor;
                Factor = 255.0000000 * (PerformanceAge_sec / DebugDrawPerformanceDuration_sec);
                PerformanceColor.A = byte(255 - int(Factor));
                // End:0x439
                if((none != PerformanceState.Performance) && PerformanceState.Performance.AudioChannel.GetAudioPerformanceID(PerformanceState.APR, AudioPerformanceID))
                {
                    Lines[LineCount] = "Last audio performance: " $ AudioPerformanceID;
                    LineColors[LineCount] = PerformanceColor;
                    ++LineCount;
                }
                Lines[LineCount] = "  Stimulus = " $ string(PerformanceState.Stimulus.StimulusType.Name);
                LineColors[LineCount] = PerformanceColor;
                ++LineCount;
                Lines[LineCount] = "  Stimulus Performance Priority = " $ string(GetEffectiveActivePerformancePriority());
                LineColors[LineCount] = PerformanceColor;
                ++LineCount;
                Lines[LineCount] = "  StartTime_sec = " $ string(PerformanceState.StartTime_sec);
                LineColors[LineCount] = PerformanceColor;
                ++LineCount;
                Lines[LineCount] = "  AudioHasLipSync = " $ string(AudioState.bHasFaceFX);
                LineColors[LineCount] = PerformanceColor;
                ++LineCount;
                // End:0x6F5
                if((PALookAtState.CurrentKey >= 0) && PALookAtState.CurrentKey < PALookAtState.CurrentKeys.Length)
                {
                    PALookAtKey = CCKeyPALookAt(PALookAtState.CurrentKeys[PALookAtState.CurrentKey]);
                    Attitude = PALookAtKey.GetEffectiveAttitude();
                    // End:0x633
                    if(none != Attitude)
                    {
                        Lines[LineCount] = "  Attitude = " $ string(Attitude.Name);                        
                    }
                    else
                    {
                        Lines[LineCount] = "  Attitude = none";
                    }
                    LineColors[LineCount] = PerformanceColor;
                    ++LineCount;
                    // End:0x6B9
                    if(none != PALookAtKey.LookAtRule)
                    {
                        Lines[LineCount] = "  LookAtRule = " $ string(PALookAtKey.LookAtRule.Name);                        
                    }
                    else
                    {
                        Lines[LineCount] = "  LookAtRule = none";
                    }
                    LineColors[LineCount] = PerformanceColor;
                    ++LineCount;                    
                }
                else
                {
                    Lines[LineCount] = "  Attitude = none";
                    LineColors[LineCount] = PerformanceColor;
                    ++LineCount;
                    Lines[LineCount] = "  LookAtRule = none";
                    LineColors[LineCount] = PerformanceColor;
                    ++LineCount;
                }
                // End:0x7C1
                if((PAControl == none) || int(PAControl.RestrictionLevel) == int(0))
                {
                    Lines[LineCount] = "  PARestriction = No bones restricted";                    
                }
                else
                {
                    // End:0x80D
                    if(int(PAControl.RestrictionLevel) == int(1))
                    {
                        Lines[LineCount] = "  PARestriction = Spine restricted";                        
                    }
                    else
                    {
                        // End:0x862
                        if(int(PAControl.RestrictionLevel) == int(2))
                        {
                            Lines[LineCount] = "  PARestriction = Head and below restricted";                            
                        }
                        else
                        {
                            Lines[LineCount] = "  PARestriction = All bones restricted";
                        }
                    }
                }
                LineColors[LineCount] = PerformanceColor;
                ++LineCount;
                Lines[LineCount] = "  Expression = none";
                LineColors[LineCount] = PerformanceColor;
                // End:0x995
                if((ExpressionState.CurrentKey >= 0) && ExpressionState.CurrentKey < ExpressionState.CurrentKeys.Length)
                {
                    ExpressionKey = CCKeyExpression(ExpressionState.CurrentKeys[ExpressionState.CurrentKey]);
                    // End:0x995
                    if(none != ExpressionKey)
                    {
                        Lines[LineCount] = ((("  Expression = " $ ExpressionKey.ExpressionName) $ " (") $ string(ExpressionKey.Strength)) $ ")";
                    }
                }
                ++LineCount;
                Lines[LineCount] = "  OutputStimulus = none";
                LineColors[LineCount] = PerformanceColor;
                // End:0xA8F
                if((OutputStimState.CurrentKey >= 0) && OutputStimState.CurrentKey < OutputStimState.CurrentKeys.Length)
                {
                    OutputStimKey = CCKeyOutputStim(OutputStimState.CurrentKeys[OutputStimState.CurrentKey]);
                    // End:0xA8F
                    if((none != OutputStimKey) && none != OutputStimKey.Stimulus)
                    {
                        Lines[LineCount] = "  OutputStimulus = " $ string(OutputStimKey.Stimulus.Name);
                    }
                }
                ++LineCount;                
            }
            else
            {
                Lines[LineCount] = "Current performance: NONE";
                LineColors[LineCount] = WhiteColor;
                ++LineCount;
            }
            Index = 0;
            J0xADF:

            // End:0xB62 [Loop If]
            if(Index < LastStimulusQueue.Length)
            {
                Lines[LineCount] = ((("StimulusQueue[" $ string(Index)) $ "] Type = (") $ string(LastStimulusQueue[Index].StimulusType)) $ ")";
                LineColors[LineCount] = WhiteColor;
                ++LineCount;
                ++Index;
                // [Loop Continue]
                goto J0xADF;
            }
        }
        // End:0xC1B
        if((none != Owner) && none != Pawn(Owner))
        {
            // End:0xBA4
            if(DebugHeightScaleZ == 0.0000000)
            {
                DebugHeightScaleZ = RandRange(1.0000000, 1.3000000);
            }
            HeightScales.X = 0.0000000;
            HeightScales.Y = 0.0000000;
            HeightScales.Z = DebugHeightScaleZ;
            BasePos = Owner.Location + (Pawn(Owner).GetCollisionHeight() * HeightScales);            
        }
        else
        {
            BasePos = Owner.Location;
        }
        pos = Canvas.Project(BasePos);
        maxXL = 0.0000000;
        LineIndex = 0;
        J0xC5B:

        // End:0xCB1 [Loop If]
        if(LineIndex < Lines.Length)
        {
            Canvas.__NFUN_464__(Lines[LineIndex], XL, YL);
            // End:0xCA7
            if(XL > maxXL)
            {
                maxXL = XL;
            }
            ++LineIndex;
            // [Loop Continue]
            goto J0xC5B;
        }
        pos.X -= (maxXL * 0.5000000);
        pos.X = FClamp(pos.X, 0.0000000, Canvas.ClipX - maxXL);
        pos.Y = FClamp(pos.Y, 0.0000000, Canvas.ClipY - YL);
        Canvas.SetPos(pos.X, pos.Y);
        oldFont = Canvas.Font;
        Canvas.Font = DebugFont;
        LineIndex = 0;
        J0xDA0:

        // End:0xDED [Loop If]
        if(LineIndex < Lines.Length)
        {
            Canvas.DrawColor = LineColors[LineIndex];
            Canvas.__NFUN_465__(Lines[LineIndex]);
            ++LineIndex;
            // [Loop Continue]
            goto J0xDA0;
        }
        Owner_DrawDebugCoordinateSystem(Owner_GetLocation(), Owner_GetRotation(), 15.0000000, 2);
        // End:0x119E
        if(none != PAControl)
        {
            CurrentTargetIndex = PAControl.GetCurrentTargetIndex();
            PC.GetPlayerViewPoint(CameraLocation, CameraRotation);
            GetAxes(CameraRotation, CameraI, CameraJ, CameraK);
            PATextLineIndex = -1;
            TargetIndex = 0;
            J0xE7C:

            // End:0x119E [Loop If]
            if(TargetIndex < PAControl.Targets.Length)
            {
                // End:0xEB2
                if(TargetIndex == CurrentTargetIndex)
                {
                    PAColor = RedColor;                    
                }
                else
                {
                    PAColor = WhiteColor;
                }
                PAPos = PAControl.Targets[TargetIndex].Position;
                PAText = ((("" $ string(PAControl.Targets[TargetIndex].Id)) $ " (") $ string(PAControl.Targets[TargetIndex].Weight)) $ ")";
                bCloseToCamera = VSizeSq(PAPosToCamera) < (PACloseToCameraThresh * PACloseToCameraThresh);
                // End:0xF74
                if(bCloseToCamera)
                {                    
                    PAText $= " [C]";
                }
                PAPosToCamera = CameraLocation - PAPos;
                bBehindCamera = (PAPosToCamera Dot CameraI) > 0.0000000;
                // End:0xFC9
                if(bBehindCamera && !bCloseToCamera)
                {                    
                    PAText $= " [B]";
                }
                // End:0xFF6
                if(bCloseToCamera || bBehindCamera)
                {
                    PAPos = CameraLocation + (CameraI * 10.0000000);
                }
                Owner_DrawDebugSphere(PAPos, 5.0000000, 4, PAColor.R, PAColor.G, PAColor.B, 2);
                Canvas.__NFUN_464__(PAText, XL, YL);
                BasePos = PAPos;
                pos = Canvas.Project(BasePos);
                pos.X -= XL;
                // End:0x10CA
                if(bCloseToCamera || bBehindCamera)
                {
                    pos.Y -= float(PATextLineIndex * 10);
                    ++PATextLineIndex;
                }
                pos.X = FClamp(pos.X, 0.0000000, Canvas.ClipX - XL);
                pos.Y = FClamp(pos.Y, 0.0000000, Canvas.ClipY - YL);
                Canvas.SetPos(pos.X, pos.Y);
                Canvas.DrawColor = PAColor;
                Canvas.__NFUN_465__(PAText);
                ++TargetIndex;
                // [Loop Continue]
                goto J0xE7C;
            }
        }
        Canvas.Font = oldFont;
    }
    //return;    
}

defaultproperties
{
    bDebugDrawLastStimulus=true
    bDebugDrawPerformance=true
    DebugDrawLastStimulusDuration_sec=10.0000000
    DebugDrawPerformanceDuration_sec=4.0000000
    WhiteColor=(R=255,G=255,B=255,A=255)
    GreenColor=(R=0,G=255,B=0,A=255)
    RedColor=(R=255,G=0,B=0,A=255)
    YellowColor=(R=255,G=255,B=0,A=255)
    DebugFont=Font'EngineFonts.SmallFont'
    Def_FiringCrouchCover=CCStimulusType'MOHA_CC.Stimuli.Def_FiringCrouchCover'
    Def_IdleCrouchCover=CCStimulusType'MOHA_CC.Stimuli.Def_IdleCrouchCover'
    Def_FiringStanding=CCStimulusType'MOHA_CC.Stimuli.Def_FiringStanding'
    Def_IdleStanding=CCStimulusType'MOHA_CC.Stimuli.Def_IdleStanding'
    Def_FiringRunning=CCStimulusType'MOHA_CC.Stimuli.Def_FiringRunning'
    Def_IdleRunning=CCStimulusType'MOHA_CC.Stimuli.Def_IdleRunning'
    bDisabled=false
    // Reference: CCHistory'Default__CCPerformer.StimHist'
    begin object name=StimHist class=Class'CCHistory'
    end object
    StimulusHistory=StimHist
    // Reference: CCPerformanceState'Default__CCPerformer.PerfState'
    begin object name=PerfState class=Class'CCPerformanceState'
    end object
    PerformanceState=PerfState
    // Reference: CCHistoryEventStimulus'Default__CCPerformer.HistEvent'
    begin object name=HistEvent
    end object
    TestStimulusHistoryEvent=HistEvent
}