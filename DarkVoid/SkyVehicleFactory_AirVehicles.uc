class SkyVehicleFactory_AirVehicles extends SkyVehicleFactory
    native;

var() bool bSetInitialPhysics;
var() bool bSpawnAIPilot;
var() Actor.EPhysics InitialPhysics;
var() SkyAirVehicle.EVehicleTakeoffType TakeoffType;
var SkyAirVehicle DockedVehicle;
var() SkyInteractor_LandAirVehicle LandingInteractor;

function bool IsBlocked()
{
    // End:0x37
    if(SpawnedVehicle != none)
    {
        // End:0x37
        if((SkyAirVehicle(SpawnedVehicle) != none) && SkyAirVehicle(SpawnedVehicle).bTakeoff)
        {
            return true;
        }
    }
    return super.IsBlocked();
    //return ReturnValue;    
}

state Active
{
    function PostSpawn()
    {
        local SkyNPC AI;
        local Controller Con;
        local SkyAirVehicle SAV;

        // End:0x17D
        if(ChildVehicle != none)
        {
            // End:0x26
            if(bSetInitialPhysics)
            {
                ChildVehicle.SetPhysics(InitialPhysics);
            }
            // End:0xF2
            if(bSpawnAIPilot)
            {
                AI = Spawn(Class'SkyNPC');
                // End:0xF2
                if(AI != none)
                {
                    Con = Spawn(Class'SkyBotControllerPilot');
                    // End:0xF2
                    if(Con != none)
                    {
                        Con.Possess(AI, false);
                        // End:0xC7
                        if(Con.PlayerReplicationInfo != none)
                        {
                            Con.PlayerReplicationInfo.SetPlayerName("Pilot");
                        }
                        // End:0xF2
                        if(!ChildVehicle.TryToDrive(AI))
                        {
                            AI.Destroy();
                        }
                    }
                }
            }
            SAV = SkyAirVehicle(ChildVehicle);
            // End:0x17D
            if(SAV != none)
            {
                SAV.TakeoffType = TakeoffType;
                // End:0x161
                if((int(InitialPhysics) == int(0)) && bSetInitialPhysics)
                {
                    SAV.bShouldHover = true;
                    SAV.bSetPhysicsOnEnter = false;
                }
                DockedVehicle = SAV;
                SAV.DockedFactory = self;
            }
        }
        //return;        
    }
    stop;    
}
