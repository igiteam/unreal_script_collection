class SeqAct_RemoveItemFromHUD extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() AdvTypes.EAdvItemType ItemType;
var() int ItemCount;

event Activated()
{
    local SeqVar_Object ObjVar;
    local EvilPawn P;

    // End:0x14F
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Players")
    {
        // End:0xA9
        if(EvilPlayerController(ObjVar.GetObjectValue()) != none)
        {
            P = EvilPawn(EvilPlayerController(ObjVar.GetObjectValue()).Pawn);            
        }
        else
        {
            P = EvilPawn(ObjVar.GetObjectValue());
        }
        // End:0x14E
        if(P != none)
        {
            AdvPRI(P.Controller.PlayerReplicationInfo).RemoveItem(ItemType, ItemCount);
        }        
    }    
    //return;    
}

defaultproperties
{
    ItemCount=1
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Remove Item From HUD"
}