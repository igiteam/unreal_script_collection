class SkyAnimNotify_Automove extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

enum EAnimNotifyAutomove
{
    AnimNotifyAutomove_Ignore,      // 0
    AnimNotifyAutomove_Enable,      // 1
    AnimNotifyAutomove_Disable,     // 2
    AnimNotifyAutomove_MAX          // 3
};

enum EAnimNotifyAutomoveTarget
{
    AnimNotifyAutomoveTarget_Default,// 0
    AnimNotifyAutomoveTarget_Driver,// 1
    AnimNotifyAutomoveTarget_Vehicle,// 2
    AnimNotifyAutomoveTarget_MAX    // 3
};

var() SkyAnimNotify_Automove.EAnimNotifyAutomove Translation;
var() SkyAnimNotify_Automove.EAnimNotifyAutomove Rotation;
var() SkyAnimNotify_Automove.EAnimNotifyAutomoveTarget AutomoveTarget;
var(Translation) name TranslationSocket;
var(Translation) float TranslationTime;
var(Translation) float StopDistanceFromTarget;
var(Translation) bool bAssumeTargetLocation;
var(Translation) bool bAssumeTargetXYOnly;
var(Rotation) bool bAssumeTargetRotation;
var(Rotation) name RotationSocket;
var(Rotation) float RotationTime;
var(Rotation) int RotationTolerance;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn P;
    local SkyInteractor Target;
    local Pawn TargetDriver;
    local Vehicle TargetVehicle;

    P = SkyPawn(Owner);
    // End:0x29E
    if(P != none)
    {
        // End:0x16D
        if(P.IsInteracting())
        {
            Target = P.GetInteractionPartner();
            // End:0x81
            if(Vehicle(Target) != none)
            {
                TargetVehicle = Vehicle(Target);
                TargetDriver = TargetVehicle.Driver;
            }
            // End:0xD0
            if(Pawn(Target) != none)
            {
                // End:0xD0
                if(Pawn(Target).DrivenVehicle != none)
                {
                    TargetDriver = Pawn(Target);
                    TargetVehicle = TargetDriver.DrivenVehicle;
                }
            }
            switch(AutomoveTarget)
            {
                // End:0xF5
                case 0:
                    P.AutomoveTarget = Target;
                    // End:0x132
                    break;
                // End:0x112
                case 1:
                    P.AutomoveTarget = TargetDriver;
                    // End:0x132
                    break;
                // End:0x12F
                case 2:
                    P.AutomoveTarget = TargetVehicle;
                    // End:0x132
                    break;
                // End:0xFFFF
                default:
                    break;
            }
            // End:0x16D
            if(P.AutomoveTarget == none)
            {
                P.bAutomoveTranslateToTarget = false;
                P.bAutomoveRotateToTarget = false;
                return;
            }
        }
        switch(Translation)
        {
            // End:0x17D
            case 0:
                // End:0x219
                break;
            // End:0x1FF
            case 1:
                P.bAutomoveTranslateToTarget = true;
                P.AutomoveTranslateSocket = TranslationSocket;
                P.Automove_TranslateTime = TranslationTime;
                P.Automove_TranslateStopDistFromTarget = StopDistanceFromTarget;
                P.bAutomove_TranslateAssumeTargetLocation = bAssumeTargetLocation;
                P.bAutomove_TranslateAssumeTargetXYOnly = true;
                // End:0x219
                break;
            // End:0x216
            case 2:
                P.bAutomoveTranslateToTarget = false;
            // End:0xFFFF
            default:
                break;
        }
        switch(Rotation)
        {
            // End:0x229
            case 0:
                // End:0x29E
                break;
            // End:0x284
            case 1:
                P.bAutomoveRotateToTarget = true;
                P.AutomoveRotateSocket = RotationSocket;
                P.Automove_RotateTime = RotationTime;
                P.bAutomove_RotateAssumeTargetRotation = bAssumeTargetRotation;
                // End:0x29E
                break;
            // End:0x29B
            case 2:
                P.bAutomoveTranslateToTarget = false;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        //return;        
    }
}
