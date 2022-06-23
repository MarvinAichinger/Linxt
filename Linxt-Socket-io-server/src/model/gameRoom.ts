import { PlayerInfo } from "./player";

export class GameRoom {
  _gameroomId: string;
  _player1: string;
  _player2: string;
  _status: GameStatus;
  _player1Info: PlayerInfo;
  _player2Info: PlayerInfo;

  constructor() {
    this._gameroomId = "unset";
    this._player1 = "unset";
    this._player2 = "unset";
    this._status = GameStatus.waiting;
    this._player1Info = new PlayerInfo();
    this._player2Info = new PlayerInfo();
  }

  get gameroomId(): string {
    return this._gameroomId;
  }

  get player1(): string {
    return this._player1;
  }

  get player2(): string {
    return this._player2;
  }

  get status(): GameStatus {
    return this._status;
  }

  set player1(name: string) {
    this._player1 = name;
  }

  set player2(name: string) {
    this._player2 = name;
  }

  set status(status: GameStatus) {
    this._status = status;
  }

  set gameroomId(id: string) {
    this._gameroomId = id;
  }

  get isFull(): boolean {
    return this._player1 !== "unset" && this._player2 !== "unset";
  }

  get player1Info(): PlayerInfo {
    return this._player1Info;
  }

  get player2Info(): PlayerInfo {
    return this._player2Info;
  }

  set player1Info(playerInfo: PlayerInfo) {
    this._player1Info = playerInfo;
  }

  set player2Info(playerInfo: PlayerInfo) {
    this._player2Info = playerInfo;
  }
}

export enum GameStatus {
  waiting,
  playing,
  finished,
}
