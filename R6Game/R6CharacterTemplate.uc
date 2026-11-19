class R6CharacterTemplate extends Object
    native
    hidecategories(Object);

struct CTMaterial
{
    var() MaterialInstance m_Material;
    var() Texture2D m_Diffuse;

    structdefaultproperties
    {
        m_Material=none
        m_Diffuse=none
    }
};

struct CTMaterialInfo
{
    var() int m_iIndex;
    var() bool m_bUseHeadMaterial;
    var() int m_iHeadMaterialIndex;
    var() array<CTMaterial> m_MaterialData;

    structdefaultproperties
    {
        m_iIndex=0
        m_bUseHeadMaterial=false
        m_iHeadMaterialIndex=0
        m_MaterialData=none
    }
};

struct CTMeshInfo
{
    var() SkeletalMesh m_SkelMesh;
    var() R6CamoPreset m_Camo;
    var() array<CTMaterialInfo> m_Materials;

    structdefaultproperties
    {
        m_SkelMesh=none
        m_Camo=none
        m_Materials=none
    }
};

struct CTStaticMeshInfo
{
    var() StaticMesh m_StaticMesh;

    structdefaultproperties
    {
        m_StaticMesh=none
    }
};

struct CTAttachmentList
{
    var() array<CTStaticMeshInfo> m_StaticMeshes;
    var() name m_BoneName;
    var() name m_SocketName;

    structdefaultproperties
    {
        m_StaticMeshes=none
        m_BoneName="None"
        m_SocketName="None"
    }
};

struct CTAttachmentGroup
{
    var() array<CTAttachmentList> m_AttachmentLists;

    structdefaultproperties
    {
        m_AttachmentLists=none
    }
};

struct CTBodyPartInfo
{
    var() array<CTMeshInfo> m_Parts;

    structdefaultproperties
    {
        m_Parts=none
    }
};

struct CTAttachmentGroupList
{
    var() array<CTAttachmentGroup> m_Groups;

    structdefaultproperties
    {
        m_Groups=none
    }
};

var(Template) CTBodyPartInfo m_Heads;
var(Template) CTBodyPartInfo m_Torsos;
var(Template) CTBodyPartInfo m_Legs;
var(Template) CTBodyPartInfo m_Hairs;
var(Template) CTBodyPartInfo m_ArmorTorso;
var(Template) CTBodyPartInfo m_ArmorShoulder1;
var(Template) CTBodyPartInfo m_ArmorShoulder2;
var(Template) CTBodyPartInfo m_ArmorLegs1;
var(Template) CTBodyPartInfo m_ArmorLegs2;
var(Template) CTBodyPartInfo m_ArmorArms1;
var(Template) CTBodyPartInfo m_ArmorArms2;
var(Template) CTAttachmentGroupList m_Attachments;
var(Template) R6EngineEnums.ETerroArmorLevel m_eArmorLevel;
var(Ragdoll) PhysicsAsset m_PhysAsset;
var(Ragdoll) float m_fDeathImpulseCoef;
var(Ragdoll) float m_fSpringStart;
var(Ragdoll) float m_fDamping;
var(Ragdoll) float m_fLinearSleepSpeed;
var(Ragdoll) float m_fAngularSleepSpeed;
var(Ragdoll) float m_fLifeTime;
var(Socket) R6SocketTemplate m_SocketTemplate;
var Texture2D m_ThumbnailTexture;
var(VisionDevice) SkeletalMesh m_VisionDeviceMesh;

defaultproperties
{
    m_eArmorLevel=1
    m_PhysAsset=PhysicsAsset'DefaultCharacterTemplate.PhysAsset_CharacterRagdoll'
    m_fDeathImpulseCoef=1.0000000
    m_fSpringStart=100.0000000
    m_fDamping=1.0000000
    m_fLinearSleepSpeed=0.5000000
    m_fAngularSleepSpeed=2.0000000
    m_fLifeTime=5.0000000
    m_ThumbnailTexture=Texture2D'KellerEditorMaterials.CharacterTemplateIcon'
}