class SkyVehicle_Bedford extends SkyVehicle
    native
    config(Game);

var MaterialInstanceConstant MatInst;
var AnimNodeSequence HatchSequence;
var bool bBrakeLightOn;
var bool bReverseLightOn;
var bool bHeadlightsOn;
var bool bWasThrottle;
var name BrakeLightParameterName;
var name ReverseLightParameterName;
var name HeadLightParameterName;
var SoundCue EjectSoundCue;
var float ThrottleStartTime;
var StaticMesh PartsMesh;

simulated function SetInputs(float InForward, float InStrafe, float InUp)
{
    Rise = InUp;
    Throttle = InForward;
    Steering = InStrafe;
    // End:0x79
    if(IsLocallyControlled())
    {
        // End:0x64
        if(Throttle == 1.0000000)
        {
            // End:0x59
            if(!bWasThrottle)
            {
                ThrottleStartTime = WorldInfo.TimeSeconds;
            }
            bWasThrottle = true;            
        }
        else
        {
            // End:0x79
            if(Throttle <= float(0))
            {
                bWasThrottle = false;
            }
        }
    }
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0xA6
    if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && !bDeleteMe)
    {
        MatInst = new (Outer) Class'Engine.MaterialInstanceConstant';
        MatInst.SetParent(Mesh.GetMaterial(0));
        Mesh.SetMaterial(0, MatInst);
        MatInst.SetScalarParameterValue('Green_Glows_Headlights', 0.0000000);
    }
    //return;    
}

function byte ChooseFireMode()
{
    // End:0xCC
    if((((((Pawn(Controller.Focus) != none) && Vehicle(Controller.Focus) == none) && Controller.MoveTarget == Controller.Focus) && Controller.InLatentExecution(Controller.503)) && VSize(Controller.GetFocalPoint() - Location) < float(1200)) && Controller.LineOfSightTo(Controller.Focus))
    {
        return 1;
    }
    return 0;
    //return ReturnValue;    
}
