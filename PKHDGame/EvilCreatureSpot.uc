class EvilCreatureSpot extends Info
    hidecategories(Navigation,Movement,Collision);

var float Radius;
var() const editconst export editinline DrawSphereComponent RadiusComponent;
var() bool bCheckCollision;

function PreBeginPlay()
{
    Radius = RadiusComponent.SphereRadius;
    super(Actor).PreBeginPlay();
    //return;    
}

defaultproperties
{
    // Reference: DrawSphereComponent'Default__EvilCreatureSpot.DrawSphere0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'DrawSphere0'
    begin object name="DrawSphere0" class=Class'Engine.DrawSphereComponent'
        SphereColor=(R=64,G=70,B=255,A=255)
        SphereRadius=64.0000000
        ReplacementPrimitive=none
    end object
    RadiusComponent=DrawSphere0
    bCheckCollision=true
    Components[0]=none
    Components[1]=DrawSphere0
}