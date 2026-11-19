class TurokActorFactoryAI extends ActorFactoryAI
    native
    config(Editor)
    editinlinenew
    collapsecategories
    hidecategories(Object);

struct native SpawnAnimInfo
{
    var() @NULL graphSet;
    var() name graphName;

    structdefaultproperties
    {
        graphSet=none
        graphName="None"
    }
};

struct native SpawnAnims
{
    var() @NULL mJumpUp;
    var() @NULL mJumpDown;
    var() @NULL mJumpOver;
    var() @NULL mRunOutLeft;
    var() @NULL mRunOutRight;

    structdefaultproperties
    {
        mJumpUp=(graphSet=none,graphName="None")
        mJumpDown=(graphSet=none,graphName="None")
        mJumpOver=(graphSet=none,graphName="None")
        mRunOutLeft=(graphSet=none,graphName="None")
        mRunOutRight=(graphSet=none,graphName="None")
    }
};

var() array mAmmoPoolClass;
var() @NULL mSpawnAnims;

defaultproperties
{
    ControllerClass=none
    bGiveDefaultInventory=true
}