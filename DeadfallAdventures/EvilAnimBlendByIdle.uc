class EvilAnimBlendByIdle extends UDKAnimBlendBase
    hidecategories(Object,Object,Object,Object);

simulated event TickAnim(float DeltaSeconds)
{
    local EvilPawn P;

    P = EvilPawn(SkelComponent.Owner);
    // End:0xF8
    if((SkelComponent != none) && P != none)
    {
        // End:0xE4
        if(P.bInMoveLatent || P.bFastSpinUp)
        {
            P.Mesh.RootMotionMode = 1;
            SetActiveChild(1, BlendTime);            
        }
        else
        {
            SetActiveChild(0, BlendTime);
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
}