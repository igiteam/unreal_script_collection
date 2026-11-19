class SeqAct_TeleportOthersToMe extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var EvilPawn Me;
var array<EvilSpawnPoint> TeleportPoints;

event Activated()
{
    local int iTIdx;
    local EvilPlayerController PC;

    iTIdx = 0;
    // End:0xD8
    foreach Me.WorldInfo.AllControllers(Class'EvilPlayerController', PC)
    {
        // End:0xD7
        if(Me != PC.Pawn)
        {
            PC.Pawn.SetLocation(TeleportPoints[iTIdx++].Location);
        }        
    }    
    //return;    
}

static event int GetObjClassVersion()
{
    return super(SequenceObject).GetObjClassVersion() + 2;
    //return ReturnValue;    
}

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Me",LinkVar="None",PropertyName="Me",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Teleport Points",LinkVar="None",PropertyName="TeleportPoints",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Teleport Others"
}