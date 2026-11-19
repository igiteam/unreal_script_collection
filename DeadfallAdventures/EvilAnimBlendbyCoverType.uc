class EvilAnimBlendbyCoverType extends UDKAnimBlendBase
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
    local int DesiredChildIndex;

    // End:0x11
    if(MyEvilPawn == none)
    {
        return;
    }
    // End:0x6A
    if(int(MyEvilPawn.CoverType) != int(0))
    {
        DesiredChildIndex = int(MyEvilPawn.CoverType) - int(1);
    }
    // End:0xDE
    if(DesiredChildIndex != ActiveChildIndex)
    {
        // End:0xC2
        if(ChildBlendTimes.Length > DesiredChildIndex)
        {
            SetActiveChild(DesiredChildIndex, ChildBlendTimes[DesiredChildIndex]);            
        }
        else
        {
            SetActiveChild(DesiredChildIndex, BlendTime);
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
    NodeName="CoverTypeNode"
}