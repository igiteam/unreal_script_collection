class R6PlayerProfileMgr extends Object
    native;

var array<R6PlayerOptions> m_aControllerProfiles;
var int m_ePlayerControllerID[2];
var byte m_bControllerEnabled[4];
var int m_eMasterControllerID;
var bool m_bLock;

defaultproperties
{
    m_ePlayerControllerID[1]=1
    m_bControllerEnabled[0]=1
    m_bControllerEnabled[1]=1
    m_bControllerEnabled[2]=1
    m_bControllerEnabled[3]=1
}