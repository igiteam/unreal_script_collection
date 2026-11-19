class SPAnimBlendOrientationNode extends SPAnimBaseNode
    native;

enum EOrientAxis
{
    EOA_YAW,                        // 0
    EOA_PITCH,                      // 1
    EOA_ROLL,                       // 2
    EOA_MAX                         // 3
};

/** Variable DeclarationOrientation axis to use */
var() const SPAnimBlendOrientationNode.EOrientAxis m_orientAxisToUse;
/** Use rotationalVelocity? */
var() bool m_blendUsingRotationalVelocity;
/** Current orientation -90,90 */
var() float m_orientation;
var Rotator m_lastRotation;
