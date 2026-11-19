class UTSeqAct_SpawnProjectile extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() class<Projectile> ProjectileClass;

event Activated()
{
    local Controller InstigatorController;
    local Pawn InstigatorPawn;
    local Vector SpawnLoc, TargetLoc;
    local Projectile Proj;

    // End:0xBF
    if((((VariableLinks.Length < 3) || VariableLinks[0].LinkedVariables.Length == 0) || VariableLinks[1].LinkedVariables.Length == 0) || VariableLinks[2].LinkedVariables.Length == 0)
    {
        ScriptLog("ERROR: All variable links must be filled");        
    }
    else
    {
        // End:0x28D
        if(VariableLinks[2].LinkedVariables.Length > 0)
        {
            InstigatorController = Controller(SeqVar_Object(VariableLinks[2].LinkedVariables[0]).GetObjectValue());
            // End:0x172
            if(InstigatorController != none)
            {
                InstigatorPawn = InstigatorController.Pawn;                
            }
            else
            {
                InstigatorPawn = Pawn(SeqVar_Object(VariableLinks[2].LinkedVariables[0]).GetObjectValue());
                // End:0x1FF
                if(InstigatorPawn != none)
                {
                    InstigatorController = InstigatorPawn.Controller;                    
                }
                else
                {
                    // End:0x28D
                    if(SeqVar_Object(VariableLinks[2].LinkedVariables[0]).GetObjectValue() != none)
                    {
                        ScriptLog(("ERROR: Instigator specified for" @ string(self)) @ "is not a Controller");
                    }
                }
            }
        }
        SpawnLoc = SeqVar_Vector(VariableLinks[0].LinkedVariables[0]).VectValue;
        TargetLoc = SeqVar_Vector(VariableLinks[1].LinkedVariables[0]).VectValue;
        Proj = GetWorldInfo().Spawn(ProjectileClass,,, SpawnLoc);
        // End:0x3BD
        if(InstigatorController != none)
        {
            Proj.Instigator = InstigatorPawn;
            Proj.InstigatorController = InstigatorController;
        }
        Proj.Init(Normal(TargetLoc - SpawnLoc));
    }
    //return;    
}

defaultproperties
{
    bCallHandler=false
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Vector',LinkedVariables=none,LinkDesc="Spawn Location",LinkVar="None",PropertyName="Targets",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Vector',LinkedVariables=none,LinkDesc="Target Location",LinkVar="None",PropertyName="None",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Instigator",LinkVar="None",PropertyName="None",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Spawn Projectile"
}