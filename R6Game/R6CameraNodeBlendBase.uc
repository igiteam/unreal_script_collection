class R6CameraNodeBlendBase extends R6CameraNode
    abstract
    native
    hidecategories(Object,Object);

struct CamBlendChild
{
    var() name m_Name;
    var() export editinline R6CameraNode m_pCamNode;
    var float m_fWeight;
    var int m_iDrawY;

    structdefaultproperties
    {
        m_Name="None"
        m_pCamNode=none
        m_fWeight=0.0000000
        m_iDrawY=0
    }
};

var() editconst export editinline array<export editinline CamBlendChild> m_aChildren;
var bool m_bFixNumChildren;
var transient array<SR6CameraCache> m_aCamCacheData;
var transient array<float> m_aCamCacheWeight;
