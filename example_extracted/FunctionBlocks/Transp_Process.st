(* ======================================== *)
(* FUNCTION BLOCK: Transp_Process *)
(* VERSION: 0.10 *)
(* Process Transport (Main Transport block) *)
(* ======================================== *)

(* INPUT PARAMETERS *)
  Iterator : INT;

(* PRIVATE VARIABLES *)
  Start : Transp_Start;
  Stop : Transp_Stop;
  BeltDrift : Transp_DriftTimer;


(* -------- PROGRAM: Transp_process -------- *)
(* Кнопка скиду помилки *)

IF PROJECT.transp[iterator].DI_Reset_Alarm THEN

	PROJECT.transp[iterator].errno := PROJECT.errors_t.No_err;

	PROJECT.transp[iterator].DI_BeltDrift[0].ErrorBelt := FALSE;
	PROJECT.transp[iterator].DI_BeltDrift[1].ErrorBelt := FALSE;
	PROJECT.transp[iterator].DI_BeltDrift[2].ErrorBelt := FALSE;
	PROJECT.transp[iterator].DI_BeltDrift[3].ErrorBelt := FALSE;

END_IF;


(* Читання стану BELT_DRIFT на 4х "кінцевиках" 3 cекунди *)
BeltDrift (Iterator := Iterator);

(* Пропускаємо обробку, якщо є помилка *)
IF PROJECT.Transp[Iterator].Errno <> Project.Errors_t.No_Err THEN
	return;
END_IF;





IF Project.Transp[Iterator].DI_Start OR 
	Project.Transp[Iterator].DI_Rem_Start THEN
	
	Start( Iterator := Iterator );
END_IF;



IF Project.Transp[Iterator].DI_Stop OR 
	Project.Transp[Iterator].DI_Rem_Stop THEN
	
	Stop( Iterator := Iterator );
END_IF;
