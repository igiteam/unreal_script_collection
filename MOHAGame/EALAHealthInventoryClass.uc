class EALAHealthInventoryClass extends Inventory
    abstract
    hidecategories(Navigation);

var string DisplayName;

defaultproperties
{
    DisplayName="Health"
    // Reference: SpriteComponent'Default__EALAHealthInventoryClass.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: DynamicLightEnvironmentComponent'Default__EALAHealthInventoryClass.MyLightEnvironment'
    begin object name=MyLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
    end object
    Components[1]=MyLightEnvironment
}