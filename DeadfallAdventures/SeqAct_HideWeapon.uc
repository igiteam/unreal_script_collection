class SeqAct_HideWeapon extends SeqAct_Latent
    forcescriptorder(true)
    hidecategories(Object);

var EvilWeap_Base Weapon;
var EvilWeap_Base WeaponLeft;

event Activated()
{
    local SeqVar_Object ObjVar;
    local EvilPawn P;

    // End:0x35B
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
        // End:0x35A
        if(P != none)
        {
            P.SetSprint(false);
            AdvPlayerController(P.GetALocalPlayerController()).ToggleQuickMenu();
            P.SavedWeapon = ((P.Weapon != none) ? class<EvilWeap_Base>(P.Weapon.Class) : none);
            P.SavedWeaponLeft = ((P.WeaponLeft != none) ? class<EvilWeap_Base>(P.WeaponLeft.Class) : none);
            Weapon = ((P.Weapon != none) ? EvilWeap_Base(P.Weapon) : none);
            WeaponLeft = ((P.WeaponLeft != none) ? EvilWeap_Base(P.WeaponLeft) : none);
            // End:0x32C
            if(Weapon != none)
            {
                Weapon.PutDownWeapon();
            }
            // End:0x35A
            if(WeaponLeft != none)
            {
                WeaponLeft.PutDownWeapon();
            }
        }        
    }    
    //return;    
}

event bool Update(float DeltaTime)
{
    // End:0x6D
    if(!Weapon.IsPuttingDown() && !WeaponLeft.IsPuttingDown())
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
    ObjName="Hide Weapon"
}