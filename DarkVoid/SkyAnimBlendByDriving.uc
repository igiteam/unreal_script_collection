class SkyAnimBlendByDriving extends SkyAnimBlendBase
    native;

enum EBlendByDrivingState
{
    Drive_PreInit,                  // 0
    Drive_NotDriving,               // 1
    Drive_Entering,                 // 2
    Drive_Driving,                  // 3
    Drive_Exiting,                  // 4
    Drive_MAX                       // 5
};

var deprecated SkyAnimBlendByDriving.EBlendByDrivingState CurrentState;
