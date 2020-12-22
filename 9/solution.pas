(* FreePascal compiles this fine. Don't know about others *)

program Day9;

var
   ringbuffer : array[0..24] of Int64;
   cursor     : Integer;
   input      : Text;
   tmp	      : Int64;
   i	      : Integer;
   j	      : Integer;
   OK	      : boolean;
   target     : Int64;


begin
   assign(input, 'input.txt');
   reset(input);

   (* Fill the preamble *)
   for i := 0 to 24 do begin
      readln(input, ringbuffer[i]);
   end;
   cursor := 0;

   (* Then go on checking numbers *)
   repeat
      OK := false;
      readln(input, tmp);
      for i := 0 to 24 do begin
	 for j := 0 to 24 do begin
	    if (ringbuffer[i] + ringbuffer[j] = tmp) then begin
	       OK := true;
	       break;
	    end;
	 end;
      end;
      ringbuffer[cursor] := tmp;
      cursor := (cursor+1) mod 25;
   until (OK = false or eof(input));
   if ( OK = false ) then begin
      writeln(tmp);
      target := tmp;
   end;
   (* End of part 1, now the tricky stuff begins... *)

   reset(input);
   (* Need to implement some dynamic array type of deal to keep
    an unknown number of Int64s in so they can be added. 
    A linked list will probably do. *)

   (* Read number from file *)
   (* Sum up all in list *)
   (* If sum > number drop head from list and redo sum *)
   (* If sum = number: ka-ching! *)
   (* else add number to tail of list  and read next*)
   
end.
