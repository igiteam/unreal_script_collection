class EvilTouchPickUp_WeaponBase extends EvilUsePickUp_Base
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord
{
    var string WeaponClassPath;
    var int MaxPickCount;
    var bool bHidden;
    var Vector Location;
    var Rotator Rotation;
    var string SavedBase;
    var bool bDynamicallySpawned;

    structdefaultproperties
    {
        WeaponClassPath=""
        MaxPickCount=0
        bHidden=false
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(Pitch=0,Yaw=0,Roll=0)
        SavedBase=""
        bDynamicallySpawned=false
    }
};

var(Pickup) class<EvilWeap_Base> WeaponClass;
var(Pickup) array<int> AmmoAmount;
var float SurvivalAmmoModifier;
var(Pickup) bool ForceUseAndText;
var bool bClientCaptionWeaponFull;
var transient bool HACKBOOL;
var bool bDynamicallySpawned;
var(Pickup) export editinline SkeletalMeshComponent SkelPickupMesh;
var(Pickup) int Lifetime;
var repnotify PlayerReplicationInfo PickupPRI;
var PlayerReplicationInfo FlyingPickupOwner;

replication
{
    // Pos:0x000
    if((int(Role) == int(ROLE_Authority)) && bNetDirty
        PickupPRI, bClientCaptionWeaponFull;
}

simulated event ReplicatedEvent(name VarName)
{
    switch(VarName)
    {
        // End:0x5F
        case 'PickupPRI':
            // End:0x3B
            if(PickupPRI != none)
            {
                SetCaptionTextOnClinet();                
            }
            else
            {
                CaptionComponent.SetCaptionCustom("");
            }
            // End:0x78
            break;
        // End:0xFFFF
        default:
            super(EvilTouchPickUp_Base).ReplicatedEvent(VarName);
            // End:0x78
            break;
            break;
    }
    //return;    
}

simulated function PostBeginPlay()
{
    local int Idx;
    local string ClassName;
    local EvilMapInfo MapInfo;

    super.PostBeginPlay();
    Idx = 0;
    J0x15:

    // End:0x76 [Loop If]
    if(Idx < Materials.Length)
    {
        SkelPickupMesh.SetMaterial(Idx, Materials[Idx]);
        ++Idx;
        // [Loop Continue]
        goto J0x15;
    }
    MapInfo = EvilMapInfo(Class'Engine.WorldInfo'.static.GetWorldInfo().GetMapInfo());
    // End:0x11F
    if((MapInfo != none) && MapInfo.WeaponMaterialLight_3rd != 1.0000000)
    {
        SetWeaponMaterialLight(MapInfo.WeaponMaterialLight_3rd);
    }
    // End:0x1D6
    if(CaptionComponent.CaptionText == "")
    {
        ClassName = string(WeaponClass.Name);
        // End:0x1A3
        if(Right(ClassName, 5) != "_Base")
        {
            ClassName = ClassName $ "_Base";
        }
        CaptionComponent.SetCaptionAltLoc("ItemName", ClassName);
    }
    // End:0x31D
    if((WorldInfo.GRI.IsMultiplayerGame() && !EvilGameReplicationInfo(WorldInfo.GRI).IsSurvivalGame()) && GetRightMost(string(WeaponClass.Name)) ~= "WP")
    {
        ClassName = string(WeaponClass.Name);
        ClassName = Mid(ClassName, 0, Len(ClassName) - 2) $ "MP";
        WeaponClass = class<EvilWeap_Base>(FindObject("AdvGameContent." $ ClassName, Class'Core.Class'));
    }
    // End:0x345
    if(Lifetime != 0)
    {
        SetTimer(float(Lifetime), false, 'DestroyDelayed');
    }
    //return;    
}

function Pickup(EvilPawn P)
{
    local EvilWeap_Base Weap, WeapLeft, currentWeap;
    local array<EvilWeap_Base> WeapList;
    local int I;
    local float AmountModifier;
    local array<int> AmmoAmountMod;
    local EvilInventoryManager Inv;

    Inv = EvilInventoryManager(P.InvManager);
    // End:0xC54
    if(Weapon(P.FindInventoryType(WeaponClass, true)) == none)
    {
        // End:0x5D8
        if(!WorldInfo.GRI.IsMultiplayerGame() || EvilGameReplicationInfo(WorldInfo.GRI).IsSurvivalGame())
        {
            // End:0x2F6
            if(class<EvilWeap_Melee_Base>(WeaponClass) != none)
            {
                // End:0x1C4
                if((class<EvilWeap_Melee_Base>(WeaponClass).default.bIsSwitchableAsMelee && P.MeleeWeapon != none) && P.MeleeWeapon.CanThrow())
                {
                    P.TossInventory(P.MeleeWeapon);
                }
                // End:0x2F3
                if((class<EvilWeap_Melee_Base>(WeaponClass).default.bIsSwitchableAsThrow && P.ThrowWeapon != none) && P.ThrowWeapon.CanThrow())
                {
                    // End:0x2C6
                    if(P.ThrowWeapon.HasAnyAmmo())
                    {
                        P.TossInventory(P.ThrowWeapon);                        
                    }
                    else
                    {
                        P.ThrowWeapon.Destroy();
                    }
                }                
            }
            else
            {
                Inv.GetWeaponList(WeapList, true, int(WeaponClass.default.InventoryGroup));
                // End:0x3CD
                if(WeapList.Length > 2)
                {
                    // End:0x3C9
                    foreach WeapList(currentWeap)
                    {
                        // End:0x391
                        if(currentWeap.DefaultInfiniteWeapon)
                        {
                            continue;
                            goto J0x3C9;                            
                        }
                        else
                        {
                            // End:0x3C8
                            if(!currentWeap.UsesOffhand)
                            {
                                Weap = currentWeap;
                            }
                        }                        
                    }
                    J0x3C9:
                                        
                }
                else
                {
                    Weap = Inv.HasWeaponWithInventoryGroup(int(WeaponClass.default.InventoryGroup));
                }
                // End:0x5D5
                if(Weap != none)
                {
                    // End:0x56A
                    if(Weap.DefaultInfiniteWeapon)
                    {
                        Weap.bSelectable = false;
                        Weap.TryPutDown();
                        WeapLeft = EvilWeap_Base(P.FindInventoryType(Weap.OffHandWeaponClass));
                        // End:0x527
                        if(WeapLeft != none)
                        {
                            WeapLeft.bSelectable = false;
                            WeapLeft.TryPutDown();
                        }
                        P.SavedWeapon = none;
                        P.SavedWeaponLeft = none;                        
                    }
                    else
                    {
                        P.bIgnoreSwitchWeapon = true;
                        P.TossInventory(Weap);
                        P.bIgnoreSwitchWeapon = false;
                    }
                }
            }            
        }
        else
        {
            // End:0x757
            if((Inv.GetInventoryItemCount(1) >= 2) || Inv.GetInventoryItemCount(4) >= 1)
            {
                // End:0x6BB
                if(int(EvilWeap_Base(P.Weapon).InventoryGroup) == int(4))
                {
                    Weap = Inv.HasWeaponWithInventoryGroup(int(WeaponClass.default.InventoryGroup));                    
                }
                else
                {
                    Weap = EvilWeap_Base(P.Weapon);
                }
                P.bIgnoreSwitchWeapon = true;
                P.TossInventory(Weap);
                P.bIgnoreSwitchWeapon = false;
            }
        }
        AmountModifier = 1.0000000;
        // End:0x849
        if(!WorldInfo.GRI.IsMultiplayerGame() && EvilPlayerController(P.Controller) != none)
        {
            AmountModifier = Class'EvilDifficultySettings'.static.GetClassByID(EvilPlayerController(P.Controller).GetFightDifficultyLevel()).default.AmmoDifficultyModifier;
        }
        I = 0;
        J0x854:

        // End:0x8B1 [Loop If]
        if(I < AmmoAmount.Length)
        {
            AmmoAmountMod.AddItem(FCeil(float(AmmoAmount[I]) * AmountModifier));            
            I++;
            // [Loop Continue]
            goto J0x854;
        }
        Weap = EvilWeap_Base(P.CreateInventory(WeaponClass, true));
        // End:0x962
        if(!Weap.BothHandWeapon)
        {
            WeapLeft = EvilWeap_Base(P.FindInventoryType(Weap.OffHandWeaponClass, true));
        }
        Weap.Unloaded();
        // End:0x9AF
        if(WeapLeft != none)
        {
            WeapLeft.Unloaded();
        }
        Weap.MagazineAmmoCount = ((AmmoAmountMod[0] > Weap.MagazineMaxAmmoCount) ? Weap.MagazineMaxAmmoCount : AmmoAmountMod[0]);
        // End:0xAAE
        if(WeapLeft != none)
        {
            WeapLeft.MagazineAmmoCount = ((AmmoAmountMod[0] > WeapLeft.MagazineMaxAmmoCount) ? WeapLeft.MagazineMaxAmmoCount : AmmoAmountMod[0]);
        }
        I = 0;
        J0xAB9:

        // End:0xBA4 [Loop If]
        if(I < AmmoAmountMod.Length)
        {
            Inv.AddAmmoToWeapon(byte(I), AmmoAmountMod[I], WeaponClass);
            // End:0xB96
            if(WeaponClass.default.OffHandWeaponClass != none)
            {
                Inv.AddAmmoToWeapon(byte(I), AmmoAmountMod[I], WeaponClass.default.OffHandWeaponClass);
            }
            I++;
            // [Loop Continue]
            goto J0xAB9;
        }
        // End:0xC3E
        if((EvilWeap_Base(P.Weapon) == none) || !EvilWeap_Base(P.Weapon).bSuppressPickupSwitch)
        {
            P.SetCurrentWeaponClass(WeaponClass);
        }
        super(EvilTouchPickUp_Base).Pickup(P);        
    }
    else
    {
        // End:0xCB2
        if(!HACKBOOL)
        {
            HACKBOOL = true;
            PickupTrigger.CylinderComponent.SetCylinderSize(128.0000000, 128.0000000);
            return;            
        }
        else
        {
            HACKBOOL = false;
            PickupTrigger.CylinderComponent.SetCylinderSize(256.0000000, 128.0000000);
        }
    }
    //return;    
}

function TriggerTouched(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local EvilPawn P;
    local EvilWeap_Base Weap;
    local string Caption;
    local int I;
    local EvilInventoryManager Inv;
    local class<EvilWeap_Melee_Base> MeleeWeapon;

    // End:0x22
    if((TimeToDestroy > float(0)) || bHidden)
    {
        return;
    }
    super.TriggerTouched(Other, OtherComp, HitLocation, HitNormal);
    P = EvilPawn(Other);
    // End:0x901
    if((P != none) && P.IsPlayerPawn())
    {
        // End:0xFC
        if(int(Physics) == int(0))
        {
            PickupPRI = EvilPlayerController(P.Controller).PlayerReplicationInfo;            
        }
        else
        {
            FlyingPickupOwner = EvilPlayerController(P.Controller).PlayerReplicationInfo;
        }
        Inv = EvilInventoryManager(P.InvManager);
        Weap = EvilWeap_Base(P.FindInventoryType(WeaponClass, true));
        // End:0x566
        if(Weap != none)
        {
            // End:0x429
            if(Inv.NeedsAmmo(WeaponClass))
            {
                I = 0;
                J0x1F5:

                // End:0x2E0 [Loop If]
                if(I < AmmoAmount.Length)
                {
                    Inv.AddAmmoToWeapon(byte(I), AmmoAmount[I], WeaponClass);
                    // End:0x2D2
                    if(WeaponClass.default.OffHandWeaponClass != none)
                    {
                        Inv.AddAmmoToWeapon(byte(I), AmmoAmount[I], WeaponClass.default.OffHandWeaponClass);
                    }
                    I++;
                    // [Loop Continue]
                    goto J0x1F5;
                }
                // End:0x324
                if(PickupSound != none)
                {
                    P.PlaySound(PickupSound, false, true, false, Location);
                }
                Caption = Localize(CaptionComponent.LocSection, "WeaponAmmoLoaded", CaptionComponent.LocModule);
                Caption = Repl(Caption, "{WEAPON}", WeaponClass.default.ItemName, false);
                CaptionComponent.SetCaptionCustom(Caption);
                bClientCaptionWeaponFull = false;
                // End:0x424
                if(!IsTimerActive('DestroyDelayed'))
                {
                    SetTimer(1.0000000, false, 'DestroyDelayed');
                }
                return;                
            }
            else
            {
                Caption = Localize(CaptionComponent.LocSection, "WeaponFull", CaptionComponent.LocModule);
                Caption = Repl(Caption, "{WEAPON}", WeaponClass.default.ItemName, false);
                CaptionComponent.SetCaptionCustom(Caption);
                bClientCaptionWeaponFull = true;
            }
            SurvivalAmmoModifier = ((EvilGameReplicationInfo(WorldInfo.GRI).IsSurvivalGame()) ? Weap.MaxAmmoCountSurvivalMultiplier : 1.0000000);
        }
        // End:0x5F5
        if((Weap != none) && !ForceUseAndText || Weap.AmmoCount >= FCeil(float(Weap.MaxAmmoCount) * SurvivalAmmoModifier))
        {
            Used(P);
            return;
        }
        // End:0x6D1
        if(!WorldInfo.GRI.IsMultiplayerGame() || EvilGameReplicationInfo(WorldInfo.GRI).IsSurvivalGame())
        {
            Weap = P.EvilInvManager.HasWeaponWithInventoryGroup(int(WeaponClass.default.InventoryGroup));            
        }
        else
        {
            Weap = EvilWeap_Base(P.Weapon);
        }
        // End:0x7B4
        if(Weap != none)
        {
            Caption = Localize(CaptionComponent.LocSection, "WeaponSwitch", CaptionComponent.LocModule);
            Caption = Repl(Caption, "{OLD_WEAPON}", Weap.ItemName, false);            
        }
        else
        {
            Caption = Localize(CaptionComponent.LocSection, "WeaponPickUp", CaptionComponent.LocModule);
        }
        Caption = Repl(Caption, "{WEAPON}", WeaponClass.default.ItemName, false);
        MeleeWeapon = class<EvilWeap_Melee_Base>(WeaponClass);
        // End:0x8D9
        if(((MeleeWeapon != none) && MeleeWeapon.default.bIsSwitchableAsThrow) && AmmoAmount[0] > 1)
        {            
            Caption @= ("x" $ string(AmmoAmount[0]));
        }
        CaptionComponent.SetCaptionCustom(Caption);
    }
    //return;    
}

function TriggerUnTouched(Actor Other)
{
    PickupPRI = none;
    super.TriggerUnTouched(Other);
    //return;    
}

simulated function SetCaptionTextOnClinet()
{
    local EvilPlayerReplicationInfo localPRI;
    local EvilWeap_Base Weap;
    local string localCaption;
    local EvilPlayerController PC;

    localPRI = EvilPlayerReplicationInfo(PickupPRI);
    PC = EvilPlayerController(localPRI.Owner);
    // End:0x66D
    if(PC == EvilPlayerController(WorldInfo.GetALocalPlayerController()))
    {
        Weap = EvilWeap_Base(PC.MyEvilPawn.FindInventoryType(WeaponClass, true));
        // End:0x31C
        if(Weap != none)
        {
            // End:0x1EB
            if(!bClientCaptionWeaponFull)
            {
                localCaption = Localize(CaptionComponent.LocSection, "WeaponAmmoLoaded", CaptionComponent.LocModule);
                localCaption = Repl(localCaption, "{WEAPON}", WeaponClass.default.ItemName, false);
                CaptionComponent.SetCaptionCustom(localCaption);
                // End:0x1E6
                if(!IsTimerActive('DestroyDelayed'))
                {
                    SetTimer(1.0000000, false, 'DestroyDelayed');
                }
                return;                
            }
            else
            {
                localCaption = Localize(CaptionComponent.LocSection, "WeaponFull", CaptionComponent.LocModule);
                localCaption = Repl(localCaption, "{WEAPON}", WeaponClass.default.ItemName, false);
                CaptionComponent.SetCaptionCustom(localCaption);
            }
            SurvivalAmmoModifier = ((EvilGameReplicationInfo(WorldInfo.GRI).IsSurvivalGame()) ? Weap.MaxAmmoCountSurvivalMultiplier : 1.0000000);
        }
        // End:0x3C0
        if((Weap != none) && !ForceUseAndText || Weap.AmmoCount >= FCeil(float(Weap.MaxAmmoCount) * SurvivalAmmoModifier))
        {
            Used(PC.MyEvilPawn);
            return;
        }
        // End:0x4B1
        if(!WorldInfo.GRI.IsMultiplayerGame() || EvilGameReplicationInfo(WorldInfo.GRI).IsSurvivalGame())
        {
            Weap = PC.MyEvilPawn.EvilInvManager.HasWeaponWithInventoryGroup(int(WeaponClass.default.InventoryGroup));            
        }
        else
        {
            Weap = EvilWeap_Base(PC.MyEvilPawn.Weapon);
        }
        // End:0x5A9
        if(Weap != none)
        {
            localCaption = Localize(CaptionComponent.LocSection, "WeaponSwitch", CaptionComponent.LocModule);
            localCaption = Repl(localCaption, "{OLD_WEAPON}", Weap.ItemName, false);            
        }
        else
        {
            localCaption = Localize(CaptionComponent.LocSection, "WeaponPickUp", CaptionComponent.LocModule);
        }
        localCaption = Repl(localCaption, "{WEAPON}", WeaponClass.default.ItemName, false);
        CaptionComponent.SetCaptionCustom(localCaption);
    }
    //return;    
}

function Used(Pawn User)
{
    // End:0x16
    if(int(Physics) == int(2))
    {
        return;
    }
    // End:0x4E
    if(!CanBeUsedNow(PlayerController(User.Controller)))
    {
        return;
    }
    super.Used(User);
    //return;    
}

simulated function bool CanBeUsedNow(PlayerController PC)
{
    // End:0x37
    if((PC == none) || PC.Pawn == none)
    {
        return false;
    }
    // End:0x79
    if(EvilPawn(PC.Pawn).IsMummy())
    {
        return false;
    }
    // End:0x1AF
    if(((EvilWeap_Base(PC.Pawn.Weapon) != none) && EvilWeap_Base(PC.Pawn.Weapon).IsReloading()) || (EvilWeap_Base(PC.Pawn.WeaponLeft) != none) && EvilWeap_Base(PC.Pawn.WeaponLeft).IsReloading())
    {
        return false;
    }
    // End:0x211
    if(EvilInventoryManager(EvilPawn(PC.Pawn).InvManager).PendingWeaponLeft != none)
    {
        return false;
    }
    return super.CanBeUsedNow(PC);
    //return ReturnValue;    
}

event Landed(Vector HitNormal, Actor FloorActor)
{
    // End:0x79
    if(int(Physics) == int(2))
    {
        SetPhysics(0);
        // End:0x48
        if(LandingSoound != none)
        {
            PlaySound(LandingSoound,,,, Location);
        }
        SetTimer(0.5000000, false, 'ActivateTriggerCollisions');
        PickupPRI = FlyingPickupOwner;
        FlyingPickupOwner = none;
    }
    //return;    
}

function ActivateTriggerCollisions()
{
    PickupTrigger.CylinderComponent.SetActorCollision(true, false);
    //return;    
}

function DeactivateTriggerCollisions()
{
    PickupTrigger.CylinderComponent.SetActorCollision(false, false);
    //return;    
}

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
    // End:0x5A
    if(Action.InputLinks[0].bHasImpulse)
    {
        SkelPickupMesh.SetHidden(true);        
    }
    else
    {
        // End:0xB4
        if(Action.InputLinks[1].bHasImpulse)
        {
            SkelPickupMesh.SetHidden(false);            
        }
        else
        {
            SkelPickupMesh.SetHidden(!bHidden);
        }
    }
    super(EvilTouchPickUp_Base).OnToggleHidden(Action);
    //return;    
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.WeaponClassPath = PathName(WeaponClass);
    Record.MaxPickCount = MaxPickCount;
    Record.bHidden = bHidden;
    Record.Location = Location;
    Record.Rotation = Rotation;
    Record.SavedBase = PathName(Base);
    Record.bDynamicallySpawned = bDynamicallySpawned;
    //return;    
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    local Actor SavedBaseActor;
    local class<EvilWeap_Base> WeapClass;
    local EvilTouchPickUp_WeaponBase WeaponPickup;

    WeapClass = class<EvilWeap_Base>(FindObject(Record.WeaponClassPath, Class'Core.Class'));
    bDynamicallySpawned = Record.bDynamicallySpawned;
    // End:0x2E5
    if(WeapClass != none)
    {
        WeaponPickup = EvilTouchPickUp_WeaponBase(WeapClass.default.PickupArchetype);
        // End:0x2E2
        if(WeaponPickup != none)
        {
            InitFromArchetype(WeaponPickup);
            MaxPickCount = Record.MaxPickCount;
            SetHidden(Record.bHidden);
            PickupMesh.SetHidden(Record.bHidden);
            SkelPickupMesh.SetHidden(Record.bHidden);
            // End:0x1D3
            if(Record.bHidden)
            {
                CaptionComponent.Hide();                
            }
            else
            {
                CaptionComponent.Show();
            }
            SetLocation(Record.Location);
            SetRotation(Record.Rotation);
            // End:0x2E2
            if(Record.SavedBase != "")
            {
                SavedBaseActor = Actor(FindObject(Record.SavedBase, Class'Engine.Actor'));
                // End:0x2B6
                if(SavedBaseActor != none)
                {
                    SetBase(SavedBaseActor);                    
                }
                else
                {
                    // End:0x2E2
                    if(Record.bDynamicallySpawned)
                    {
                        StartFalling();
                    }
                }
            }
        }        
    }
    else
    {
        Destroy();
    }
    //return;    
}

function InitFromArchetype(EvilTouchPickUp_WeaponBase Template)
{
    local int I;

    // End:0x11
    if(Template == none)
    {
        return;
    }
    DetachComponent(PickupMesh);
    PickupMesh = new (self) Template.PickupMesh.Class (Template.PickupMesh);
    AttachComponent(PickupMesh);
    DetachComponent(SkelPickupMesh);
    SkelPickupMesh = new (self) Template.SkelPickupMesh.Class (Template.SkelPickupMesh);
    AttachComponent(SkelPickupMesh);
    DetachComponent(LightEnvironment);
    LightEnvironment = new (self) Template.LightEnvironment.Class (Template.LightEnvironment);
    AttachComponent(LightEnvironment);
    PickupSound = Template.PickupSound;
    ForceUseAndText = Template.ForceUseAndText;
    Lifetime = Template.Lifetime;
    CheckSameDropDistance = Template.CheckSameDropDistance;
    WeaponClass = Template.WeaponClass;
    I = 0;
    J0x275:

    // End:0x2EC [Loop If]
    if(I < Template.AmmoAmount.Length)
    {
        AmmoAmount[I] = Template.AmmoAmount[I];
        I++;
        // [Loop Continue]
        goto J0x275;
    }
    I = 0;
    J0x2F7:

    // End:0x3E4 [Loop If]
    if(I < Template.Materials.Length)
    {
        Materials[I] = Template.Materials[I];
        PickupMesh.SetMaterial(I, Materials[I]);
        SkelPickupMesh.SetMaterial(I, Materials[I]);
        I++;
        // [Loop Continue]
        goto J0x2F7;
    }
    // End:0x40C
    if(Lifetime != 0)
    {
        SetTimer(float(Lifetime), false, 'DestroyDelayed');
    }
    //return;    
}

event OnSleepRBPhysics()
{
    local SkeletonSnapshot Snapshot;

    // End:0x160
    if(SkelPickupMesh != none)
    {
        Snapshot = Class'EvilAnim_SkeletonSnapshot'.static.TakeSnapshotCopy(SkelPickupMesh);
        SkelPickupMesh.SetHasPhysicsAssetInstance(false);
        SkelPickupMesh.PhysicsWeight = 0.0000000;
        SkelPickupMesh.SetAnimTreeTemplate(AnimTree'ar_PickUps.IdlePickupWithSkeletalMesh');
        EvilAnim_SkeletonSnapshot(AnimTree(SkelPickupMesh.Animations).Children[0].Anim).SetSnapshot(Snapshot);
        SkelPickupMesh.SetRotation(Rotation);
        SetRotation(MakeRotator(0, 0, 0));
    }
    CollisionComponent = CylinderComponent;
    SetPhysics(0);
    super.OnSleepRBPhysics();
    //return;    
}

simulated function StartFalling(optional Vector InStartVelocity, optional Pawn InInstigator)
{
    DeactivateTriggerCollisions();
    SetPhysics(2);
    Velocity = InStartVelocity;
    Instigator = InInstigator;
    //return;    
}

simulated function SetWeaponMaterialLight(float WeaponMaterialLight)
{
    local int I, NumElements;
    local MaterialInstanceConstant MIC;

    // End:0xCB
    if(SkelPickupMesh != none)
    {
        NumElements = SkelPickupMesh.GetNumElements();
        I = 0;
        J0x43:

        // End:0xCB [Loop If]
        if(I < NumElements)
        {
            MIC = SkelPickupMesh.CreateAndSetMaterialInstanceConstant(I);
            MIC.SetScalarParameterValue('LevelMultiply', WeaponMaterialLight);
            ++I;
            // [Loop Continue]
            goto J0x43;
        }
    }
    //return;    
}

defaultproperties
{
    AmmoAmount[0]=0
    AmmoAmount[1]=0
    AmmoAmount[2]=0
    SurvivalAmmoModifier=1.0000000
    // Reference: SkeletalMeshComponent'Default__EvilTouchPickUp_WeaponBase.SkelPickupMeshComp'
    begin object name=SkelPickupMeshComp class=Class'Engine.SkeletalMeshComponent'
        ReplacementPrimitive=none
        bIgnoreOwnerHidden=true
        bCastStaticShadow=false
        bSelfShadowOnly=true
        bAcceptsDynamicDominantLightShadows=false
        LightingChannels=(Dynamic=true,Unnamed_6=true,Gameplay_1=true)
    end object
    SkelPickupMesh=SkelPickupMeshComp
    // Reference: CylinderComponent'Default__EvilTouchPickUp_WeaponBase.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: StaticMeshComponent'Default__EvilTouchPickUp_WeaponBase.PickupMeshComp'
    begin object name=PickupMeshComp
        ReplacementPrimitive=none
    end object
    PickupMesh=PickupMeshComp
    // Reference: EvilCaptionComponent'Default__EvilTouchPickUp_WeaponBase.CaptionComp'
    begin object name=CaptionComp
    end object
    CaptionComponent=CaptionComp
    // Reference: DynamicLightEnvironmentComponent'Default__EvilTouchPickUp_WeaponBase.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=CollisionCylinder
    Components[1]=PickupMeshComp
    Components[2]=MyLightEnvironment
    Components[3]=CaptionComp
    Components[4]=SkelPickupMeshComp
    CollisionComponent=CollisionCylinder
}