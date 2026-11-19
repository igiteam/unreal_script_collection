class EvilAnimBlendByWalkSpeed extends UDKAnimBlendBase
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
    // End:0x35
    if((MyEvilPawn == none) || !bRelevant)
    {
        return;
    }
    // End:0x99
    if(MyEvilPawn.bShouldWalkFast != (ActiveChildIndex == 1))
    {
        SetActiveChild(int(MyEvilPawn.bShouldWalkFast), BlendTime);
    }
    //return;    
}

defaultproperties
{
    bTickAnimInScript=true
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}