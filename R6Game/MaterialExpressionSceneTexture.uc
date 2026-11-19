class MaterialExpressionSceneTexture extends MaterialExpression within Material
    native
    collapsecategories
    hidecategories(Object);

enum ESceneTextureType
{
    SceneTex_Lighting,              // 0
    SceneTex_MAX                    // 1
};

var ExpressionInput Coordinates;
var() MaterialExpressionSceneTexture.ESceneTextureType SceneTextureType;
