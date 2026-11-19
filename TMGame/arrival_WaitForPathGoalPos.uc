class arrival_WaitForPathGoalPos extends CoreTask within animscripts_cover_arrival;

// parameter

// output

// local

state main
{
Begin:
	while (true)
	{
		if (pathgoalpos != invalid_vector)
			_return();

		wait (1);
	}
}
