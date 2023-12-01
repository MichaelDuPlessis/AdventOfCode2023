import std/strutils
import std/sequtils
import std/enumerate

const NUMBERS = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

proc get_nums(chars: string): tuple[left: char, right: char] =
  for i in low(chars)..high(chars):
    if result.left != cast[char](0):
      break

    if chars[i] in Digits:
      result.left = chars[i]

    for j, number in enumerate(NUMBERS):
      if i + number.len < chars.len:
        if chars[i..<i + number.len] == number:
          result.left = char(j + 49)
          break

  for i in countdown(high(chars), low(chars)):
    if result.right != cast[char](0):
      break

    if chars[i] in Digits:
      result.right = chars[i]

    for j, number in enumerate(NUMBERS):
      # echo $(i - number.len + 1)
      if i - number.len + 1 >= 0:
        if chars[i - number.len + 1..i] == number:
          result.right = char(j + 49)
          break

template withFile(file: untyped, filename: string, mode: FileMode, body: untyped) =
  var file: File
  if open(file, filename, mode):
    try:
      body
    finally:
      file.close()
  else:
    quit("cannot open: $1" % [filename])

proc part1(): uint64 =
  withFile(file, "./input.txt", fmRead):
    let data = readAll(file).strip()

    for line in splitLines(data):
      let chars = cast[seq[char]](line)
      let nums = filter(chars, proc(c: char): bool = c in Digits)
      let num = "$1$2" % [$nums[0], $nums[^1]]  

      result += cast[uint64](num.parseInt())

proc part2(): uint64 =
  withFile(file, "./input.txt", fmRead):
    let data = readAll(file).strip()

    for line in splitLines(data):
      let (left, right) = get_nums(line)
      let num = "$1$2" % [$left, $right]  

      result += cast[uint64](num.parseInt())

when isMainModule:
  echo $part1()
  echo $part2()
