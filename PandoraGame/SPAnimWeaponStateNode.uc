class SPAnimWeaponStateNode extends SPAnimSwitchNode
    native;

enum ESPAnimWeaponStateNodeChildSelect
{
    Child_Aim,                      // 0
    Child_Fire,                     // 1
    Child_Reload,                   // 2
    Child_Idle,                     // 3
    Child_UnderFire,                // 4
    Child_ThrowGrenade,             // 5
    Child_ThrowMolotov,             // 6
    Child_MAX                       // 7
};

/** Variable Declaration variable only used by the editor for previewing animations */
var() transient SPAnimWeaponStateNode.ESPAnimWeaponStateNodeChildSelect m_editorChildSelect;
