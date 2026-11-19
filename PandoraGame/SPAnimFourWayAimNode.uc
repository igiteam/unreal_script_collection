class SPAnimFourWayAimNode extends SPAnimPartialBlendNode
    native;

/** Variable Declaration */
var() float m_horizontalAngularRange;
var() float m_verticalAngularRange;
var() name m_aimSocketName;
var float m_currentU;
var float m_currentV;
var bool m_bHadTargetLastTime;
