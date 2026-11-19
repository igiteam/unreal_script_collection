class WeaponLocker extends SkyGameInteractor
    native;

simulated function PostBeginPlay()
{
    WorldInfo.RadarNodes.AddItem(self);
    //return;    
}

function Destroyed()
{
    WorldInfo.RadarNodes.RemoveItem(self);
    //return;    
}
