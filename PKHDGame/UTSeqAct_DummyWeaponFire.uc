class UTSeqAct_DummyWeaponFire extends SeqAct_Latent
    forcescriptorder(true)
    hidecategories(Object);

var UTDummyPawn DummyPawn;
var() int ShotsToFire;
var() class<EvilWeap_Base> WeaponClass;
var() byte FireMode;
var() Actor Origin;
var() Actor Target;
var() Rotator MaxSpread;
var() bool bSuppressSounds;
var int ShotsFired;

event Activated()
{
    local EvilWeap_Base NewWeapon;

    // End:0x372
    if(InputLinks[0].bHasImpulse)
    {
        // End:0x6B
        if(WeaponClass == none)
        {
            ScriptLog("Error: DummyWeaponFire with no WeaponClass");            
        }
        else
        {
            // End:0xAF
            if(Origin == none)
            {
                ScriptLog("Error: DummyWeaponFire with no Origin");                
            }
            else
            {
                // End:0xF3
                if(Target == none)
                {
                    ScriptLog("Error: DummyWeaponFire with no Target");                    
                }
                else
                {
                    ShotsFired = 0;
                    // End:0x304
                    if((DummyPawn == none) || DummyPawn.bDeleteMe)
                    {
                        DummyPawn = Origin.Spawn(Class'UTDummyPawn');
                        // End:0x1AA
                        if(DummyPawn == none)
                        {
                            ScriptLog("Error: Failed to spawn dummy actor");                            
                        }
                        else
                        {
                            DummyPawn.FireAction = self;
                            NewWeapon = DummyPawn.Spawn(WeaponClass, DummyPawn);
                            NewWeapon.bAllowFiringWithoutController = true;
                            NewWeapon.bSuppressSounds = bSuppressSounds;
                            NewWeapon.GiveTo(DummyPawn);
                            DummyPawn.InvManager.SetCurrentWeapon(NewWeapon);
                            DummyPawn.WeaponAttachmentChanged();
                            DummyPawn.StartFire(FireMode);
                        }                        
                    }
                    else
                    {
                        DummyPawn.StopWeaponFiring();
                        DummyPawn.StartFire(FireMode);
                        DummyPawn.LifeSpan = 0.0000000;
                    }
                }
            }
        }        
    }
    else
    {
        // End:0x3E6
        if(DummyPawn != none)
        {
            DummyPawn.StopWeaponFiring();
            DummyPawn.LifeSpan = 1.0000000;
            OutputLinks[2].bHasImpulse = true;
        }
    }
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

function NotifyDummyFire()
{
    ShotsFired++;
    // End:0x97
    if((ShotsToFire > 0) && ShotsFired >= ShotsToFire)
    {
        DummyPawn.StopWeaponFiring();
        DummyPawn.LifeSpan = 1.0000000;
        OutputLinks[1].bHasImpulse = true;
    }
    //return;    
}

event bool Update(float DeltaTime)
{
    return (DummyPawn != none) && DummyPawn.LifeSpan ~= 0.0000000;
    //return ReturnValue;    
}

defaultproperties
{
    ShotsToFire=1
    bCallHandler=false
    bAutoActivateOutputLinks=false
    InputLinks[0]=(LinkDesc="Start Firing",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Stop Firing",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    OutputLinks[0]=(Links=none,LinkDesc="Out",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[1]=(Links=none,LinkDesc="Finished",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[2]=(Links=none,LinkDesc="Stopped",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Origin",LinkVar="None",PropertyName="Origin",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Target",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Dummy Weapon Fire"
}