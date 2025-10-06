(* ======================================== *)
(* FUNCTION BLOCK: Valve_Get_Times *)
(* VERSION: 0.07 *)
(* UNUSED Get time of close|openning *)
(* ======================================== *)

(* INPUT PARAMETERS *)
  Iterator : INT;

(* OUTPUT PARAMETERS *)
  OpenTime_ms : INT;
  CloseTime_ms : INT;

(* PRIVATE VARIABLES *)
  TON_0 : TON;
  TON_1 : TON;
  TON_Enable : Valve_TON_Enable;


(* -------- PROGRAM: InitTime -------- *)
(*	OPEN  | CLOSE
•	FALSE |	TRUE 	— Відкрита заслінка (Open зімкнутий, Close розімкнутий).
•       TRUE  |	FALSE 	— Закрита заслінка (Close зімкнутий, Open розімкнутий).
•	FALSE |	FALSE 	— Проблема на лінії (обидва розімкнуті).
•	TRUE  |	TRUE 	— Проміжний стан (обидва зімкнуті).
*)
(*
IF NOT Project.Valve[iterator].DI_End_Open AND Project.Valve[iterator].DI_End_Close THEN

	(*TON_Enable (Iterator := INT_TO_DINT(iterator),
	            State := TRUE,
	            Time_wait := 15000);)

ELSIF Project.Valve[iterator].DI_End_Open AND NOT Project.Valve[iterator].DI_End_Close THEN

ELSIF NOT Project.Valve[iterator].DI_End_Open AND NOT Project.Valve[iterator].DI_End_Close THEN

ELSE 

END_IF; 
*)
