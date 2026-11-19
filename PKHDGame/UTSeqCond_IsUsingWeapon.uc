class UTSeqCond_IsUsingWeapon extends SequenceCondition
    forcescriptorder(true)
    hidecategories(Object);

var Actor Target;
var() class<Weapon> RequiredWeapon;
var() bool bAllowSubclass;
var() bool bMustBeImpactHammer;

event Activated()
{
    local Pawn P;
    local bool bHasItem;

    P = GetPawn(Target);
    // End:0x134
    if(P != none)
    {
        // End:0x103
        if(P.Weapon != none)
        {
            // End:0x6C
            if(bMustBeImpactHammer)
            {
                bHasItem = false;                
            }
            else
            {
                bHasItem = ((bAllowSubclass) ? ClassIsChildOf(P.Weapon.Class, RequiredWeapon) : P.Weapon.Class == RequiredWeapon);
            }
        }
        OutputLinks[((bHasItem) ? 0 : 1)].bHasImpulse = true;
    }
    //return;    
}

defaultproperties
{
    OutputLinks[0]=(Links=none,LinkDesc="Using It",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[1]=(Links=none,LinkDesc="Not Using It",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Target",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Is Using Weapon"
}