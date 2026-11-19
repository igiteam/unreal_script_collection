class EvilTouchPickUp_WeaponBase extends EvilUsePickUp_Base
    notplaceable
    hidecategories(Navigation);

var(Pickup) class<EvilWeap_Base> WeaponClass;
var(Pickup) array<int> AmmoAmount;
var(Pickup) bool ForceUseAndText;
var transient bool HACKBOOL;
var(Pickup) export editinline SkeletalMeshComponent SkelPickupMesh;

simulated function PostBeginPlay()
{
    local int Idx;
    local string ClassName;

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
    // End:0x12D
    if(CaptionComponent.CaptionText == "")
    {
        ClassName = string(WeaponClass.Name);
        // End:0xFA
        if(Right(ClassName, 5) != "_Base")
        {
            ClassName = ClassName $ "_Base";
        }
        CaptionComponent.SetCaptionAltLoc("ItemName", ClassName);
    }
    //return;    
}

function Pickup(EvilPawn P)
{
    local EvilWeap_Base Weap;
    local int I;

    // End:0x49D
    if(Weapon(P.FindInventoryType(WeaponClass, true)) == none)
    {
        // End:0x1E3
        if(class<EvilWeap_Melee_Base>(WeaponClass) != none)
        {
            // End:0x118
            if((class<EvilWeap_Melee_Base>(WeaponClass).default.bIsSwitchableAsMelee && P.MeleeWeapon != none) && P.MeleeWeapon.CanThrow())
            {
                P.TossInventory(P.MeleeWeapon);
            }
            // End:0x1E0
            if((class<EvilWeap_Melee_Base>(WeaponClass).default.bIsSwitchableAsThrow && P.ThrowWeapon != none) && P.ThrowWeapon.CanThrow())
            {
                P.TossInventory(P.ThrowWeapon);
            }            
        }
        else
        {
            P.TossInventory(EvilInventoryManager(P.InvManager).HasWeaponWithInventoryGroup(int(WeaponClass.default.InventoryGroup)));
        }
        Weap = EvilWeap_Base(P.CreateInventory(WeaponClass, true));
        Weap.Unloaded();
        I = 0;
        J0x2C6:

        // End:0x3ED [Loop If]
        if(I < AmmoAmount.Length)
        {
            EvilInventoryManager(P.InvManager).AddAmmoToWeapon(byte(I), AmmoAmount[I], WeaponClass);
            // End:0x3DF
            if(WeaponClass.default.OffHandWeaponClass != none)
            {
                EvilInventoryManager(P.InvManager).AddAmmoToWeapon(byte(I), AmmoAmount[I], WeaponClass.default.OffHandWeaponClass);
            }
            I++;
            // [Loop Continue]
            goto J0x2C6;
        }
        // End:0x487
        if((EvilWeap_Base(P.Weapon) != none) && !EvilWeap_Base(P.Weapon).bSuppressPickupSwitch)
        {
            P.SetCurrentWeaponClass(WeaponClass);
        }
        super(EvilTouchPickUp_Base).Pickup(P);        
    }
    else
    {
        // End:0x4FB
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
        // End:0x75D
        if(EvilInventoryManager(P.InvManager).NeedsAmmo(WeaponClass))
        {
            I = 0;
            J0x59A:

            // End:0x6C1 [Loop If]
            if(I < AmmoAmount.Length)
            {
                EvilInventoryManager(P.InvManager).AddAmmoToWeapon(byte(I), AmmoAmount[I], WeaponClass);
                // End:0x6B3
                if(WeaponClass.default.OffHandWeaponClass != none)
                {
                    EvilInventoryManager(P.InvManager).AddAmmoToWeapon(byte(I), AmmoAmount[I], WeaponClass.default.OffHandWeaponClass);
                }
                I++;
                // [Loop Continue]
                goto J0x59A;
            }
            CaptionComponent.SetCaptionCustom(Localize(CaptionComponent.LocSection, "WeaponAmmoLoaded", CaptionComponent.LocModule));
            TimeToDestroy = 1.0000000;
            super(EvilTouchPickUp_Base).Pickup(P);            
        }
        else
        {
            CaptionComponent.SetCaptionCustom(Localize(CaptionComponent.LocSection, "WeaponFull", CaptionComponent.LocModule));
        }
    }
    //return;    
}

simulated function TriggerTouched(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local EvilPawn P;
    local EvilWeap_Base Weap;
    local string Caption;

    // End:0x13
    if(TimeToDestroy > float(0))
    {
        return;
    }
    super.TriggerTouched(Other, OtherComp, HitLocation, HitNormal);
    P = EvilPawn(Other);
    // End:0x318
    if((P != none) && P.IsPlayerPawn())
    {
        Weap = EvilWeap_Base(P.FindInventoryType(WeaponClass, true));
        // End:0x144
        if((Weap != none) && !ForceUseAndText || Weap.AmmoCount >= Weap.MaxAmmoCount)
        {
            Used(P);
            return;
        }
        Weap = P.EvilInvManager.HasWeaponWithInventoryGroup(int(WeaponClass.default.InventoryGroup));
        // End:0x254
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
        CaptionComponent.SetCaptionCustom(Caption);
    }
    //return;    
}

simulated function TriggerUnTouched(Actor Other)
{
    super.TriggerUnTouched(Other);
    CaptionComponent.SetCaptionCustom("");
    //return;    
}

event Landed(Vector HitNormal, Actor FloorActor)
{
    // End:0x19
    if(int(Physics) == int(2))
    {
        SetPhysics(0);
    }
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

defaultproperties
{
    AmmoAmount[0]=0
    AmmoAmount[1]=0
    AmmoAmount[2]=0
    // Reference: SkeletalMeshComponent'Default__EvilTouchPickUp_WeaponBase.SkelPickupMeshComp'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'SkelPickupMeshComp'
    begin object name="SkelPickupMeshComp" class=Class'Engine.SkeletalMeshComponent'
        ReplacementPrimitive=none
        bIgnoreOwnerHidden=true
        bCastStaticShadow=false
        bAcceptsDynamicDominantLightShadows=false
        LightingChannels=(Dynamic=true,Gameplay_1=true)
    end object
    SkelPickupMesh=SkelPickupMeshComp
    // Reference: CylinderComponent'Default__EvilTouchPickUp_WeaponBase.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__EvilUsePickUp_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: StaticMeshComponent'Default__EvilTouchPickUp_WeaponBase.PickupMeshComp'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupMeshComp'
    // Archetype: StaticMeshComponent'Default__EvilUsePickUp_Base.PickupMeshComp'
    begin object name="PickupMeshComp"
        ReplacementPrimitive=none
    end object
    PickupMesh=PickupMeshComp
    // Reference: EvilCaptionComponent'Default__EvilTouchPickUp_WeaponBase.CaptionComp'
    // Archetype: EvilCaptionComponent'Default__EvilUsePickUp_Base.CaptionComp'
    begin object name="CaptionComp"
    end object
    CaptionComponent=CaptionComp
    // Reference: DynamicLightEnvironmentComponent'Default__EvilTouchPickUp_WeaponBase.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__EvilUsePickUp_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=CollisionCylinder
    Components[1]=PickupMeshComp
    Components[2]=MyLightEnvironment
    Components[3]=CaptionComp
    Components[4]=SkelPickupMeshComp
    CollisionComponent=CollisionCylinder
}