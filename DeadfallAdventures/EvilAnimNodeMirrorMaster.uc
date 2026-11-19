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
    bForceNonMirrorOutsideOfCover = (((MyEvilPawn != none) && int(MyEvilPawn.CoverType) == int(0)) && !MyEvilPawn.IsRidingRailCar()) && (int(MyEvilPawn.PawnAction) == 0) || !MyEvilPawn.PawnActions[int(MyEvilPawn.PawnAction)].bCoverExitMirrorTransition;
    // End:0x171
    if((bForceNonMirrorOutsideOfCover && MyEvilPawn != none) && MyEvilPawn.bWantsToBeMirrored)
    {
        MyEvilPawn.SetMirroredSide(false);
    }
    // End:0x27B
    if(!bPlayingTransition)
    {
        // End:0x278
        if(MyEvilPawn.bIsMirrored != MyEvilPawn.bWantsToBeMirrored)
        {
            MyEvilPawn.bDoingCoverActionAnimTransition = true;
            TransitionNode = GetMostRelevantTransitionNode();
            // End:0x278
            if(TransitionNode != none)
            {
                ActSeq = TransitionNode.StartTransition(BlendTime);
                // End:0x278
                if((ActSeq != none) && ActSeq.bPlaying)
                {
                    bPlayingTransition = true;
                }
            }
        }        
    }
    else
    {
        // End:0x31E
        if((ActSeq != none) && ActSeq.bPlaying)
        {
            // End:0x31B
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
    // End:0x93
    if(MyEvilPawn.IsRidingRailCar())
    {
        // End:0x73
        if(MyEvilPawn.RailCarTransitionByLeft())
        {
            TransitionNode = FindTransNodeByName('Trans_RailCarL');            
        }
        else
        {
            TransitionNode = FindTransNodeByName('Trans_RailCarR');
        }        
    }
    else
    {
        switch(MyEvilPawn.CoverType)
        {
            // End:0xE0
            case 2:
                TransitionNode = FindTransNodeByName('Trans_MidCov');
                // End:0x105
                break;
            // End:0x102
            case 1:
                TransitionNode = FindTransNodeByName('Trans_StdCov');
            // End:0xFFFF
            default:
                break;
        }
    }
    // End:0x1FC
    if(TransitionNode == none)
    {
        I = 0;
        J0x11F:

        // End:0x1FC [Loop If]
        if(I < TransitionNodes.Length)
        {
            Candidate = TransitionNodes[I];
            // End:0x1EE
            if((Candidate != none) && Candidate.bRelevant)
            {
                // End:0x1EE
                if(Candidate.NodeTotalWeight > HightestWeight)
                {
                    TransitionNode = Candidate;
                    HightestWeight = Candidate.NodeTotalWeight;
                }
            }
            I++;
            // [Loop Continue]
            goto J0x11F;
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