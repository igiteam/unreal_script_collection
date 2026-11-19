class SkyParticleModuleBeamBoneTarget extends SkyParticleModuleBeamBase
    native
    editinlinenew;

enum EBoneCheckRadiusInputType
{
    EINPUTTYPE_Random,              // 0
    EINPUTTYPE_Time,                // 1
    EINPUTTYPE_MAX                  // 2
};

struct native BeamBoneTargetInstancePayload
{
    var int BoneIdx;
    var float BoneOffset;

    structdefaultproperties
    {
        BoneIdx=0
        BoneOffset=0.0000000
    }
};

var(BoneTarget) RawDistributionFloat BoneCheckRadius;
var(BoneTarget) SkyParticleModuleBeamBoneTarget.EBoneCheckRadiusInputType BoneCheckRadiusInputType;
