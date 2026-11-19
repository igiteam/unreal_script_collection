class HealthInventory extends Inventory;

var int Amount;

function GiveTo( pawn Other )
{
	Other.Health = FClamp(Other.Health+Amount, Other.Health, 100);

	destroy();
}
