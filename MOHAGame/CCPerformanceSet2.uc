class CCPerformanceSet2 extends Object
    native
    editinlinenew
    hidecategories(Object);

enum ERestrictionLevel
{
    CC_RESTRICTION_NONE,            // 0
    CC_RESTRICTION_SPINE,           // 1
    CC_RESTRICTION_HEAD,            // 2
    CC_RESTRICTION_ALL,             // 3
    CC_RESTRICTION_MAX              // 4
};

struct native CCIdleStimulusByFiring
{
    var() CCStimulusType StimulusType;
    var() CCPerformanceSet2.ERestrictionLevel RestrictionLevel;
    var() CCStimulusType OptionalOneShotStimulusType;

    structdefaultproperties
    {
        StimulusType=none
        RestrictionLevel=0
        OptionalOneShotStimulusType=none
    }
};

struct native CCIdleStimulusByActivity
{
    var transient name ActivityTypeName;
    var transient name ActivityPoseName;
    var() AnimActivities.EOIRActivityName ActivityType;
    var() AnimActivities.EOIRActivityPose activityPose;
    var() CCIdleStimulusByFiring NotFiring;
    var() CCIdleStimulusByFiring Firing;

    structdefaultproperties
    {
        ActivityTypeName="None"
        ActivityPoseName="None"
        ActivityType=0
        activityPose=0
        NotFiring=(StimulusType=none,RestrictionLevel=0,OptionalOneShotStimulusType=none)
        Firing=(StimulusType=none,RestrictionLevel=0,OptionalOneShotStimulusType=none)
    }
};

struct native CCIdleStimulusByOIR
{
    var() name oir;
    var() init array<init CCIdleStimulusByActivity> Activities;

    structdefaultproperties
    {
        oir="None"
        Activities=none
    }
};

struct native CCIdleStimulus
{
    var CCStimulusType StimulusType;
    var CCPerformanceSet2.ERestrictionLevel RestrictionLevel;
    var CCStimulusType OptionalOneShotStimulusType;
    var int OIRIndex;
    var int ActivityIndex;

    structdefaultproperties
    {
        StimulusType=none
        RestrictionLevel=0
        OptionalOneShotStimulusType=none
        OIRIndex=-1
        ActivityIndex=-1
    }
};

var() int MaxVoices[13];
var() float VoiceIDExpirationRadius;
var() transient float GlobalResponseProbability;
var() export editinline array<export editinline CCPerformance2> Performances2;
var(Idles) array<CCIdleStimulusByOIR> Idles;
var(Idles) CCIdleStimulusByFiring DefaultFiringIdle;
var(Idles) CCIdleStimulusByFiring DefaultNotFiringIdle;
var(FaceFX) array<string> FaceFXRegisters;

// Export UCCPerformanceSet2::execMarkPackageDirtyFromScript(FFrame&, void* const)
native final function MarkPackageDirtyFromScript();

// Export UCCPerformanceSet2::execPostBeginPlay(FFrame&, void* const)
native function PostBeginPlay();

// Export UCCPerformanceSet2::execFindPerformance(FFrame&, void* const)
native function CCPerformance2 FindPerformance(CCStimulusType StimulusType, optional out int PIndex);

private final function CCIdleStimulus FindIdleStimulusForActivity(int OIRIndex, int ActivityIndex, bool bFiring)
{
    local CCIdleStimulus IdleStim;

    // End:0x19B
    if(bFiring)
    {
        IdleStim.StimulusType = Idles[OIRIndex].Activities[ActivityIndex].Firing.StimulusType;
        IdleStim.RestrictionLevel = Idles[OIRIndex].Activities[ActivityIndex].Firing.RestrictionLevel;
        IdleStim.OptionalOneShotStimulusType = Idles[OIRIndex].Activities[ActivityIndex].Firing.OptionalOneShotStimulusType;
        // End:0x198
        if(none == IdleStim.StimulusType)
        {
            IdleStim.StimulusType = Idles[OIRIndex].Activities[ActivityIndex].NotFiring.StimulusType;
            IdleStim.RestrictionLevel = Idles[OIRIndex].Activities[ActivityIndex].NotFiring.RestrictionLevel;
            IdleStim.OptionalOneShotStimulusType = Idles[OIRIndex].Activities[ActivityIndex].NotFiring.OptionalOneShotStimulusType;
        }        
    }
    else
    {
        IdleStim.StimulusType = Idles[OIRIndex].Activities[ActivityIndex].NotFiring.StimulusType;
        IdleStim.RestrictionLevel = Idles[OIRIndex].Activities[ActivityIndex].NotFiring.RestrictionLevel;
        IdleStim.OptionalOneShotStimulusType = Idles[OIRIndex].Activities[ActivityIndex].NotFiring.OptionalOneShotStimulusType;
        // End:0x32A
        if(none == IdleStim.StimulusType)
        {
            IdleStim.StimulusType = Idles[OIRIndex].Activities[ActivityIndex].Firing.StimulusType;
            IdleStim.RestrictionLevel = Idles[OIRIndex].Activities[ActivityIndex].Firing.RestrictionLevel;
            IdleStim.OptionalOneShotStimulusType = Idles[OIRIndex].Activities[ActivityIndex].Firing.OptionalOneShotStimulusType;
        }
    }
    // End:0x369
    if(none != IdleStim.StimulusType)
    {
        IdleStim.OIRIndex = OIRIndex;
        IdleStim.ActivityIndex = ActivityIndex;
    }
    return IdleStim;
    //return ReturnValue;    
}

private final function CCIdleStimulus FindIdleStimulusForOIR(int OIRIndex, name activity, name Pose, bool bFiring)
{
    local CCIdleStimulus IdleStim;
    local int ActivityIndex;

    ActivityIndex = 0;
    J0x07:

    // End:0xB0 [Loop If]
    if(ActivityIndex < Idles[OIRIndex].Activities.Length)
    {
        // End:0xA6
        if((Idles[OIRIndex].Activities[ActivityIndex].ActivityTypeName == activity) && Idles[OIRIndex].Activities[ActivityIndex].ActivityPoseName == Pose)
        {
            IdleStim = FindIdleStimulusForActivity(OIRIndex, ActivityIndex, bFiring);
            // [Explicit Break]
            goto J0xB0;
        }
        ++ActivityIndex;
        // [Loop Continue]
        goto J0x07;
    }
    J0xB0:

    return IdleStim;
    //return ReturnValue;    
}

function CCIdleStimulus FindIdleStimulus(name oir, name activity, name Pose, bool bFiring, CCIdleStimulus HintPrevIdleStim)
{
    local CCIdleStimulus IdleStim;
    local int OIRIndex, ActivityIndex;

    OIRIndex = HintPrevIdleStim.OIRIndex;
    ActivityIndex = HintPrevIdleStim.ActivityIndex;
    // End:0x13A
    if(((OIRIndex >= 0) && OIRIndex < Idles.Length) && Idles[OIRIndex].oir == oir)
    {
        // End:0x116
        if((((ActivityIndex >= 0) && ActivityIndex < Idles[OIRIndex].Activities.Length) && Idles[OIRIndex].Activities[ActivityIndex].ActivityTypeName == activity) && Idles[OIRIndex].Activities[ActivityIndex].ActivityPoseName == Pose)
        {
            IdleStim = FindIdleStimulusForActivity(OIRIndex, ActivityIndex, bFiring);            
        }
        else
        {
            IdleStim = FindIdleStimulusForOIR(OIRIndex, activity, Pose, bFiring);
        }        
    }
    else
    {
        OIRIndex = 0;
        J0x141:

        // End:0x19E [Loop If]
        if(OIRIndex < Idles.Length)
        {
            // End:0x194
            if(Idles[OIRIndex].oir == oir)
            {
                IdleStim = FindIdleStimulusForOIR(OIRIndex, activity, Pose, bFiring);
                // [Explicit Break]
                goto J0x19E;
            }
            ++OIRIndex;
            // [Loop Continue]
            goto J0x141;
        }
    }
    J0x19E:

    // End:0x2F2
    if(none == IdleStim.StimulusType)
    {
        IdleStim.OptionalOneShotStimulusType = none;
        // End:0x261
        if(bFiring)
        {
            IdleStim.StimulusType = DefaultFiringIdle.StimulusType;
            IdleStim.RestrictionLevel = DefaultFiringIdle.RestrictionLevel;
            // End:0x25E
            if(none == IdleStim.StimulusType)
            {
                IdleStim.StimulusType = DefaultNotFiringIdle.StimulusType;
                IdleStim.RestrictionLevel = DefaultNotFiringIdle.RestrictionLevel;
            }            
        }
        else
        {
            IdleStim.StimulusType = DefaultNotFiringIdle.StimulusType;
            IdleStim.RestrictionLevel = DefaultNotFiringIdle.RestrictionLevel;
            // End:0x2F2
            if(none == IdleStim.StimulusType)
            {
                IdleStim.StimulusType = DefaultFiringIdle.StimulusType;
                IdleStim.RestrictionLevel = DefaultFiringIdle.RestrictionLevel;
            }
        }
    }
    return IdleStim;
    //return ReturnValue;    
}

function int GetMaxVoicesForNationality(CCChannelAudio.ENationality Nationality)
{
    // End:0x30
    if((int(Nationality) >= 0) && int(Nationality) < int(13))
    {
        return MaxVoices[int(Nationality)];        
    }
    else
    {
        return 9;
    }
    //return ReturnValue;    
}

function float GetGlobalResponseProbability()
{
    // End:0x1A
    if(GlobalResponseProbability < 0.0000000)
    {
        GlobalResponseProbability = 1.0000000;
    }
    return GlobalResponseProbability;
    //return ReturnValue;    
}

defaultproperties
{
    MaxVoices[1]=9
    MaxVoices[2]=9
    MaxVoices[3]=5
    MaxVoices[4]=5
    MaxVoices[5]=5
    MaxVoices[6]=5
    MaxVoices[7]=5
    MaxVoices[8]=5
    MaxVoices[9]=5
    MaxVoices[10]=5
    MaxVoices[11]=5
    MaxVoices[12]=5
    VoiceIDExpirationRadius=5000.0000000
    GlobalResponseProbability=1.0000000
}