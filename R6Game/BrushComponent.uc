class BrushComponent extends PrimitiveComponent
    native
    editinlinenew
    collapsecategories
    noexport;

struct KCachedConvexData_Mirror
{
    var array<int> CachedConvexElements;

    structdefaultproperties
    {
        CachedConvexElements=none
    }
};

var const Model Brush;
var native const Pointer WireObject;
var KAggregateGeom BrushAggGeom;
var private native const KCachedConvexData_Mirror CachedPhysBrushData;
