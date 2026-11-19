class EvilAnimNodeBlendByProperty extends AnimNodeBlendByProperty
    hidecategories(Object,Object,Object,Object);

var() bool bSynchronizeNodesWithTheSameProperty;
var transient array<AnimNodeBlendByProperty> CachedBlendByPropertyNodes;

event OnInit()
{
    local AnimNodeBlendByProperty Prop;

    super(AnimNode).OnInit();
    // End:0x81
    foreach SkelComponent.AllAnimNodes(Class'Engine.AnimNodeBlendByProperty', Prop)
    {
        // End:0x80
        if(Prop.PropertyName == PropertyName)
        {
            CachedBlendByPropertyNodes.AddItem(Prop);            
        }        
    }    
    //return;    
}

event OnCeaseRelevant()
{
    local AnimNodeBlendByProperty Prop;

    OnBecomeRelevant();
    // End:0xE5
    if((SkelComponent != none) && bSynchronizeNodesWithTheSameProperty)
    {
        // End:0xE4
        foreach CachedBlendByPropertyNodes(Prop)
        {
            Prop.Children[0].Weight = Children[0].Weight;
            Prop.Children[1].Weight = Children[1].Weight;            
        }        
    }
    //return;    
}

defaultproperties
{
    bCallScriptEventOnInit=true
    bCallScriptEventOnCeaseRelevant=true
}