class R6ActionManager extends Object
    native;

const kDoubleGap = 3;

struct R6ActionTypeBase_Ptr
{
    var Pointer I;

    structdefaultproperties
    {
        I=none
    }
};

var R6GameEnums.EActionSuperType m_eChosenSuperType;
var array<R6ActionTypeBase_Ptr> m_pActionTypes;
var float m_fScorePresets[3];
