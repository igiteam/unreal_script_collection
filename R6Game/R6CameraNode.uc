class R6CameraNode extends Object
    abstract
    native
    hidecategories(Object);

var int m_iNodePosX;
var int m_iNodePosY;
var int m_iOutDrawY;
var int m_iDrawWidth;
var int m_iDrawHeight;
var transient float m_fDebugHeight;
var transient Texture2D m_DebugIcon;
var transient bool m_bShowDebugTick;
var transient R6Camera m_pCamera;
var transient int m_iTick;

defaultproperties
{
    m_DebugIcon=Texture2D'EngineResources.AnimBlendIcon'
}