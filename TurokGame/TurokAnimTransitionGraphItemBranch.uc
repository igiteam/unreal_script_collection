class TurokAnimTransitionGraphItemBranch extends TurokAnimTransitionGraphItem
    native
    hidecategories(Object,Object);

var(branch) name mBranchName;
var(branch) int mPreviewBranchIndex;
var transient int mBranchIndex;

event int GraphBranch(@NULL aiInterface, byte actorType)
{
    // End:0x39
    if(NotEqual_InterfaceInterface(TurokAnimInterfaceGraphEvents(aiInterface), TurokAnimInterfaceGraphEvents(none)))
    {
        return TurokAnimInterfaceGraphEvents(aiInterface).GraphBranch(self, actorType);
    }
    return mPreviewBranchIndex;
    //return ReturnValue;    
}

defaultproperties
{
    mBranchIndex=-1
    mOutputs=/* Array type was not detected. */
}