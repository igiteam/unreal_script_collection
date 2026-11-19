class TurokInventory extends Inventory
    abstract
    native
    config(Game)
    hidecategories(Navigation);

var protected const config float MovementModifier;
var protected const class<Class> mAttachmentType;

static event float GetMovementModifier()
{
    return default.MovementModifier;
    //return ReturnValue;    
}

static function class<Class> GetAttachmentType()
{
    return default.mAttachmentType;
    //return ReturnValue;    
}

function GivenTo(@NULL thisPawn, optional bool bDoNotActivate)
{
    local @NULL tph;

    // End:0x44
    if(mAttachmentType != none)
    {
        tph = TurokPawnHuman(thisPawn);
        // End:0x44
        if(tph != none)
        {
            tph.AttachInventory(self.Class);
        }
    }
    super.GivenTo(thisPawn, bDoNotActivate);
    //return;    
}

function ItemRemovedFromInvManager()
{
    local @NULL pwn;

    // End:0x39
    if(mAttachmentType != none)
    {
        pwn = TurokPawnHuman(Owner);
        // End:0x39
        if(pwn != none)
        {
            pwn.DetachInventory();
        }
    }
    super.ItemRemovedFromInvManager();
    //return;    
}

function DropFrom(@NULL StartLocation, @NULL StartVelocity)
{
    local @NULL P;

    // End:0x1D
    if((DroppedPickupClass == none) || DroppedPickupMesh == none)
    {
        Destroy();
        return;
    }
    P = __NFUN_278__(DroppedPickupClass,,, StartLocation);
    // End:0x45
    if(P == none)
    {
        Destroy();
        return;
    }
    P.Inventory = self;
    P.Inventory.SetTickGroup(3);
    P.InventoryClass = Class;
    P.Velocity = StartVelocity;
    P.SetPhysics(2);
    P.SetPickupMesh(DroppedPickupMesh);
    // End:0x105
    if((Instigator != none) && Instigator.InvManager != none)
    {
        TurokInventoryManager(TurokPawnHuman(Instigator).InvManager).DropFromInventory(self);
    }
    ItemDropped(P, Instigator);
    Instigator = none;
    //return;    
}

function ItemDropped(@NULL P, @NULL inst)
{
    //return;    
}

defaultproperties
{
    PickupSound=SoundCue'SndWeapCommon.WeaponPickupSndCue'
    DroppedPickupClass=Class'TurokDroppedPickup'
    // Reference: SpriteComponent'Default__TurokInventory.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}