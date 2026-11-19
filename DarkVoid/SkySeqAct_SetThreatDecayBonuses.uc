class SkySeqAct_SetThreatDecayBonuses extends SequenceAction;

var() bool bIgnoreThreatDecayBonuses;
var() float EnemyThreatBonusDecayTime;

event Activated()
{
    local Actor AI;
    local SeqVar_Object ObjVar;

    // End:0xA6
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Target")
    {
        AI = Actor(ObjVar.GetObjectValue());
        // End:0x79
        if(SkyAIController(AI) != none)
        {
            // End:0x79
            if(Pawn(AI) != none)
            {
                AI = SkyAIController(Pawn(AI).Controller);
            }
        }
        // End:0xA5
        if(SkyAIController(AI) != none)
        {
            SkyAIController(AI).bIgnoreThreatDecayBonuses = bIgnoreThreatDecayBonuses;
        }        
    }    
    super(SequenceOp).Activated();
    //return;    
}
