class R6ScriptedSequenceSockets extends Object
    native
    hidecategories(Object);

struct R6ScriptSocketInfo
{
    var() Quat m_Rotation;
    var() Vector m_vPosition;
    var() name m_Name;

    structdefaultproperties
    {
        m_Rotation=(X=0.0000000,Y=0.0000000,Z=0.0000000,W=0.0000000)
        m_vPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_Name="None"
    }
};

var() array<R6ScriptSocketInfo> m_Sockets;
var() R6ScriptSocketInfo m_pRoot;
