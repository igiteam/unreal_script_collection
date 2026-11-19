class SPDismemberedBodyPartName_Soldier extends SPDismemberedBodyPartName
    editinlinenew;

enum SPSoldierDismemberedBodyPartType
{
    esbdUnknown,                    // 0
    esdbHead,                       // 1
    esdbRightArm,                   // 2
    esdbLeftArm,                    // 3
    esdbRightLeg,                   // 4
    esdbLeftLeg,                    // 5
    SPSoldierDismemberedBodyPartType_MAX// 6
};

/** VARIABLE DECLARATIONS */
var() SPDismemberedBodyPartName_Soldier.SPSoldierDismemberedBodyPartType BodyPartType;

event name GetJointName()
{
    switch(BodyPartType)
    {
        // End:0x17
        case 1:
            return 'JO_neck';
        // End:0x26
        case 2:
            return 'JO_shoulder_R';
        // End:0x35
        case 3:
            return 'JO_shoulder_L';
        // End:0x44
        case 4:
            return 'JO_upperLeg_R';
        // End:0x53
        case 5:
            return 'JO_upperLeg_L';
        // End:0xFFFF
        default:
            return 'None';
            break;
    }
    //return ReturnValue;    
}
