class EvilWeaponPickupFactory extends EvilPickupFactory
    hidecategories(Navigation,Lighting,LightColor,Force,Display,Collision,PickupFactory)
    classgroup(Pickups,Weapon);

var() class<EvilWeap_Base> WeaponPickupClass;
var bool bWeaponStay;
var bool bIsActive;
var export editinline ParticleSystemComponent BaseGlow;
var float WeaponPickupScaling;
var array<PawnToucher> Customers;

simulated function InitializePickup()
{
    local int I;

    InventoryType = WeaponPickupClass;
    // End:0x32
    if(InventoryType == none)
    {
        GotoState('Disabled');
        return;
    }
    PivotTranslation = WeaponPickupClass.default.PivotTranslation;
    SetWeaponStay();
    // End:0x114
    if(WeaponPickupClass.default.bHasLocationSpeech)
    {
        bHasLocationSpeech = true;
        I = 0;
        J0x9D:

        // End:0x114 [Loop If]
        if(I < WeaponPickupClass.default.LocationSpeech.Length)
        {
            LocationSpeech[I] = WeaponPickupClass.default.LocationSpeech[I];
            I++;
            // [Loop Continue]
            goto J0x9D;
        }
    }
    super(PickupFactory).InitializePickup();
    //return;    
}

simulated function SetPickupVisible()
{
    BaseGlow.SetActive(true);
    super.SetPickupVisible();
    //return;    
}

simulated function SetPickupHidden()
{
    BaseGlow.DeactivateSystem();
    super.SetPickupHidden();
    //return;    
}

simulated function SetPickupMesh()
{
    super.SetPickupMesh();
    // End:0x61
    if(PickupMesh != none)
    {
        PickupMesh.SetScale(PickupMesh.Scale * WeaponPickupScaling);
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x60
    if(VarName == 'InventoryType')
    {
        // End:0x5D
        if(InventoryType != WeaponPickupClass)
        {
            WeaponPickupClass = class<EvilWeap_Base>(InventoryType);
            super.ReplicatedEvent(VarName);
        }        
    }
    else
    {
        super.ReplicatedEvent(VarName);
    }
    //return;    
}

function bool CheckForErrors()
{
    // End:0x0F
    if(super(PickupFactory).CheckForErrors())
    {
        return true;
    }
    // End:0x20
    if(WeaponPickupClass == none)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function SetWeaponStay()
{
    bWeaponStay = !WeaponPickupClass.default.bSuperWeapon && EvilGame(WorldInfo.Game).bWeaponStay;
    //return;    
}

function StartSleeping()
{
    // End:0x1D
    if(!bWeaponStay)
    {
        GotoState('Sleeping');
    }
    //return;    
}

function bool AddCustomer(Pawn P)
{
    local int I;
    local PawnToucher Pt;

    // End:0x2F
    if(EvilInventoryManager(P.InvManager) == none)
    {
        return false;
    }
    // End:0x193
    if(Customers.Length > 0)
    {
        I = 0;
        J0x4A:

        // End:0x193 [Loop If]
        if(I < Customers.Length)
        {
            // End:0x14F
            if(Customers[I].NextTouchTime < WorldInfo.TimeSeconds)
            {
                // End:0x12C
                if(Customers[I].P == P)
                {
                    Customers[I].NextTouchTime = WorldInfo.TimeSeconds + float(30);
                    return true;
                }
                Customers.Remove(I, 1);
                I--;                
            }
            else
            {
                // End:0x185
                if(Customers[I].P == P)
                {
                    return false;
                }
            }
            I++;
            // [Loop Continue]
            goto J0x4A;
        }
    }
    Pt.P = P;
    Pt.NextTouchTime = WorldInfo.TimeSeconds + float(30);
    Customers[Customers.Length] = Pt;
    return true;
    //return ReturnValue;    
}

function bool HasCustomer(Pawn P)
{
    local int I;
    local bool bFoundCustomer;

    // End:0x107
    if(Customers.Length > 0)
    {
        I = 0;
        J0x1B:

        // End:0x107 [Loop If]
        if(I < Customers.Length)
        {
            bFoundCustomer = Customers[I].P == P;
            // End:0xEA
            if(Customers[I].NextTouchTime < WorldInfo.TimeSeconds)
            {
                Customers.Remove(I, 1);
                I--;
                // End:0xE7
                if(bFoundCustomer)
                {
                    return false;
                }                
            }
            else
            {
                // End:0xF9
                if(bFoundCustomer)
                {
                    return true;
                }
            }
            I++;
            // [Loop Continue]
            goto J0x1B;
        }
    }
    return false;
    //return ReturnValue;    
}

function PickedUpBy(Pawn P)
{
    // End:0x9A
    if(bWeaponStay)
    {
        AddCustomer(P);
        // End:0x9A
        if((P.Controller != none) && P.Controller.IsLocalPlayerController())
        {
            ShowHidden();
            SetTimer(30.0000000, false, 'ShowActive');
        }
    }
    super.PickedUpBy(P);
    //return;    
}

function SpawnCopyFor(Pawn Recipient)
{
    local Inventory Inv;

    // End:0x10E
    if(EvilInventoryManager(Recipient.InvManager) != none)
    {
        Inv = EvilInventoryManager(Recipient.InvManager).HasInventoryOfClass(WeaponPickupClass);
        // End:0x10E
        if(EvilWeap_Base(Inv) != none)
        {
            EvilWeap_Base(Inv).AddAmmo(WeaponPickupClass.default.AmmoCount);
            EvilWeap_Base(Inv).AnnouncePickup(Recipient);
            return;
        }
    }
    Recipient.MakeNoise(0.2000000);
    super(PickupFactory).SpawnCopyFor(Recipient);
    //return;    
}

simulated function ShowActive()
{
    //return;    
}

simulated function ShowHidden()
{
    BaseGlow.DeactivateSystem();
    // End:0x4E
    if(PickupMesh != none)
    {
        PickupMesh.SetHidden(true);
    }
    bIsActive = false;
    //return;    
}

simulated function NotifyLocalPlayerDead(PlayerController PC)
{
    //return;    
}

auto state Pickup
{
    simulated function ShowActive()
    {
        BaseGlow.SetActive(true);
        bIsActive = true;
        // End:0x5C
        if(PickupMesh != none)
        {
            PickupMesh.SetHidden(false);
        }
        //return;        
    }

    simulated function NotifyLocalPlayerDead(PlayerController PC)
    {
        // End:0x17
        if(bWeaponStay)
        {
            ShowActive();
        }
        //return;        
    }

    simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
        local Pawn Recipient;
        local Controller PickupController;

        // End:0x3F
        if(!bWeaponStay)
        {
            super.Touch(Other, OtherComp, HitLocation, HitNormal);
            return;
        }
        Recipient = Pawn(Other);
        // End:0x1D4
        if(((Recipient != none) && !HasCustomer(Recipient)) && ValidTouch(Recipient))
        {
            // End:0x193
            if(bIsActive)
            {
                PickupController = Recipient.Controller;
                // End:0x143
                if((PickupController == none) && Recipient.DrivenVehicle != none)
                {
                    PickupController = Recipient.DrivenVehicle.Controller;
                }
                // End:0x193
                if((PickupController != none) && PickupController.IsLocalPlayerController())
                {
                    ShowHidden();
                    SetTimer(30.0000000, false, 'ShowActive');
                }
            }
            // End:0x1D4
            if(int(Role) == int(ROLE_Authority))
            {
                // End:0x1C1
                if(!AddCustomer(Recipient))
                {
                    return;
                }
                GiveTo(Recipient);
            }
        }
        //return;        
    }

    simulated function bool ValidTouch(Pawn Other)
    {
        // End:0x28
        if(int(Role) == int(ROLE_Authority))
        {
            return super.ValidTouch(Other);
        }
        // End:0xB8
        if((((Other == none) || !Other.bCanPickupInventory) || Other.Controller == none) || !FastTrace(Other.Location, Location))
        {
            return false;
        }
        return true;
        //return ReturnValue;        
    }

    simulated event BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        ShowActive();
        //return;        
    }
    stop;    
}

defaultproperties
{
    bWeaponStay=true
    // Reference: ParticleSystemComponent'Default__EvilWeaponPickupFactory.GlowEffect'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'GlowEffect'
    begin object name="GlowEffect" class=Class'Engine.ParticleSystemComponent'
        ReplacementPrimitive=none
        Translation=(X=0.0000000,Y=0.0000000,Z=-44.0000000)
    end object
    BaseGlow=GlowEffect
    WeaponPickupScaling=1.2000000
    // Reference: DynamicLightEnvironmentComponent'Default__EvilWeaponPickupFactory.PickupLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__EvilPickupFactory.PickupLightEnvironment'
    begin object name="PickupLightEnvironment"
    end object
    LightEnvironment=PickupLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__EvilWeaponPickupFactory.ForceFeedbackWaveformPickUp'
    begin object name="ForceFeedbackWaveformPickUp" class=Class'Engine.ForceFeedbackWaveform'
        Samples=/* Array type was not detected. */
    end object
    PickUpWaveForm=ForceFeedbackWaveformPickUp
    bRotatingPickup=true
    bDoVisibilityFadeIn=false
    // Reference: StaticMeshComponent'Default__EvilWeaponPickupFactory.BaseMeshComp'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'BaseMeshComp'
    // Archetype: StaticMeshComponent'Default__EvilPickupFactory.BaseMeshComp'
    begin object name="BaseMeshComp"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__EvilWeaponPickupFactory.PickupLightEnvironment'
        Translation=(X=0.0000000,Y=0.0000000,Z=-44.0000000)
    end object
    BaseMesh=BaseMeshComp
    // Reference: CylinderComponent'Default__EvilWeaponPickupFactory.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__EvilPickupFactory.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
        BlockZeroExtent=false
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=none
    Components[2]=PickupLightEnvironment
    Components[3]=BaseMeshComp
    Components[4]=GlowEffect
    bBlockActors=true
    CollisionComponent=CollisionCylinder
}