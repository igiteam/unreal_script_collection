class MOHARagdollAudioAsset extends Object
    native
    editinlinenew;

enum EBodyCollisionSection
{
    EBODY_COLLISION_HEAD,           // 0
    EBODY_COLLISION_TORSO_HI,       // 1
    EBODY_COLLISION_TORSO_LO,       // 2
    EBODY_COLLISION_ARM_LEFT,       // 3
    EBODY_COLLISION_ARM_RIGHT,      // 4
    EBODY_COLLISION_LEG_LEFT,       // 5
    EBODY_COLLISION_LEG_RIGHT,      // 6
    EBODY_COLLISION_BONE_SNAP,      // 7
    EBODY_COLLISION_CUSTOM_1,       // 8
    EBODY_COLLISION_CUSTOM_2,       // 9
    EBODY_COLLISION_CUSTOM_3,       // 10
    EBODY_COLLISION_CUSTOM_4,       // 11
    EBODY_COLLISION_ALL,            // 12
    EBODY_COLLISION_NONE,           // 13
    EBODY_COLLISION_MAX             // 14
};

struct native ImpactSettings
{
    var() MOHAPhysicalMaterialProperty.EImpactType ImpactType;
    var() float MinSpeed;
    var() float MaxVolumeSpeed;
    var() float MinVolumeScale;
    var() float MaxVolumeScale;

    structdefaultproperties
    {
        ImpactType=19
        MinSpeed=30.0000000
        MaxVolumeSpeed=0.0000000
        MinVolumeScale=1.0000000
        MaxVolumeScale=1.0000000
    }
};

struct native BodyPartInfo
{
    var() editconst name BodyPart;
    var() float ReplayGate;
    var() array<ImpactSettings> Impacts;

    structdefaultproperties
    {
        BodyPart="None"
        ReplayGate=0.3330000
        Impacts=none
    }
};

struct native RigidBodyToBodyPart
{
    var() editconst name RigidBody;
    var() MOHARagdollAudioAsset.EBodyCollisionSection BodyPart;

    structdefaultproperties
    {
        RigidBody="None"
        BodyPart=0
    }
};

var() int MaxPlayCount;
var() float MaxPlayCountInterval;
var() editconstarray array<BodyPartInfo> BodyPartsInfo;
var() MOHARagdollAudioAsset.EBodyCollisionSection DebugIsolate;
var() editconstarray array<RigidBodyToBodyPart> BodyPartMap;

defaultproperties
{
    MaxPlayCount=3
    MaxPlayCountInterval=0.3000000
    BodyPartsInfo[0]=(BodyPart="Head",ReplayGate=0.3330000,Impacts=none)
    BodyPartsInfo[1]=(BodyPart="HighTorso",ReplayGate=0.3330000,Impacts=none)
    BodyPartsInfo[2]=(BodyPart="LowTorso",ReplayGate=0.3330000,Impacts=none)
    BodyPartsInfo[3]=(BodyPart="LeftArm",ReplayGate=0.3330000,Impacts=none)
    BodyPartsInfo[4]=(BodyPart="RightArm",ReplayGate=0.3330000,Impacts=none)
    BodyPartsInfo[5]=(BodyPart="LeftLeg",ReplayGate=0.3330000,Impacts=none)
    BodyPartsInfo[6]=(BodyPart="RightLeg",ReplayGate=0.3330000,Impacts=none)
    BodyPartsInfo[7]=(BodyPart="BoneSnap",ReplayGate=0.3330000,Impacts=none)
    BodyPartsInfo[8]=(BodyPart="Custom1",ReplayGate=0.3330000,Impacts=none)
    BodyPartsInfo[9]=(BodyPart="Custom2",ReplayGate=0.3330000,Impacts=none)
    BodyPartsInfo[10]=(BodyPart="Custom3",ReplayGate=0.3330000,Impacts=none)
    BodyPartsInfo[11]=(BodyPart="Custom4",ReplayGate=0.3330000,Impacts=none)
    DebugIsolate=13
    BodyPartMap[0]=(RigidBody="Hips",BodyPart=2)
    BodyPartMap[1]=(RigidBody="Belly",BodyPart=2)
    BodyPartMap[2]=(RigidBody="Sternum",BodyPart=1)
    BodyPartMap[3]=(RigidBody="Chest",BodyPart=1)
    BodyPartMap[4]=(RigidBody="Neck",BodyPart=13)
    BodyPartMap[5]=(RigidBody="Head",BodyPart=0)
    BodyPartMap[6]=(RigidBody="LeftShoulder",BodyPart=1)
    BodyPartMap[7]=(RigidBody="LeftUpperArm",BodyPart=3)
    BodyPartMap[8]=(RigidBody="LeftForeArm",BodyPart=3)
    BodyPartMap[9]=(RigidBody="LeftHand",BodyPart=3)
    BodyPartMap[10]=(RigidBody="RightShoulder",BodyPart=1)
    BodyPartMap[11]=(RigidBody="RightUpperArm",BodyPart=4)
    BodyPartMap[12]=(RigidBody="RightForeArm",BodyPart=4)
    BodyPartMap[13]=(RigidBody="RightHand",BodyPart=4)
    BodyPartMap[14]=(RigidBody="LeftThigh",BodyPart=5)
    BodyPartMap[15]=(RigidBody="LeftCalf",BodyPart=5)
    BodyPartMap[16]=(RigidBody="LeftFoot",BodyPart=5)
    BodyPartMap[17]=(RigidBody="RightThigh",BodyPart=6)
    BodyPartMap[18]=(RigidBody="RightCalf",BodyPart=6)
    BodyPartMap[19]=(RigidBody="RightFoot",BodyPart=6)
}