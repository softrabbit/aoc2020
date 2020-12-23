(* FreePascal compiles this fine. Don't know about others. *)

program Day9;

type
   (* single linked list to use as a FIFO *)
   Int64List  = ^Int64Node; 
   Int64Node  = record
		   i	: Int64;
		   next	: Int64List;
		end;

var
   ringbuffer : array[0..24] of Int64;
   cursor     : Integer;
   input      : Text;
   tmp	      : Int64;
   i	      : Integer;
   j	      : Integer;
   OK	      : boolean;
   (* For part 2 *)
   sum        : Int64;
   target     : Int64;
   head	      : Int64List; 
   tail	      : Int64List;
   min        : Int64;
   max        : Int64;
   
(* Adds a new Int64 node to the list and return the pointer *)
function addL(l : Int64List; i: Int64) : Int64List;
var tmp	:  Int64List;
begin
   new(tmp);
   tmp^.i := i;
   tmp^.next := Nil;
   (* Empty list? *)
   if( l <> Nil )then begin
      l^.next := tmp;
   end;
   addL := tmp;
end;

(* Remove the node pointed to and return next *)
function removeL(l : Int64List) : Int64List;
begin
   removeL := l^.next;
   dispose(l);
end;

(* Returns the head value *)
function valueL(l : Int64List) : Int64;
begin
   valueL := l^.i;
end;



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
   close(input);
   reset(input);
   head := Nil;
   tail := Nil;
   sum  := 0;
   OK := false;

   while OK <> true and not eof(input) do begin
      (* Read number from file *)
      readln(input, tmp);

      (* put in tail end of list, add to sum *)
      tail := addL(tail, tmp);
      if(head = Nil) then begin
	 (* empty list? *)
	 head := tail;
      end;
      sum := sum + tmp;

      (* drop head from list and adjust sum down to below target *)
      while (sum > target) and (head<>Nil) do begin
	 sum := sum - valueL(head);
	 head := removeL(head);
      end;
      
      if sum = target then begin
	 OK := true;
	 break;
      end; 
   end; 

   (* Then find min and max in the list and add together *)
   max := 0;
   min := sum;
   while head<>Nil do begin
      tmp := valueL(head);
      head := removeL(head);
      if tmp < min then min := tmp;
      if tmp > max then max := tmp;
   end;
   writeln (min + max);
end.
