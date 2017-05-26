(**
 * Copyright (c) 2017, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the "hack" directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *
 *)

type 'a t = {
  incoming: 'a list;
  outgoing: 'a list;
  length: int;
}

exception Empty

let empty = {
  incoming = [];
  outgoing = [];
  length = 0;
}

let length t = t.length

let is_empty t = length t = 0

let push t x =
  { t with
    incoming = x :: t.incoming;
    length = t.length + 1;
  }

let pop t =
  let t = match t.outgoing with
    | [] -> { t with incoming = []; outgoing = List.rev t.incoming }
    | _ -> t
  in
  match t.outgoing with
    | [] -> (None, t)
    | hd::tl -> (Some hd, { t with outgoing = tl; length = t.length - 1 })

let pop_unsafe t =
  match pop t with
    | (Some x, t) -> (x, t)
    | (None, _) -> raise Empty
