(***********************************************************************)
(*                                                                     *)
(*                           Objective Caml                            *)
(*                                                                     *)
(*            Xavier Leroy, projet Cristal, INRIA Rocquencourt         *)
(*                                                                     *)
(*  Copyright 1996 Institut National de Recherche en Informatique et   *)
(*  en Automatique.  All rights reserved.  This file is distributed    *)
(*  under the terms of the Q Public License version 1.0.               *)
(*                                                                     *)
(***********************************************************************)

(* $Id: arch.ml,v 1.13 2006-04-16 23:28:14 doligez Exp $ *)

(* Machine-specific command-line options *)

val fast_math : bool ref

val command_line_options : (string * Arg.spec * string) list

(* Specific operations for the Intel 386 processor *)

open Misc
open Format

type addressing_mode =
    Ibased of string * int              (* symbol + displ *)
  | Iindexed of int                     (* reg + displ *)
  | Iindexed2 of int                    (* reg + reg + displ *)
  | Iscaled of int * int                (* reg * scale + displ *)
  | Iindexed2scaled of int * int        (* reg + reg * scale + displ *)

type specific_operation =
    Ilea of addressing_mode             (* Lea gives scaled adds *)
  | Istore_int of nativeint * addressing_mode (* Store an integer constant *)
  | Istore_symbol of string * addressing_mode (* Store a symbol *)
  | Ioffset_loc of int * addressing_mode (* Add a constant to a location *)
  | Ipush                               (* Push regs on stack *)
  | Ipush_int of nativeint            (* Push an integer constant *)
  | Ipush_symbol of string              (* Push a symbol *)
  | Ipush_load of addressing_mode       (* Load a scalar and push *)
  | Ipush_load_float of addressing_mode (* Load a float and push *)
  | Isubfrev | Idivfrev                 (* Reversed float sub and div *)
  | Ifloatarithmem of bool * float_operation * addressing_mode
                                        (* Float arith operation with memory *)
                                        (* bool: true=64 bits, false=32 *)
  | Ifloatspecial of string

and float_operation =
    Ifloatadd | Ifloatsub | Ifloatsubrev | Ifloatmul | Ifloatdiv | Ifloatdivrev

(* Sizes, endianness *)

val big_endian : bool

val size_addr : int
val size_int : int
val size_float : int

(* Operations on addressing modes *)

val identity_addressing : addressing_mode

val offset_addressing : addressing_mode -> int -> addressing_mode

val num_args_addressing : addressing_mode -> int

(* Printing operations and addressing modes *)

val print_addressing : (Format.formatter -> 'a -> unit) -> addressing_mode -> Format.formatter -> 'a array -> unit

val print_specific_operation : (Format.formatter -> 'a -> unit) -> specific_operation -> Format.formatter -> 'a array -> unit
      
(* Stack alignment constraints *)

val stack_alignment : int
