class SkySkelMeshComponent extends SkeletalMeshComponent
    native
    editinlinenew;

var(Transitions) AnimTransitionTable TransitionTable;
var int LockInputCounter;
var transient int TransitionNodeRecursionCounter;
var transient SkyAnimNodeSequence BlendSequence;
var transient SkyAnimNodeSequence PerBoneSequence1;
var transient SkyAnimNodeSequence PerBoneSequence2;
var transient AnimNodeMirror MirrorNode;
var transient AnimNodeBlendPerBone PerBoneNode;
var transient AnimNodeBlendList PerBoneBlendHelper;
var transient AnimNodeMirror PerBoneMirrorNode;
var transient array<AnimNodeTransition> GreatestBlendSequences;
var transient array<AnimNodeTransition> TempGreatestBlendSequences;
var(Transitions) int TotalGroups;
var(Transitions) bool DisableTransitions;
var() array<AnimSet> OriginalAnimSets;
var transient name DisplayBoneBranch;

// Export USkySkelMeshComponent::execBuildComposePriorityList(FFrame&, void* const)
native final function BuildComposePriorityList(out array<byte> PriorityList);

// Export USkySkelMeshComponent::execExtractVelocity(FFrame&, void* const)
native final function ExtractVelocity(AnimNodeSequence NodeSeq, name BoneName, float CheckTime, float LookBackTime, out Vector Velocity);

function SetShowBones(bool Enabled, optional name Branch)
{
    local Actor TempOwner;
    local bool bReattach;

    TempOwner = Owner;
    // End:0x27
    if(Enabled != (bDisplayBones == 1))
    {
        bReattach = true;
    }
    bDisplayBones = ((Enabled) ? 1 : 0);
    DisplayBoneBranch = Branch;
    // End:0x70
    if(bReattach)
    {
        TempOwner.DetachComponent(self);
        TempOwner.AttachComponent(self);
    }
    //return;    
}
