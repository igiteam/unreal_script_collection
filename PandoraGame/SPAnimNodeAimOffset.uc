class SPAnimNodeAimOffset extends AnimNodeAimOffset
    native;

var() name m_aimSocketName;
var int m_left;
var int m_right;
var int m_up;
var int m_down;
/** If true, tries to use last frame's gun position as the basis for aim This really only works well for running animations to prevent hip movement from swinging the aim around */
var() bool m_bRelative;
/** If these aren't the default of -1 <-> +1, they represent a rescaling of the aim range. Example, -0.5 <-> 0.1 means that when the aim is -1, it should be -0.5. When the aim is 1 it should be 0.1. The center is therefore -0.2. This is very different from the way the Unreal version of this node uses Angleoffset and range. Also MIN is x and y, not "horizontal", etc. */
var() Vector2D m_minAim;
var() Vector2D m_maxAim;
var Vector2D m_lastAim;
var Vector2D m_adjustedAim;

// Export USPAnimNodeAimOffset::execSetActiveProfileByIndex(FFrame&, void* const)
native function bool SetActiveProfileByIndex(int ProfileIndex);
