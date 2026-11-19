class SeqAct_SpawnOIRPawn extends SequenceAction
    hidecategories(Object);

var() class<MOHAOIRPawn> SpawnOIRPawnClass;

function ReportSpawned(Actor spawned)
{
    local SeqVar_Object ObjectVar;

    // End:0x0D
    if(spawned == none)
    {
        return;
    }
    // End:0x42
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjectVar, "Spawned")
    {
        ObjectVar.SetObjectValue(spawned);        
    }    
    //return;    
}

defaultproperties
{
    SpawnOIRPawnClass=Class'MOHAOIRPawn'
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Spawned",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=0,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjClassVersion=2
    ObjName="Spawn OIR Pawn"
    ObjCategory="Pawn"
}