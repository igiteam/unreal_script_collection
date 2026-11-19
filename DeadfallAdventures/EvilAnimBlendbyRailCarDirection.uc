class EvilAnimBlendbyRailCarDirection extends UDKAnimBlendBase
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

    // End:0x37
    if((MyEvilPawn == none) || !MyEvilPawn.IsRidingRailCar())
    {
        return;
    }
    // End:0x68
    if(MyEvilPawn.bIsMirrored)
    {
        DesiredChildIndex = 2;        
    }
    else
    {
        DesiredChildIndex = 1;
    }
    // End:0xE7
    if(DesiredChildIndex != ActiveChildIndex)
    {
        // End:0xCB
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
    NodeName="RailCarDirectionNode"
}