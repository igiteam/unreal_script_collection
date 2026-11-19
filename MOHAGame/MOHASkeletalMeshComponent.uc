class MOHASkeletalMeshComponent extends SkeletalMeshComponent
    native
    editinlinenew
    hidecategories(Object)
    autoexpandcategories(Collision,Rendering,Lighting);

var() float FOV;
var() float fCustomBoundsSize;
var() bool bMatchLODWithParentAnimComponent;
var bool bForceNoTick;
var bool bLockTranslation;
var transient bool bPoseRootBoneOnly;
var transient bool bLODExempted;
var() int iMinLODLevel;
var float fActivitySetTime;
var Vector lockTranslationVector;
var transient float AccumulatedDeltaTime;

// Export UMOHASkeletalMeshComponent::execForceTick(FFrame&, void* const)
native function ForceTick(float fDeltaTime);

// Export UMOHASkeletalMeshComponent::execGetParentBoneNative(FFrame&, void* const)
native function name GetParentBoneNative(name BoneName);

function PlayAnimAtRate(name AnimName, optional float DesiredRate, optional float DesiredPosition = 0.0000000, optional bool bLoop, optional bool bRestartIfAlreadyPlaying = false)
{
    local AnimNodeSequence AnimNode;

    AnimNode = AnimNodeSequence(Animations);
    // End:0x6E
    if((AnimNode == none) && Animations.IsA('AnimTree'))
    {
        AnimNode = AnimNodeSequence(AnimTree(Animations).Children[0].Anim);
    }
    // End:0xA5
    if(AnimNode == none)
    {
        AnimNode = AnimNodeSequence(Animations.FindAnimNode(AnimName));
        // End:0xA5
        if(AnimNode == none)
        {
            return;
        }
    }
    // End:0x149
    if((AnimNode.AnimSeq != none) && AnimNode.AnimSeq.SequenceName == AnimName)
    {
        AnimNode.bPlaying = true;
        // End:0x11C
        if(bRestartIfAlreadyPlaying)
        {
            AnimNode.PlayAnim(bLoop, DesiredRate, DesiredPosition);            
        }
        else
        {
            AnimNode.Rate = DesiredRate;
            AnimNode.bLooping = bLoop;
        }        
    }
    else
    {
        AnimNode.SetAnim(AnimName);
        // End:0x198
        if(AnimNode.AnimSeq != none)
        {
            AnimNode.PlayAnim(bLoop, DesiredRate, DesiredPosition);
        }
    }
    //return;    
}

function float GetAnimNormalizedPosition(name AnimName)
{
    local AnimNodeSequence AnimNode;

    AnimNode = AnimNodeSequence(Animations);
    // End:0x5E
    if((AnimNode == none) && Animations.IsA('AnimTree'))
    {
        AnimNode = AnimNodeSequence(AnimTree(Animations).Children[0].Anim);
    }
    // End:0x99
    if(AnimNode == none)
    {
        AnimNode = AnimNodeSequence(Animations.FindAnimNode(AnimName));
        // End:0x99
        if(AnimNode == none)
        {
            return 0.0000000;
        }
    }
    // End:0xE4
    if((AnimNode.AnimSeq != none) && AnimNode.AnimSeq.SequenceName == AnimName)
    {
        return AnimNode.GetNormalizedPosition();
    }
    //return ReturnValue;    
}

function float GetAnimCurrentTime(name AnimName)
{
    return (GetAnimNormalizedPosition(AnimName)) * GetAnimLength(AnimName);
    //return ReturnValue;    
}

function SetLockTranslationVector(Vector NewTranslation)
{
    lockTranslationVector = NewTranslation;
    //return;    
}

defaultproperties
{
    bAcceptsDecalsDuringGameplay=false
}