class MOHARagdollAudioInstance extends Object
    native;

struct native BodyPartState
{
    var transient float EarliestReplayTime;

    structdefaultproperties
    {
        EarliestReplayTime=0.0000000
    }
};

var transient array<BodyPartState> BodyPartStates;
var transient array<float> ImpactTimes;
var transient int NextImpactIx;
var transient float MinSpeed;
var const transient MOHARagdollAudioAsset Asset;
var transient Actor Owner;
var transient int MaxPlayCount;
var transient float MaxPlayCountInterval;

// Export UMOHARagdollAudioInstance::execDoImpact(FFrame&, void* const)
native function DoImpact(int RigidBody, float impactSpeed, const out Vector inImpactLocation, const out Vector inImpactNormal, Actor ImpactedActor, PhysicalMaterial Material);
