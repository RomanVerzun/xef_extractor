(* ======================================== *)
(* PROGRAM: Valve_Emulate *)
(* TYPE: section *)
(* TASK: FAST *)
(* SECTION ORDER: 1 *)
(* ======================================== *)

FOR Valve_Emulator_iterator := 0 TO Valve_count DO
	(* SKIP, IF THERE ARE ERROR
		TODO :: ERROR PROCESSING*)
	IF Valve[Valve_Emulator_iterator].Errno <> Errors_t.NO_Err THEN
		JMP CONTINUE;
	END_IF;
	
	IF Valve[Valve_Emulator_iterator].DO_MOTOR_ENABLE  THEN
		IF Valve[Valve_Emulator_iterator].DO_Motor_Open THEN
			(* Обраховуємо час 1 крока *)
			IF Emulate_Valve[Valve_Emulator_iterator].Open_Step_ms = 0 THEN
				Emulate_Valve[Valve_Emulator_iterator].Open_Step_ms := Emulate_Valve[Valve_Emulator_iterator].Open_Time_ms / 100;
			END_IF;

			IF NOT Emulate_Valve[Valve_Emulator_iterator].End_Open THEN
				IF Emulate_Valve[Valve_Emulator_iterator].Valve_Move THEN
					Emulate_Valve[Valve_Emulator_iterator].Procentage := Emulate_Valve[Valve_Emulator_iterator].Procentage + 1;
					Emulate_Valve[Valve_Emulator_iterator].End_Close := FALSE;
					TON_Enable (Iterator := Valve_Emulator_iterator, State := FALSE, Time_wait := Emulate_Valve[Valve_Emulator_iterator].Open_Step_ms); 
					IF Emulate_Valve[Valve_Emulator_iterator].Procentage = 100 THEN
						Emulate_Valve[Valve_Emulator_iterator].End_Open := TRUE;
						JMP CONTINUE;	
					END_IF;

				END_IF; 
				(* Не повністтю відкритий *)
				TON_Enable (Iterator := Valve_Emulator_iterator, State := TRUE, Time_wait := Emulate_Valve[Valve_Emulator_iterator].Open_Step_ms);
				(* ЗАПУСК ТАЙМЕРУ ЕМУЛЯЦІЇ ДЕВАЙСІВ *)
 

			ELSE 
				JMP CONTINUE;	
			END_IF;

		ELSIF Valve[Valve_Emulator_iterator].DO_Motor_Close THEN
			IF Emulate_Valve[Valve_Emulator_iterator].Close_Step_ms = 0 THEN
				Emulate_Valve[Valve_Emulator_iterator].Close_Step_ms := Emulate_Valve[Valve_Emulator_iterator].Close_Time_ms / 100;
			END_IF;

			IF NOT Emulate_Valve[Valve_Emulator_iterator].End_Close THEN
			
				IF Emulate_Valve[Valve_Emulator_iterator].Valve_Move THEN
					Emulate_Valve[Valve_Emulator_iterator].Procentage := Emulate_Valve[Valve_Emulator_iterator].Procentage - 1;
					Emulate_Valve[Valve_Emulator_iterator].End_Open := FALSE;
					TON_Enable (Iterator := Valve_Emulator_iterator, State := FALSE, Time_wait := Emulate_Valve[Valve_Emulator_iterator].Close_Step_ms); 
					IF Emulate_Valve[Valve_Emulator_iterator].Procentage = 0 THEN
						Emulate_Valve[Valve_Emulator_iterator].End_Close := TRUE;
						JMP CONTINUE;	
					END_IF;

				END_IF;
				(* Не повністтю відкритий *)
				TON_Enable (Iterator := Valve_Emulator_iterator, State := TRUE, Time_wait := Emulate_Valve[Valve_Emulator_iterator].Close_Step_ms);
				(* ЗАПУСК ТАЙМЕРУ ЕМУЛЯЦІЇ ДЕВАЙСІВ *)


			ELSE 
				JMP CONTINUE;	
			END_IF;
		END_IF;
	END_IF;
	CONTINUE:
END_FOR;