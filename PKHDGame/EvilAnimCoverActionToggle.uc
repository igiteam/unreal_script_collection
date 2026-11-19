class EvilAnimCoverActionToggle extends UDKAnimBlendBase
    hidecategories(Object,Object,Object,Object);

var EvilPawn MyEvilPawn;

event OnInit()
{
    super(AnimNode).OnInit();
    MyEvilPawn = EvilPawn(SkelComponent.Owner);
    //return;    
}

event OnBecomeRelevant()
{
    //return;    
}

function bool GetTransitionIndex(EvilTypes.ECoverBlend From, EvilTypes.ECoverBlend To, out int ChildIndex)
{
    local EvilTypes.ECoverBlend TempCB;
    local bool bRevertAnim;

    ChildIndex = -1;
    // End:0x6F
    if(int(From) > int(To))
    {
        bRevertAnim = true;
        TempCB = From;
        From = To;
        To = TempCB;
    }
    switch(From)
    {
        // End:0xC6
        case 0:
            switch(To)
            {
                // End:0xAD
                case 3:
                    ChildIndex = 0;
                    // End:0xC3
                    break;
                // End:0xC0
                case 4:
                    ChildIndex = 1;
                    // End:0xC3
                    break;
                // End:0xFFFF
                default:
                    break;
            }
            // End:0x103
            break;
        // End:0xF8
        case 3:
            switch(To)
            {
                // End:0xF2
                case 4:
                    ChildIndex = 2;
                    // End:0xF5
                    break;
                // End:0xFFFF
                default:
                    break;
            }
            // End:0x103
            break;
        // End:0x100
        case 4:
            // End:0x103
            break;
        // End:0xFFFF
        default:
            break;
    }
    return bRevertAnim;
    //return ReturnValue;    
}

function AnimNodeSequence GetTransitionNode(int ChildIndex)
{
    // End:0x5C
    if((ChildIndex >= 0) && ChildIndex < Children.Length)
    {
        return AnimNodeSequence(Children[ChildIndex].Anim);        
    }
    else
    {
        return none;
    }
    //return ReturnValue;    
}

function AnimNodeSequence StartTransition(optional int ChildIndex = -1, optional bool bRevertAnim)
{
    local AnimNodeSequence Seq;

    // End:0xA3
    if(ChildIndex > -1)
    {
        Seq = GetTransitionNode(ChildIndex);
        // End:0xA3
        if(Seq != none)
        {
            Seq.PlayAnim(false, ((bRevertAnim) ? -1.0000000 : 1.0000000), 0.0000000);
            SetActiveChild(ChildIndex, BlendTime);
        }
    }
    return Seq;
    //return ReturnValue;    
}

event OnCeaseRelevant()
{
    //return;    
}

simulated event TickAnim(float DeltaSeconds)
{
    // End:0x0F
    if(MyEvilPawn != none)
    {
    }
    //return;    
}

defaultproperties
{
    bTickAnimInScript=true
    Children=/* Array type was not detected. */
    bCallScriptEventOnBecomeRelevant=true
    bCallScriptEventOnCeaseRelevant=true
}