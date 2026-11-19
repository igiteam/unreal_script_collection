class SPScout extends Scout
    transient
    native
    config(Game);

var float minFloorToWallZDelta;
var float maxFloorToWallZDelta;
var float minFloorToWallLength;
var float maxFloorToWallLength;
var float minFloorToWallCos;
var float maxFloorToWallCos;
var float minWallConnectionLength;
var float maxWallConnectionLength;
var float minWallInnerCornerConnectionLength;
var float maxWallInnerCornerConnectionLength;
var float minOppositeWallConnectionLength;
var float maxOppositeWallConnectionLength;
var float minGappedWallConnection;
var float maxGappedWallConnection;
var float WallSpeed;
var float extraWallJumpSpeedMultiplier;
var float wallJumpTimeDilation;
