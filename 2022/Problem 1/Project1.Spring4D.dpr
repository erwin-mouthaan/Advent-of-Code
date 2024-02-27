program Project1.Spring4D;

// https://adventofcode.com/2022/day/1
// Advent of Code 2022 Day 1 - Calorie Counting

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  Spring.Collections;

procedure Main;
var
  sourceS: IEnumerable<string>;
  sourceSl: IEnumerable<TStrings>;
  sourceInt: IEnumerable<Integer>;
begin
   var sl := TStringList.Create;
   try
     sl.LineBreak := sLineBreak + sLineBreak;
     sl.LoadFromFile( '..\..\Prob 1 Data.txt' );
     // split it on double newlines
     sourceS := TEnumerable.From<string>( sl.ToStringArray );
   finally
     sl.Free;
   end;

   // list of tstrings - objectlist for automatic memory management
   sourceSl := TCollections.CreateObjectList<TStrings>( TEnumerable.Select<string,TStrings>(
     sourceS,
     function (const s: string): TStrings
     begin
       Result := TStringList.Create;
       Result.Text := s;
     end)
     );

   // list of integer
   sourceInt := TEnumerable.Select<TStrings,Integer>(
     sourceSl,
     function (const sl: TStrings): Integer
     begin
       Result := 0;
       for var s in sl do
         Result := Result + s.ToInteger;
     end);

   // max entry
   Writeln( sourceInt.Max );
   Writeln;

   // part 2
   // top 3 entries
   var total := 0;
   for var i in sourceInt.Ordered.TakeLast(3) do begin
     Writeln( i );
     total := total + i;
   end;

   Writeln( total );
end;

begin
  try
    Main;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

  Readln;
end.
