class R6CameraTree extends R6CameraNodeBlendBase
    native
    hidecategories(Object,Object,Object);

var transient bool m_bBeingEdited;
var array<R6TreeComment> m_Comments;

// Export UR6CameraTree::execDrawAnimDebug(FFrame&, void* const)
native final function DrawAnimDebug(Canvas Canvas, name StartingPoint, int iOffsetX, int iOffsetY, bool m_bAnimDebugRelevantOnly);

defaultproperties
{
    m_aChildren[0]=(m_Name="Child",m_pCamNode=none,m_fWeight=1.0000000,m_iDrawY=0)
}