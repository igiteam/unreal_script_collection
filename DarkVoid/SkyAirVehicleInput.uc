class SkyAirVehicleInput extends SkyPlayerInput within PlayerController
    transient
    native
    config(Input);

var bool bInitialDeadZoneOn;

function Initialized()
{
    super.Initialized();
    bInitialDeadZoneOn = true;
    //return;    
}

function PreProcessInput(float DeltaTime)
{
    local SkyAirVehicle MyVehicle;
    local SkyPawn Driver;

    super.PreProcessInput(DeltaTime);
    // End:0x30
    if(!bInvertMouse)
    {
        aBaseY = -aBaseY;
        RawJoyUp = -RawJoyUp;
    }
    MyVehicle = SkyAirVehicle(Outer.Pawn);
    // End:0x1D8
    if(MyVehicle != none)
    {
        // End:0xDA
        if(bInitialDeadZoneOn && (Abs(RawJoyRight) + Abs(RawJoyUp)) < 0.7000000)
        {
            flightInputX = 0.0000000;
            flightInputY = 0.0000000;
            aBaseY = 0.0000000;
            RawJoyUp = 0.0000000;
            aStrafe = 0.0000000;
            RawJoyRight = 0.0000000;
            MyVehicle.SetRoll(-aTurn);            
        }
        else
        {
            bInitialDeadZoneOn = false;
            MyVehicle.SetRoll(-aTurn);
            // End:0x12D
            if(!MyVehicle.bTakeoff)
            {
                flightInputX = -RawJoyRight;
                flightInputY = RawJoyUp;                
            }
            else
            {
                flightInputX = 0.0000000;
                flightInputY = 0.0000000;
            }
        }
        Driver = SkyPawn(MyVehicle.Driver);
        // End:0x1D5
        if(Driver != none)
        {
            // End:0x1D5
            if((Driver.IsHijacking() || Driver.bGoingIntervehicular) || Driver.bHijackClearInput)
            {
                RawJoyUp = 0.0000000;
                RawJoyRight = 0.0000000;
                RawJoyLookRight = 0.0000000;
                RawJoyLookUp = 0.0000000;
            }
        }        
    }
    //return;    
}
