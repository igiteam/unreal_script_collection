class EvilAnimNodeSequence extends AnimNodeSequence
    hidecategories(Object,Object,Object);

var() bool bBackToStartAfterPlay;

event OnCeaseRelevant()
{
    super(AnimNode).OnCeaseRelevant();
    // End:0x32
    if(bBackToStartAfterPlay)
    {
        SetPosition(0.0000000, !bNoNotifies);
    }
    //return;    
}

defaultproperties
{
    bBackToStartAfterPlay=true
    bCallScriptEventOnCeaseRelevant=true
}