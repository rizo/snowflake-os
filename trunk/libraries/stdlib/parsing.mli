(***********************************************************************)
(*                                                                     *)
(*                           Objective Caml                            *)
(*                                                                     *)
(*            Xavier Leroy, projet Cristal, INRIA Rocquencourt         *)
(*                                                                     *)
(*  Copyright 1996 Institut National de Recherche en Informatique et   *)
(*  en Automatique.  All rights reserved.  This file is distributed    *)
(*  under the terms of the GNU Library General Public License, with    *)
(*  the special exception on linking described in file ../LICENSE.     *)
(*                                                                     *)
(***********************************************************************)

(* $Id: parsing.mli,v 1.18 2004-04-14 15:37:30 doligez Exp $ *)

(** The run-time library for parsers generated by [ocamlyacc]. *)

val symbol_start : unit -> int
(** [symbol_start] and {!Parsing.symbol_end} are to be called in the
   action part of a grammar rule only. They return the offset of the
   string that matches the left-hand side of the rule: [symbol_start()]
   returns the offset of the first character; [symbol_end()] returns the
   offset after the last character. The first character in a file is at
   offset 0. *)

val symbol_end : unit -> int
(** See {!Parsing.symbol_start}. *)

val rhs_start : int -> int
(** Same as {!Parsing.symbol_start} and {!Parsing.symbol_end}, but
   return the offset of the string matching the [n]th item on the
   right-hand side of the rule, where [n] is the integer parameter
   to [rhs_start] and [rhs_end]. [n] is 1 for the leftmost item. *)

val rhs_end : int -> int
(** See {!Parsing.rhs_start}. *)

val symbol_start_pos : unit -> Lexing.position;;
(** Same as [symbol_start], but return a [position] instead of an offset. *)

val symbol_end_pos : unit -> Lexing.position
(** Same as [symbol_end], but return a [position] instead of an offset. *)

val rhs_start_pos : int -> Lexing.position
(** Same as [rhs_start], but return a [position] instead of an offset. *)

val rhs_end_pos : int -> Lexing.position
(** Same as [rhs_end], but return a [position] instead of an offset. *)

val clear_parser : unit -> unit
(** Empty the parser stack. Call it just after a parsing function
   has returned, to remove all pointers from the parser stack
   to structures that were built by semantic actions during parsing.
   This is optional, but lowers the memory requirements of the
   programs. *)

exception Parse_error
(** Raised when a parser encounters a syntax error.
   Can also be raised from the action part of a grammar rule,
   to initiate error recovery. *)


(**/**)

(** {6  } *)

(** The following definitions are used by the generated parsers only.
   They are not intended to be used by user programs. *)

type parser_env

type parse_tables =
  { actions : (parser_env -> Obj.t) array;
    transl_const : int array;
    transl_block : int array;
    lhs : string;
    len : string;
    defred : string;
    dgoto : string;
    sindex : string;
    rindex : string;
    gindex : string;
    tablesize : int;
    table : string;
    check : string;
    error_function : string -> unit;
    names_const : string;
    names_block : string }

exception YYexit of Obj.t

val yyparse :
  parse_tables -> int -> (Lexing.lexbuf -> 'a) -> Lexing.lexbuf -> 'b
val peek_val : parser_env -> int -> 'a
val is_current_lookahead : 'a -> bool
val parse_error : string -> unit
