class SPWallPathPlacementHelperProperty extends Object
    native
    editinlinenew;

/** INCLUDES MACROS STRUCT DECLARATIONS VARIABLE DECLARATIONS */
var() SPWallPathNodeProperty StartProperty;
var() class<SPPathNode> StartClass;
var() SPWallPathNodeProperty EndProperty;
var() class<SPPathNode> EndClass;
var() name AnimationConnectionName;
var() Texture2D Sprite;
var(SecondaryProperties) array<SPWallPathNodeProperty> SecondaryStartProperties;
var(SecondaryProperties) array<SPWallPathNodeProperty> SecondaryEndProperties;
