class EvilAnimNodeBlendByLightInfluence extends UDKAnimBlendBase
    hidecategories(Object,Object,Object,Object);

var EvilPawn MyEvilPawn;
var AnimNodeAdditiveBlending AddAnim;

event OnInit()
{
    super(AnimNode).OnInit();
    MyEvilPawn = EvilPawn(SkelComponent.Owner);
    AddAnim = AnimNodeAdditiveBlending(Children[0].Anim);
    //return;    
}

simulated event TickAnim(float DeltaSeconds)
{
    // End:0x22
    if((MyEvilPawn == none) || AddAnim == none)
    {
        return;
    }
    // End:0xA0
    if(MyEvilPawn.LightInfluenceWeight > float(0))
    {
        // End:0x9D
        if(AddAnim.NodeTotalWeight < 1.0000000)
        {
            AddAnim.SetBlendTarget(1.0000000, BlendTime);
        }        
    }
    else
    {
        // End:0xF5
        if(AddAnim.NodeTotalWeight > 0.0000000)
        {
            AddAnim.SetBlendTarget(0.0000000, BlendTime);
        }
    }
    //return;    
}

defaultproperties
{
    bTickAnimInScript=true
    Children=/* Array type was not detected. */
    bFixNumChildren=true
    bCallScriptEventOnInit=true
}