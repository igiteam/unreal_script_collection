class R6CharacterTemplateList extends R6CharacterTemplate
    native
    hidecategories(Object,R6CharacterTemplate);

struct CTListInfo
{
    var() R6CharacterTemplate m_Template;

    structdefaultproperties
    {
        m_Template=none
    }
};

var() array<CTListInfo> m_Templates;
