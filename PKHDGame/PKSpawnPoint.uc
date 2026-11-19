class PKSpawnPoint extends EvilSpawnPoint
    native(Sequence)
    hidecategories(Navigation,Lighting,LightColor,Force);

var() bool NotCountable;
var() bool UseSpawnAngle;
var() int GroupCount;
var() float GroupDelay;
var() int GroupSize;
var() float EachDelay;
var() float StartDelay;
var() editoronly string PKMonsterClass;
var() PKTypes.EAITypes MonsterType;
var() PKWalkArea WalkArea;
var class<AIController> ControllerClass;
var init array< init class<Pawn> > PawnClassArray;
var string FactoryClassName;

defaultproperties
{
    FactoryClassName="SeqAct_PKAIFactory"
    // Reference: CylinderComponent'Default__PKSpawnPoint.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'EvilGame.Default__EvilSpawnPoint.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=none
    Components[2]=none
    CollisionComponent=CollisionCylinder
}