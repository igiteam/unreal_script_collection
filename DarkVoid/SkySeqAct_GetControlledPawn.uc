class SkySeqAct_GetControlledPawn extends SequenceAction;

enum EPawnType
{
    PAWN_Character,                 // 0
    PAWN_Vehicle,                   // 1
    PAWN_MAX                        // 2
};

var() SkySeqAct_GetControlledPawn.EPawnType PawnType;
var Pawn OutPawn;

event Activated()
{
    local Controller Controller;
    local Pawn Pawn;

    Pawn = Pawn(SeqVar_Object(VariableLinks[0].LinkedVariables[0]).GetObjectValue());
    // End:0x56
    if(Pawn != none)
    {
        Controller = Pawn.Controller;        
    }
    else
    {
        Controller = Controller(SeqVar_Object(VariableLinks[0].LinkedVariables[0]).GetObjectValue());
    }
    // End:0x96
    if(Controller == none)
    {
        return;
    }
    switch(PawnType)
    {
        // End:0x12A
        case 0:
            // End:0xDA
            if(SkyPawn(Controller.Pawn) != none)
            {
                OutPawn = SkyPawn(Controller.Pawn);                
            }
            else
            {
                // End:0x120
                if(SkyVehicle(Controller.Pawn) != none)
                {
                    OutPawn = SkyPawn(SkyVehicle(Controller.Pawn).Driver);                    
                }
                else
                {
                    OutPawn = none;
                }
            }
            // End:0x16E
            break;
        // End:0x16B
        case 1:
            // End:0x161
            if(SkyVehicle(Controller.Pawn) != none)
            {
                OutPawn = Controller.Pawn;                
            }
            else
            {
                OutPawn = none;
            }
            // End:0x16E
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}
