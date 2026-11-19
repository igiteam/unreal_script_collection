class R6MotdConfig extends Object
    native;

struct R6MotdContent
{
    var R6EngineEnums.ELanguage m_eLanguage;
    var string m_szTitle;
    var string m_szMessage;

    structdefaultproperties
    {
        m_eLanguage=0
        m_szTitle=""
        m_szMessage=""
    }
};

var string m_szFilename;
var string m_szMonth;
var string m_szDay;
var string m_szYear;
var array<R6MotdContent> m_arMessageContents;
