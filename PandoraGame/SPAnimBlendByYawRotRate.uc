class SPAnimBlendByYawRotRate extends SPAnimBaseNode
    native;

/** Value we can adjust to see the griffon turn in the anim tree. */
var() float m_editorTurnRate;
/** Do we allow us to keep on blending two animations together. */
var() bool m_continuousBlend;
/** Function that gets called when another child become the most significant. */
var() name m_newActiveChildFunc;
/** How long it takes to do a blend if we have to blend from 0.0 to 1.0 */
var() float m_fullBlendTime;
/** How fast m_destTurnRate moves towards m_currTurnRate */
var() float m_turnRateAdjustSpeed;
/** We always play the straight ahead anim if within this angle. */
var() float m_deadAngle;
var float m_currTurnRate;
/** Array that describes when each animation should be selected. Functions */
var() array<float> m_turnRates;

event SPAnimBlendByYawRotRateProto(SPAnimBlendByYawRotRate Node, name childName, int ChildIndex, float turnAmountInDegrees)
{
    //return;    
}
