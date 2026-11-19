//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDWeapon_AirAttack extends HDSpecialWeapon;

var ParticleSystem					PS_SelectedZone;
var Emitter             			EM_SelectedPoint;
var transient bool                  bAttackFlag;

var(AirAttack) int                  ProjectileCount;
var(AirAttack) float                AttackOffset;
var(AirAttack) float                AttackRange;
var(AirAttack) float                DelayTime;
var(AirAttack) float                ZScale;
var transient  bool                 bDoFiring;
var transient  vector               SpawnLocation;
var transient  rotator              SpawnDirection;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    if ( EM_SelectedPoint == none )
    {
		EM_SelectedPoint = Spawn(class'TMEmitter',Self,, Location);
		EM_SelectedPoint.LifeSpan = 0;
		EM_SelectedPoint.SetOnlyOwnerSee(TRUE);
		EM_SelectedPoint.SetTemplate(PS_SelectedZone);
		EM_SelectedPoint.ParticleSystemComponent.ActivateSystem();
		EM_SelectedPoint.ParticleSystemComponent.SetActive(FALSE);
    }
}

simulated function Destroyed()
{
    if ( EM_SelectedPoint != none )
    {
        EM_SelectedPoint.Destroy();
        EM_SelectedPoint = none;
    }
    Super.Destroyed();
}

simulated function Rotator GetAdjustedAim( vector StartFireLoc )
{
    return super(TMWeapon).GetAdjustedAim(StartFireLoc);
}


simulated function TimeAirAttacking()
{
	if( !IsTimerActive('DoAirAttack') )
	{
		SetTimer( GetFireInterval(0), true, nameof(DoAirAttack) );
	}
}
simulated function DoAirAttack()
{
    if ( bDoFiring )
    {
        //DrawDebugBox( SpawnLocation, vect(50,50,50), 250, 255, 0, FALSE );
        --ProjectileCount;
        SpwanProjectileFire();
    }
}

simulated function  SpwanProjectileFire()
{
	local Projectile	SpawnedProjectile;
    local vector RandValue;
    local float SpawnRange;

    if( Role == ROLE_Authority )
    {
        SpawnRange = (ProjectileCount%7==0)? AttackRange*0.1 : AttackRange;

        // Spawn projectile
        RandValue.X = RandRange( -SpawnRange, SpawnRange);
        RandValue.Y = RandRange( -SpawnRange, SpawnRange);
        RandValue.Z = RandRange( -SpawnRange, SpawnRange) * ZScale;

        RandValue = SpawnLocation + RandValue;
    	SpawnedProjectile = Spawn(GetProjectileClass(),,, RandValue);
    	if( SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe )
    	{
    		SpawnedProjectile.Init( Vector(SpawnDirection) );
    	}
    }
}

simulated function TestFinishAttack()
{
    if ( bDoFiring )
    {
       if ( ProjectileCount <= 0 )
       {
           bDoFiring = FALSE;
      	   if (IsTimerActive('DoAirAttack'))
	       {
		      ClearTimer('DoAirAttack');
           }
       }
    }
    else
    {
        ProjectileCount = default.ProjectileCount;
    }
}

simulated event Tick( float DeltaTime )
{
	super.Tick(DeltaTime);
    SelectAttackZone();
    TestFinishAttack();
}

simulated function SendToFiringState(byte FireModeNum)
{
   if ( bDoFiring ) return;
   Super.SendToFiringState(FireModeNum);
}
simulated function SelectAttackZone();

simulated state Active
{
    simulated function SelectAttackZone()
    {
       	local vector StartTrace, EndTrace;
	    local ImpactInfo	RealImpact;
	    local vector HitLocation, HitNormal;
	    local rotator HitRotator;

	    if ( bDoFiring )
        {
            EM_SelectedPoint.ParticleSystemComponent.SetActive(FALSE);
            return;
        }

        StartTrace = InstantFireStartTrace();
    	EndTrace = InstantFireEndTrace(StartTrace);
    	RealImpact = CalcWeaponFire(StartTrace, EndTrace);
    	if ( RealImpact.HitActor != NONE )
    	{
            //DrawDebugLine( StartTrace, EndTrace, 255,0,0, FALSE );
            HitLocation = RealImpact.HitLocation;
            HitNormal = RealImpact.HitNormal;
            EM_SelectedPoint.ParticleSystemComponent.SetActive(TRUE);
            EM_SelectedPoint.SetLocation(HitLocation);
            HitRotator =  rotator(HitNormal) + rot(-16384,0,0);
            EM_SelectedPoint.SetRotation(HitRotator);
            bAttackFlag = TRUE;
        }
        else
        {
            EM_SelectedPoint.ParticleSystemComponent.SetActive(FALSE);
            bAttackFlag = FALSE;
        }

    }
}

state Inactive
{
    simulated function BeginState(name PreviousStateName)
    {
         Super.BeginState(PreviousStateName);
         EM_SelectedPoint.ParticleSystemComponent.SetActive(FALSE);
    }
}

state WeaponFiring
{
    simulated function CustomFire()
    {
        local vector FireDirection;
        if ( bAttackFlag == TRUE && bDoFiring != TRUE )
        {
            bDoFiring = TRUE;
            // calculate spawn projectile location
            SpawnLocation = Instigator.Location;
            SpawnLocation.Z += AttackOffset;
            FireDirection = EM_SelectedPoint.Location - SpawnLocation;
            SpawnDirection = rotator(FireDirection);
            SetTimer( DelayTime, false, nameof(TimeAirAttacking) );
        }
    }
}


// do not switch NV and gasmask
simulated   function bool ToggleNightVision(bool bIsNightVision);
simulated   function bool ToggleGasMask(bool bIsEquip );
simulated   function ToggleMelee();
simulated   function DrawWeaponCrosshair( Hud HUD );
/*********************************************************************************************
 * Ammunition / Inventory
 *********************************************************************************************/

/**
 * Consumes some of the ammo
 */
simulated function ConsumeAmmo( byte FireModeNum )
{
	// Subtract the Ammo
	if ( bDoFiring == FALSE && bAttackFlag == TRUE )
	{
        AddAmmoCount( -ShotCost[FireModeNum], FireModeNum );
    }
}


