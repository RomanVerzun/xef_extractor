(* ======================================== *)
(* FUNCTION BLOCK: Valve_MoveButtons *)
(* VERSION: 0.09 *)
(* Proccesing of Physical and Remote open buttons (maybe split it) *)
(* ======================================== *)

(* INPUT PARAMETERS *)
  iterator : INT;

(* PRIVATE VARIABLES *)
  Open : Valve_Open;
  Close : Valve_Close;
  Stop : Valve_Stop;
  TON : Valve_TON_case;


(* -------- PROGRAM: Buttons_move -------- *)
IF (NOT PROJECT.Valve[Iterator].Prev_Loc_Open AND PROJECT.Valve[Iterator].DI_Loc_Open) THEN 
    (* фронт натискання OPEN *) 
    	Stop (Iterator := Iterator);
    	Open (Iterator := Iterator);

ELSIF (PROJECT.Valve[Iterator].Prev_Loc_Open) AND (NOT PROJECT.Valve[Iterator].DI_Loc_Open) THEN
    (* фронт відпускання OPEN *)
    	IF NOT PROJECT.Valve[Iterator].DI_Loc_Open THEN
		PROJECT.Valve[Iterator].DO_Motor_Enable := FALSE;
	END_IF;
	PROJECT.Valve[Iterator].DO_Motor_Open   := FALSE;
END_IF;

IF (NOT PROJECT.Valve[Iterator].Prev_Loc_Close AND PROJECT.Valve[Iterator].DI_Loc_Close) THEN
    (* фронт натискання CLOSE *)
    	Stop (Iterator := Iterator);
	Close (Iterator := Iterator);

ELSIF (PROJECT.Valve[Iterator].Prev_Loc_Close) AND (NOT PROJECT.Valve[Iterator].DI_Loc_Close) THEN
    (* фронт відпускання CLOSE *)
    	IF NOT PROJECT.Valve[Iterator].DI_Loc_Close THEN
		PROJECT.Valve[Iterator].DO_Motor_Enable := FALSE;
	END_IF;
	PROJECT.Valve[Iterator].DO_Motor_Close  := FALSE;
END_IF;

(* оновлення пам’яті *)
PROJECT.Valve[Iterator].Prev_Loc_Open  := PROJECT.Valve[Iterator].DI_Loc_Open;
PROJECT.Valve[Iterator].Prev_Loc_Close := PROJECT.Valve[Iterator].DI_Loc_Close;


(* Обробка дистанційних кнопок окремо, для пріорітетності локальних, та запуску таймера *)

IF (PROJECT.Valve[iterator].Timeout_Timer) THEN
	TON (Iterator := Iterator,
       		IN := TRUE,
       		PT := DINT_TO_TIME(PROJECT.Valve_timeout_ms),
       		Q => PROJECT.Valve[iterator].TON_Q,
     		ET => PROJECT.Valve[iterator].TON_Elapsed_Time);
	
	IF (PROJECT.Valve[iterator].TON_Q) THEN
	
		Stop (Iterator := Iterator);
		PROJECT.Valve[iterator].errno := PROJECT.Errors_t.Err_timeout;
		PROJECT.Valve[iterator].Do_Alarm := TRUE;
		PROJECT.Valve[iterator].Timeout_Timer := FALSE;
	
	END_IF;		
ELSE 
	TON (Iterator := Iterator,
		IN := FALSE,
	       	PT := DINT_TO_TIME(0),
	       	Q => PROJECT.Valve[iterator].TON_Q,
	     	ET => PROJECT.Valve[iterator].TON_Elapsed_Time);

END_IF;

IF (PROJECT.Valve[Iterator].DI_Rem_Open) THEN
	Open (Iterator := Iterator);
	TON (Iterator := Iterator,
       		IN := TRUE,
       		PT := DINT_TO_TIME(PROJECT.Valve_timeout_ms),
       		Q => PROJECT.Valve[iterator].TON_Q,
     		ET => PROJECT.Valve[iterator].TON_Elapsed_Time);
	PROJECT.Valve[iterator].Timeout_Timer := TRUE;
ELSIF (PROJECT.Valve[Iterator].DI_Rem_Close) THEN
	Close (Iterator := Iterator);
	TON (Iterator := Iterator,
       		IN := TRUE,
       		PT := DINT_TO_TIME(PROJECT.Valve_timeout_ms),
       		Q => PROJECT.Valve[iterator].TON_Q,
     		ET => PROJECT.Valve[iterator].TON_Elapsed_Time);
	PROJECT.Valve[iterator].Timeout_Timer := TRUE;
END_IF;
