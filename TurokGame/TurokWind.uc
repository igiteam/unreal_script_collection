class TurokWind extends Info
    native
    hidecategories(Navigation,Movement,Collision);

var() const editconst export editinline @NULL mpWindComponent;

defaultproperties
{
    // Reference: TurokWindComponent'Default__TurokWind.TurokWindComponent0'
    begin object name=TurokWindComponent0 class=Class'TurokWindComponent'
    end object
    mpWindComponent=TurokWindComponent0
    bStatic=true
    bNoDelete=true
    // Reference: SpriteComponent'Default__TurokWind.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=TurokWindComponent0
}