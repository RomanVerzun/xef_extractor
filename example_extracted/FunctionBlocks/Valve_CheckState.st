(* ======================================== *)
(* FUNCTION BLOCK: Valve_CheckState *)
(* VERSION: 0.04 *)
(* Check Valve state *)
(* ======================================== *)

(* INPUT PARAMETERS *)
  Iterator : INT;

(* OUTPUT PARAMETERS *)
  End_Switch_State : INT;

(* PRIVATE VARIABLES *)
  Stop_Valve : Valve_Stop;


(* -------- PROGRAM: CheckState -------- *)
IF PROJECT.Valve[iterator].DI_End_Open AND NOT PROJECT.Valve[iterator].DI_End_Close THEN
    (* Відчинений *)
    End_Switch_State := PROJECT.States_t.Open;
    (* Якщо ми рухалися на відкриття — зупинити мотор *)
    IF PROJECT.Valve[iterator].DO_Motor_Open THEN
	(* Як можна швидше зупинити мотор *)
	Stop_Valve (Iterator := iterator);
    END_IF;

ELSIF NOT PROJECT.Valve[iterator].DI_End_Open AND PROJECT.Valve[iterator].DI_End_Close THEN
    (* Закритий *)
    End_Switch_State := PROJECT.States_t.Close;
    (* Якщо ми рухалися на закриття — зупинити мотор *)

    IF PROJECT.Valve[iterator].DO_Motor_Close THEN
	Stop_Valve (Iterator := iterator);
    END_IF;
	
ELSIF PROJECT.Valve[iterator].DI_End_Open AND PROJECT.Valve[iterator].DI_End_Close THEN
	(* TRUE TRUE — проблема *)
	End_Switch_State := PROJECT.States_t.Error;
	PROJECT.Valve[iterator].Errno := Project.Errors_t.Err_EndSwitchConflict;
	PROJECT.Valve[iterator].DO_Alarm := TRUE;
	(* Скинути мотор на всякий випадок *)
	Stop_Valve (Iterator := iterator);
ELSE 
	End_Switch_State := PROJECT.States_t.Middle;
END_IF;
