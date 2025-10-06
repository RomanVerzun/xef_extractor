(* ======================================== *)
(* FUNCTION BLOCK: Valve_Process *)
(* VERSION: 0.10 *)
(* Process Valve (Main Valve block) *)
(* ======================================== *)

(* INPUT PARAMETERS *)
  Iterator : INT;

(* PRIVATE VARIABLES *)
  Stop : Valve_Stop;
  Open : Valve_Open;
  Close : Valve_Close;
  CheckState : Valve_CheckState;
  HalfSecond_Move : Valve_HalfSecond;
  Buttons_Move : Valve_MoveButtons;


(* -------- PROGRAM: Process -------- *)
(* Скид аварії *)
IF PROJECT.Valve[Iterator].DI_Rem_Reset_Err THEN
	Stop (Iterator := Iterator);
	PROJECT.Valve[Iterator].DO_Alarm := 0;
	PROJECT.Valve[Iterator].errno := PROJECT.Errors_t.NO_Err;
END_IF;


(* Пропуск, якщо є помилка *)
IF PROJECT.Valve[Iterator].Errno <> PROJECT.Errors_t.NO_Err THEN
	return;
END_IF;

(* ---------------------------- *)
(* Читання емульованих !!!!!!!!!!!!!!!!!!!!!! значень *)
PROJECT.Valve[Iterator].DI_End_Open := PROJECT.Emulate_Valve[Iterator].End_Open;
PROJECT.Valve[Iterator].DI_End_Close := PROJECT.Emulate_Valve[Iterator].End_Close;


(* ---------------------------- *)
(* 1. Зупинка *)
IF PROJECT.Valve[Iterator].DI_Rem_Stop THEN
	Stop (Iterator := Iterator);
	return;   (* стоп, не рухаємо далі логіку *)
END_IF;

IF PROJECT.Valve[Iterator].DO_Motor_Open AND PROJECT.Valve[Iterator].DO_Motor_Close THEN
	PROJECT.Valve[Iterator].errno := PROJECT.Errors_t.Err_MotorDirectionErr;
	PROJECT.Valve[Iterator].DO_Alarm := TRUE;
END_IF;

    (* ---------------------------- *)
    (* 2. Стан за кінцевиками *)
(* Стан кінцевиків і відключення моторів *)
CheckState (Iterator := Iterator,
         End_Switch_State => PROJECT.Valve[Iterator].state); 
(* ---------------------------- *)
(* 3. Локальне керування — має пріоритет *)

(* ---------------------------- *)
(* 4. Дистанційне керування *)


Buttons_Move (iterator := Iterator);

(* ---------------------------- *)
(* 5. Відкриття протягом 0.5 секунд *)

IF PROJECT.Valve[Iterator].DI_Rem_OpenHalf THEN
	 HalfSecond_Move ( Enable_Timer := True,
	Enable_Move := True,
	IS_Open := True,
    	Iterator := Iterator);
ELSIF PROJECT.Valve[Iterator].DI_Rem_CloseHalf THEN
	 HalfSecond_Move ( Enable_Timer := True,
	Enable_Move := True,
	IS_Open := False,
    	Iterator := Iterator);
ELSIF PROJECT.Valve[Iterator].Half_sec_Timer THEN
	 HalfSecond_Move ( Enable_Timer := True,
	Enable_Move := False,
	IS_Open := False,
    	Iterator := Iterator);
END_IF;
