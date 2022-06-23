export class PlayerInfo {
  _name: string;

  constructor() {
    this._name = "";
  }

  get name(): string {
    return this._name;
  }

  set name(name: string) {
    this._name = name;
  }
}
