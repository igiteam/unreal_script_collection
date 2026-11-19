class SkySeqAct_EnterVehicle extends SequenceAction;

var() int SeatIndex;
var() bool bOverrideVehicleEnter;

event Activated()
{
    local SeqVar_Object ObjVar;
    local Pawn Target;
    local SkyGameVehicle TheVehicle;
    local SkyVehicleFactory Factory;

    // End:0xA4
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Vehicle/Vehicle Factory")
    {
        TheVehicle = SkyGameVehicle(ObjVar.GetObjectValue());
        // End:0x95
        if(TheVehicle == none)
        {
            Factory = SkyVehicleFactory(ObjVar.GetObjectValue());
            // End:0x95
            if(Factory != none)
            {
                TheVehicle = Factory.ChildVehicle;
            }
        }
        // End:0xA3
        if(TheVehicle != none)
        {
            // End:0xA4
            break;
        }        
    }    
    // End:0xEA
    if(TheVehicle == none)
    {
        ScriptLog(("WARNING: Vehicle variable for" @ string(self)) @ "is empty");        
    }
    else
    {
        // End:0x30E
        foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Target")
        {
            Target = Pawn(ObjVar.GetObjectValue());
            // End:0x30D
            if(Target != none)
            {
                // End:0x1E9
                if(((SeatIndex <= 0) || SeatIndex >= TheVehicle.Seats.Length) && TheVehicle.Driver == none)
                {
                    // End:0x1A4
                    if(bOverrideVehicleEnter && SkyPawn(Target) != none)
                    {
                        SkyPawn(Target).OverrideVehicleEnter = bOverrideVehicleEnter;
                    }
                    TheVehicle.DriverEnter(Target);
                    // End:0x1E6
                    if(SkyAirVehicle(TheVehicle) != none)
                    {
                        SkyAirVehicle(TheVehicle).ForceFlying();
                    }
                    // End:0x30D
                    continue;
                }
                // End:0x24F
                if(((SeatIndex > 0) && SeatIndex < TheVehicle.Seats.Length) && TheVehicle.SeatAvailable(SeatIndex))
                {
                    TheVehicle.PassengerEnter(Target, SeatIndex);
                    // End:0x30D
                    continue;
                }
                // End:0x2E0
                if(TheVehicle.Driver == none)
                {
                    // End:0x29B
                    if(bOverrideVehicleEnter && SkyPawn(Target) != none)
                    {
                        SkyPawn(Target).OverrideVehicleEnter = bOverrideVehicleEnter;
                    }
                    TheVehicle.DriverEnter(Target);
                    // End:0x2DD
                    if(SkyAirVehicle(TheVehicle) != none)
                    {
                        SkyAirVehicle(TheVehicle).ForceFlying();
                    }
                    // End:0x30D
                    continue;
                }
                TheVehicle.PassengerEnter(Target, TheVehicle.GetFirstAvailableSeat());
            }            
        }        
    }
    //return;    
}
