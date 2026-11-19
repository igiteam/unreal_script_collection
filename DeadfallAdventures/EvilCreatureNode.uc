class EvilCreatureNode extends Info
    hidecategories(Navigation,Movement,Collision);

var float Radius;
var() const editconst export editinline DrawSphereComponent RadiusComponent;

function PreBeginPlay()
{
    Radius = RadiusComponent.SphereRadius;
    super(Actor).PreBeginPlay();
    //return;    
}

defaultproperties
{
    // Reference: DrawSphereComponent'Default__EvilCreatureNode.DrawSphere0'
    begin object name=DrawSphere0 class=Class'Engine.DrawSphereComponent'
        SphereColor=(R=64,G=70,B=255,A=255)
        SphereRadius=64.0000000
        ReplacementPrimitive=none
    end object
    RadiusComponent=DrawSphere0
    Components[0]=none
    Components[1]=DrawSphere0
}