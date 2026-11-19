class SeqAct_GetAmmoCount extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() class<EvilWeap_Base> WeapClass;
var int AmmoReturned;

event Activated()
{
    local SeqVar_Object ObjVar;
    local EvilPawn P;
    local EvilWeap_Base Weap;

    // End:0x19E
    if(InputLinks[0].bHasImpulse)
    {
        // End:0x192
        foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Players")
        {
            // End:0xCB
            if(EvilPlayerController(ObjVar.GetObjectValue()) != none)
            {
                P = EvilPawn(EvilPlayerController(ObjVar.GetObjectValue()).Pawn);                
            }
            else
            {
                P = EvilPawn(ObjVar.GetObjectValue());
            }
            // End:0x191
            if(P != none)
            {
                Weap = EvilWeap_Base(P.FindInventoryType(WeapClass, true));
                // End:0x182
                if(Weap != none)
                {
                    AmmoReturned = Weap.AmmoCount;
                    // End:0x191
                    continue;
                }
                AmmoReturned = -1;
            }            
        }        
        ActivateOutputLink(0);
    }
    //return;    
}

defaultproperties
{
    bAutoActivateOutputLinks=false
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Ammo",LinkVar="None",PropertyName="AmmoReturned",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Get Ammo Count"
}