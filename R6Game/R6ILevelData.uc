class R6ILevelData extends Actor
    abstract
    native
    notplaceable
    hidecategories(lighting);

struct MapFloor
{
    structcpptext
    {

        void Init();
        void AddTriangle(const class FNMTriangle*, class UENavMesh* pFromNavMesh = NULL);
        INT GetNbTriangles();

        FLOAT Mean();
        FLOAT Variance();

        INT Divide(TArray<FMapFloor>& aFloors);
        void Absorb(INT iFloorIndex);

    private:
        void AddToStats(FLOAT fNewZ);
        void ResetStats();
        void UpdateLimits(const FNMTriangle* pTriangle, UENavMesh* pFromNavMesh=NULL);
        void ResetLimits();
        TArray<FMapFloor>* GetFloorArray();
        INT GetIndex();
        UENavMesh* FindNavMesh(const FNMTriangle* pTri);
    
    }

    var Texture2D m_Texture;
    var float Z;
    var Vector m_vMin;
    var Vector m_vMax;
    var float m_fMean;
    var private float m_fSqMean;
    var float m_fVar;
    var int m_iTriangleNumber;

    structdefaultproperties
    {
        m_Texture=none
        Z=0.0000000
        m_vMin=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vMax=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_fMean=0.0000000
        m_fSqMean=0.0000000
        m_fVar=0.0000000
        m_iTriangleNumber=0
    }
};

struct sCivWalkZone
{
    var R6DelimiterInfoPoint m_Point1;
    var R6DelimiterInfoPoint m_Point2;
    var float m_fZoneWidth;
    var float m_fRadius;
    var float m_fEmitTime;
    var float m_fCurrentTime;
    var int m_iNbCurrentCivilian;
    var int m_iMaxCivilian;
    var bool m_bActive;

    structdefaultproperties
    {
        m_Point1=none
        m_Point2=none
        m_fZoneWidth=0.0000000
        m_fRadius=0.0000000
        m_fEmitTime=0.0000000
        m_fCurrentTime=0.0000000
        m_iNbCurrentCivilian=0
        m_iMaxCivilian=0
        m_bActive=false
    }
};

var ENavMesh m_pNavMesh;
var R6NavMeshCorrections m_pNavMeshCorrections;
var array<R6ExitInfoPoint> m_aEmergencyExits;
var array<MapFloor> m_aFloors;
var float m_fMapGenResolution;
var float m_fMapGenDivideVariance;
var float m_fMapGenMergeDistance;
var int m_iMapGenMinTriNum;
var bool m_bLockFloors;
var array<sCivWalkZone> m_aCivWalkZone;

defaultproperties
{
    m_fMapGenResolution=15.0000000
    m_fMapGenDivideVariance=5000.0000000
    m_fMapGenMergeDistance=125.0000000
    m_iMapGenMinTriNum=300
    bHiddenEd=true
    Components=none
    TickGroup=1
}