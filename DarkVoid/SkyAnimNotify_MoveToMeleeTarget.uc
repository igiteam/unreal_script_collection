class SkyAnimNotify_MoveToMeleeTarget extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() bool bOn;
var() bool bAssumeTargetLocation;
var() bool bSnapToSocket;
var() bool bTargetVehicle;
var() float TravelTime;
var() float StopDistanceFromTarget;
var() name Socket;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn P;
    local SkyArchonPilot SAP;
    local SkyPawn TP;

    P = SkyPawn(Owner);
    // End:0x247
    if(P != none)
    {
        // End:0x59
        if(P.IsInteracting())
        {
            P.AutomoveTarget = P.GetInteractionPartner();            
        }
        else
        {
            // End:0xBF
            if((P.Pilot != none) && P.Pilot.IsInteracting())
            {
                P.AutomoveTarget = P.Pilot.GetInteractionPartner();
            }
        }
        // End:0x181
        if(bTargetVehicle)
        {
            SAP = SkyArchonPilot(P.AutomoveTarget);
            TP = SkyPawn(P.AutomoveTarget);
            // End:0x140
            if((SAP != none) && SAP.PilotedPawn != none)
            {
                P.AutomoveTarget = SAP.PilotedPawn;                
            }
            else
            {
                // End:0x181
                if((TP != none) && TP.DrivenVehicle != none)
                {
                    P.AutomoveTarget = TP.DrivenVehicle;
                }
            }
        }
        // End:0x235
        if(bOn && P.AutomoveTarget != none)
        {
            P.bAutomoveTranslateToTarget = true;
            P.bAutomove_TranslateAssumeTargetLocation = bAssumeTargetLocation;
            P.bAutomove_TranslateAssumeTargetXYOnly = true;
            P.Automove_TranslateStopDistFromTarget = StopDistanceFromTarget;
            P.Automove_TranslateTime = TravelTime;
            P.AutomoveTranslateSocket = Socket;
            P.bAutomoveTranslateSnapToSocket = bSnapToSocket;            
        }
        else
        {
            P.bAutomoveTranslateToTarget = false;
        }
    }
    //return;    
}
