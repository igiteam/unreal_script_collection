class R6PECAssetManager extends Object
    native;

enum EPECAssetType
{
    PECASSET_CHARACTER_TEMPLATE,    // 0
    PECASSET_PERM_CAMO,             // 1
    PECASSET_PERM_TEXTURE,          // 2
    PECASSET_PERM_SKELETALMESH,     // 3
    PECASSET_PERM_STATICMESH,       // 4
    PECASSET_VOL_CAMO,              // 5
    PECASSET_VOL_TEXTURE,           // 6
    PECASSET_VOL_SKELETALMESH,      // 7
    PECASSET_VOL_STATICMESH,        // 8
    PECASSET_ALL,                   // 9
    PECASSET_MAX                    // 10
};

struct PECAssetReference
{
    structcpptext
    {

    FPECAssetReference(INT iAssetID, BYTE eType, INT iPlayerID, BYTE eAsset)
        :m_iID(iAssetID), m_eType(eType), m_iPlayerID(iPlayerID), m_pObject(NULL), m_eAsset(eAsset), m_pLinkedObject(NULL)
    {
    }

    friend UBOOL operator==(const FPECAssetReference& first, const FPECAssetReference& second)
    {
        return ((first.m_iID == second.m_iID) && 
                (first.m_iPlayerID == second.m_iPlayerID) &&
                (first.m_eType == second.m_eType) && 
                (first.m_pObject == second.m_pObject) &&
                (first.m_eAsset == second.m_eAsset) && 
                (first.m_pLinkedObject == second.m_pLinkedObject));
    }

    }

    var int m_iID;
    var int m_iPlayerID;
    var R6PECAssetManager.EPECAssetType m_eType;
    var Object m_pObject;
    var Object m_pLinkedObject;
    var R6EngineEnums.EPecAsset m_eAsset;

    structdefaultproperties
    {
        m_iID=0
        m_iPlayerID=0
        m_eType=0
        m_pObject=none
        m_pLinkedObject=none
        m_eAsset=0
    }
};

struct ArmorInfo
{
    structcpptext
    {

    UBOOL QuickCompare(const FArmorInfo& other)
    {
        return ((eGender == other.eGender) && 
                (eArmorType == other.eArmorType) && 
                (eCategory == other.eCategory) && 
                (eSide == other.eSide));

    }

    }

    var int iIdx;
    var byte eGender;
    var byte eArmorType;
    var byte eCategory;
    var byte eSide;

    structdefaultproperties
    {
        iIdx=0
        eGender=0
        eArmorType=0
        eCategory=0
        eSide=0
    }
};

struct CustomHeadInfo
{
    var int m_PlayerID;
    var native Pointer m_pData;
    var native Pointer m_pRawData;
    var int m_RawDataSize;
    var bool m_AlreadyProcessed;
    var int m_Crc;
    var bool m_Done;

    structdefaultproperties
    {
        m_PlayerID=0
        m_RawDataSize=0
        m_AlreadyProcessed=false
        m_Crc=0
        m_Done=false
    }
};

struct CustomColorInfo
{
    structcpptext
    {

    FCustomColorInfo()
        :m_iPlayerID(0)
        ,m_byCamoIndex(0)
        ,m_byPattern(0)
        ,m_Color1()
        ,m_Color2()
        ,m_Color3()
        ,m_Color4()
    {
    }

    }

    var int m_iPlayerID;
    var byte m_byCamoIndex;
    var Color m_Color1;
    var Color m_Color2;
    var Color m_Color3;
    var Color m_Color4;
    var byte m_byPattern;

    structdefaultproperties
    {
        m_iPlayerID=0
        m_byCamoIndex=0
        m_Color1=(R=0,G=0,B=0,A=0)
        m_Color2=(R=0,G=0,B=0,A=0)
        m_Color3=(R=0,G=0,B=0,A=0)
        m_Color4=(R=0,G=0,B=0,A=0)
        m_byPattern=0
    }
};

struct CustomColorReference
{
    structcpptext
    {

    FCustomColorReference()
        :m_iPlayerID(0)
        ,m_byCamoIndex(0)
        ,m_pReference(NULL)
    {
    }

    }

    var int m_iPlayerID;
    var byte m_byCamoIndex;
    var Object m_pReference;

    structdefaultproperties
    {
        m_iPlayerID=0
        m_byCamoIndex=0
        m_pReference=none
    }
};

var bool m_bLoadComplete;
var bool m_bOmniAssetsLoaded;
var float m_fStartSyncTimer;
var array<PECAssetReference> m_AssetReferences;
var array<CustomColorInfo> m_CustomColorInfos;
var array<CustomColorReference> m_CustomColorLookup;
var array<SkeletalMesh> m_aMaleHeadMeshes;
var array<SkeletalMesh> m_aFemaleHeadMeshes;
var array<SkeletalMesh> m_aMaleBalaclavaSMMeshes;
var array<SkeletalMesh> m_aMaleBalaclavaBCMeshes;
var array<SkeletalMesh> m_aFemaleBalaclavaSMMeshes;
var array<SkeletalMesh> m_aFemaleBalaclavaBCMeshes;
var array<Texture2D> m_aFacialFeature;
var array<Texture2D> m_aFacialHairs;
var array<SkeletalMesh> m_aMaleTorsoMeshes;
var array<SkeletalMesh> m_aFemaleTorsoMeshes;
var array<SkeletalMesh> m_aMaleLegsMeshes;
var array<SkeletalMesh> m_aFemaleLegsMeshes;
var array<StaticMesh> m_aMaleHeadGearMeshes;
var array<StaticMesh> m_aFemaleHeadGearMeshes;
var array<StaticMesh> m_aMaleFaceGearMeshes;
var array<StaticMesh> m_aFemaleFaceGearMeshes;
var array<StaticMesh> m_aMaleEyeWearMeshes;
var array<StaticMesh> m_aFemaleEyeWearMeshes;
var array<SkeletalMesh> m_aMaleLegArmorMeshes;
var array<SkeletalMesh> m_aFemaleLegArmorMeshes;
var array<SkeletalMesh> m_aMaleTorsoArmorMeshes;
var array<SkeletalMesh> m_aFemaleTorsoArmorMeshes;
var array<SkeletalMesh> m_aMaleShoulderArmorMeshes;
var array<SkeletalMesh> m_aFemaleShoulderArmorMeshes;
var array<SkeletalMesh> m_aMaleArmArmorMeshes;
var array<SkeletalMesh> m_aFemaleArmArmorMeshes;
var array<R6CamoPreset> m_aCamoPresets;
var array<Texture2D> m_aTorsoTextures;
var array<Texture2D> m_aRankBadgeTextures;
var array<Texture2D> m_aCustomCamoPatterns;
var array<ArmorInfo> m_arrMaleArmorBody;
var array<ArmorInfo> m_arrMaleArmorArms;
var array<ArmorInfo> m_arrMaleArmorShoulders;
var array<ArmorInfo> m_arrMaleArmorShins;
var array<ArmorInfo> m_arrFemaleArmorBody;
var array<ArmorInfo> m_arrFemaleArmorArms;
var array<ArmorInfo> m_arrFemaleArmorShoulders;
var array<ArmorInfo> m_arrFemaleArmorShins;
var MaterialInstanceConstant m_ChinStrapMatInst;
var array<string> m_strFacialHairChannels;
var array<string> m_strFacialHairColors;
var array<string> m_strRankBadgeChannels;
var string m_strDefaultFacialHairPath;
var string m_strEmptyFacialHairPath;
var string m_CamoTextureParamNameDiffuse;
var string m_CamoTextureParamNameSpecular;
var string m_strTorsoSkinTexturePath;
var array<CustomHeadInfo> m_aCustomHeadInfos;
var native Pointer m_pLocalCustomHeadData;
var SkeletalMesh m_pRefSkelMesh_M;
var SkeletalMesh m_pRefSkelMesh_F;
var MaterialInstance m_pRefMaterial;
var Texture2D m_pRefTexture_M;
var Texture2D m_pRefTexture_F;

// Export UR6PECAssetManager::execPoolAsset(FFrame&, void* const)
native function PoolAsset(int iAssetId, R6PECAssetManager.EPECAssetType EType, int iPlayerID, optional byte eAsset);

// Export UR6PECAssetManager::execPoolCustomCamo(FFrame&, void* const)
native function PoolCustomCamo(int iPlayerID, byte iIndex, byte byPattern, Color color1, Color color2, Color Color3, Color Color4);

// Export UR6PECAssetManager::execReset(FFrame&, void* const)
native function Reset();

// Export UR6PECAssetManager::execUnreferencePlayer(FFrame&, void* const)
native simulated function UnreferencePlayer(int iPlayerID, optional int iType);

// Export UR6PECAssetManager::execLoadInGameAssets(FFrame&, void* const)
native function LoadInGameAssets();

// Export UR6PECAssetManager::execLinLoadInGameAssets(FFrame&, void* const)
native function LinLoadInGameAssets();

// Export UR6PECAssetManager::execLoadPecHQAssets(FFrame&, void* const)
native function LoadPecHQAssets();

// Export UR6PECAssetManager::execLoadOmnipresentAssets(FFrame&, void* const)
native function LoadOmnipresentAssets();

// Export UR6PECAssetManager::execBeginSynchronization(FFrame&, void* const)
native function BeginSynchronization();

// Export UR6PECAssetManager::execEndSynchronization(FFrame&, void* const)
native function EndSynchronization();

// Export UR6PECAssetManager::execSynchronizeNewClient(FFrame&, void* const)
native function SynchronizeNewClient(R6PlayerController pPC);

defaultproperties
{
    m_fStartSyncTimer=-1.0000000
    m_strFacialHairChannels[0]="D"
    m_strFacialHairChannels[1]="S"
    m_strFacialHairChannels[2]="N"
    m_strFacialHairColors[0]="a"
    m_strFacialHairColors[1]="b"
    m_strFacialHairColors[2]="c"
    m_strFacialHairColors[3]="d"
    m_strRankBadgeChannels[0]="D"
    m_strRankBadgeChannels[1]="N"
    m_strRankBadgeChannels[2]="S"
    m_strDefaultFacialHairPath="RS5MPCharacters_Head_%02dM.RS5MPC_Head_%02d_%s_hair%d%s"
    m_strEmptyFacialHairPath="RS5MPCharacters_Head_%02dM.RS5MPC_Head_%02d_%s"
    m_CamoTextureParamNameDiffuse="D"
    m_CamoTextureParamNameSpecular="S"
    m_strTorsoSkinTexturePath="RS5MPCharacters_Torso.RS5MPC_TorsoSkin_%s_%02d_%s"
}