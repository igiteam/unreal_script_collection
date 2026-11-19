class R6NavMeshVertex extends Actor
    native
    notplaceable
    hidecategories(lighting);

var int m_iVertexIndex;
var Level m_pLevel;
var array<int> m_pConnectedTriangles;
var bool m_bIsACorner;
var array<Vector> m_aLeftGuideLine;
var array<Vector> m_aRightGuideLine;

defaultproperties
{
    Components=none
}