class SPAnimCoverTypeNode extends SPAnimSwitchNode
    native;

enum ESPAnimCoverTypeNodeChildSelect
{
    CoverChild_None,                // 0
    CoverChild_Low,                 // 1
    CoverChild_HighLeft,            // 2
    CoverChild_HighRight,           // 3
    CoverChild_MAX                  // 4
};

/** Variable Declaration variable only used by the editor for previewing animations */
var() transient SPAnimCoverTypeNode.ESPAnimCoverTypeNodeChildSelect m_editorChildSelect;
