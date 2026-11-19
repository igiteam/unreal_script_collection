class SPSkeletalMeshActor extends SkeletalMeshActor
    native;

var transient name SavedAnimSeq;
var transient bool bPlayingSaved;

simulated event BeginAnimControl(array<AnimSet> InAnimSets)
{
    local SPAnimNodeSequence SeqNode;

    SeqNode = SPAnimNodeSequence(SkeletalMeshComponent.Animations);
    bPlayingSaved = SeqNode.bPlaying;
    SavedAnimSeq = SeqNode.AnimSeqName;
    super.BeginAnimControl(InAnimSets);
    //return;    
}

simulated event SetAnimPosition(name SlotName, int ChannelIndex, name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping)
{
    local SPAnimNodeSequence SeqNode;

    SeqNode = SPAnimNodeSequence(SkeletalMeshComponent.Animations);
    // End:0xDA
    if(SeqNode.AnimSeqName != InAnimSeqName)
    {
        SeqNode.ResetRootBoneExtraction();
        SeqNode.bPlaying = false;
        SeqNode.m_bAbsoluteExtraction = true;
        SeqNode.m_bForceNoPlaying = true;
        SkeletalMeshComponent.m_rootExtractionMode.Mode = 1;
        SkeletalMeshComponent.m_rootExtractionMode.StartLocation = Location;
        SkeletalMeshComponent.m_rootExtractionMode.StartRotation = Rotation;
    }
    super.SetAnimPosition(SlotName, ChannelIndex, InAnimSeqName, InPosition, bFireNotifies, bLooping);
    //return;    
}

simulated event FinishAnimControl()
{
    local SPAnimNodeSequence SeqNode;

    super.FinishAnimControl();
    SkeletalMeshComponent.m_rootExtractionMode.Mode = 0;
    SeqNode = SPAnimNodeSequence(SkeletalMeshComponent.Animations);
    SeqNode.bPlaying = bPlayingSaved;
    SeqNode.SetAnim(SavedAnimSeq);
    SeqNode.m_bAbsoluteExtraction = false;
    SeqNode.m_bForceNoPlaying = false;
    //return;    
}

simulated function OnSpPlayFaceFXAnimNotify(SeqAct_SpPlayFaceFXAnimNotify inAction)
{
    local PlayerController PC;

    ClearLatentAction(Class'SeqAct_SpPlayFaceFXAnimNotify', false, inAction);
    // End:0x59
    if(SkeletalMeshComponent != none)
    {
        SkeletalMeshComponent.PlayFaceFXAnim(inAction.FaceFXAnimSetRef, inAction.FaceFXAnimName, inAction.FaceFXGroupName);
    }
    // End:0xD3
    foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
    {
        // End:0xD2
        if(NetConnection(PC.Player) != none)
        {
            PC.ClientPlayActorFaceFXAnim(self, inAction.FaceFXAnimSetRef, inAction.FaceFXGroupName, inAction.FaceFXAnimName);
        }        
    }    
    //return;    
}
