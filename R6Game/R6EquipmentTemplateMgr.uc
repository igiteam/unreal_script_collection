class R6EquipmentTemplateMgr extends Object
    native;

struct EquipmentTemplateList
{
    var array<R6EquipmentTemplate> m_Templates;
    var string m_Gamertag;
    var R6EngineEnums.EOutfittingKit m_eSelectedKit;

    structdefaultproperties
    {
        m_Templates=none
        m_Gamertag=""
        m_eSelectedKit=0
    }
};

var array<EquipmentTemplateList> m_TemplateLists;
var array<R6EquipmentTemplate> m_DefaultTemplates;
var array<R6EquipmentTemplate> m_FullTemplates;
var bool m_bDefaultsInit;
var int m_iCurrentSaveIndex;

defaultproperties
{
    m_iCurrentSaveIndex=-1
}