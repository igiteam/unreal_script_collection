class TurokAnimTransitionGraphItem extends Object
    abstract
    native
    hidecategories(Object);

var int mNodePosX;
var int mNodePosY;
var int mDrawWidth;
var int mDrawHeight;
var int mOutDrawY;
var int mInDrawY;
var array mOutputs;

// Export UTurokAnimTransitionGraphItem::execGetGraphSet(FFrame&, void* const)
native function @NULL GetGraphSet();

// Export UTurokAnimTransitionGraphItem::execGetGraph(FFrame&, void* const)
native function @NULL GetGraph();

event bool GraphInterrupt(@NULL aiInterface, byte actorType)
{
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    mOutputs=/* Array type was not detected. */
}