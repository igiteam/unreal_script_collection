class EALADemoCharge extends EALAWeapon
    abstract
    config(Weapon)
    hidecategories(Navigation);

var float PutDownTimePrimed;
var float PrimeInterval;
var MOHAProj_Explosive explosive;
var() config float ExplosiveDrawScale;
var() config float FuseTime;
var() config Vector vDemoChargeOffsetFromPlayerRoot_AS;

function bool CanPlaceDemoCharge()
{
    return true;
    //return ReturnValue;    
}

simulated function ConsumeAmmo(byte FireModeNum)
{
    //return;    
}

simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact)
{
    local Vector vDemoChargePos;
    local Rotator rDemoChargeRot;

    Mesh.SetHidden(true);
    // End:0x6E
    if(!GetDemoChargePosAndRot(vDemoChargePos, rDemoChargeRot))
    {
        vDemoChargePos = ((Impact.HitActor != none) ? Impact.HitActor.Location : Location);
        rDemoChargeRot = Rotation;
    }
    explosive = MOHAProj_Explosive(SpawnProjectile(vDemoChargePos, Vector(rDemoChargeRot)));
    Impact.HitActor.TriggerEventClass(Class'SeqEvent_DemoChargePlaced', none);
    explosive.SetDrawScale(ExplosiveDrawScale);
    explosive.SetTimer(FuseTime);
    //return;    
}

function bool GetDemoChargePosAndRot(out Vector vDemoChargePos, out Rotator vDemoChargeRot)
{
    // End:0x33
    if(MOHAPlayerPawn(Instigator) != none)
    {
        return MOHAPlayerPawn(Instigator).GetDemoChargePosAndRot(vDemoChargePos, vDemoChargeRot);
    }
    return false;
    //return ReturnValue;    
}

function Vector GetDemoChargeOffsetFromPlayerRoot()
{
    return vDemoChargeOffsetFromPlayerRoot_AS;
    //return ReturnValue;    
}

simulated state WeaponFiring
{
    simulated function RefireCheckTimer()
    {
        PutDownWeapon();
        return;
        //return;        
    }
    stop;    
}

simulated state WeaponPuttingDown
{
    simulated function BeginState(name PreviousStateName)
    {
        // End:0xC0
        if((Instigator != none) && Instigator.IsA('MOHAPlayerPawn'))
        {
            // End:0x94
            if(MOHAPlayerPawn(Instigator).IsDemoCharging() && MOHAPlayerController(Instigator.Controller).DemoChargeTimeDone())
            {
                MOHAPlayerPawn(Instigator).Weapon_LowerPrimedDemoCharge();
                SetTimer(PutDownTimePrimed, false, 'WeaponIsDown');                
            }
            else
            {
                MOHAPlayerPawn(Instigator).Weapon_LowerWeaponEvent();
                SetTimer(PutDownTime, false, 'WeaponIsDown');
            }
        }
        bWeaponPutDown = false;
        ForceEndFire();
        //return;        
    }

    function bool CanPlaceDemoCharge()
    {
        return false;
        //return ReturnValue;        
    }
    stop;    
}

simulated state WeaponEquipping
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        Mesh.SetHidden(false);
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        // End:0x54
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).Player_PlaceDemoCharge();
            PlayWeaponAnimation('compb_gun_prime', PrimeInterval);
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    PutDownTimePrimed=1.0000000
    PrimeInterval=2.7330000
    ExplosiveDrawScale=2.0000000
    FuseTime=4.0000000
    vDemoChargeOffsetFromPlayerRoot_AS=(X=61.1450000,Y=20.1240000,Z=158.8290000)
    AmmoCount=10
    bCanIronsight=false
    PickupMinAmmo=1
    WeaponEquipAnim="compb_gun_idle"
    WeaponFireTypes=/* Array type was not detected. */
    FiringStatesArray=/* Array type was not detected. */
    FireInterval=/* Array type was not detected. */
    EquipTime=1.0000000
    // Reference: MOHASkeletalMeshComponent'Default__EALADemoCharge.PickupMesh'
    begin object name=PickupMesh
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
}