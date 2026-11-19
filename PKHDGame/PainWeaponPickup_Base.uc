class PainWeaponPickup_Base extends PainItemBaseSkelMesh
    abstract
    placeable
    hidecategories(Navigation);

var class<PainWeap_Base> WeaponClass;
var() array<int> AmmoAmount;
var() Vector PivotTranslation;
var() float YawRotationRate;
var() float BobBaseOffset;
var() float BobOffset;
var() float BobSpeed;
var transient float BobTimer;

function PostBeginPlay()
{
    // End:0x4B
    if(PainGRI(WorldInfo.GRI).IsMultiplayerGame())
    {
        MaxPickCount = 0;
    }
    // End:0x97
    if(PainGRI(WorldInfo.GRI).IsCoopMultiplayerGame())
    {
        MaxPickCount = 2;
    }
    super(PainItemBase).PostBeginPlay();
    //return;    
}

function bool CanPickUp(PKPlayerPawn P, PainPRI PRI)
{
    // End:0x0F
    if(bHidden)
    {
        return false;
    }
    // End:0x39
    if((LastPRIPicker != none) && LastPRIPicker == PRI)
    {
        return false;
    }
    // End:0xD4
    if((Weapon(P.FindInventoryType(WeaponClass, true)) != none) && !EvilInventoryManager(P.InvManager).NeedsAmmo(WeaponClass))
    {
        SetTimer(0.5000000, false, 'ReCheckTouchingPlayers_T');
        return false;
    }
    return super(PainItemBase).CanPickUp(P, PRI);
    //return ReturnValue;    
}

function ReCheckTouchingPlayers_T()
{
    local PKPlayerPawn P;
    local bool bIsSomeoneTouchingWhoCantPickup;

    bIsSomeoneTouchingWhoCantPickup = false;
    // End:0xBB
    foreach TouchingActors(Class'PKPlayerPawn', P)
    {
        // End:0x72
        if(!CanPickUp(P, PainPRI(P.PlayerReplicationInfo)))
        {
            bIsSomeoneTouchingWhoCantPickup = true;
            // End:0xBA
            continue;
        }
        Touch(P, none, Location, Normal(Location - P.Location));        
    }    
    // End:0xDC
    if(bIsSomeoneTouchingWhoCantPickup)
    {
        SetTimer(0.5000000, false, 'ReCheckTouchingPlayers_T');
    }
    //return;    
}

function Pickup(PKPlayerPawn P, PainPRI PRI)
{
    local int I;

    // End:0x22E
    if(Weapon(P.FindInventoryType(WeaponClass, true)) == none)
    {
        PainWeap_Base(P.CreateInventory(WeaponClass, true));
        I = 0;
        J0x75:

        // End:0x175 [Loop If]
        if(I < AmmoAmount.Length)
        {
            EvilInventoryManager(P.InvManager).AddAmmoToWeapon(byte(I), (((PainGRI_SP(WorldInfo.GRI) != none) && PainGRI_SP(WorldInfo.GRI).b666AmmoCardEnabled) ? 666 : AmmoAmount[I]), WeaponClass);
            I++;
            // [Loop Continue]
            goto J0x75;
        }
        // End:0x20F
        if((PainWeap_Base(P.Weapon) != none) && !PainWeap_Base(P.Weapon).bSuppressPickupSwitch)
        {
            P.SetCurrentWeaponClass(WeaponClass);
        }
        super(PainItemBase).Pickup(P, PRI);        
    }
    else
    {
        I = 0;
        J0x239:

        // End:0x2C3 [Loop If]
        if(I < AmmoAmount.Length)
        {
            EvilInventoryManager(P.InvManager).AddAmmoToWeapon(byte(I), AmmoAmount[I], WeaponClass);
            I++;
            // [Loop Continue]
            goto J0x239;
        }
        // End:0x35D
        if((PainWeap_Base(P.Weapon) != none) && !PainWeap_Base(P.Weapon).bSuppressPickupSwitch)
        {
            P.SetCurrentWeaponClass(WeaponClass);
        }
        super(PainItemBase).Pickup(P, PRI);
    }
    // End:0x40E
    if((PKGameMP_Base(WorldInfo.Game) != none) && PKGameMP_Base(WorldInfo.Game).bWeaponsStay)
    {
        LastPRIPicker = PRI;
        SetTimer(20.0000000, false, 'ClearLastPRIPicker');
    }
    //return;    
}

function ClearLastPRIPicker()
{
    LastPRIPicker = none;
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

simulated function Tick(float DeltaTime)
{
    local Rotator NewRotation;
    local Vector NewTranslation;
    local Matrix R;
    local float Offset;

    super(Actor).Tick(DeltaTime);
    // End:0x48
    if((WorldInfo.TimeSeconds - LastRenderTime) > 0.2000000)
    {
        return;
    }
    NewRotation = ItemMeshSkel.Rotation;
    NewRotation.Yaw += Round(DeltaTime * YawRotationRate);
    ItemMeshSkel.SetRotation(NewRotation);
    R = MakeRotationMatrix(ItemMeshSkel.Rotation);
    NewTranslation.Z = ItemMeshSkel.Translation.Z;
    NewTranslation = ((PivotTranslation.X * MatrixGetAxis(R, 1)) + (PivotTranslation.Y * MatrixGetAxis(R, 2))) + NewTranslation;
    BobTimer += DeltaTime;
    Offset = BobOffset * Sin(BobTimer * BobSpeed);
    NewTranslation.Z = BobBaseOffset + Offset;
    ItemMeshSkel.SetTranslation(NewTranslation);
    //return;    
}

function SetRespawn()
{
    // End:0xB9
    if(WorldInfo.GRI.IsCoopMultiplayerGame() || (PKGameMP_Base(WorldInfo.Game) != none) && PKGameMP_Base(WorldInfo.Game).bWeaponsStay)
    {
        GotoState('PickupReady');        
    }
    else
    {
        GotoState('Sleeping');
    }
    //return;    
}

defaultproperties
{
    AmmoAmount[0]=0
    AmmoAmount[1]=0
    YawRotationRate=7000.0000000
    BobBaseOffset=10.0000000
    BobOffset=5.0000000
    BobSpeed=2.0000000
    // Reference: SkeletalMeshComponent'Default__PainWeaponPickup_Base.ItemMeshSkelComp0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ItemMeshSkelComp0'
    // Archetype: SkeletalMeshComponent'Default__PainItemBaseSkelMesh.ItemMeshSkelComp0'
    begin object name="ItemMeshSkelComp0"
        // Reference: AnimNodeSequence'Default__PainWeaponPickup_Base.ItemMeshSkelComp0.AnimNodeSeq0'
        // Archetype: AnimNodeSequence'Default__PainItemBaseSkelMesh.AnimNodeSeq0'
        begin object name="AnimNodeSeq0"
        end object
        Animations=AnimNodeSeq0
        ReplacementPrimitive=none
    end object
    ItemMeshSkel=ItemMeshSkelComp0
    // Reference: CylinderComponent'Default__PainWeaponPickup_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PainItemBaseSkelMesh.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionRadius=30.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: DynamicLightEnvironmentComponent'Default__PainWeaponPickup_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainItemBaseSkelMesh.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=CollisionCylinder
    Components[1]=MyLightEnvironment
    Components[2]=ItemMeshSkelComp0
    CollisionComponent=CollisionCylinder
}