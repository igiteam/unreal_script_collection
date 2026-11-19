class SkySeqAct_ExtractControllerFromFactory extends SequenceAction;

event Activated()
{
    local SeqVar_Object ObjVar;
    local SkyGameVehicle TheVehicle;
    local SkyVehicleFactory Factory;

    // End:0x72
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Vehicle Factory")
    {
        Factory = SkyVehicleFactory(ObjVar.GetObjectValue());
        // End:0x63
        if(Factory != none)
        {
            TheVehicle = Factory.ChildVehicle;
        }
        // End:0x71
        if(TheVehicle != none)
        {
            // End:0x72
            break;
        }        
    }    
    // End:0xC2
    if(TheVehicle != none)
    {
        // End:0xC1
        foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Controller")
        {
            ObjVar.SetObjectValue(TheVehicle.Controller);            
        }        
    }
    //return;    
}
