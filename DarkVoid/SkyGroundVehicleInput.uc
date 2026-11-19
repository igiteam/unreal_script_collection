class SkyGroundVehicleInput extends SkyPlayerInput within PlayerController
    transient
    native
    config(Input);

var input byte bHandbrake;

function PreProcessInput(float DeltaTime)
{
    local SkyVehicle MyVehicle;

    // End:0x64
    if(SkyVehicle_AAGun_Gatling(Outer.Pawn) != none)
    {
        // End:0x3F
        if(aStrafe != 0.0000000)
        {
            aTurn = aStrafe;
            RawJoyLookRight = RawJoyRight;
        }
        // End:0x64
        if(aBaseY != 0.0000000)
        {
            aLookUp = aBaseY;
            RawJoyLookUp = RawJoyUp;
        }
    }
    super.PreProcessInput(DeltaTime);
    MyVehicle = SkyVehicle(Outer.Pawn);
    // End:0xC7
    if(MyVehicle != none)
    {
        MyVehicle.Roll = 0.0000000;
        MyVehicle.bHoldingDownHandbrake = int(bHandbrake) != int(0);
    }
    flightInputX = -aStrafe;
    flightInputY = aBaseY;
    //return;    
}
