class R6FacialSequence extends Object
    native
    hidecategories(Object);

var Texture2D m_pGenericBrowserIcon;
var() string m_UserDescription;
var float m_fTotalTime;
var transient float m_fCurrentTime;
var transient bool m_bPlaying;
var native const noexport LazyArray_Mirror m_Tracks;
var native const noexport array<int> m_Shapes;

defaultproperties
{
    m_pGenericBrowserIcon=Texture2D'KellerResource.S_FacialSequence'
}