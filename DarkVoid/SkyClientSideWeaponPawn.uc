class SkyClientSideWeaponPawn extends SkyWeaponPawn
    config(Game);

simulated function PreBeginPlay()
{
    //return;    
}

simulated function AttachDriver(Pawn P)
{
    Driver = P;
    super.AttachDriver(P);
    //return;    
}

simulated function DetachDriver(Pawn P)
{
    super(Vehicle).DetachDriver(P);
    Destroy();
    //return;    
}

simulated function Tick(float DeltaTime)
{
    super(Actor).Tick(DeltaTime);
    // End:0x45
    if(((Driver == none) || Driver.bDeleteMe) || Driver.DrivenVehicle != self)
    {
        Destroy();
    }
    //return;    
}
