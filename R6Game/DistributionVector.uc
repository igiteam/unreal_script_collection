class DistributionVector extends Component
    abstract
    native
    editinlinenew
    collapsecategories
    noexport
    hidecategories(Object);

enum EDistributionVectorLockFlags
{
    EDVLF_None,                     // 0
    EDVLF_XY,                       // 1
    EDVLF_XZ,                       // 2
    EDVLF_YZ,                       // 3
    EDVLF_XYZ,                      // 4
    EDVLF_MAX                       // 5
};

enum EDistributionVectorMirrorFlags
{
    EDVMF_Same,                     // 0
    EDVMF_Different,                // 1
    EDVMF_Mirror,                   // 2
    EDVMF_MAX                       // 3
};

var private native noexport Pointer CurveEdVTable;
