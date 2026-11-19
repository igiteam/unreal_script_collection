class EvilAnimBaseBlendNode extends UDKAnimBlendBase
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
    // End:0x6E
    if((int(MyEvilPawn.CoverType) != int(0)) && !MyEvilPawn.bMovingToCover)
    {
        DesiredChildIndex = 1;        
    }
    else
    {
        // End:0xAF
        if((ActiveChildIndex == 1) && MyEvilPawn.bDoingCoverActionAnimTransition)
        {
            DesiredChildIndex = 1;            
        }
        else
        {
            DesiredChildIndex = 0;
        }
    }
    // End:0x12E
    if(DesiredChildIndex != ActiveChildIndex)
    {
        // End:0x112
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
    NodeName="BaseBlendNode"
}