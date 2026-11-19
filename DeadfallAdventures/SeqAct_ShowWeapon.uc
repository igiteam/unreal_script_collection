class SeqAct_ShowWeapon extends SeqAct_Latent
    forcescriptorder(true)
    hidecategories(Object);

var EvilWeap_Base Weapon;
var EvilWeap_Base WeaponLeft;
var transient float ElapsedTime;

event Activated()
{
    local SeqVar_Object ObjVar;
    local EvilPawn P;
    local EvilWeap_Base savedLeft;

    // End:0x3DE
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
        // End:0x3DD
        if(P != none)
        {
            savedLeft = EvilWeap_Base(P.FindInventoryType(P.SavedWeaponLeft));
            // End:0x244
            if(AdvPlayerController(P.Controller).isInventory(savedLeft))
            {
                P.SetBlockingInventoryClass(P.SavedWeaponLeft, true);
                // End:0x244
                if(P.SavedWeapon == none)
                {
                    P.SetCurrentWeaponLeftClass(P.SavedWeaponLeft, false);
                    P.SavedWeaponLeft = none;
                }
            }
            // End:0x2C9
            if(P.SavedWeapon != none)
            {
                P.SetCurrentWeaponClass(P.SavedWeapon, false);
                P.SavedWeapon = none;                
            }
            else
            {
                // End:0x32D
                if(P.HandsClass != none)
                {
                    P.SavedWeapon = P.HandsClass;                    
                }
            }
            Weapon = ((P.Weapon != none) ? EvilWeap_Base(P.Weapon) : none);
            WeaponLeft = ((P.WeaponLeft != none) ? EvilWeap_Base(P.WeaponLeft) : none);
        }        
    }    
    //return;    
}

event bool Update(float DeltaTime)
{
    ElapsedTime += DeltaTime;
    // End:0x4A
    if(ElapsedTime >= 0.5000000)
    {
        OutputLinks[0].bHasImpulse = true;
        return false;
    }
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Show Weapon"
}