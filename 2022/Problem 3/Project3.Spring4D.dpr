program Project3.Spring4D;

// https://adventofcode.com/2022/day/3
// Advent of Code 2022 Day 3 - Rucksack Reorganization

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.IOUtils,
  System.Character,
  Spring.Collections;

type
  TRuckSack = class
    Left: IEnumerable<Char>;
    Right: IEnumerable<Char>;
  end;

procedure Main;
var
  source: IEnumerable<string>;
  rucksacks: IEnumerable<TRuckSack>;
  mispackeds, badges: IEnumerable<Char>;
begin
  source := TEnumerable.From<string>( TFile.ReadAllLines('..\..\Prob 3 Data.txt') );

  rucksacks := TCollections.CreateObjectList<TRuckSack>(
    TEnumerable.Select<string,TRuckSack>(
      source,
      function (const s: string): TRuckSack
      begin
        Result := TRuckSack.Create;
        Result.Left :=  TEnumerable.From<Char>( s.ToCharArray( 0, Length(s) div 2 ) );
        Result.Right := TEnumerable.From<Char>( s.ToCharArray( Length(s) div 2, Length(s) div 2 ) );
      end));

  mispackeds := TEnumerable.Select<TRuckSack,Char>(
    rucksacks,
    function (const r: TRuckSack): Char
    begin
      Result := r.Left.Intersect( r.Right ).First;
    end);

  var total := mispackeds.Sum(
    function (const c: Char): Integer
    begin
      if c.IsLower then
        Result := Ord(c) - 96 // Ord('a') = 97 --> 1
      else
        Result := Ord(c) - 38 // Ord('A') = 65 --> 27
    end);

  Writeln( 'Part 1 answer : ', total);

  badges := TEnumerable.Select<TArray<string>,Char>(
    TEnumerable.Chunk<string>(source,3),
    function (const x: TArray<string>): Char
    begin
      Result := TEnumerable.From<Char>( x[0].ToCharArray )
        .Intersect( TEnumerable.From<Char>( x[1].ToCharArray ))
        .Intersect( TEnumerable.From<Char>( x[2].ToCharArray )).First;
    end);

  var total2 := badges.Sum(
  function (const c: Char): Integer
  begin
    if c.IsLower then
      Result := Ord(c) - 96 // Ord('a') = 97 --> 1
    else
      Result := Ord(c) - 38 // Ord('A') = 65 --> 27
  end);

  Writeln( 'Part 2 answer : ', total2);
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



