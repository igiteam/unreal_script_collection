class TurokVehicleTransmission extends SVehicleSimCarTransmission
    native;

struct native WheelPair
{
    var int indexA;
    var int indexB;
    var float mDist2FixedAxle;

    structdefaultproperties
    {
        indexA=0
        indexB=0
        mDist2FixedAxle=0.0000000
    }
};

var private array mWheelPairs;
