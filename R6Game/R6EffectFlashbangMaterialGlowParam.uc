class R6EffectFlashbangMaterialGlowParam extends Object
    native;

struct MaterialOverride
{
    var int m_Index;
    var MaterialInstanceConstant m_Override;

    structdefaultproperties
    {
        m_Index=0
        m_Override=none
    }
};

var array<MaterialOverride> m_Overrides;
