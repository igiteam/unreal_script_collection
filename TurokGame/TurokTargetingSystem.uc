class TurokTargetingSystem extends ActorComponent
    native
    hidecategories(Actor,Object,ActorComponent);

const kMaxTargetThreatValue = 10.f;

enum ETargetType
{
    TARGETTYPE_None,                // 0
    TARGETTYPE_Human,               // 1
    TARGETTYPE_WhiskeyCompany,      // 2
    TARGETTYPE_MendelGruman,        // 3
    TARGETTYPE_GroundFauna,         // 4
    TARGETTYPE_AirFauna,            // 5
    TARGETTYPE_WaterFauna,          // 6
    TARGETTYPE_SmallCarnivore,      // 7
    TARGETTYPE_MediumCarnivore,     // 8
    TARGETTYPE_LargeCarnivore,      // 9
    TARGETTYPE_HugeCarnivore,       // 10
    TARGETTYPE_SmallHerbivore,      // 11
    TARGETTYPE_MediumHerbivore,     // 12
    TARGETTYPE_LargeHerbivore,      // 13
    TARGETTYPE_HugeHerbivore,       // 14
    TARGETTYPE_Bug,                 // 15
    TARGETTYPE_Plant,               // 16
    TARGETTYPE_Vehicle,             // 17
    TARGETTYPE_MGVehicle,           // 18
    TARGETTYPE_NoAIAttacks,         // 19
    TARGETTYPE_MAX                  // 20
};

var() float mTrackLOSTime;
var() bool mbConsiderHumans;
var() bool mbConsiderMendelGruman;
var() bool mbConsiderWhiskeyCompany;
var() bool mbConsiderFauna;
var() bool mbConsiderSmallHerbivore;
var() bool mbConsiderSmallCarnivore;
var() bool mbConsiderMediumHerbivore;
var() bool mbConsiderMediumCarnivore;
var() bool mbConsiderLargeHerbivore;
var() bool mbConsiderLargeCarnivore;
var() bool mbConsiderHugeHerbivore;
var() bool mbConsiderHugeCarnivore;
var() bool mbConsiderBugs;
var() bool mbConsiderPlants;
var() bool mbConsiderOthers;
var() bool mbConsiderSame;
var() bool mbConsiderSameWhenFlared;
var() bool mbConsiderVehicles;
var() bool mbConsiderMGVehicles;
var() bool mbConsiderPlayer;
var() bool mbConsiderReachability;
var bool mbTargetLOS;
var() byte mTargetType;
var() byte mTargetGroup;
var() float mWeightRange;
var() float mWeightHurt;
var() float mWeightLOS;
var() float mWeightNoise;
var() float mWeightIncoming;
var() float mWeightExistingTarget;
var() float mWeightMutualTarget;
var() float mWeightTargetedBy;
var() float mWeightUnfriendly;
var() float mWeightHuman;
var @NULL mCurrentTarget;
var @NULL mTargetLastKnownAnchor;
var @NULL mTargetLastKnownPos;
var float mCurrentTargetThreat;
var float mTimeSinceLosingLOS;
var float mLastTargetThreat;
var int mIsTargetedBy;
var array mTargeters;

// Export UTurokTargetingSystem::execUpdate(FFrame&, void* const)
native function Update(float Time, @NULL Controller);

// Export UTurokTargetingSystem::execHearNoise(FFrame&, void* const)
native function HearNoise(@NULL Controller, float Loudness, @NULL NoiseMaker, name NoiseType);

// Export UTurokTargetingSystem::execSetTarget(FFrame&, void* const)
native function bool SetTarget(@NULL Controller, @NULL TargetPawn, optional bool bCanSee, optional bool bUpdateFactory);

// Export UTurokTargetingSystem::execGetTargetLocation(FFrame&, void* const)
native function @NULL GetTargetLocation(@NULL Controller);

// Export UTurokTargetingSystem::execGetTarget(FFrame&, void* const)
native function @NULL GetTarget(@NULL Controller);

// Export UTurokTargetingSystem::execCheckPotentialTarget(FFrame&, void* const)
native function bool CheckPotentialTarget(@NULL Controller, @NULL TargetPawn, optional float noiseLevel);

// Export UTurokTargetingSystem::execConsiderTarget(FFrame&, void* const)
native function bool ConsiderTarget(@NULL Pawn, @NULL TargetPawn, optional bool ignoreHealth);

// Export UTurokTargetingSystem::execSetTargetLastKnown(FFrame&, void* const)
native function SetTargetLastKnown(@NULL lastKnownPos);

// Export UTurokTargetingSystem::execSetTargetLastKnownAnchor(FFrame&, void* const)
native function SetTargetLastKnownAnchor(@NULL lastKnownAnchor);

// Export UTurokTargetingSystem::execGetTargetLastKnown(FFrame&, void* const)
native function @NULL GetTargetLastKnown();

// Export UTurokTargetingSystem::execGetTargetLastKnownAnchor(FFrame&, void* const)
native function @NULL GetTargetLastKnownAnchor();

// Export UTurokTargetingSystem::execEvaluateFactoryDynamicTarget(FFrame&, void* const)
native function bool EvaluateFactoryDynamicTarget(@NULL Target, @NULL Factory, @NULL SpawnNode);

// Export UTurokTargetingSystem::execUpdateFactoryDynamicTarget(FFrame&, void* const)
native function UpdateFactoryDynamicTarget(@NULL Target, @NULL SpawnNode);

// Export UTurokTargetingSystem::execClearAllTargeters(FFrame&, void* const)
native function ClearAllTargeters(@NULL Controller);

function float GetCurrentThreatLevel()
{
    return mCurrentTargetThreat;
    //return ReturnValue;    
}

// Export UTurokTargetingSystem::execIsLame(FFrame&, void* const)
native final function bool IsLame();

function bool TargetIsTargeted()
{
    // End:0xA0
    if(Pawn(Owner) != none)
    {
        // End:0xA0
        if((TurokPawn(Pawn(Owner).Controller.Enemy) != none) && TurokPawn(Pawn(Owner).Controller.Enemy).mTargetingSystem != none)
        {
            return TurokPawn(Pawn(Owner).Controller.Enemy).mTargetingSystem.mIsTargetedBy > 0;
        }
    }
    return false;
    //return ReturnValue;    
}

iterator function (optional bool bClearFactory = false)
{
    local editinline @NULL targetSystem;

    mCurrentTarget = none;
    mCurrentTargetThreat = 0.0000000;
    mbTargetLOS = false;
    mTimeSinceLosingLOS = -1.0000000;
    // End:0x185
    if((Pawn(Owner) != none) && Pawn(Owner).Controller != none)
    {
        // End:0xAC
        if(TurokPawn(Pawn(Owner).Controller.Enemy) != none)
        {
            targetSystem = TurokPawn(Pawn(Owner).Controller.Enemy).mTargetingSystem;
        }
        // End:0x11A
        if(targetSystem != none)
        {
            targetSystem.mIsTargetedBy--;
            // End:0x2E00
            targetSystem.mTargeters.Remove(targetSystem.mTargeters.Find(case (((Owner != 1) != TurokAIController(Pawn(Owner).Controller)) == none) == :), TurokPawn(Pawn(Owner).Controller.Enemy) != none);
            }/* !MISMATCHING REMOVE, tried If got Type:Case Position:0x0E5! */
            Pawn(Owner).Controller.Enemy = none;
            TurokAIController(Pawn(Owner).Controller).TargetChanged();
        }
        // End:0x18E
        if(bClearFactory)
        {
        }
        //return;        
        @NULL/* !MISMATCHING REMOVE, tried Case got Type:If Position:0x02A! */
}

defaultproperties
{
    mTrackLOSTime=5.0000000
    mbConsiderHumans=true
    mbConsiderSmallHerbivore=true
    mbConsiderSmallCarnivore=true
    mbConsiderMediumHerbivore=true
    mbConsiderMediumCarnivore=true
    mbConsiderLargeHerbivore=true
    mbConsiderLargeCarnivore=true
    mbConsiderHugeHerbivore=true
    mbConsiderHugeCarnivore=true
    mbConsiderBugs=true
    mbConsiderVehicles=true
    mWeightRange=1.0000000
    mWeightHurt=1.0000000
    mWeightLOS=1.0000000
    mWeightNoise=1.0000000
    mWeightIncoming=1.0000000
    mWeightExistingTarget=1.0000000
    mWeightMutualTarget=1.0000000
    mWeightTargetedBy=1.0000000
    mWeightUnfriendly=1.0000000
    mWeightHuman=1.0000000
    mTimeSinceLosingLOS=-1.0000000
    TickGroup=3
}