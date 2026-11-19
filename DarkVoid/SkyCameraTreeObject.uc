class SkyCameraTreeObject extends Object
    abstract
    native;

enum BlendFunctions
{
    SCBLEND_Linear,                 // 0
    SCBLEND_EaseIn,                 // 1
    SCBLEND_EaseInEaseOut,          // 2
    SCBLEND_EaseOut,                // 3
    SCBLEND_MAX                     // 4
};

enum SKYCAMERA_CONSTRAINT
{
    THE_PLAYER,                     // 0
    MOST_RECENT_COVER_SLOT,         // 1
    MOST_RECENT_USED_VEHICLE,       // 2
    MOST_RECENT_TARGET_VEHICLE,     // 3
    NEAREST_TARGET,                 // 4
    MATINEE_CAMERA,                 // 5
    MOST_RECENT_MELEE_TARGET,       // 6
    CONSTRAINT_NONE,                // 7
    COVER_CAMERA,                   // 8
    SKYCAMERA_CONSTRAINT_MAX        // 9
};

enum SKYCAMERA_MOVEMENT_TYPE
{
    SKYCAMERA_MOVEMENT_TYPE_LERP,   // 0
    SKYCAMERA_MOVEMENT_TYPE_SLERP,  // 1
    SKYCAMERA_MOVEMENT_TYPE_NONE,   // 2
    SKYCAMERA_MOVEMENT_TYPE_MAX     // 3
};

enum EFlagOffset
{
    EFO_DoNotOverride,              // 0
    EFO_True,                       // 1
    EFO_False,                      // 2
    EFO_MAX                         // 3
};

enum EAlignControllerMode
{
    EACM_None,                      // 0
    EACM_WhileHasAnyWeight,         // 1
    EACM_WhileNotLosingWeight,      // 2
    EACM_UseAutoPitch,              // 3
    EACM_MAX                        // 4
};

enum EAlignControllerModeOffset
{
    EACMO_DoNotOverride,            // 0
    EACMO_None,                     // 1
    EACMO_WhileHasAnyWeight,        // 2
    EACMO_WhileNotLosingWeight,     // 3
    EACMO_UseAutoPitch,             // 4
    EACMO_MAX                       // 5
};

struct native s_RotatorDegrees
{
    var() float PitchDegrees;
    var() float YawDegrees;
    var() float RollDegrees;

    structdefaultproperties
    {
        PitchDegrees=0.0000000
        YawDegrees=0.0000000
        RollDegrees=0.0000000
    }
};

var transient SkyCamera Camera;
