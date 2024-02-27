program Project5.Spring4D;

// https://adventofcode.com/2022/day/5
// Advent of Code 2022 Day 5 - Supply Stacks

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.IOUtils,
  Spring,
  Spring.SystemUtils,
  Spring.Collections;

function GetStacks: IList<IStack<Char>>;
var
  stacks: IList<IStack<Char>>;
begin
  stacks := TCollections.CreateList<IStack<Char>>;
  stacks.Add( TCollections.CreateStack<Char>( 'ZN'.ToCharArray ) );
  stacks.Add( TCollections.CreateStack<Char>( 'MCD'.ToCharArray ) );
  stacks.Add( TCollections.CreateStack<Char>( ['P'] ) );


  Result := stacks;
end;

procedure Main;
var
  stacks: IList<IStack<Char>>;
  source: IEnumerable<string>;
  moves: IList<Tuple<Integer,Integer,Integer>>;
  topCrates: string;
begin
  source := TEnumerable.From<string>(TFile.ReadAllLines( '../../Prob 5 Data.txt' ))
    .SkipWhile(
      function (const s: string): Boolean
      begin
        Result := not s.StartsWith('move');
      end);

  moves := TCollections.CreateList<Tuple<Integer,Integer,Integer>>(
    TEnumerable.Select<string,Tuple<Integer,Integer,Integer>>(
      source,
      function (const s: string): Tuple<Integer,Integer,Integer>
      var
        arr: TArray<string>;
        iMove, iFrom, iTo: Integer;
      begin
        arr := SplitString(s,[' ']);
        iMove := arr[1].ToInteger;
        iFrom := arr[3].ToInteger - 1;
        iTo := arr[5].ToInteger - 1;
        Result := Tuple.Create(iMove,iFrom,iTo);
      end));

  stacks := GetStacks;

  moves.ForEach(
    procedure (const t: Tuple<Integer,Integer,Integer>)
    begin
      for var i := 1 to t.Value1 do
        stacks[t.Value3].Push( stacks[t.Value2].Pop );
    end);

  topCrates := TEnumerable.Aggregate<IStack<Char>,string>(
    stacks,
    EmptyStr,
    function (const s: string; const stack: IStack<Char>): string
    begin
      Result := s + stack.Peek;
    end);

  Writeln( 'Part 1 answer : ' + topCrates );

  stacks := GetStacks;

  moves.ForEach(
    procedure (const t: Tuple<Integer,Integer,Integer>)
    var
      tempStack: IStack<Char>;
    begin
      tempStack := TCollections.CreateStack<Char>([]);
      for var i := 1 to t.Value1 do
        tempStack.Push( stacks[t.Value2].Pop );

      for var i := 1 to t.Value1 do
        stacks[t.Value3].Push( tempStack.Pop );
    end);

  topCrates := TEnumerable.Aggregate<IStack<Char>,string>(
    stacks,
    EmptyStr,
    function (const s: string; const stack: IStack<Char>): string
    begin
      Result := s + stack.Peek;
    end);

  Writeln( 'Part 2 answer : ' + topCrates );
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
