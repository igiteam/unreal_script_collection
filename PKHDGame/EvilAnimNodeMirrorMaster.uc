class EvilAnimNodeMirrorMaster extends UDKAnimBlendBase
    hidecategories(Object,Object,Object,Object);

var EvilPawn MyEvilPawn;
var bool bPlayingTransition;
var AnimNodeSequence ActSeq;
var array<EvilAnimCoverTransitionBlend> TransitionNodes;

event OnInit()
{
    local EvilAnimCoverTransitionBlend TransitionNode;

    super(AnimNode).OnInit();
    MyEvilPawn = EvilPawn(SkelComponent.Owner);
    // End:0x9B
    foreach MyEvilPawn.Mesh.AllAnimNodes(Class'EvilAnimCoverTransitionBlend', TransitionNode)
    {
        TransitionNodes.AddItem(TransitionNode);        
    }    
    //return;    
}

simulated event TickAnim(float DeltaSeconds)
{
    local EvilAnimCoverTransitionBlend TransitionNode;
    local bool bForceNonMirrorOutsideOfCover;

    // End:0x23
    if((MyEvilPawn == none) || TransitionNodes.Length <= 0)
    {
        return;
    }
    bForceNonMirrorOutsideOfCover = ((MyEvilPawn != none) && int(MyEvilPawn.CoverType) == int(0)) && (int(MyEvilPawn.PawnAction) == 0) || !MyEvilPawn.PawnActions[int(MyEvilPawn.PawnAction)].bCoverExitMirrorTransition;
    // End:0x14B
    if((bForceNonMirrorOutsideOfCover && MyEvilPawn != none) && MyEvilPawn.bWantsToBeMirrored)
    {
        MyEvilPawn.SetMirroredSide(false);
    }
    // End:0x255
    if(!bPlayingTransition)
    {
        // End:0x252
        if(MyEvilPawn.bIsMirrored != MyEvilPawn.bWantsToBeMirrored)
        {
            MyEvilPawn.bDoingCoverActionAnimTransition = true;
            TransitionNode = GetMostRelevantTransitionNode();
            // End:0x252
            if(TransitionNode != none)
            {
                ActSeq = TransitionNode.StartTransition(BlendTime);
                // End:0x252
                if((ActSeq != none) && ActSeq.bPlaying)
                {
                    bPlayingTransition = true;
                }
            }
        }        
    }
    else
    {
        // End:0x2F8
        if((ActSeq != none) && ActSeq.bPlaying)
        {
            // End:0x2F5
            if(ActSeq.GetTimeLeft() <= BlendTime)
            {
                TransitionBlendingOut(BlendTime);
                bPlayingTransition = false;
                MyEvilPawn.bDoingCoverActionAnimTransition = false;
            }            
        }
        else
        {
            TransitionBlendingOut(0.0000000);
            MyEvilPawn.bDoingCoverActionAnimTransition = false;
            bPlayingTransition = false;
        }
    }
    //return;    
}

function EvilAnimCoverTransitionBlend GetMostRelevantTransitionNode()
{
    local EvilAnimCoverTransitionBlend TransitionNode, Candidate;
    local int I;
    local float HightestWeight;

    HightestWeight = 0.0000000;
    switch(MyEvilPawn.CoverType)
    {
        // End:0x5C
        case 2:
            TransitionNode = FindTransNodeByName('Trans_MidCov');
            // End:0x81
            break;
        // End:0x7E
        case 1:
            TransitionNode = FindTransNodeByName('Trans_StdCov');
        // End:0xFFFF
        default:
            break;
    }
    // End:0x178
    if(TransitionNode == none)
    {
        I = 0;
        J0x9B:

        // End:0x178 [Loop If]
        if(I < TransitionNodes.Length)
        {
            Candidate = TransitionNodes[I];
            // End:0x16A
            if((Candidate != none) && Candidate.bRelevant)
            {
                // End:0x16A
                if(Candidate.NodeTotalWeight > HightestWeight)
                {
                    TransitionNode = Candidate;
                    HightestWeight = Candidate.NodeTotalWeight;
                }
            }
            I++;
            // [Loop Continue]
            goto J0x9B;
        }
    }
    return TransitionNode;
    //return ReturnValue;    
}

function EvilAnimCoverTransitionBlend FindTransNodeByName(name InNodeName)
{
    local EvilAnimCoverTransitionBlend TransitionNode;

    // End:0x4F
    foreach TransitionNodes(TransitionNode)
    {
        // End:0x4E
        if(TransitionNode.NodeName == InNodeName)
        {            
            return TransitionNode;
        }        
    }    
    return none;
    //return ReturnValue;    
}

function TransitionBlendingOut(float BlendOutTimeToGo)
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x68 [Loop If]
    if(I < TransitionNodes.Length)
    {
        TransitionNodes[I].SetBlendTarget(0.0000000, BlendOutTimeToGo);
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    MyEvilPawn.bIsMirrored = !MyEvilPawn.bIsMirrored;
    //return;    
}

defaultproperties
{
    bTickAnimInScript=true
    Children=/* Array type was not detected. */
    bFixNumChildren=true
    bCallScriptEventOnInit=true
    NodeName="EvilAnimNodeMirror"
}