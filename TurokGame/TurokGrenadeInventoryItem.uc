class TurokGrenadeInventoryItem extends TurokInventory
    native
    config(Game)
    hidecategories(Navigation);

var class<Class> mGrenadeClassType;

function class<Class> GetGrenadeClassType()
{
    return mGrenadeClassType;
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: SpriteComponent'Default__TurokGrenadeInventoryItem.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}