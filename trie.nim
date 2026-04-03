import std/tables

type
  TrieNode = ref object
    children: Table[char, TrieNode]
    isEnd: bool

  Trie* = ref object
    root: TrieNode

proc newTrieNode(): TrieNode =
  TrieNode(children: initTable[char, TrieNode](), isEnd: false)

proc newTrie*(): Trie =
  Trie(root: newTrieNode())

proc insert*(t: Trie, word: string) =
  var node = t.root
  for item in word:
    if item notin node.children:
      node.children[item] = newTrieNode()
    node = node.children[item]
  node.isEnd = true

proc search*(t: Trie, word: string): bool =
  var node = t.root
  for item in word:
    if item notin node.children:
      return false
    node = node.children[item]
  return node.isEnd

proc startsWith*(t: Trie, prefix: string): bool =
  var node = t.root
  for item in prefix:
    if item notin node.children:
      return false
    node = node.children[item]
  return true

proc collectWords(node: TrieNode, prefix: string, results: var seq[string]) =
  if node.isEnd:
    results.add(prefix)
  for item, child in node.children:
    collectWords(child, prefix & item, results)

proc autocomplete*(t: Trie, prefix: string): seq[string] =
  var node = t.root
  for item in prefix:
    if item notin node.children:
      return @[]
    node = node.children[item]
  var results: seq[string] = @[]
  collectWords(node, prefix, results)
  return results
