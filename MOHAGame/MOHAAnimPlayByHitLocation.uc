class MOHAAnimPlayByHitLocation extends MOHAAnimPlayByBase
    hidecategories(Object,Object,Object,Object,AnimNodeBlendList);

enum EDeathAnimBodyPart
{
    DEATH_BODYPART_HEAD,            // 0
    DEATH_BODYPART_NECK,            // 1
    DEATH_BODYPART_TORSO,           // 2
    DEATH_BODYPART_GROIN,           // 3
    DEATH_BODYPART_LEFTARM,         // 4
    DEATH_BODYPART_RIGHTARM,        // 5
    DEATH_BODYPART_LEFTLEG,         // 6
    DEATH_BODYPART_RIGHTLEG,        // 7
    DEATH_BODYPART_MAX              // 8
};

struct RigidBodyToDeathBodyPart
{
    var() editconst name RigidBody;
    var() MOHAAnimPlayByHitLocation.EDeathAnimBodyPart BodyPart;

    structdefaultproperties
    {
        RigidBody="None"
        BodyPart=0
    }
};

var() editconstarray array<RigidBodyToDeathBodyPart> BodyPartMap;

event int GetChildIndexToPlay()
{
    local int Index;
    local editinline MOHASkeletalMeshComponent Mesh;
    local MOHAPawn Pawn;

    Index = 0;
    Mesh = MOHASkeletalMeshComponent(SkelComponent);
    // End:0x85
    if(Mesh != none)
    {
        Pawn = MOHAPawn(Mesh.Owner);
        // End:0x85
        if((Pawn != none) && Pawn.LastHitRigdBodyId >= 0)
        {
            Index = int(BodyPartMap[Pawn.LastHitRigdBodyId].BodyPart) + 1;
        }
    }
    return Index;
    //return ReturnValue;    
}

defaultproperties
{
    BodyPartMap[0]=(RigidBody="Hips",BodyPart=3)
    BodyPartMap[1]=(RigidBody="Belly",BodyPart=3)
    BodyPartMap[2]=(RigidBody="Sternum",BodyPart=2)
    BodyPartMap[3]=(RigidBody="Chest",BodyPart=2)
    BodyPartMap[4]=(RigidBody="Neck",BodyPart=1)
    BodyPartMap[5]=(RigidBody="Head",BodyPart=0)
    BodyPartMap[6]=(RigidBody="LeftShoulder",BodyPart=4)
    BodyPartMap[7]=(RigidBody="LeftUpperArm",BodyPart=4)
    BodyPartMap[8]=(RigidBody="LeftForeArm",BodyPart=4)
    BodyPartMap[9]=(RigidBody="LeftHand",BodyPart=4)
    BodyPartMap[10]=(RigidBody="RightShoulder",BodyPart=5)
    BodyPartMap[11]=(RigidBody="RightUpperArm",BodyPart=5)
    BodyPartMap[12]=(RigidBody="RightForeArm",BodyPart=5)
    BodyPartMap[13]=(RigidBody="RightHand",BodyPart=5)
    BodyPartMap[14]=(RigidBody="LeftThigh",BodyPart=6)
    BodyPartMap[15]=(RigidBody="LeftCalf",BodyPart=6)
    BodyPartMap[16]=(RigidBody="LeftFoot",BodyPart=6)
    BodyPartMap[17]=(RigidBody="RightThigh",BodyPart=7)
    BodyPartMap[18]=(RigidBody="RightCalf",BodyPart=7)
    BodyPartMap[19]=(RigidBody="RightFoot",BodyPart=7)
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}