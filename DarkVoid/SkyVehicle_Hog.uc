class SkyVehicle_Hog extends SkyVehicle
    config(Game);

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    //return;    
}

simulated function bool DriverEnter(Pawn P)
{
    return super.DriverEnter(P);
    //return ReturnValue;    
}

simulated event bool DriverLeave(bool bForceLeave)
{
    return super.DriverLeave(bForceLeave);
    //return ReturnValue;    
}
