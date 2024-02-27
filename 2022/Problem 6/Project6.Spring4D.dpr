program Project6.Spring4D;

// https://adventofcode.com/2022/day/6
// Advent of Code 2022 Day 6 - Tuning Trouble

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.IOUtils,
  Spring,
  Spring.Collections;

function GetPositionFirstTimeMarker(const aNumberDistinctValues: Integer; const source: IEnumerable<Char>): Integer;
var
  sequence: TArray<Char>;
begin
  Result := -1;
  for var i := aNumberDistinctValues to Pred(source.Count) do begin

    SetLength(sequence,aNumberDistinctValues);
    TArray.Copy<Char>( source.ToArray, sequence, i-aNumberDistinctValues, 0, aNumberDistinctValues );

    if TEnumerable.From<Char>(sequence).Distinct.Count = aNumberDistinctValues then begin
      Result := i;
      Break;
    end;
  end;
end;

procedure Main;
var
  source: IEnumerable<Char>;
  idx: Integer;
begin
  source := TEnumerable.From<Char>( TFile.ReadAllText('..\..\Prob 6 Data.txt').ToCharArray );

  idx := GetPositionFirstTimeMarker(4,source);
  Writeln( 'Part 1 answer : ' + idx.ToString );

  idx := GetPositionFirstTimeMarker(14,source);
  Writeln( 'Part 2 answer : ' + idx.ToString );
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

