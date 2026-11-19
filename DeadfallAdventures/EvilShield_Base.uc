class EvilShield_Base extends Inventory
    abstract
    hidecategories(Navigation);

var bool bEquipClothShield;

simulated function PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    // End:0x55
    if(bEquipClothShield)
    {
        EvilPawn(Owner).EquipShield(self.Class);
    }
    //return;    
}
