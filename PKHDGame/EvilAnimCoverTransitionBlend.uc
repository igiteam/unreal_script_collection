class EvilAnimCoverTransitionBlend extends UDKAnimBlendBase
    hidecategories(Object,Object,Object,Object);

var EvilPawn MyEvilPawn;

event OnInit()
{
    super(AnimNode).OnInit();
    MyEvilPawn = EvilPawn(SkelComponent.Owner);
    //return;    
}

simulated event TickAnim(float DeltaSeconds)
{
    super.TickAnim(DeltaSeconds);
    // End:0x24
    if(MyEvilPawn == none)
    {
        return;
    }
    //return;    
}

function AnimNodeSequence StartTransition(float BlendInTime)
{
    local AnimNodeSequence Seq;

    Seq = AnimNodeSequence(Children[1].Anim);
    // End:0xCD
    if(Seq != none)
    {
        // End:0x8F
        if(MyEvilPawn.bIsMirrored)
        {
            Seq.PlayAnim(false, -1.0000000, 0.0000000);            
        }
        else
        {
            Seq.PlayAnim(false, 1.0000000, 0.0000000);
        }
        SetActiveChild(1, BlendInTime);
    }
    return Seq;
    //return ReturnValue;    
}

function SetBlendTarget(float InBlendTarget, float InBlendTime)
{
    SetActiveChild(int(InBlendTarget), BlendTime);
    //return;    
}

defaultproperties
{
    bTickAnimInScript=true
    Children=/* Array type was not detected. */
    bFixNumChildren=true
    bCallScriptEventOnInit=true
}