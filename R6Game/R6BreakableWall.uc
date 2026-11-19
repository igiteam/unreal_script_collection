class R6BreakableWall extends R6BreakableActor
    native
    hidecategories(Material);

var Vector m_avSideAVertex[2];
var Vector m_avSideBVertex[2];
var R6BreakableWall m_pTopParent;

function PostBeginPlay()
{
    PostBeginPlay();
    m_bIsDynamicObstacle = false;
    return;
}

defaultproperties
{
    m_bIsDynamicObstacle=false
    m_bIgnoreForNavMesh=false
}