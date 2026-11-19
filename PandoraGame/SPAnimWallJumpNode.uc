class SPAnimWallJumpNode extends SPAnimBaseNode
    native;

struct native WallJumpAnimCBParams
{
    var bool bResetAnims;
    var float jumpAngle;

    structdefaultproperties
    {
        bResetAnims=false
        jumpAngle=0.0000000
    }
};

/** Variable Declaration */
var() float m_minJumpAngle;
var() float m_maxJumpAngle;
var() float m_jumpAngle;
var bool m_bReset;

event WallJumpAnimCB(out WallJumpAnimCBParams Params)
{
    //return;    
}
