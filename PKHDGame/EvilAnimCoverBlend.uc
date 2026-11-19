class EvilAnimCoverBlend extends UDKAnimBlendBase
    hidecategories(Object,Object,Object,Object);

var EvilPawn MyEvilPawn;
var EvilTypes.ECoverBlend LastDesiredBlend;
var EvilAnimCoverActionToggle AnimNodeCoverActionToggle;
var bool bPlayingTransition;
var AnimNodeSequence CurrentTransitionNode;

event OnInit()
{
    super(AnimNode).OnInit();
    MyEvilPawn = EvilPawn(SkelComponent.Owner);
    AnimNodeCoverActionToggle = EvilAnimCoverActionToggle(Children[1].Anim);
    //return;    
}

event OnCeaseRelevant()
{
    super(AnimNode).OnCeaseRelevant();
    // End:0x5C
    if(MyEvilPawn != none)
    {
        MyEvilPawn.UpdateCoverActionAnimTransition(false);
        CurrentTransitionNode = none;
        bPlayingTransition = false;
        LastDesiredBlend = 0;
    }
    //return;    
}

simulated event TickAnim(float DeltaSeconds)
{
    local int DesiredChildIndex;
    local EvilTypes.ECoverBlend DesiredBlend;
    local bool bDoingTransition;
    local int TransitionIndex;
    local bool bRevertTransition;

    // End:0x11
    if(MyEvilPawn == none)
    {
        return;
    }
    // End:0x119
    if(!MyEvilPawn.bThrowingGrenade)
    {
        switch(MyEvilPawn.CoverAction)
        {
            // End:0x62
            case 8:
            // End:0x82
            case 4:
                DesiredChildIndex = 3;
                DesiredBlend = 3;
                // End:0x116
                break;
            // End:0x87
            case 2:
            // End:0x9B
            case 1:
                DesiredChildIndex = 5;
                // End:0x116
                break;
            // End:0xA0
            case 7:
            // End:0xC0
            case 3:
                DesiredChildIndex = 3;
                DesiredBlend = 3;
                // End:0x116
                break;
            // End:0xC5
            case 9:
            // End:0xE5
            case 5:
                DesiredChildIndex = 4;
                DesiredBlend = 4;
                // End:0x116
                break;
            // End:0xF9
            case 6:
                DesiredChildIndex = 6;
                // End:0x116
                break;
            // End:0xFFFF
            default:
                DesiredChildIndex = 0;
                DesiredBlend = 0;
                // End:0x116
                break;
                break;
        }        
    }
    else
    {
        DesiredChildIndex = 0;
        DesiredBlend = 0;
    }
    // End:0x39F
    if(DesiredChildIndex != ActiveChildIndex)
    {
        // End:0x33F
        if((AnimNodeCoverActionToggle != none) && int(DesiredBlend) != int(LastDesiredBlend))
        {
            bRevertTransition = AnimNodeCoverActionToggle.GetTransitionIndex(LastDesiredBlend, DesiredBlend, TransitionIndex);
            // End:0x212
            if(bRevertTransition && AnimNodeCoverActionToggle.GetTransitionNode(TransitionIndex + 3) != none)
            {
                bRevertTransition = false;
                TransitionIndex += 3;
            }
            // End:0x31E
            if(TransitionIndex >= 0)
            {
                // End:0x2AA
                if(CurrentTransitionNode != AnimNodeCoverActionToggle.GetTransitionNode(TransitionIndex))
                {
                    CurrentTransitionNode = AnimNodeCoverActionToggle.StartTransition(TransitionIndex, bRevertTransition);
                    SetActiveChild(1, BlendTime);                    
                }
                else
                {
                    // End:0x31B
                    if(!CurrentTransitionNode.bPlaying || CurrentTransitionNode.GetTimeLeft() < BlendTime)
                    {
                        LastDesiredBlend = DesiredBlend;
                        CurrentTransitionNode = none;
                    }
                }                
            }
            else
            {
                LastDesiredBlend = DesiredBlend;
                CurrentTransitionNode = none;
            }            
        }
        else
        {
            // End:0x380
            if(ChildBlendTimes.Length > DesiredChildIndex)
            {
                SetActiveChild(DesiredChildIndex, ChildBlendTimes[DesiredChildIndex]);                
            }
            else
            {
                SetActiveChild(DesiredChildIndex, BlendTime);
            }
        }        
    }
    else
    {
        LastDesiredBlend = DesiredBlend;
    }
    bDoingTransition = ((Children[ActiveChildIndex].Weight < 0.9900000) || ActiveChildIndex != DesiredChildIndex) || ActiveChildIndex == 1;
    MyEvilPawn.UpdateCoverActionAnimTransition(bDoingTransition);
    // End:0x4CE
    if(!bDoingTransition)
    {
        // End:0x4CE
        if(int(MyEvilPawn.CoverActionAnim) != int(MyEvilPawn.CoverAction))
        {
            MyEvilPawn.CoverActionAnim = MyEvilPawn.CoverAction;
        }
    }
    super.TickAnim(DeltaSeconds);
    //return;    
}

defaultproperties
{
    bTickAnimInScript=true
    Children=/* Array type was not detected. */
    bFixNumChildren=true
    bCallScriptEventOnInit=true
    bCallScriptEventOnCeaseRelevant=true
    NodeName="CoverBlendNode"
}