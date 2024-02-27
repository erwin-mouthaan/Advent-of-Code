program Project4.Spring4D;

// https://adventofcode.com/2022/day/4
// Advent of Code 2022 Day 4 - Camp Cleanup

{$APPTYPE CONSOLE}

uses
  System.StrUtils,
  System.SysUtils,
  System.IOUtils,
  Spring,
  Spring.Collections;

type
  TAssignment = class
  public
    Start: Integer;
    &End: Integer;
    constructor Create(const aStart, aEnd: Integer);
    function FullyContains(const a: TAssignment): Boolean;
    function Overlap(const a: TAssignment): Boolean;
  end;

{ TAssignment }

function TAssignment.FullyContains(const a: TAssignment): Boolean;
begin
  Result := (Start <= a.Start) and (&End >= a.&End);
end;

function TAssignment.Overlap(const a: TAssignment): Boolean;
begin
  Result := not ((&End < a.Start) or (Start > a.&End));
end;

constructor TAssignment.Create(const aStart, aEnd: Integer);
begin
  inherited Create;
  Start := aStart;
  &End := aEnd;
end;

procedure Main;
var
  source: IEnumerable<string>;
  assignments, fullyContainedAssignments, overlappedAssignments: IEnumerable<Tuple<TAssignment,TAssignment>>;
begin
  source := TEnumerable.From<string>( TFile.ReadAllLines('..\..\Prob 4 Data.txt') );

  assignments := TEnumerable.Select<string,Tuple<TAssignment,TAssignment>>(
    source,
    function (const s: string): Tuple<TAssignment,TAssignment>
    var
      arr: TArray<string>;
    begin
      arr := SplitString(s,',');

      var first := TAssignment.Create( SplitString(arr[0],'-')[0].ToInteger, SplitString(arr[0],'-')[1].ToInteger );
      var second := TAssignment.Create( SplitString(arr[1],'-')[0].ToInteger, SplitString(arr[1],'-')[1].ToInteger );

      Result := Tuple<TAssignment,TAssignment>.Create(first,second);
    end);

  fullyContainedAssignments := assignments.Where(
    function (const tup: Tuple<TAssignment,TAssignment> ): Boolean
    begin
      Result := tup.Value1.FullyContains( tup.Value2 ) or tup.Value2.FullyContains( tup.Value1 );
    end);

  overlappedAssignments := assignments.Where(
    function (const tup: Tuple<TAssignment,TAssignment> ): Boolean
    begin
      Result := tup.Value1.Overlap( tup.Value2 );
    end);

  Writeln( 'Part 1 answer : ', fullyContainedAssignments.Count );
  Writeln( 'Part 2 answer : ', overlappedAssignments.Count);
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


