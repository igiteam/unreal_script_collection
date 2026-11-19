class ECAPAsset extends Object
    native
    editinlinenew
    hidecategories(Object);

enum eECAPAssetAxis
{
    XAxis,                          // 0
    YAxis,                          // 1
    ZAxis,                          // 2
    eECAPAssetAxis_MAX              // 3
};

enum eECAPAssetFunction
{
    TranslationOneBone,             // 0
    MaxTranslationTwoBones,         // 1
    DistanceBetweenTwoBones,        // 2
    eECAPAssetFunction_MAX          // 3
};

struct native ECAPAssetBlendRegion
{
    var() editconst name REGION_NAME;
    var() bool bDoRegion;
    var() name ScalarParameterName;
    var() name BoneNamea;
    var() name BoneNameb;
    var() float lowValue;
    var() float highValue;
    var() ECAPAsset.eECAPAssetAxis ECAPdoXYZ;
    var() ECAPAsset.eECAPAssetFunction ECAPdoFunction;
    var() bool bDoConstrain;

    structdefaultproperties
    {
        REGION_NAME="None"
        bDoRegion=false
        ScalarParameterName="None"
        BoneNamea="None"
        BoneNameb="None"
        lowValue=0.0000000
        highValue=-1.0000000
        ECAPdoXYZ=0
        ECAPdoFunction=0
        bDoConstrain=true
    }
};

var(Main) bool bDoECAP;
var(Main) bool bClearECAP;
var(Main) bool bDebugConstraint;
var private native bool bDirty;
var(Main) int MaterialSlotID;
var(Main) MaterialInstance ECAPMaterial;
var(Main) array<ECAPAssetBlendRegion> aRegions;
var private native Pointer CachedSkeletalMeshPointer;

defaultproperties
{
    bDoECAP=true
    bClearECAP=true
    MaterialSlotID=2
    aRegions[0]=(REGION_NAME="Right Cheek",bDoRegion=true,ScalarParameterName="EcapBlendParam",BoneNamea="RightMouth",BoneNameb="na",lowValue=0.4000000,highValue=-0.6800000,ECAPdoXYZ=0,ECAPdoFunction=0,bDoConstrain=true)
    aRegions[1]=(REGION_NAME="Left Cheek",bDoRegion=true,ScalarParameterName="EcapBlendParam_1",BoneNamea="LeftMouth",BoneNameb="na",lowValue=-0.4000000,highValue=0.6800000,ECAPdoXYZ=0,ECAPdoFunction=0,bDoConstrain=true)
    aRegions[2]=(REGION_NAME="Eye Wrinkle",bDoRegion=true,ScalarParameterName="EcapBlendParam_2",BoneNamea="RightInnerEyebrow",BoneNameb="LeftInnerEyebrow",lowValue=0.0000000,highValue=1.5000000,ECAPdoXYZ=0,ECAPdoFunction=2,bDoConstrain=true)
    aRegions[3]=(REGION_NAME="Right Crow",bDoRegion=true,ScalarParameterName="EcapBlendParam_3",BoneNamea="RightUpCheek",BoneNameb="na",lowValue=0.0000000,highValue=-1.0000000,ECAPdoXYZ=1,ECAPdoFunction=0,bDoConstrain=true)
    aRegions[4]=(REGION_NAME="Left Crow",bDoRegion=true,ScalarParameterName="EcapBlendParam_4",BoneNamea="LeftUpCheek",BoneNameb="na",lowValue=0.0000000,highValue=-1.0000000,ECAPdoXYZ=1,ECAPdoFunction=0,bDoConstrain=true)
    aRegions[5]=(REGION_NAME="Nose",bDoRegion=true,ScalarParameterName="EcapBlendParam_5",BoneNamea="LeftNose",BoneNameb="RightNose",lowValue=0.0000000,highValue=-0.8300000,ECAPdoXYZ=1,ECAPdoFunction=1,bDoConstrain=true)
    aRegions[6]=(REGION_NAME="Right eye",bDoRegion=true,ScalarParameterName="EcapBlendParam_6",BoneNamea="RightInnerEyebrow",BoneNameb="na",lowValue=1.0000000,highValue=-1.5000000,ECAPdoXYZ=1,ECAPdoFunction=0,bDoConstrain=true)
    aRegions[7]=(REGION_NAME="Left eye",bDoRegion=true,ScalarParameterName="EcapBlendParam_7",BoneNamea="LeftInnerEyebrow",BoneNameb="na",lowValue=1.0000000,highValue=-1.5000000,ECAPdoXYZ=1,ECAPdoFunction=0,bDoConstrain=true)
    aRegions[8]=(REGION_NAME="Neck",bDoRegion=false,ScalarParameterName="EcapBlendParam_8",BoneNamea="Chin",BoneNameb="na",lowValue=1.0000000,highValue=-1.5000000,ECAPdoXYZ=1,ECAPdoFunction=0,bDoConstrain=true)
    aRegions[9]=(REGION_NAME="Mouth",bDoRegion=true,ScalarParameterName="EcapBlendParam_9",BoneNamea="RightMouth",BoneNameb="LeftMouth",lowValue=-1.3400000,highValue=0.6500000,ECAPdoXYZ=0,ECAPdoFunction=2,bDoConstrain=true)
}