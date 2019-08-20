ScriptComponent @gMapWizard;

void MapWizard_main(ScriptComponent @p)
{
	// Init happens here if necessary
	@gMapWizard = p; 

	p.setMainFunction("mainState");
}

void MapWizard_mainState(ScriptComponent @p)
{
	
	while(true)
	{
		auto pos = p.position();
		p.setViewCenter(pos.x, pos.y);
		// Controls

		auto input = p.input();
		MapWizard_move(p, input);

		p.suspend();
	}
	
}

void MapWizard_move(ScriptComponent @p, const InputEvent &input)
{
	float speed = 5.0f;
	// Movement

	float moveX = 0;
	float moveY = 0;
	
	if (input.stickLeftX < -0.1 or input.stickLeftX > 0.1)
	{
		moveX = input.stickLeftX;	
	} 
	if (input.stickLeftY < -0.1 or input.stickLeftY > 0.1)
	{
		moveY = input.stickLeftY;	
	}

	if (moveX == 0 and moveY == 0)
	{
		p.playAnimation("idle");
	}
	else
	{
		float mag = sqrt(moveX **2 + moveY ** 2);
		moveX /= mag;
		moveY /= mag;
		moveX *= speed;
		moveY *= speed;
		p.playAnimation("walking");
	}
	p.setMomentum(moveX, moveY);
}