class SeqAct_AttachObjects extends SequenceAction
    native;

/** true to attach based on the current relative positions of the objects */
var() bool m_bUseCurrentPosition;
/** just like the name says */
var() bool m_bDisableCollisionOnAttachedObjects;
/** don't set bHardAttach to true CPP Text     Default Properties */
var() bool m_bSoftAttached;
/** optional  name of the socket on the attacher to from */
var() name m_socketNameOnAttacher;
/** optional  name of the socket to attach to */
var() name m_socketName;
/** optional rotation (only used if no socket name is present) */
var() Rotator m_rotation;
/** optional offset (only used if no socket name is present) */
var() Vector m_offset;
