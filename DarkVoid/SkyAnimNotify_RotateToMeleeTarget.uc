class SkyAnimNotify_RotateToMeleeTarget extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() bool bOn;
var() bool bAssumeTargetRotation;
var() bool bInverse;
var() bool bTargetVehicle;
var() float RotateTime;
var() int RotationTolerance;
var() name Socket;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn P;
    local SkyArchonPilot SAP;
    local SkyPawn TP;

    P = SkyPawn(Owner);
    // End:0x264
    if(P != none)
    {
        // End:0x6E
        if(P.IsInteracting())
        {
            P.AutomoveTarget = P.GetInteractionPartner();
            P.AutomoveRotateSocket = Socket;            
        }
        else
        {
            // End:0xD4
            if((P.Pilot != none) && P.Pilot.IsInteracting())
            {
                P.AutomoveTarget = P.Pilot.GetInteractionPartner();
            }
        }
        // End:0x196
        if(bTargetVehicle)
        {
            SAP = SkyArchonPilot(P.AutomoveTarget);
            TP = SkyPawn(P.AutomoveTarget);
            // End:0x155
            if((SAP != none) && SAP.PilotedPawn != none)
            {
                P.AutomoveTarget = SAP.PilotedPawn;                
            }
            else
            {
                // End:0x196
                if((TP != none) && TP.DrivenVehicle != none)
                {
                    P.AutomoveTarget = TP.DrivenVehicle;
                }
            }
        }
        // End:0x252
        if(bOn && P.AutomoveTarget != none)
        {
            P.bAutomoveRotateToTarget = true;
            P.bAutomove_RotateAssumeTargetRotation = bAssumeTargetRotation;
            P.Automove_RotateTime = RotateTime;
            P.bAutomove_RotateInverse = bInverse;
            // End:0x230
            if(RotationTolerance >= 0)
            {
                P.Automove_RotateTolerance = float(RotationTolerance);                
            }
            else
            {
                P.Automove_RotateTolerance = P.default.Automove_RotateTolerance;
            }            
        }
        else
        {
            P.bAutomoveRotateToTarget = false;
        }
    }
    //return;    
}
