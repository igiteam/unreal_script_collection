class MOHACoverService extends AxonCoverService;

var AnimSet OIRAnimSet;
var AnimTree OIRAnimTree;

protected function bool GetSingleCoverNode(int idx, out KynapseCoverNode Node)
{
    // End:0x17
    if(!super.GetSingleCoverNode(idx, Node))
    {
        return false;
    }
    SetAnimSetOnNode(Node);
    return true;
    //return ReturnValue;    
}

protected function SetAnimSetOnNode(out KynapseCoverNode Node)
{
    Node.OIRAnimSet = OIRAnimSet;
    Node.OIRAnimTree = OIRAnimTree;
    //return;    
}

defaultproperties
{
    OIRAnimSet=AnimSet'Anim_AI_CoverAnimSet.AnimSet.CoverAnimSet'
    OIRAnimTree=AnimTree'Anim_AI_Cover.AnimTrees.CoverTest'
}