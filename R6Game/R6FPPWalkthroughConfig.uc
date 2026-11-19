class R6FPPWalkthroughConfig extends R6Config
    native
    config(Game)
    hidecategories(Object);

var(Menus) Texture2D m_QuittingScreen;
var(Menus) Texture2D m_MapLoadingScreen;
var(Menus) Texture2D m_ProgressBar;
var(Menus) Vector2D m_ProgressBarStart;
var(Menus) Vector2D m_ProgressBarEnd;
var config int m_iQuitWaitTime;
var config string m_FPPMap;
var config bool m_bShowExitScreen;

defaultproperties
{
    m_iQuitWaitTime=5
    m_FPPMap="05_Dantes_FPP_03"
    m_szDescription="FPP walkthrough settings"
}