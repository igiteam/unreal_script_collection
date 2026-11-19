class AdvWeap_Base extends EvilWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

enum WeaponType
{
    TYPE_Default,                   // 0
    TYPE_SMG,                       // 1
    TYPE_AutomaticPistol,           // 2
    TYPE_Pistol,                    // 3
    TYPE_Revolver,                  // 4
    TYPE_AutomaticRifle,            // 5
    TYPE_Special,                   // 6
    TYPE_HMG,                       // 7
    TYPE_Rifle,                     // 8
    TYPE_SniperRifle,               // 9
    TYPE_MAX                        // 10
};

var config bool bPurchasedWeaponDLC;
var bool bTrailsEnabled;
var bool bTrailsEnabledMP;
var() config bool ActivateFlashlightInZoom;
var float TrailChance;
var float TrailChanceMP;
var const localized string WeaponUpgradeMessage;
var config int WeaponStatMP_Damage;
var config int WeaponStatMP_Firerate;
var config int WeaponStatMP_Accuracy;
var config int WeaponStatMP_Magazines;
var config int WeaponStatMP_ReloadSpeed;
var config int WeaponStatMP_RunFriendly;
var const localized array<localized string> WeaponTypeNames;
var AdvWeap_Base.WeaponType EWeaponType;
var() config Vector FlashlightBaseSpotlightOffset;
var() config Rotator FlashlightBaseSpotlightRotOffset;
var() config Vector FlashlightAimingSpotlightOffset;
var() config Rotator FlashlightAimingSpotlightRotOffset;

simulated function EvilProcessInstantHit(byte FiringMode, ImpactInfo Impact, float BulletPower)
{
    local AdvPlayerControllerMP C;
    local editinline ParticleSystemComponent SmokeProj;

    super.EvilProcessInstantHit(FiringMode, Impact, BulletPower);
    // End:0x29C
    if(WorldInfo.GRI.IsMultiplayerGame())
    {
        // End:0x299
        if(bTrailsEnabledMP && FRand() < TrailChanceMP)
        {
            // End:0x178
            if(NotEqual_InterfaceInterface(EvilPlayer_interface(Instigator), EvilPlayer_interface(none)))
            {
                // End:0x175
                if((int(WorldInfo.NetMode) != int(NM_Client)) && SmokeTracePS != none)
                {
                    // End:0x174
                    foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', C)
                    {
                        C.SpawnEnemyPlayerTrail(Impact, SmokeTracePS, AdvPlayerControllerMP(AdvPlayerPawnMP(Instigator).Controller));                        
                    }                    
                }                
            }
            else
            {
                // End:0x299
                if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && SmokeTracePS != none)
                {
                    SmokeProj = WorldInfo.MyEmitterPool.SpawnEmitter(SmokeTracePS, Impact.StartTrace, Rotator(Impact.HitLocation - Impact.StartTrace));
                    SmokeProj.SetVectorParameter('SnipeEnd', Impact.HitLocation);
                }
            }
        }        
    }
    else
    {
        // End:0x3DC
        if(bTrailsEnabled && FRand() < TrailChance)
        {
            // End:0x3DC
            if((SmokeTracePS != none) && EqualEqual_InterfaceInterface(EvilPlayer_interface(Instigator), EvilPlayer_interface(none)))
            {
                SmokeProj = WorldInfo.MyEmitterPool.SpawnEmitter(SmokeTracePS, Impact.StartTrace, Rotator(Impact.HitLocation - Impact.StartTrace));
                SmokeProj.SetVectorParameter('SnipeEnd', Impact.HitLocation);
            }
        }
    }
    //return;    
}

function GivenTo(Pawn thisPawn, optional bool bDoNotActivate)
{
    super.GivenTo(thisPawn, bDoNotActivate);
    // End:0x89
    if(AdvPlayerControllerMP(thisPawn.Controller) != none)
    {
        AdvPlayerControllerMP(thisPawn.Controller).ReadAndInitWeaponStats(self);
    }
    //return;    
}

simulated function bool MultiplayerUpgradesEnabled()
{
    return WorldInfo.GRI.IsMultiplayerGame() && class<AdvGameSurvivalBase>(WorldInfo.GetGameClass()) == none;
    //return ReturnValue;    
}

function IncreaseKillCount()
{
    // End:0x34A
    if(MultiplayerUpgradesEnabled())
    {
        KillCount++;
        // End:0xC8
        if(AdvPlayerControllerMP(Pawn(Owner).Controller).ProfileSettings != none)
        {
            AdvPlayerControllerMP(Pawn(Owner).Controller).SaveWeaponKillCountStat(self.Class, KillCount);
        }
        switch(KillCount)
        {
            // End:0x157
            case KillsRequiredForUpgrade_Spread:
                AdvPlayerControllerMP(Pawn(Owner).Controller).SetWeaponUpgradeMessage(ItemName, Class'AdvGFxUI_Menu_MultiPlayerSettings'.default.UpgradeIconPath_Spread_On);
                // End:0x34A
                break;
            // End:0x1D3
            case KillsRequiredForUpgrade_ReloadSpeed:
                AdvPlayerControllerMP(Pawn(Owner).Controller).SetWeaponUpgradeMessage(ItemName, Class'AdvGFxUI_Menu_MultiPlayerSettings'.default.UpgradeIconPath_ReloadSpeed_On);
                // End:0x34A
                break;
            // End:0x24F
            case KillsRequiredForUpgrade_FireInterval:
                AdvPlayerControllerMP(Pawn(Owner).Controller).SetWeaponUpgradeMessage(ItemName, Class'AdvGFxUI_Menu_MultiPlayerSettings'.default.UpgradeIconPath_Firerate_On);
                // End:0x34A
                break;
            // End:0x2CB
            case KillsRequiredForUpgrade_StaminaDecrease:
                AdvPlayerControllerMP(Pawn(Owner).Controller).SetWeaponUpgradeMessage(ItemName, Class'AdvGFxUI_Menu_MultiPlayerSettings'.default.UpgradeIconPath_Stamina_On);
                // End:0x34A
                break;
            // End:0x347
            case KillsRequiredForUpgrade_BonusMagazines:
                AdvPlayerControllerMP(Pawn(Owner).Controller).SetWeaponUpgradeMessage(ItemName, Class'AdvGFxUI_Menu_MultiPlayerSettings'.default.UpgradeIconPath_Magazines_On);
                // End:0x34A
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        //return;        
    }
}

reliable server function InitializeWeaponStats(int NewKillCount)
{
    // End:0x63
    if(MultiplayerUpgradesEnabled())
    {
        KillCount = NewKillCount;
        AmmoCount = DefaultAmmoCount + (((KillCount >= KillsRequiredForUpgrade_BonusMagazines) ? UpgradeModifier_BonusMagazines : 0) * MagazineMaxAmmoCount);
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0xB5
    if(VarName == 'KillCount')
    {
        // End:0xB2
        if(AdvPlayerControllerMP(Pawn(Owner).Controller) != none)
        {
            AdvPlayerControllerMP(Pawn(Owner).Controller).SaveWeaponKillCountStat(self.Class, KillCount);
        }        
    }
    else
    {
        super.ReplicatedEvent(VarName);
    }
    //return;    
}

simulated function DrawWeaponCrosshair(HUD HUD)
{
    super.DrawWeaponCrosshair(HUD);
    //return;    
}

simulated function bool ShouldRefire()
{
    local bool bResult;
    local EvilWeap_Base Weapon, WeaponLeft;

    // End:0x271
    if(MagazineAmmoCount < ShotCost[int(CurrentFireMode)])
    {
        // End:0xA9
        if(AdvGRI(WorldInfo.GRI).IsMultiplayerGame() && !AdvGRI(WorldInfo.GRI).IsSurvivalGame())
        {
            return false;
        }
        Weapon = EvilWeap_Base(EvilPawn(Owner).Weapon);
        WeaponLeft = EvilWeap_Base(EvilPawn(Owner).WeaponLeft);
        // End:0x213
        if(Weapon == self)
        {
            // End:0x210
            if((BothHandWeapon || (Weapon.OffHandWeaponClass == WeaponLeft.Class) && WeaponLeft.MagazineAmmoCount < WeaponLeft.ShotCost[int(CurrentFireMode)]) || Weapon.OffHandWeaponClass != WeaponLeft.Class)
            {
                return false;
            }            
        }
        else
        {
            // End:0x271
            if(WeaponLeft == self)
            {
                // End:0x271
                if(Weapon.MagazineAmmoCount < Weapon.ShotCost[int(CurrentFireMode)])
                {
                    return false;
                }
            }
        }
    }
    // End:0x28A
    if(IsTimerActive('StartSprint'))
    {
        return false;
    }
    // End:0x301
    if(int(CurrentFireMode) == int(1))
    {
        // End:0x2B0
        if(IsAltInCooldown == true)
        {
            return false;
        }
        // End:0x301
        if(!IsTimerActive('AltCooldownTimer') && BlockingAltTime > float(0))
        {
            SetTimer(BlockingAltTime, false, 'AltCooldownTimer');
            IsAltInCooldown = true;
            return false;
        }
    }
    bResult = super.ShouldRefire();
    // End:0x373
    if(bResult && AdvPawn(Owner) != none)
    {
        bResult = !AdvPawn(Owner).DualWieldRefireNotify(self);
    }
    return bResult;
    //return ReturnValue;    
}

simulated function StartZoom(EvilPlayerController PC, byte FireModeNum, optional bool bZoomSyncFromOther = false)
{
    local AdvPlayerPawn PP;

    super.StartZoom(PC, FireModeNum, bZoomSyncFromOther);
    PP = AdvPlayerPawn(Instigator);
    // End:0x152
    if(((ActivateFlashlightInZoom && PP != none) && PP.MyTorch != none) && PP.MyTorch.IsEquipped())
    {
        AdvPlayerPawn(Instigator).MyTorch.ActivateFlightBeam();
        // End:0x152
        if(int(Role) < int(ROLE_Authority))
        {
            AdvPlayerPawn(Instigator).MyTorch.ClientActivateFlightBeam();
        }
    }
    //return;    
}

simulated function EndZoom(EvilPlayerController PC, optional bool bZoomSyncFromOther = false)
{
    local AdvPlayerPawn PP;

    super.EndZoom(PC, bZoomSyncFromOther);
    PP = AdvPlayerPawn(Instigator);
    // End:0x14B
    if(((ActivateFlashlightInZoom && PP != none) && PP.MyTorch != none) && PP.MyTorch.IsEquipped())
    {
        AdvPlayerPawn(Instigator).MyTorch.DeactivateFlightBeam();
        // End:0x14B
        if(int(Role) < int(ROLE_Authority))
        {
            AdvPlayerPawn(Instigator).MyTorch.ClientDeactivateFlightBeam();
        }
    }
    //return;    
}

simulated function EndZoomInstant(EvilPlayerController PC, optional bool bZoomSyncFromOther = false)
{
    local AdvPlayerPawn PP;

    EndZoom(PC, bZoomSyncFromOther);
    PP = AdvPlayerPawn(Instigator);
    // End:0x14B
    if(((ActivateFlashlightInZoom && PP != none) && PP.MyTorch != none) && PP.MyTorch.IsEquipped())
    {
        AdvPlayerPawn(Instigator).MyTorch.DeactivateFlightBeam();
        // End:0x14B
        if(int(Role) < int(ROLE_Authority))
        {
            AdvPlayerPawn(Instigator).MyTorch.ClientDeactivateFlightBeam();
        }
    }
    //return;    
}

simulated function SetWeaponMaterialLight(float WeaponMaterialLight, SkeletalMeshComponent onMesh)
{
    local int I, NumElements;
    local MaterialInstanceConstant MIC;

    // End:0xCB
    if(onMesh != none)
    {
        NumElements = onMesh.GetNumElements();
        I = 0;
        J0x43:

        // End:0xCB [Loop If]
        if(I < NumElements)
        {
            MIC = onMesh.CreateAndSetMaterialInstanceConstant(I);
            MIC.SetScalarParameterValue('LevelMultiply', WeaponMaterialLight);
            ++I;
            // [Loop Continue]
            goto J0x43;
        }
    }
    //return;    
}

function DropFrom(Vector StartLocation, Vector StartVelocity)
{
    ClientTryDetachSpotlight();
    super.DropFrom(StartLocation, StartVelocity);
    //return;    
}

reliable client simulated function ClientTryDetachSpotlight()
{
    // End:0x104
    if(((AdvPlayerPawn(Owner) != none) && AdvPlayerPawn(Owner).MyTorch != none) && AdvPlayerPawn(Owner).MyTorch.Parts.SpotLight != none)
    {
        self.DetachComponent(AdvPlayerPawn(Owner).MyTorch.Parts.SpotLight);
    }
    //return;    
}

simulated state WeaponEquipping
{
    simulated function BeginState(name PreviousStateName)
    {
        local AdvPlayerPawn P;
        local AdvMapInfo MapInfo;
        local editinline UDKSkeletalMeshComponent ArmMeshComp;

        super.BeginState(PreviousStateName);
        P = AdvPlayerPawn(Instigator);
        // End:0x378
        if(P != none)
        {
            MapInfo = AdvMapInfo(Class'Engine.WorldInfo'.static.GetWorldInfo().GetMapInfo());
            // End:0x14D
            if((MapInfo != none) && MapInfo.WeaponMaterialLight != 1.0000000)
            {
                SetWeaponMaterialLight(MapInfo.WeaponMaterialLight, SkeletalMeshComponent(Mesh));
                ArmMeshComp = GetArmMeshComponent();
                // End:0x14D
                if(ArmMeshComp != none)
                {
                    SetWeaponMaterialLight(MapInfo.WeaponMaterialLight, ArmMeshComp);
                }
            }
            // End:0x378
            if(P.MyTorch != none)
            {
                // End:0x342
                if(BothHandWeapon)
                {
                    // End:0x31E
                    if(UDKSkeletalMeshComponent(Mesh).GetSocketByName('FlashLightSocket') != none)
                    {
                        P.MyTorch.NotifyWeaponEquipping(self, true);
                        // End:0x31B
                        if(P.MyTorch.bPendingFlashlightOn)
                        {
                            // End:0x2E5
                            if(P.MyTorch.CanAttachToWeapon(self))
                            {
                                P.SetBlockingInventoryClass(P.MyTorch.Class, true);
                                P.MyTorch.AttachToWeapon(self);                                
                            }
                            else
                            {
                                P.MyTorch.bPendingFlashlightOn = false;
                            }
                        }                        
                    }
                    else
                    {
                        P.SetBlockingInventoryClass(none, true);
                    }                    
                }
                else
                {
                    P.MyTorch.NotifyWeaponEquipping(self, true);
                }
            }
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        local AdvPlayerPawn P;

        P = AdvPlayerPawn(Instigator);
        // End:0x87
        if((P != none) && P.MyTorch != none)
        {
            P.MyTorch.NotifyWeaponEquipping(self, false);
        }
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

simulated state WeaponPuttingDown
{
    simulated function BeginState(name PreviousStateName)
    {
        local AdvPlayerPawn P;

        super.BeginState(PreviousStateName);
        P = AdvPlayerPawn(Instigator);
        // End:0x9A
        if((P != none) && P.MyTorch != none)
        {
            P.MyTorch.NotifyWeaponPuttingDown(self, true);
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        local AdvPlayerPawn P;

        P = AdvPlayerPawn(Instigator);
        // End:0x87
        if((P != none) && P.MyTorch != none)
        {
            P.MyTorch.NotifyWeaponPuttingDown(self, false);
        }
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

simulated state QuickHide
{
    simulated function BeginState(name PreviousStateName)
    {
        local AdvPlayerPawn P;

        P = AdvPlayerPawn(Instigator);
        // End:0x86
        if((P != none) && P.MyTorch != none)
        {
            P.MyTorch.NotifyQuickHide(true);
        }
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated function StartFire(byte FireModeNum)
    {
        // End:0x47
        if((AdvPlayerPawn(Instigator) != none) && AdvPlayerPawn(Instigator).WaitingForDualReload)
        {
            return;
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        local AdvPlayerPawn P;

        P = AdvPlayerPawn(Instigator);
        // End:0x86
        if((P != none) && P.MyTorch != none)
        {
            P.MyTorch.NotifyQuickHide(false);
        }
        super(Frozen).EndState(NextStateName);
        //return;        
    }
    stop;    
}

defaultproperties
{
    bPurchasedWeaponDLC=true
    bTrailsEnabled=true
    TrailChance=1.0000000
    TrailChanceMP=0.1500000
    WeaponUpgradeMessage="`w upgraded!"
    WeaponStatMP_Damage=5
    WeaponStatMP_Firerate=5
    WeaponStatMP_Accuracy=5
    WeaponStatMP_Magazines=5
    WeaponStatMP_ReloadSpeed=5
    WeaponStatMP_RunFriendly=5
    WeaponTypeNames[0]="Default"
    WeaponTypeNames[1]="SMG"
    WeaponTypeNames[2]="Automatic Pistol"
    WeaponTypeNames[3]="Pistol"
    WeaponTypeNames[4]="Revolver"
    WeaponTypeNames[5]="Automatic Rifle"
    WeaponTypeNames[6]="Special"
    WeaponTypeNames[7]="HMG"
    WeaponTypeNames[8]="Rifle"
    WeaponTypeNames[9]="Sniper Rifle"
    HeadDamageMultiplier=3.0000000
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    CrosshairScaling=0.2000000
    Crosshair=(UpTex=Texture2D'UI_AdvHUD.crosshair_up',UpCord=(UL=128.0000000,VL=128.0000000),DownTex=Texture2D'UI_AdvHUD.crosshair_down',DownCord=(UL=128.0000000,VL=128.0000000),LeftTex=Texture2D'UI_AdvHUD.crosshair_left',LeftCord=(UL=128.0000000,VL=128.0000000),RightTex=Texture2D'UI_AdvHUD.crosshair_right',RightCord=(UL=128.0000000,VL=128.0000000),DotTex=Texture2D'UI_AdvHUD.crosshair_center',DotCord=(UL=128.0000000,VL=128.0000000))
    // Reference: AudioComponent'Default__AdvWeap_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    SmokeTracePS=ParticleSystem'ps_wp_MuzzleBase.Effects.ps_Smokefromtrace'
    UpgradeModifier_Spread=0.8000000
    UpgradeModifier_ReloadSpeed=0.7500000
    UpgradeModifier_FireInterval=0.8500000
    UpgradeModifier_StaminaDecreaseRate=0.7000000
    UpgradeModifier_BonusMagazines=2
    KillsRequiredForUpgrade_Spread=300
    KillsRequiredForUpgrade_ReloadSpeed=100
    KillsRequiredForUpgrade_FireInterval=500
    KillsRequiredForUpgrade_StaminaDecrease=200
    KillsRequiredForUpgrade_BonusMagazines=400
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    // Reference: SkeletalMeshComponent'Default__AdvWeap_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}