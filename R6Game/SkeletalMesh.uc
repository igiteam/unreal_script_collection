class SkeletalMesh extends Object
    native
    noexport
    hidecategories(Object);

struct BoneMirrorInfo
{
    var() int SourceIndex;
    var() Object.EAxis BoneFlipAxis;

    structdefaultproperties
    {
        SourceIndex=0
        BoneFlipAxis=0
    }
};

struct SkeletalMeshLODInfo
{
    var() float DisplayFactor;
    var() float LODHysteresis;
    var() editconstarray array<int> LODMaterialMap;

    structdefaultproperties
    {
        DisplayFactor=0.0000000
        LODHysteresis=0.0000000
        LODMaterialMap=none
    }
};

var native const BoxSphereBounds Bounds;
var() native const array<MaterialInstance> Materials;
var() native const Vector Origin;
var() native const Rotator RotOrigin;
var native const array<int> RefSkeleton;
var native const int SkeletalDepth;
var private native const IndirectArray_Mirror LODModels;
var native const array<Matrix> RefBasesInvMatrix;
var() editconstarray array<BoneMirrorInfo> SkelMirrorTable;
var() Object.EAxis SkelMirrorAxis;
var() Object.EAxis SkelMirrorFlipAxis;
var bool m_bHasLitSpecialSocket;
var() bool m_bUseOriginalBoundingBox;
var() SkeletalMesh m_pFPMesh;
var array<SkeletalMeshSocket> Sockets;
var native map{VOID,VOID} m_BonesToIndexNameMap;
var() editconstarray array<SkeletalMeshLODInfo> LODInfo;
var() const bool bForceCPUSkinning;
var() float DefaultHeat;
var native array<int> PlayerHeadMarks;
var(PlayerHead) Texture2D HeadTexture;

defaultproperties
{
    SkelMirrorAxis=1
    SkelMirrorFlipAxis=4
}