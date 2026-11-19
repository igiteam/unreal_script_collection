class SkyVWeap extends SkyVehicleWeapon
    native
    config(Game);

var(EffectsV) ParticleSystem MuzzleFlash;
var export editinline transient SkyParticleSystemComponent VehicleMuzzleFlashEffect;
var(AI) float BotWeaponUseRange;
var(AI) float BotWeaponUseMinRange;
var(Projectiles) SkyProjectile ProjectileArchetype;
var(Weapon) bool bIsPrimaryWeapon;
var(AutoAim) bool AutoAimToAllies;
var(AutoAim) bool AutoAimToTurrets;
var bool bShouldRefire;
var(Weapon) bool DetonateProjectileOnSecondFireAttempt;
var(Flash) float FlashRearModifier;
var(Flash) float FlashPeripheralModifier;
var(Flash) float FlashNPCModifier;
var(Flash) float FlashPlayerModifier;
var(Flash) float FlashRearAngle;
var(Flash) float FlashSideAngle;
var deprecated float AutoAimAngle;
var(AutoAim) float AutoAimDistanceToReticle;
var(AutoAim) float AutoAimDistanceToReticleEasy;
var(AutoAim) float AutoAimDistanceToReticleHard;
var(AutoAim) float AutoAimDistanceToReticleZoomed;
var(AutoAim) float AutoAimDistanceToReticleEasyZoomed;
var(AutoAim) float AutoAimDistanceToReticleHardZoomed;
var(AutoAim) float AutoAimMaxRange;
var(AutoAim) float AutoAimMinRange;
var(Weapon) float SpreadYaw;
var(Weapon) float SpreadPitch;
var deprecated array<SkyEmitter> FlashEffects;
var deprecated int NextFlashEffect;
var deprecated int PreAllocateMuzzleFlashCount;
var SkyProjectile StoredProjectileToDetonate;
var transient array<bool> AnimFireFlag;
var transient array<bool> AnimFireFlagChecked;
var transient array<bool> bRecoilInProgress;
var transient array<AnimNodeSequence> LastRecoilSeq;
var(Performance) int NumberOfShotsBetweenImpactEffectsPlayer;
var(Performance) int NumberOfShotsBetweenImpactEffectsBot;
var transient int ShotsBetweenThisImpactEffect;

// Export USkyVWeap::execFireAmmunition(FFrame&, void* const)
native simulated function FireAmmunition();

simulated function float MaxRange()
{
    // End:0x14
    if(bInstantHit)
    {
        return GetTraceRange();
    }
    return 50000.0000000;
    //return ReturnValue;    
}

// Export USkyVWeap::execCreateProjectile(FFrame&, void* const)
native simulated function Projectile CreateProjectile(class<Projectile> SpawnClass, optional Actor SpawnOwner, optional name SpawnTag, optional Vector SpawnLocation, optional Rotator SpawnRotation, optional Actor ActorTemplate, optional bool bNoCollisionFail);

// Export USkyVWeap::execProjectileFire(FFrame&, void* const)
native simulated function Projectile ProjectileFire();

// Export USkyVWeap::execAddSpread(FFrame&, void* const)
native simulated function Rotator AddSpread(Rotator BaseAim);

// Export USkyVWeap::execGenerateParametricSpread(FFrame&, void* const)
native function Rotator GenerateParametricSpread(Rotator BaseAim, float YawParam, float PitchParam);

// Export USkyVWeap::execDrawWeaponCrosshair(FFrame&, void* const)
native function DrawWeaponCrosshair(HUD HUD);

// Export USkyVWeap::execStopVehicleMuzzleFlash(FFrame&, void* const)
native function StopVehicleMuzzleFlash();

// Export USkyVWeap::execSetUpMuzzleFlash(FFrame&, void* const)
native function SetUpMuzzleFlash();

simulated event StopFire(byte FireModeNum)
{
    StopVehicleMuzzleFlash();
    super(SkyWeaponBase).StopFire(FireModeNum);
    //return;    
}

simulated function DrawAmmoCount(HUD H)
{
    local SkyHUD SH;
    local SkyAirVehicle skyAirVeh;
    local WeaponHUDParam WHP;
    local Texture2D texDisplay;

    skyAirVeh = SkyAirVehicle(MyVehicle);
    // End:0x39
    if((skyAirVeh != none) && int(skyAirVeh.AirVehicleState) != int(3))
    {
        return;
    }
    SH = SkyHUD(H);
    // End:0x10F
    if((SH != none) && SH.HideHUDRefCount == 0)
    {
        // End:0xA7
        if(SH.GetWeaponParam(WeaponName, WHP))
        {
            texDisplay = Texture2D(WHP.DisplayTexture);
        }
        // End:0xE1
        if(bIsPrimaryWeapon)
        {
            SH.DrawPrimary(texDisplay, GetAmmoCount(), -1, bInfiniteAmmo);            
        }
        else
        {
            SH.DrawSecondary(texDisplay, GetAmmoCount(), -1, bInfiniteAmmo);
        }
    }
    //return;    
}

// Export USkyVWeap::execConsumeAmmo(FFrame&, void* const)
native function ConsumeAmmo(byte FireModeNum);

simulated function bool UseSkyFireModes()
{
    return false;
    //return ReturnValue;    
}

simulated function bool PendingFire(int FireMode)
{
    // End:0x18
    if(bIsPrimaryWeapon)
    {
        return super(Weapon).PendingFire(FireMode);        
    }
    else
    {
        // End:0x3F
        if(SkyVehicleInventoryManager(InvManager) != none)
        {
            return bool(SkyVehicleInventoryManager(InvManager).PendingSecondaryFire);
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function SetPendingFire(int FireMode)
{
    // End:0x17
    if(bIsPrimaryWeapon)
    {
        super(Weapon).SetPendingFire(FireMode);        
    }
    else
    {
        // End:0x3D
        if(SkyVehicleInventoryManager(InvManager) != none)
        {
            SkyVehicleInventoryManager(InvManager).PendingSecondaryFire = 1;
        }
    }
    //return;    
}

simulated function ClearPendingFire(int FireMode)
{
    // End:0x17
    if(bIsPrimaryWeapon)
    {
        super(Weapon).ClearPendingFire(FireMode);        
    }
    else
    {
        // End:0x3D
        if(SkyVehicleInventoryManager(InvManager) != none)
        {
            SkyVehicleInventoryManager(InvManager).PendingSecondaryFire = 0;
        }
    }
    //return;    
}

simulated function FlashRadius(Actor FlashDevice, float FlashLength, float FlashMinRadius, float FlashMaxRadius, optional bool bFlashUsesLOS)
{
    local Vector vecttobang, viewloc;
    local Rotator ViewRot;
    local float disttobang, ourflashlength, dotofeyes;
    local Controller OtherController;

    // End:0x21F
    foreach WorldInfo.AllControllers(Class'Engine.Controller', OtherController)
    {
        // End:0x21E
        if(OtherController.Pawn != none)
        {
            // End:0x9B
            if(OtherController.Pawn == FlashDevice)
            {
                vecttobang = FlashDevice.Location - SkyVehicle(OtherController.Pawn).Seats[0].StoragePawn.Location;                
            }
            else
            {
                vecttobang = FlashDevice.Location - OtherController.Pawn.Location;
            }
            disttobang = VSize(vecttobang);
            // End:0x21E
            if((disttobang < FlashMaxRadius) && OtherController.LineOfSightTo(FlashDevice))
            {
                // End:0x11D
                if(disttobang <= FlashMinRadius)
                {
                    ourflashlength = FlashLength;                    
                }
                else
                {
                    ourflashlength = FlashLength * (1.0000000 - ((disttobang - FlashMinRadius) / (FlashMaxRadius - FlashMinRadius)));
                    // End:0x1C1
                    if(bFlashUsesLOS)
                    {
                        OtherController.GetPlayerViewPoint(viewloc, ViewRot);
                        dotofeyes = Normal(vecttobang) Dot Vector(ViewRot);
                        // End:0x1A6
                        if(dotofeyes <= FlashRearAngle)
                        {
                            ourflashlength *= FlashRearModifier;                            
                        }
                        else
                        {
                            // End:0x1C1
                            if(dotofeyes < FlashSideAngle)
                            {
                                ourflashlength *= FlashPeripheralModifier;
                            }
                        }
                    }
                }
                // End:0x1F9
                if(SkyPlayerController(OtherController) != none)
                {
                    SkyPlayerController(OtherController).ApplyFlash(ourflashlength * FlashPlayerModifier);
                    // End:0x21E
                    continue;
                }
                SkyBotControllerBase(OtherController).ApplyFlash(ourflashlength * FlashNPCModifier);
            }
        }        
    }    
    //return;    
}

simulated function bool ShouldRefire()
{
    local SkyBotControllerPilot pBot;

    pBot = SkyBotControllerPilot(SkyVehicle(Owner).Controller);
    // End:0x71
    if(pBot != none)
    {
        // End:0x6F
        if(pBot.Enemy != none)
        {
            // End:0x6F
            if(pBot.CanAttack(pBot.Enemy) == true)
            {
                return super(SkyWeaponBase).ShouldRefire();
            }
        }
        return false;
    }
    return super(SkyWeaponBase).ShouldRefire();
    //return ReturnValue;    
}

simulated event ParticleSystemComponent CauseEffect(name Socket, ParticleSystem PSCTemplate, ParticleSystemComponent PSC, bool bLoops)
{
    local editinline SkeletalMeshComponent SKMesh;
    local SkyVehicle MySkyVehicle;

    MySkyVehicle = SkyVehicle(MyVehicle);
    // End:0x48
    if((MySkyVehicle != none) && MySkyVehicle.bIsFirstPersonVehicle)
    {
        SKMesh = MySkyVehicle.FirstPersonMesh;        
    }
    else
    {
        SKMesh = MyVehicle.Mesh;
    }
    // End:0x124
    if((SKMesh != none) && Socket != 'None')
    {
        // End:0x124
        if(PSCTemplate != none)
        {
            // End:0xBE
            if(PSC == none)
            {
                PSC = new (Outer) Class'SkyParticleSystemComponent';
                SkyParticleSystemComponent(PSC).bSkyPoolActive = true;
            }
            PSC.bPersistDynamicLight = true;
            SKMesh.AttachComponentToSocket(PSC, Socket);
            PSC.DynamicLightSKMesh = SKMesh;
            PSC.DynamicLightSocket = Socket;
            PSC.DeactivateSystem();
        }
    }
    // End:0x18C
    if(PSC != none)
    {
        // End:0x18C
        if(PSC.bWasDeactivated || !bLoops)
        {
            SkyParticleSystemComponent(PSC).bSkyPoolActive = true;
            PSC.SetTemplate(PSCTemplate);
            PSC.ActivateSystem();
        }
    }
    return PSC;
    //return ReturnValue;    
}

simulated function BeginFire(byte FireModeNum)
{
    ShotsBetweenThisImpactEffect = 0;
    super.BeginFire(FireModeNum);
    //return;    
}

auto state Inactive
{
    reliable server function ServerStartFire(byte FireModeNum)
    {
        // End:0x59
        if((SkyVehicle(Instigator) != none) && SkyVehicle(Instigator).SkySeats[0].SecondaryGun == self)
        {
            GotoState('Active');
            global.ServerStartFire(FireModeNum);            
        }
        else
        {
            // End:0x99
            if((SkyVehicleInventoryManager(InvManager) != none) && SkyVehicleInventoryManager(InvManager).PendingSecondaryWeapon == self)
            {
                SetPendingFire(int(FireModeNum));                
            }
            else
            {
                super.ServerStartFire(FireModeNum);
            }
        }
        //return;        
    }
    stop;    
}

simulated state WeaponFiring
{
    simulated function BeginState(name PreviousStateName)
    {
        // End:0x1E
        if(IsOverheated())
        {
            GotoState('Active');            
        }
        else
        {
            super.BeginState(PreviousStateName);
        }
        //return;        
    }

    simulated function RefireCheckTimer()
    {
        // End:0x15
        if(bWeaponPutDown)
        {
            PutDownWeapon();
            return;
        }
        // End:0x58
        if(ShouldRefire())
        {
            // End:0x4C
            if(SkyPlayerController(SkyVehicle(Owner).Controller) != none)
            {
                bShouldRefire = true;                
            }
            else
            {
                FireAmmunition();
            }
            return;
        }
        HandleFinishedFiring();
        //return;        
    }
    stop;    
}
