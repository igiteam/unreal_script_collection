class UTSeqAct_EnterVehicle extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() int SeatIndex;

event Activated()
{
    local SeqVar_Object ObjVar;
    local Pawn Target;
    local EvilVehicle_Base TheVehicle;
    local UTVehicleFactory Factory;

    // End:0xFE
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Vehicle/Vehicle Factory")
    {
        TheVehicle = EvilVehicle_Base(ObjVar.GetObjectValue());
        // End:0xEB
        if(TheVehicle == none)
        {
            Factory = UTVehicleFactory(ObjVar.GetObjectValue());
            // End:0xEB
            if(Factory != none)
            {
                TheVehicle = EvilVehicle_Base(Factory.ChildVehicle);
            }
        }
        // End:0xFD
        if(TheVehicle != none)
        {
            // End:0xFE
            break;
        }        
    }    
    // End:0x14C
    if(TheVehicle == none)
    {
        ScriptLog(("WARNING: Vehicle variable for" @ string(self)) @ "is empty");        
    }
    else
    {
        // End:0x383
        foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Target")
        {
            Target = GetPawn(Actor(ObjVar.GetObjectValue()));
            // End:0x382
            if(Target != none)
            {
                // End:0x24D
                if(((SeatIndex <= 0) || SeatIndex >= TheVehicle.Seats.Length) && TheVehicle.Driver == none)
                {
                    TheVehicle.DriverEnter(Target);
                    // End:0x382
                    continue;
                }
                // End:0x2EC
                if(((SeatIndex > 0) && SeatIndex < TheVehicle.Seats.Length) && TheVehicle.SeatAvailable(SeatIndex))
                {
                    TheVehicle.PassengerEnter(Target, SeatIndex);
                    // End:0x382
                    continue;
                }
                // End:0x33B
                if(TheVehicle.Driver == none)
                {
                    TheVehicle.DriverEnter(Target);
                    // End:0x382
                    continue;
                }
                TheVehicle.PassengerEnter(Target, TheVehicle.GetFirstAvailableSeat());
            }            
        }        
    }
    //return;    
}

defaultproperties
{
    SeatIndex=-1
    bCallHandler=false
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Vehicle/Vehicle Factory",LinkVar="None",PropertyName="None",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Enter Vehicle"
}