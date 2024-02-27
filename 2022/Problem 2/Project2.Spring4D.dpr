program Project2.Spring4D;

// https://adventofcode.com/2022/day/2
// Advent of Code 2022 Day 2 - Rock Paper Scissors

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.IOUtils,
  Spring,
  Spring.Collections;

type
  THandShape = (rock,paper,scissors);

  THandShapeHelper = record helper for THandShape
    function GetLosingShape : THandShape;
    function GetWinningShape : THandShape;
  end;

  TRound = class(TObject)
  private
    fFirstHand: THandShape;
    fSecondHand: THandShape;

    function HandScore: Integer;
    function Outcome: Integer;
    function TotalScore: Integer;

    property FirstHand: THandShape read fFirstHand write fFirstHand;
    property SecondHand: THandShape read fSecondHand write fSecondHand;
  end;

{ TRound }

function TRound.HandScore: Integer;
begin
  case fSecondHand of
    rock    : Result := 1;
    paper   : Result := 2;
    scissors: Result := 3;
  end;
end;

function TRound.Outcome: Integer;
var
  win: Boolean;
begin
  win := ((SecondHand = rock) and (FirstHand = scissors)) or ((SecondHand = paper) and (FirstHand = rock)) or
    ((SecondHand = scissors) and (FirstHand = paper));

  if win then
    Result := 6
  else if (SecondHand = FirstHand) then
    Result := 3 // draw
  else
    Result := 0; // loss
end;

function TRound.TotalScore: Integer;
begin
  Result := HandScore + Outcome;
end;

{ THandShapeHelper }

function THandShapeHelper.GetLosingShape: THandShape;
begin
  case Self of
    rock    : Result := scissors;
    paper   : Result := rock;
    scissors: Result := paper;
  end;
end;

function THandShapeHelper.GetWinningShape: THandShape;
begin
  case Self of
    rock    : Result := paper;
    paper   : Result := scissors;
    scissors: Result := rock;
  end;
end;

procedure Main;
var
  source: IEnumerable<string>;
  rounds, rounds2: IEnumerable<TRound>;
  scores, scores2: IEnumerable<Integer>;
begin
  source := TEnumerable.From<string>( TFile.ReadAllLines('..\..\Prob 2 Data.txt') );

  rounds := TCollections.CreateObjectList<TRound>(
    TEnumerable.Select<string,TRound>(
      source,
      function (const s: string): TRound
      const
        cChoiceOpponent: array ['A'..'C'] of THandShape = (rock,paper,scissors);
        cChoice: array ['X'..'Z'] of THandShape = (rock,paper,scissors);
      var
        arr: TArray<Char>;
      begin
        Result := TRound.Create;
        arr := s.ToCharArray;
        Result.FirstHand := cChoiceOpponent[ arr[0] ];
        Result.SecondHand := cChoice[ arr[2] ];
      end));

  scores := TEnumerable.Select<TRound,Integer>(
    rounds,
    function (const aRound: TRound): Integer
    begin
      Result := aRound.TotalScore;
    end);

  Writeln( 'Part 1 answer : ', scores.Sum);

  rounds2 := TCollections.CreateObjectList<TRound>(
    TEnumerable.Select<string,TRound>(
      source,
      function (const s: string): TRound
      const
        cChoiceOpponent: array ['A'..'C'] of THandShape = (rock,paper,scissors);
        cChoice: array ['X'..'Z'] of THandShape = (rock,paper,scissors);
      var
        arr: TArray<Char>;
      begin
        Result := TRound.Create;
        arr := s.ToCharArray;
        Result.FirstHand := cChoiceOpponent[ arr[0] ];
        case arr[2] of
          'X': Result.SecondHand := Result.FirstHand.GetLosingShape; // loss
          'Y': Result.SecondHand := Result.FirstHand; // draw
          'Z': Result.SecondHand := Result.FirstHand.GetWinningShape; // win
        end;
      end));

  scores2 := TEnumerable.Select<TRound,Integer>(
    rounds2,
    function (const aRound: TRound): Integer
    begin
      Result := aRound.TotalScore;
    end);

  Writeln( 'Part 2 answer : ', scores2.Sum);
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
