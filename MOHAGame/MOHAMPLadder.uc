class MOHAMPLadder extends Actor
    native
    placeable
    hidecategories(Navigation);

var const export editinline SpriteComponent TopSprite;
var const export editinline SpriteComponent BottomSprite;
var() float LadderHeight;
var() PhysicalMaterial PhysMaterial;

defaultproperties
{
    // Reference: SpriteComponent'Default__MOHAMPLadder.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        Sprite=Texture2D'EngineResources.S_NavP'
        HiddenGame=true
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    TopSprite=Sprite
    // Reference: SpriteComponent'Default__MOHAMPLadder.Sprite2'
    begin object name=Sprite2 class=Class'Engine.SpriteComponent'
        Sprite=Texture2D'EngineResources.S_NavP'
        HiddenGame=true
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    BottomSprite=Sprite2
    PhysMaterial=PhysicalMaterial'GCm_PhysMaterials.Metal_Rung_Ladder'
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__MOHAMPLadder.Arrow'
    begin object name=Arrow class=Class'Engine.ArrowComponent'
        ArrowColor=(R=50,G=20,B=55,A=255)
        ArrowSize=5.0000000
    end object
    Components[2]=Arrow
    bNoDelete=true
}