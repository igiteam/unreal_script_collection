class R6LevelData extends R6ILevelData
    native
    hidecategories(lighting);

enum EDarePlusData
{
    eDPOccZone,                     // 0
    eDPDynOcc,                      // 1
    EDarePlusData_MAX               // 2
};

struct SubPath
{
    var() array<R6PatrolPoint> Points;
    var() int Percent;
    var() bool bIsActive;

    structdefaultproperties
    {
        Points=none
        Percent=0
        bIsActive=false
    }
};

struct PatrolInfo
{
    var() R6PatrolPoint Point;
    var() bool bHasSubPaths;
    var() SubPath SubPaths[3];
    var bool bIsCurrent;

    structdefaultproperties
    {
        Point=none
        bHasSubPaths=false
        SubPaths[0]=(Points=none,Percent=0,bIsActive=false)
        SubPaths[1]=(Points=none,Percent=0,bIsActive=false)
        SubPaths[2]=(Points=none,Percent=0,bIsActive=false)
        bIsCurrent=false
    }
};

struct Patrol
{
    var() name ID;
    var() bool bCircular;
    var() editinline array<editinline PatrolInfo> aInfo;
    var() bool bWalkBackward;
    var() name WaitAnim;
    var bool bIsCurrent;

    structdefaultproperties
    {
        ID="None"
        bCircular=false
        aInfo=none
        bWalkBackward=false
        WaitAnim="None"
        bIsCurrent=false
    }
};

struct DarePlusDataInfo
{
    var string szName;
    var int iDataSize;
    var array<byte> pData;

    structdefaultproperties
    {
        szName=""
        iDataSize=0
        pData=none
    }
};

struct DarePlusDataElement
{
    var array<DarePlusDataInfo> Element;

    structdefaultproperties
    {
        Element=none
    }
};

var array<R6AreaOfOperation> m_aAreaOfOperations;
var array<Patrol> m_aPatrols;
var DarePlusDataElement m_aDarePlusData[2];
