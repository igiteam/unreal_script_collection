class TurokHitReactionDirectionSettings extends Component
    hidecategories(Object);

var() editconst byte Direction;
var() float MaxAngle;
var() float MaxDamage;
var() float MinDamage;
var() float MaxTranslation;
var() float RecoveryTime;
var() float MaxHeadshotRotation;
var() float MovementDampen;
var() float MinMoveAmount;
var() float MovementDampenRecover;
var() @NULL MovementAnglesPercentages;
var() @NULL MovementAnglesVariance;

defaultproperties
{
    MaxAngle=15.0000000
    MaxDamage=75.0000000
    MinDamage=1.0000000
    MaxTranslation=8.0000000
    RecoveryTime=0.4000000
    MaxHeadshotRotation=40.0000000
    MovementDampen=0.1000000
    MinMoveAmount=0.2000000
    MovementDampenRecover=0.2000000
    MovementAnglesPercentages=(X=0.0000000,Y=1.0000000,Z=0.0000000)
    MovementAnglesVariance=(X=0.2000000,Y=0.2000000,Z=0.2000000)
}