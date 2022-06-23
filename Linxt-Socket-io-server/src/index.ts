import { Socket } from "socket.io";
import express from "express";

import * as http from "http";

import { Server } from "socket.io";
import { GameRoom, GameStatus } from "./model/gameRoom";

// Server messages
interface ServerToClientEvents {
  noArg: () => void;
  basicEmit: (a: number, b: string, c: Buffer) => void;
}

// Client messages
interface ClientToServerEvents {
  hello: () => void;
}

// Interal Server events
interface InterServerEvents {
  ping: () => void;
}

// Individual client data
interface SocketData {
  name: string;
  age: number;
}

let gameRooms: Map<string, GameRoom> = new Map<string, GameRoom>();

let gameRoomIDs: string[] = [];

let freeGameRooms: string[] = [];

function generateGameRoomID(): string {
  let id = "";
  const possible =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

  do {
    for (let i = 0; i < 5; i++) {
      id += possible.charAt(Math.floor(Math.random() * possible.length));
    }
  } while (gameRoomIDs.includes(id));

  return id;
}

const app = express();

const server: http.Server = http.createServer(app);
const io: Server = new Server<
  ClientToServerEvents,
  ServerToClientEvents,
  InterServerEvents,
  SocketData
>(server);

server.listen(3000, () => {
  console.log("listening on *:3000");
});

let roomId: string | string[] | undefined = undefined;
let isPrivate: string | string[] | undefined = undefined;
let userName: string | string[] | undefined = undefined;

io.use((socket, next) => {
  roomId = socket.handshake.query.roomId;
  isPrivate = socket.handshake.query.isPrivate;
  userName = socket.handshake.query.userName;
  if (socket.handshake.query.token === "Linxt") {
    next();
  } else {
    next(new Error("Authentication error"));
  }
});

io.on("connection", (socket: Socket) => {
  if (roomId) {
    joinGameRoom(socket, roomId as string);
  } else {
    if (isPrivate) {
      createPrivateRoom(socket);
      console.log("created");
    } else {
      console.log("normalSearch");
      normalSearch(socket);
    }
  }

  socket.on("pointSet", (roomId: string, point: number) => {
    console.log(roomId);
    let gameRoom = gameRooms.get(roomId);
    if (gameRoom) {
      if (gameRoom.player1 === socket.id) {
        io.sockets.sockets.get(gameRoom.player2)?.emit("pointSet", point);
      } else {
        io.sockets.sockets.get(gameRoom.player1)?.emit("pointSet", point);
      }
    }
  });

  socket.on("gameFinished", (roomId: string) => {
    let gameRoom = gameRooms.get(roomId);
    if (gameRoom) {
      gameRoom.status = GameStatus.finished;
      if (gameRoom.player1 === socket.id) {
        io.sockets.sockets.get(gameRoom.player1)?.emit("gameFinished");
      } else {
        io.sockets.sockets.get(gameRoom.player2)?.emit("gameFinished");
      }
    }
  });

  socket.on("surrender", (roomId: string) => {
    let gameRoom = gameRooms.get(roomId);
    if (gameRoom) {
      gameRoom.status = GameStatus.finished;
      if (gameRoom.player1 === socket.id) {
        io.sockets.sockets.get(gameRoom.player2)?.emit("surrender");
      } else {
        io.sockets.sockets.get(gameRoom.player1)?.emit("surrender");
      }
    }
  });

  socket.on("disconnect", () => {
    let gameRoomId: string = "";
    gameRooms.forEach((gameRoom) => {
      if (gameRoom.player1 == socket.id || gameRoom.player2 == socket.id) {
        gameRoomId = gameRoom.gameroomId;
      }
    });

    if (gameRooms.get(gameRoomId)) {
      if (gameRooms.get(gameRoomId)!.player1 == socket.id) {
        io.sockets.sockets
          .get(gameRooms.get(gameRoomId)!.player2)
          ?.disconnect(true);
      } else {
        io.sockets.sockets
          .get(gameRooms.get(gameRoomId)!.player1)
          ?.disconnect(true);
      }
      gameRooms.delete(gameRoomId);
    }
  });
});

function normalSearch(socket: Socket) {
  console.log("normalSearch");
  if (freeGameRooms.length == 0) {
    console.log("new Room");
    let gameRoom = new GameRoom();
    gameRoom.gameroomId = generateGameRoomID();
    gameRoom.player1 = socket.id;
    gameRoom.player1Info.name = userName as string;
    userName = undefined;
    gameRooms.set(gameRoom.gameroomId, gameRoom);
    freeGameRooms.push(gameRoom.gameroomId);
    socket.emit("gameRoomID", gameRoom.gameroomId);
  } else {
    console.log("join Room");
    let gameRoom = gameRooms.get(freeGameRooms.splice(0, 1)[0]);
    if (gameRoom) {
      gameRoom!.player2 = socket.id;
      gameRoom!.player2Info.name = userName as string;
      userName = undefined;
      gameRoom!.status = GameStatus.playing;
      socket.emit("gameRoomID", gameRoom!.gameroomId);
      let random_boolean = Math.random() < 0.5;
      io.sockets.sockets
        .get(gameRoom!.player1)
        ?.emit("startGame", random_boolean, gameRoom!.player2Info.name);
      io.sockets.sockets
        .get(gameRoom!.player2)
        ?.emit("startGame", !random_boolean, gameRoom!.player1Info.name);
    }
  }
}

function joinGameRoom(socket: Socket, roomId: string) {
  let gameRoom = gameRooms.get(roomId);
  if (gameRoom) {
    gameRoom.player2 = socket.id;
    gameRoom.player2Info.name = userName as string;
    userName = undefined;
    gameRoom.status = GameStatus.playing;
    socket.emit("gameRoomID", gameRoom.gameroomId);
    let random_boolean = Math.random() < 0.5;
    io.sockets.sockets
      .get(gameRoom.player1)
      ?.emit("startGame", random_boolean, gameRoom.player2Info.name);
    io.sockets.sockets
      .get(gameRoom.player2)
      ?.emit("startGame", !random_boolean, gameRoom.player1Info.name);
  } else {
    console.log("gameRoom not found");
    socket.disconnect();
  }
}

function createPrivateRoom(socket: Socket) {
  let gameRoom = new GameRoom();
  gameRoom.gameroomId = generateGameRoomID();
  gameRoom.player1 = socket.id;
  gameRoom.player1Info.name = userName as string;
  userName = undefined;
  gameRooms.set(gameRoom.gameroomId, gameRoom);
  socket.emit("gameRoomID", gameRoom.gameroomId);
}
