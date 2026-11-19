class R6HandSignalsConfig extends R6Config
    native
    hidecategories(Object);

struct R6HandSignalProperty
{
    var() float m_fTime;
    var() float m_fFPIkActivation;
    var() float m_fFPIkActDuration;
    var() float m_fTPIkActivation;
    var() float m_fTPIkActDuration;
    var() float m_fTCIkActivation;
    var() float m_fTCIkActDuration;
    var() float m_fFPIkDeactivation;
    var() float m_fFPIkDeactDuration;
    var() float m_fTPIkDeactivation;
    var() float m_fTPIkDeactDuration;
    var() float m_fTCIkDeactivation;
    var() float m_fTCIkDeactDuration;
    var() string m_strFPAnim;
    var() string m_strTPAnim;
    var() string m_strTCAnim;
    var() editconst R6EngineEnums.EOrderSignalId m_Id;

    structdefaultproperties
    {
        m_fTime=0.0000000
        m_fFPIkActivation=0.0000000
        m_fFPIkActDuration=0.0000000
        m_fTPIkActivation=0.0000000
        m_fTPIkActDuration=0.0000000
        m_fTCIkActivation=0.0000000
        m_fTCIkActDuration=0.0000000
        m_fFPIkDeactivation=0.0000000
        m_fFPIkDeactDuration=0.0000000
        m_fTPIkDeactivation=0.0000000
        m_fTPIkDeactDuration=0.0000000
        m_fTCIkDeactivation=0.0000000
        m_fTCIkDeactDuration=0.0000000
        m_strFPAnim=""
        m_strTPAnim=""
        m_strTCAnim=""
        m_Id=0
    }
};

struct R6OrderProperties
{
    var() /*0x04000000-0x00000000*/ R6EngineEnums.EOrderSignalId m_SignalId;
    var() /*0x04000000-0x00000000*/ SoundCue m_Sound;

    structdefaultproperties
    {
        m_SignalId=0
        m_Sound=none
    }
};

var() editconstarray array<R6OrderProperties> m_aOrdersIndex;
var() editconstarray array<R6HandSignalProperty> m_aHandSignalProperties;

// Export UR6HandSignalsConfig::execGetHandSignalId(FFrame&, void* const)
native final function R6EngineEnums.EOrderSignalId GetHandSignalId(R6EngineEnums.ECommunicationTeamMessageType EOrderId);

defaultproperties
{
    m_aOrdersIndex[0]=(m_SignalId=0,m_Sound=none)
    m_aOrdersIndex[1]=(m_SignalId=3,m_Sound=none)
    m_aOrdersIndex[2]=(m_SignalId=2,m_Sound=none)
    m_aOrdersIndex[3]=(m_SignalId=1,m_Sound=none)
    m_aHandSignalProperties[0]=(m_fTime=0.0000000,m_fFPIkActivation=0.0000000,m_fFPIkActDuration=0.0000000,m_fTPIkActivation=0.0000000,m_fTPIkActDuration=0.0000000,m_fTCIkActivation=0.0000000,m_fTCIkActDuration=0.0000000,m_fFPIkDeactivation=0.0000000,m_fFPIkDeactDuration=0.0000000,m_fTPIkDeactivation=0.0000000,m_fTPIkDeactDuration=0.0000000,m_fTCIkDeactivation=0.0000000,m_fTCIkDeactDuration=0.0000000,m_strFPAnim="",m_strTPAnim="",m_strTCAnim="",m_Id=0)
    m_aHandSignalProperties[1]=(m_fTime=2.0000000,m_fFPIkActivation=0.0000000,m_fFPIkActDuration=0.0000000,m_fTPIkActivation=0.0000000,m_fTPIkActDuration=0.0000000,m_fTCIkActivation=0.0000000,m_fTCIkActDuration=0.0000000,m_fFPIkDeactivation=0.0000000,m_fFPIkDeactDuration=0.0000000,m_fTPIkDeactivation=0.0000000,m_fTPIkDeactDuration=0.0000000,m_fTCIkDeactivation=0.0000000,m_fTCIkDeactDuration=0.0000000,m_strFPAnim="FPSignalHold",m_strTPAnim="Hold",m_strTCAnim="Tc_HandSignal_Hold",m_Id=1)
    m_aHandSignalProperties[2]=(m_fTime=1.5000000,m_fFPIkActivation=0.0000000,m_fFPIkActDuration=0.0000000,m_fTPIkActivation=0.0000000,m_fTPIkActDuration=0.0000000,m_fTCIkActivation=0.0000000,m_fTCIkActDuration=0.0000000,m_fFPIkDeactivation=0.0000000,m_fFPIkDeactDuration=0.0000000,m_fTPIkDeactivation=0.0000000,m_fTPIkDeactDuration=0.0000000,m_fTCIkDeactivation=0.0000000,m_fTCIkDeactDuration=0.0000000,m_strFPAnim="FPSignalMove",m_strTPAnim="GoForward",m_strTCAnim="Tc_HandSignal_Move",m_Id=2)
    m_aHandSignalProperties[3]=(m_fTime=2.1000000,m_fFPIkActivation=0.0000000,m_fFPIkActDuration=0.0000000,m_fTPIkActivation=0.0000000,m_fTPIkActDuration=0.0000000,m_fTCIkActivation=0.0000000,m_fTCIkActDuration=0.0000000,m_fFPIkDeactivation=0.0000000,m_fFPIkDeactDuration=0.0000000,m_fTPIkDeactivation=0.0000000,m_fTPIkDeactDuration=0.0000000,m_fTCIkDeactivation=0.0000000,m_fTCIkDeactDuration=0.0000000,m_strFPAnim="FPSignalRegroup",m_strTPAnim="Regroup",m_strTCAnim="Tc_HandSignal_Regroup",m_Id=3)
}