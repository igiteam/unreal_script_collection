class R6AnimNodeTC360ReadyPoseOffset extends AnimNodeAimOffset
    native
    hidecategories(Object,Object,Object,Object,AnimNodeAimOffset);

var() R6EngineEnums.EActionSide m_eReadyPoseSide;
var() bool m_bMovementAnims;
var() bool m_bPECAnims;
var transient Rotator m_rCurrentLeftArmOffset;
var transient Rotator m_rCurrentRightHandOffset;
