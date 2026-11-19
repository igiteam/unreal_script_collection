class Brush extends Actor
    native
    notplaceable
    hidecategories(lighting,Object,Movement,Display);

enum ECsgOper
{
    CSG_Active,                     // 0
    CSG_Add,                        // 1
    CSG_Subtract,                   // 2
    CSG_Intersect,                  // 3
    CSG_Deintersect,                // 4
    CSG_MAX                         // 5
};

struct GeomSelection
{
    var int Type;
    var int Index;
    var int SelectionIndex;
    var float SelStrength;

    structdefaultproperties
    {
        Type=0
        Index=0
        SelectionIndex=0
        SelStrength=0.0000000
    }
};

var() Brush.ECsgOper CsgOper;
var() Color BrushColor;
var() editconst int PolyFlags;
var() bool bColored;
var const export Model Brush;
var() const export editinline BrushComponent BrushComponent;
var array<GeomSelection> SavedSelections;

defaultproperties
{
    // Reference: BrushComponent'Default__Brush.BrushComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="BrushComponent0" class=Class'BrushComponent'
    end object
    BrushComponent=BrushComponent0
    bStatic=true
    bHidden=true
    bNoDelete=true
    bEdShouldSnap=true
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}