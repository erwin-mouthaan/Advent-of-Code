program Project7.Spring4D;

// https://adventofcode.com/2022/day/7
// Advent of Code 2022 Day 7 - No Space Left On Device

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.IOUtils,
  Spring,
  Spring.SystemUtils,
  Spring.Collections;

procedure Main;
var
  source: IEnumerable<string>;
  sizes: IDictionary<string,Integer>;
  query: IEnumerable<TPair<string,Integer>>;
  affected: IStack<string>;
begin
// https://nickymeuleman.netlify.app/garden/aoc2022-day07
  source := TEnumerable.From<string>( TFile.ReadAllLines('..\..\Prob 7 Data.txt') );

  source := source.Where(
    function (const x: string): Boolean
    begin
      Result := not (x.StartsWith('$ ls') or x.StartsWith('dir'));
    end);

  sizes := TCollections.CreateDictionary<string,Integer>;
  affected := TCollections.CreateStack<string>;

  source.ForEach(
    procedure (const s: string)
    var
      arr: TArray<string>;
      value: Integer;
    begin
      arr := SplitString(s,[' ']);

      if (arr[0] = '$') and (arr[1] = 'cd') and (arr[2] = '..') then
        affected.Pop
      else if (arr[0] = '$') and (arr[1] = 'cd') then
        affected.Push( arr[2] )
      else begin
        var size := arr[0].ToInteger;
        var path := EmptyStr;
        for var aff in affected.Reversed do begin
          path := path + aff;
          value := sizes.GetValueOrDefault(path);
          sizes[path] := value + size;
        end;
      end;
    end);

  query := sizes.Where(
    function (const pair: TPair<string,Integer>): Boolean
    begin
      Result := pair.Value <= 100_000;
    end);

  var part1 := query.Sum(
    function (const pair: TPair<string,Integer>): Integer
    begin
      Result := pair.Value;
    end);

  Writeln( 'Part 1 answer : ' + part1.ToString );

  var freeSpace := 70_000_000 - sizes['/'];
  var spaceToFree := 30_000_000 - freeSpace;

  query := sizes.Where(
    function (const pair: TPair<string,Integer>): Boolean
    begin
      Result := pair.Value > spaceToFree;
    end);

  var part2 := query.Min(
    function (const pair: TPair<string,Integer>): Integer
    begin
      Result := pair.Value;
    end);

  Writeln( 'Part 2 answer : ' + part2.ToString );
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
