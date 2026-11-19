class SPTurnNode extends SPAnimBaseNode
    native;

struct native TurnData
{
    /** Struct Declaration */
    var() float degreeTurn;

    structdefaultproperties
    {
        degreeTurn=0.0000000
    }
};

struct native TurnAnimCBParams
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
var() array<TurnData> m_blendData;
var() bool m_scaleToTurnRate;
var transient bool m_isOrientationRegistered;
var transient bool m_isWalking;
var() float m_editorTurnAmount;
var float m_editorReset;
var transient Rotator m_registeredRot;
var transient Vector m_registeredPos;
var transient int m_registeredIndex;
var transient Vector m_registeredDebugPos;

event TurnAnimCB(out TurnAnimCBParams Params)
{
    //return;    
}
