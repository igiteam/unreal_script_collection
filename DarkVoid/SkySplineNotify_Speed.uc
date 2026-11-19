class SkySplineNotify_Speed extends SkySplineNotify
    editinlinenew
    collapsecategories;

enum NOTIFY_SPEED
{
    SPEED_SLOWEST,                  // 0
    SPEED_SLOW,                     // 1
    SPEED_NORMAL,                   // 2
    SPEED_FAST,                     // 3
    SPEED_BOOST,                    // 4
    SPEED_MAX                       // 5
};

var() bool bEnableCruiseControl;
var(MPH) bool bUseMPH;
var(MPH) float MilesPerHour;
var() SkySplineNotify_Speed.NOTIFY_SPEED Speed;
var() float TimeToReachSpeed;

simulated event Activated(Actor Target)
{
    local SkyAIController SBCB;
    local SkyBotControllerPilot SBCP;
    local SkyAirVehicle SV;
    local float myMPH;
    local editinline SkyVehicleSim_CrimsonAircraft crimsonSim;
    local float mySpeed;

    // End:0x236
    if(Pawn(Target) != none)
    {
        SBCB = SkyAIController(Pawn(Target).Controller);
        // End:0x236
        if(SBCB != none)
        {
            SBCP = SkyBotControllerPilot(Pawn(Target).Controller);
            // End:0x236
            if(SBCP != none)
            {
                // End:0x224
                if(bEnableCruiseControl == true)
                {
                    // End:0x8A
                    if(bUseMPH == true)
                    {
                        myMPH = MilesPerHour;                        
                    }
                    else
                    {
                        SV = SkyAirVehicle(Target);
                        crimsonSim = SkyVehicleSim_CrimsonAircraft(SV.SimObj);
                        // End:0x203
                        if(crimsonSim != none)
                        {
                            switch(Speed)
                            {
                                // End:0xF5
                                case 0:
                                    mySpeed = SV.AirSpeed * crimsonSim.BrakeScale;
                                    // End:0x1F1
                                    break;
                                // End:0x14C
                                case 1:
                                    mySpeed = SV.AirSpeed - (SV.AirSpeed - ((SV.AirSpeed * crimsonSim.BrakeScale) * 0.5000000));
                                    // End:0x1F1
                                    break;
                                // End:0x169
                                case 2:
                                    mySpeed = SV.AirSpeed;
                                    // End:0x1F1
                                    break;
                                // End:0x1C0
                                case 3:
                                    mySpeed = SV.AirSpeed + (((SV.AirSpeed * crimsonSim.TurboScale) - SV.AirSpeed) * 0.5000000);
                                    // End:0x1F1
                                    break;
                                // End:0x1EE
                                case 4:
                                    mySpeed = SV.AirSpeed * crimsonSim.TurboScale;
                                    // End:0x1F1
                                    break;
                                // End:0xFFFF
                                default:
                                    break;
                            }
                            myMPH = mySpeed * 0.0223693;
                        }
                    }
                    SBCP.SetCruiseControl(myMPH, TimeToReachSpeed);                    
                }
                else
                {
                    SBCP.bCruiseControlOn = false;
                }
            }
        }
    }
    //return;    
}
