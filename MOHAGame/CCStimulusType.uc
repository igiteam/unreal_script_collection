class CCStimulusType extends Object
    native
    editinlinenew
    hidecategories(Object);

enum ECCPriority
{
    CC_PRIORITY_UNINTERRUPTABLE,    // 0
    CC_PRIORITY_DEATHS,             // 1
    CC_PRIORITY_HITS,               // 2
    CC_PRIORITY_SCRIPTED_AID,       // 3
    CC_PRIORITY_GLOBAL_AID,         // 4
    CC_PRIORITY_NON_AUDIO,          // 5
    CC_PRIORITY_MAX                 // 6
};

enum ECCDetectionMethod
{
    CC_DETECT_MANUAL,               // 0
    CC_DETECT_ACTOR_CLASS_RADIUS,   // 1
    CC_DETECT_ACTOR_CLASS_VISIBLE,  // 2
    CC_DETECT_MAX                   // 3
};

struct native CCStimulus
{
    var() CCStimulusType StimulusType;
    var() Actor SourceActor;
    var() Vector SourceLocation;
    var() bool bUseSourceLocation;
    var bool bIsIdle;

    structdefaultproperties
    {
        StimulusType=none
        SourceActor=none
        SourceLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        bUseSourceLocation=false
        bIsIdle=false
    }
};

var() CCStimulusType.ECCPriority PriorityLevel;
var() CCHistory.EAgeAttenuationFunction AgeAttenuationFunc;
var() bool bIsDeath;
var() float ResponseProbability;
var() float AgeAttenuationMin_sec;
var() float AgeAttenuationMax_sec;

// Export UCCStimulusType::execAreStimuliIdentical(FFrame&, void* const)
native function bool AreStimuliIdentical(CCStimulus A, CCStimulus B);

// Export UCCStimulusType::execAreStimuliEquivalent(FFrame&, void* const)
native function bool AreStimuliEquivalent(CCStimulus A, CCStimulus B);

defaultproperties
{
    ResponseProbability=1.0000000
}