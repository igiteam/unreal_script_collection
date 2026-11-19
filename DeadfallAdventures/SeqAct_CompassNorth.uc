class SeqAct_CompassNorth extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() Vector2D NorthDirection;

event Activated()
{
    local AdvInventoryItem_Compass Compass;
    local SeqVar_Object ObjVar;
    local EvilPawn P;

    // End:0x248
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
        // End:0x247
        if(P != none)
        {
            Compass = AdvInventoryItem_Compass(P.FindInventoryType(Class'AdvInventoryItem_Compass'));
            // End:0x247
            if(Compass != none)
            {
                Compass.NorthVector.X = NorthDirection.X;
                Compass.NorthVector.Y = NorthDirection.Y;
                Compass.NorthVector.Z = 0.0000000;
                Compass.NorthVector = Normal(Compass.NorthVector);
            }
        }        
    }    
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    bAutoActivateOutputLinks=false
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Compass Set North"
}