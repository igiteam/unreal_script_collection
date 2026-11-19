class MOHAAnimNodeVehicleAimDir extends AnimNodeBlendBase
    native
    hidecategories(Object,Object);

enum EVehicleAimDir
{
    VEHICLE_AIM_LEFT,               // 0
    VEHICLE_AIM_FORWARD,            // 1
    VEHICLE_AIM_RIGHT,              // 2
    VEHICLE_AIM_BACKWARD,           // 3
    VEHICLE_AIM_MAX                 // 4
};

var() int iVehicleWeapon;

defaultproperties
{
    Children=/* Array type was not detected. */
}