class SkySeqAct_SetMetaVariableOnBehTree extends SequenceAction;

var() string MetaVariableName;
var() float MetaVariableValue;
var() bool bMetaVariableIsGlobal;
var() bool bMetaVariableIsRelativeToWorldTime;

event Activated()
{
    local SeqVar_Object ObjVar;
    local Pawn P;
    local SkyBot SBC;
    local array<SkyBot> BotArray;
    local int Idx;
    local float ActualValue;

    // End:0xA2
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Target")
    {
        SBC = SkyBot(ObjVar.GetObjectValue());
        // End:0x89
        if(SBC == none)
        {
            P = Pawn(ObjVar.GetObjectValue());
            // End:0x89
            if(P != none)
            {
                SBC = SkyBot(P.Controller);
            }
        }
        // End:0xA1
        if(SBC != none)
        {
            BotArray.AddItem(SBC);
        }        
    }    
    // End:0xDC
    if(BotArray.Length <= 0)
    {
        // End:0xDB
        foreach GetWorldInfo().AllControllers(Class'SkyBot', SBC)
        {
            BotArray.AddItem(SBC);            
        }        
    }
    ActualValue = MetaVariableValue;
    // End:0x107
    if(bMetaVariableIsRelativeToWorldTime)
    {
        ActualValue += GetWorldInfo().TimeSeconds;
    }
    Idx = 0;
    J0x10E:

    // End:0x17B [Loop If]
    if(Idx < BotArray.Length)
    {
        SBC = BotArray[Idx];
        // End:0x171
        if((SBC != none) && SBC.BehaviorTree != none)
        {
            SBC.AssignVariable(MetaVariableName, bMetaVariableIsGlobal, ActualValue);
        }
        ++Idx;
        // [Loop Continue]
        goto J0x10E;
    }
    //return;    
}
