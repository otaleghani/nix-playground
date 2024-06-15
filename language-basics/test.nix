# Expression. To evaluate it you use nix-instantiate --eval test.nix
# 1 + 2

# You need to imagine Nix like a json with classes
# {
#   string = "hello";
#   integer = 1;
#   float = 3.141;
#   bool = true;
#   null = null;
#   list = [ 1 "two" false ];
#   attribute-set = {
#     a = "hello";
#     b = 2;
#     c = 2.718;
#     d = false;
#   }; # comments are supported
# }

# rec grants access to attributes within themself
# NB: Nix is laxyly evaluated, so things will be calculated only when needed. 
# You'll need to add flag --strict to make it evaluate everything
# rec {
#   one = 1;
#   two = 1 + one;
#   three = 1 + two;
# }

# Let expression
# With let you create key value pairs that you can une in the in part
# let
#  x = 1;
#  y = 2;
# in x + y

# Whitespaces are optional
# let x=1; y=1; in x+y

# Attribute access is done with a .
# but you could also declaring an attribute with the dot
# let 
#   attrset = { x.y = 1; };
# in
#   attrset.x.y * 2

# with gives you the ability to access data of an attribute
# without having to write it down 
# Attributes made available with "with" are only in the scope of the expression
# following the ;
# let 
#   a = {
#     x = 1;
#     y = 2;
#     z = 3;
#   };
# in
# with a; [ x y z ] # same as [ a.x a.y a.z ]

# inherit lets you re-declare the attributes declared in the let in in
# let 
#   a = 1;
#   b = 2;
#   c = 3;
# in
# {
#   inherit a b c;
# }

# You could even inherit from an attribute set like this
# let 
#   a = { x = 1; y = 2; z = 3; };
# in 
# {
#   inherit (a) x y z;
# }

# String interpolation, only string or chars are usable
# let 
#   name = "nand";
# in
#   "Anvedi come balla ${name}"

# they can be concatenated
# let
#   name = "sandro";
# in
#   "${name + " ${name + " ${name}"}"}" # wow much readable, such nix lang

# nix has support for paths
# /absoule/path
# ./relative
# relative/path
# ./. # current directory
# ../. # parent directory

# You can use string interpolation with path type
# let
#   dir = "somedir";
# in
#   ./${dir}

# lookup paths, basically paths related to the functioning of the system
# You should not use them in production code because they add impurities
# to that I say you are not my mother nix, I will use them
# <nixpkgs>

# multi-line strings. They evaluate with \n instead of a normal spce
# ''
# some thing
# here
# ''

# these functions have no names, so they evaluate to LAMBDA
# on the left there is the function argument, on the right the body
# you can use function to assign names to values
# x: x + 1 # single argument
# x: y: x + y # multiple arguments
# (x: (y: x + y)) 1 2 # same as this

# { a, b }: a + b # set argument
# { a ? 1, b ? 2 }: a + b # set argument with defaults
# { a, b, ...}: a + b # set argument with additional values allowed
# args@{ a, b, ...}: a + b + args.c # named arguments

# functions can be assigned to names
# let 
#   a = x: x + 1;
# in 
#   a

# calling a function
# let
#   a = x: x + 1;
# in 
#   a 2

# This function accepts a set with an attribute "b"
# let 
#   a = x: x.b;
# in
#   a { b = 10; }

# You could also call it like this
# let
#   a = x: x.b;
#   c = { b = 10; };
# in
#   a c

# Calling a function outside of a let... in
# remember that whitespace is required in functions call
# (x: x + 1) 2

# List elements are also separeted by white space, so be careful when creating one
# let 
#   f = x: x + 1;
#   a = 2;
# in
#   [ f a ] 
  
# let 
#   f = x: x + 1;
#   a = 2;
# in
#   [ (f a) ] 

# function that accepts a set
# let 
#   f = {a, b}: a + b;
# in
#   f { a = 1; b = 2; } 

# Same thing, but with a and b declared in let
# This function will accept only a and b, if you pass something else it will throw an error
# let 
#   f = { a, b }: a + b; 
#   c = { a = 1; b = 2; };
# in
#   f c

# default values
# let 
#   f = { a ? 1, b ? 2 }: a + b;
# in 
#   f { } # empty attribute set

# additional attributes
# The ellipsis lets you accept more attributes
# let 
#   f = { a, b, ...}: a + b;
# in
#   f { a = 1; b = 2; c = 3; }

# You can access the additional attributes by using a named attribute
# let
#   f = args@{ a, b, ...}: a + b + args.c;
# in
#   f { a = 1; b = 2; c = 3; }

# Nix has a series of built in function in the builtins library
# You should get familiar with this
# builtins.toString ./.

# import is part of the builtins, but can be accessed with just import
# it imports another nix file, given a path 
# builtins.import ./expression.nix
# import ./expression.nix # same thing 

# You could even import somethign and then pass an argoument to the function present in that file
# import ./function.nix 1

# the <nixpkgs> contains an attribute set that has a lot of useful functions
# let 
#   pkgs = import <nixpkgs> {};
# in
#   pkgs.lib.strings.toUpper "sandro"

# This thing actually gives us a way to talk about what is and what is not a true reproducible build. If you import the lookup path, you are importing some version of the function toUpper. Of cource it's a trivial function this time, but more complex function could have different results. For this reason you usually do something like this to have a truly reproducible build
# let
#   nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/06278c77b5d162e62df170fec307e83f1812d94b.tar.gz";
#   pkgs = import nixpkgs {};
# in
# pkgs.lib.strings.toUpper "sandro, said with a pinned resource"

# Usually pkgs and lib are passed as argouments to functions
# To make this work, you have to pass <nixpkgs> to this file. You can do that by adding --arg pkgs 'import <nixpkgs> {}'
# { pkgs, ...}:
# pkgs.lib.strings.removePrefix "ah stronzo " "ah stronzo anvedi come balla nando"

# same thing is true for the lib library,
# You will need to add --arg lib '(import <nixpkgs> {}).lib' to the command
# { lib, ...}:
# let 
#   to-be = true;
# in 
#   lib.trivial.or to-be (! to-be)

# Usually you'll find both pkgs and lib called
# --arg lib '(import <nixpkgs> {}).lib' --arg pkgs 'import <nixpkgs> {}'
{ pkgs, lib, ...}:
let 
  a = lib.strings.removePrefix "a " "a vedi";
  b = pkgs.lib.strings.toUpper "sandro";
in
  [ a b ]

# next: impurities
