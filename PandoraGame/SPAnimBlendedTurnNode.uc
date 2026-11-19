class SPAnimBlendedTurnNode extends SPAnimBaseNode
    native;

struct native BlendedTurnData
{
    /** Struct Declaration */
    var() float degreeTurn;

    structdefaultproperties
    {
        degreeTurn=0.0000000
    }
};

struct native BlendedTurnAnimCBParams
{
    var bool bResetAnims;
    var float turnAmount;

    structdefaultproperties
    {
        bResetAnims=false
        turnAmount=0.0000000
    }
};

/** Variable Declaration */
var() array<BlendedTurnData> m_blendData;
var() bool m_scaleToTurnRate;
var() float m_editorTurnAmount;
var float m_editorReset;

event BlendedTurnAnimCB(out BlendedTurnAnimCBParams Params)
{
    //return;    
}
