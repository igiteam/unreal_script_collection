class SASTerroristGlobalAI extends Actor
	native;

// Cover point selection parameters
var float		mCoverMaxDist;				// Max range of CPs to be considered.
var float		mCoverDistRandFactor;
var float		mCoverDistCost;
var float		mCoverFacingCost;				
var float		mCoverCoveredCost;
var float		mCoverExposedCost;
var float		mCoverThreatDistCost;
var float		mCoverMinThreatDist;
var float		mCoverGroupCohesionCost;
var float		mCoverOptimalCohesionDist;
var float		mCoverBlockedLoFCost;
var float		mCoverBlockingOtherLoFCost;
var float		mCoverCorpseProximityCost;

// Times to hide behind cover between attacks
var float		mCoverHideTimeMinAggression;
var float		mCoverHideTimeMaxAggression;
var float		mCoverHideRandomScale;

// Retreat point selection parameters
//...





// Decompiled with UE Explorer.
defaultproperties
{
    mCoverMaxDist=1500.0000000
    mCoverDistRandFactor=0.2000000
    mCoverDistCost=1.0000000
    mCoverFacingCost=-0.2500000
    mCoverCoveredCost=-0.0200000
    mCoverExposedCost=3.0000000
    mCoverThreatDistCost=2.0000000
    mCoverMinThreatDist=150.0000000
    mCoverGroupCohesionCost=1.0000000
    mCoverOptimalCohesionDist=150.0000000
    mCoverBlockedLoFCost=1.0000000
    mCoverBlockingOtherLoFCost=1.0000000
    mCoverCorpseProximityCost=1.0000000
    mCoverHideTimeMinAggression=2.5000000
    mCoverHideTimeMaxAggression=1.5000000
    mCoverHideRandomScale=0.2500000
}